import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
  });

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not found',
        );
      }

      final userModel = UserModel.fromFirebaseUser(userCredential.user!);
      
      // Ensure user exists in Firestore users collection (for existing users)
      await _ensureUserInFirestore(userCredential.user!);
      
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('🔥 DataSource: Creating user with Firebase...');
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('🔥 DataSource: Firebase response received');

      if (userCredential.user == null) {
        print('🔥 DataSource: ERROR - userCredential.user is null');
        throw FirebaseAuthException(
          code: 'user-creation-failed',
          message: 'Failed to create user',
        );
      }

      print('🔥 DataSource: User created - UID: ${userCredential.user!.uid}');
      final userModel = UserModel.fromFirebaseUser(userCredential.user!);
      print('🔥 DataSource: UserModel created - Email: ${userModel.email}');

      // Store user in Firestore users collection
      print('🔥 DataSource: Storing user in Firestore...');
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': userCredential.user!.email,
        'displayName': userCredential.user!.displayName ?? '',
        'photoURL': userCredential.user!.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('🔥 DataSource: User stored in Firestore successfully');

      return userModel;
    } catch (e) {
      print('🔥 DataSource: Error occurred - $e');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  /// Ensures that a user exists in Firestore users collection
  /// This helps with users who registered before the Firestore integration
  Future<void> _ensureUserInFirestore(User user) async {
    try {
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      
      if (!userDoc.exists) {
        print('🔥 Adding existing user to Firestore: ${user.email}');
        await firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'displayName': user.displayName ?? '',
          'photoURL': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });
        print('🔥 User successfully added to Firestore');
      }
    } catch (e) {
      print('⚠️ Error ensuring user in Firestore: $e');
      // Don't throw here, as this is not critical for sign-in
    }
  }
}