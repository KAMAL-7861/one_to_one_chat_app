import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../core/usecases/sign_in_with_email.dart';
import '../../../core/usecases/sign_out.dart';
import '../../../core/usecases/sign_up_with_email.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final SignOut signOut;

  AuthCubit({
    required this.signInWithEmail,
    required this.signUpWithEmail,
    required this.signOut,
  }) : super(AuthInitial());

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await signInWithEmail(
      SignInParams(email: email, password: password),
    );

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(AuthSuccess(user)),
    );
  }

  // Add this to your AuthCubit's signUp method
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    print('Starting sign up process...');
    emit(AuthLoading());

    final result = await signUpWithEmail(
      SignUpParams(email: email, password: password),
    );

    result.fold(
          (failure) {
        print('Sign up failed: ${failure.message}');
        emit(AuthError(failure.message));
      },
          (user) {
        print('Sign up successful: ${user.email}');
        emit(AuthSuccess(user));
      },
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());

    final result = await signOut(const NoParams());

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (_) => emit(AuthSignedOut()),
    );
  }

  void resetState() {
    emit(AuthInitial());
  }
}