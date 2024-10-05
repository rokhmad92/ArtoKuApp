import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artoku/bloc/auth/auth_bloc.dart';
import 'package:artoku/widget/elevated_button.dart';
import 'package:artoku/widget/text_field.dart';
import '../../global_variable.dart';

// login bloc
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const LoginView(),
    );
  }
}

// login view
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthenticatedError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal Login : ${state.message}')),
        );

        _passController.clear();
      } else if (state is Authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Berhasil')),
        );
      }
    }, builder: (context, state) {
      if (state is Authenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'userPage', (Route<dynamic> route) => false);
        });
      }

      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).secondaryHeaderColor,
                ],
              ),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  Center(
                    child: Image.asset(
                      'assets/login.png',
                      width: GlobalVariable.deviceWidth(context) * 0.5,
                      height: GlobalVariable.deviceWidth(context) * 0.5,
                    ),
                  ),
                  Text(
                    'Form Login',
                    style: Theme.of(context).primaryTextTheme.titleLarge,
                  ),
                  Text(
                    'Lengkapi form login untuk bisa menggunakan aplikasi.',
                    style: Theme.of(context).primaryTextTheme.titleSmall,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FormText(
                    labelText: "Email",
                    hintText: "Masukkan Email anda",
                    controller: _emailController,
                    prefixIcon: const Icon(Icons.person),
                    backgroundColor: Colors.white,
                    borderFocusColor: Colors.blue,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  FormText(
                    labelText: "Password",
                    hintText: "Masukkan password anda",
                    controller: _passController,
                    inputActionDone: true,
                    textKapital: false,
                    prefixIcon: const Icon(Icons.password),
                    backgroundColor: Colors.white,
                    borderFocusColor: Colors.blue,
                    obscureText: _obscureText,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonElevated(
                    onPress: state is AuthLoading
                        ? () {} // Fungsi kosong jika sedang loading
                        : () {
                            if (_formKey.currentState!.validate()) {
                              authBloc.add(LoginEvent(
                                email: _emailController.text,
                                password: _passController.text,
                              ));
                            }
                          },
                    text: state is AuthLoading ? 'Loading' : 'Login',
                    styleText: Theme.of(context).primaryTextTheme.displayMedium,
                  ),
                  SizedBox(height: GlobalVariable.deviceHeight(context) - 560),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum punya akun?',
                        style: Theme.of(context).primaryTextTheme.titleSmall,
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      InkWell(
                        onTap: () => {Navigator.pushNamed(context, 'register')},
                        child: Text('Daftar Akun',
                            style: Theme.of(context)
                                .primaryTextTheme
                                .titleSmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
