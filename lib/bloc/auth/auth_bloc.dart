import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:artoku/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<CheckLoginStatusEvent>((event, emit) async {
      User? user;

      try {
        await Future.delayed(const Duration(seconds: 4), () async {
          user = _auth.currentUser;
        });

        if (await isTokenValid()) {
          if (user != null) {
            emit(Authenticated(user));
          } else {
            emit(UnAuthenticated());
          }
        } else {
          await _auth.signOut();
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthenticatedError(message: e.toString()));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
            email: event.email.trim(), password: event.password.trim());

        User? user = userCredential.user;

        if (user != null) {
          await generateToken(user);
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        String errorMessage = 'Error';
        if (e is FirebaseAuthException) {
          errorMessage = validate(e);
        }

        emit(AuthenticatedError(message: errorMessage));
      }
    });

    on<SignupEvent>((event, emit) async {
      emit(AuthLoading());

      try {
        final userCredential = await _auth.createUserWithEmailAndPassword(
            email: event.user.email.toString(),
            password: event.user.password.toString());

        final user = userCredential.user;

        if (user != null) {
          await db.collection("users").doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'phone': event.user.phone.toString(),
            'name': event.user.name.toString(),
            'created_at': DateTime.now()
          });

          await generateToken(user);
          emit(Authenticated(user));
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        String errorMessage = 'Error';
        if (e is FirebaseAuthException) {
          errorMessage = validate(e);
        }
        emit(AuthenticatedError(message: errorMessage));
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        await removeToken();
        await _auth.signOut();
        emit(UnAuthenticated());
      } catch (e) {
        emit(AuthenticatedError(message: e.toString()));
      }
    });
  }

  String validate(FirebaseAuthException e) {
    String errorMessage;

    switch (e.code) {
      // login
      case 'user-not-found':
        errorMessage = 'Email atau Password salah.';
        break;
      case 'wrong-password':
        errorMessage = 'Email atau Password salah.';
        break;
      case 'invalid-credential':
        errorMessage = 'Email atau Password salah.';
        break;

      // register
      case 'email-already-in-use':
        errorMessage = 'Email sudah terdaftar. Silakan gunakan email lain.';
        break;
      case 'invalid-email':
        errorMessage =
            'Email tidak valid. Silakan periksa kembali format email.';
        break;
      case 'weak-password':
        errorMessage =
            'Password terlalu lemah. Harap gunakan kombinasi yang lebih kuat.';
        break;

      // system
      case 'too-many-requests':
        errorMessage = 'Terlalu banyak permintaan. Silakan coba lagi nanti.';
        break;
      case 'network-request-failed':
        errorMessage = 'Periksa koneksi internet Anda.';
        break;
      default:
        errorMessage = 'Terjadi kesalahan: ${e.message}';
        break;
    }

    return errorMessage;
  }

  Future<void> generateToken(user) async {
    // Simpan session token dengan masa berlaku 2 minggu
    final prefs = await SharedPreferences.getInstance();
    final token = await user.getIdToken();

    await prefs.setString('session_token', token!);
    await prefs.setInt('token_expiry',
        DateTime.now().add(const Duration(days: 14)).millisecondsSinceEpoch);

    // user info
    final DocumentSnapshot getUser =
        await db.collection('users').doc(user.uid).get();
    if (getUser.exists) {
      final Map<String, String> userInfo = {
        "uid": getUser['uid'],
        "name": getUser['name'],
        "email": getUser['email'],
        "phone": getUser['phone'],
      };

      await prefs.setString('uid', userInfo['uid']!);
      await prefs.setString('name', userInfo['name']!);
      await prefs.setString('email', userInfo['email']!);
      await prefs.setString('phone', userInfo['phone']!);
    }
  }

  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTimestamp = prefs.getInt('token_expiry') ?? 0;

    // Cek apakah token masih berlaku
    if (DateTime.now().millisecondsSinceEpoch >= expiryTimestamp) {
      // Hapus token jika sudah kedaluwarsa
      await removeToken();
      return false; // Token tidak valid
    }

    return true; // Token masih valid
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_token');
    await prefs.remove('token_expiry');
    await prefs.remove('uid');
    await prefs.remove('name');
    await prefs.remove('email');
    await prefs.remove('phone');
  }
}
