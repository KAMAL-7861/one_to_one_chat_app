import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSource(this.firestore);

  Stream<List<ChatModel>> getChats(String userId) {
    return firestore.collection('chats')
        .where('users', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ChatModel.fromJson({
      ...doc.data(),
      'chatId': doc.id,
    }))
        .toList());
  }

  Stream<List<MessageModel>> getMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MessageModel.fromJson({
      ...doc.data(),
      'messageId': doc.id,
    }))
        .toList());
  }

  Future<void> sendMessage(MessageModel message) async {
    final ref = firestore
        .collection('chats')
        .doc(message.chatId)
        .collection('messages')
        .doc();

    await ref.set({
      ...message.toJson(),
      'messageId': ref.id,
    });
  }

  Future<void> createChat(ChatModel chat) async {
    final ref = firestore.collection('chats').doc();
    await ref.set({
      ...chat.toJson(),
      'chatId': ref.id,
    });
  }

  Future<String> createOrGetChat(String email) async {
    try {
      print('🚀 Starting createOrGetChat for email: $email');

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) throw Exception("User not signed in");

      final currentUserEmail = currentUser.email;
      if (currentUserEmail == null) throw Exception("Current user email not found");

      print('📧 Current user email: $currentUserEmail');
      print('📧 Target email: $email');

      // STEP 1: Check if target user exists and ensure they're in Firestore
      print('🔍 Checking if target user exists...');
      await _ensureUserExistsInFirestore(email);

      // STEP 2: Check if chat already exists
      print('🔍 Checking if chat already exists...');
      final chatCollection = firestore.collection('chats');

      final querySnapshot = await chatCollection
          .where('users', arrayContains: currentUserEmail)
          .get();

      print('📄 Found ${querySnapshot.docs.length} chats for current user');

      for (var doc in querySnapshot.docs) {
        final users = List<String>.from(doc['users'] ?? []);
        print('👥 Chat ${doc.id} users: $users');

        if (users.contains(email) && users.contains(currentUserEmail)) {
          print('✅ Existing chat found: ${doc.id}');
          return doc.id;
        }
      }

      // STEP 3: Create new chat if it doesn't exist
      print('➕ Creating new chat...');
      final docRef = await chatCollection.add({
        'users': [currentUserEmail, email],
        'createdAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });

      print('✅ New chat created with ID: ${docRef.id}');
      return docRef.id;

    } catch (e) {
      print('❌ Error in createOrGetChat: $e');
      throw Exception("Failed to create or get chat: $e");
    }
  }

  /// Ensures that a user exists in the Firestore users collection
  /// This is a helper method to handle cases where users exist in Firebase Auth
  /// but not in the Firestore users collection (due to the previous bug)
  Future<void> _ensureUserExistsInFirestore(String email) async {
    print('🔍 Checking if user exists in Firestore users collection...');
    
    // First check if user exists in users collection
    final usersQuery = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (usersQuery.docs.isNotEmpty) {
      print('✅ User found in users collection');
      return;
    }

    print('⚠️ User not found in users collection');
    
    // For now, we'll throw an error asking the user to ensure they're registered
    // In a production app, you might want to try to fetch the user from Firebase Auth
    // and add them to Firestore, but this requires admin privileges
    throw Exception("User with email $email not found. Please make sure the user has registered in the app. If they registered recently, ask them to log out and log back in.");
  }
}