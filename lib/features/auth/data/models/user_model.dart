import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String uid,
    required String email,
    String? displayName,
  }) : super(
    uid: uid,
    email: email,
    displayName: displayName,
  );

  factory UserModel.fromFirebaseUser(User user) {
    print('👤 UserModel: Creating from Firebase user - UID: ${user.uid}, Email: ${user.email}');

    if (user.email == null || user.email!.isEmpty) {
      print('👤 UserModel: WARNING - User email is null or empty');
    }

    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      displayName: displayName,
    );
  }
}