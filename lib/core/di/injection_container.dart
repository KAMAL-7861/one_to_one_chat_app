import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/chat_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repositry.dart';
import '../../features/auth/data/repositories/auth_repositry_impl.dart';
import '../../features/auth/data/repositories/chat_repositry.dart';
import '../../features/auth/data/repositories/chat_repositry_impl.dart';
import '../../features/presentation/cubit/auth_cubit.dart';
import '../../features/presentation/cubit/chat_cubit.dart';
import '../usecases/sign_in_with_email.dart';
import '../usecases/sign_out.dart';
import '../usecases/sign_up_with_email.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(
        () => AuthCubit(
      signInWithEmail: sl(),
      signUpWithEmail: sl(),
      signOut: sl(),
    ),
  );
  sl.registerFactory(() => ChatCubit(sl()));

  // Use cases
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => SignUpWithEmail(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ChatRepository>(
        () => ChatRepositoryImpl(sl()), // Fixed: properly inject ChatRemoteDataSource
  );

  // Data sources
    sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: sl(),
        firestore: sl(),
      ),
  );
  sl.registerLazySingleton<ChatRemoteDataSource>(
        () => ChatRemoteDataSource(sl()), // Add ChatRemoteDataSource registration
  );

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance); // Add Firestore instance
}