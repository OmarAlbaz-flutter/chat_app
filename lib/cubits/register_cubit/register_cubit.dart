import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> registerUser(
      {required String email,
      required String password,
      required String username}) async {
    emit(RegisterLoading());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      credential.user!.updateDisplayName(username);
      await credential.user!.reload();
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure(errMessage: "The password provided is too weak"));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(
            errMessage: "The account already exists for that email."));
      }
    } catch (e) {
      emit(RegisterFailure(errMessage: e.toString()));
    }
  }
}
