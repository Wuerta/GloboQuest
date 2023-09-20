import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:globo_quest/constants/assets.dart';
import 'package:globo_quest/view_models/login_view_model.dart';
import 'package:globo_quest/widgets/google_sign_in_button.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late final LoginViewModel _loginViewModel;

  @override
  void initState() {
    super.initState();
    _loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
  }

  Future<void> _login() async {
    if (_loginViewModel.loading) return;

    final email = _emailController.text;
    final password = _passwordController.text;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);

    try {
      final user = await _loginViewModel.loginWithEmail(email, password);
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Bem vindo, ${user.displayName}'),
        ),
      );

      if (mounted) {
        context.go('/home');
        _loginViewModel.clearValues();
      }
    } catch (_) {
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            'Ocorreu um erro ao realizar o login, tente novamente.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onError,
            ),
          ),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    }
  }

  Future<void> _loginWithGoogle() async {
    if (_loginViewModel.loading) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);

    try {
      final user = await _loginViewModel.loginWithGoogle();
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Bem vindo, ${user.displayName}'),
        ),
      );

      if (mounted) {
        context.go('/home');
        _loginViewModel.clearValues();
      }
    } catch (_) {
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            'Ocorreu um erro ao realizar o login, tente novamente.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onError,
            ),
          ),
          backgroundColor: theme.colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = context.watch<LoginViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(logoImage, height: 124),
                    const SizedBox(height: 16),
                    Text(
                      'GloboQuest',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        filled: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe um e-mail';
                        }

                        if (!EmailValidator.validate(value)) {
                          return 'E-mail inválido';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Builder(builder: (context) {
                      return TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          filled: true,
                          suffixIcon: IconButton(
                            onPressed: () {
                              loginViewModel.showPassword =
                                  !loginViewModel.showPassword;
                            },
                            icon: Icon(
                              loginViewModel.showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        obscureText: !loginViewModel.showPassword,
                        textInputAction: TextInputAction.send,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe uma senha';
                          }

                          return null;
                        },
                        onFieldSubmitted: (_) {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                      );
                    }),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: !loginViewModel.loading
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  _login();
                                }
                              }
                            : null,
                        child: const Text('Entrar'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Esqueceu sua senha?',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        const SizedBox(width: 8),
                        Text(
                          'ou',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.maxFinite,
                      child: GoogleSignInButton(
                        onPressed: !loginViewModel.loading
                            ? () {
                                _loginWithGoogle();
                              }
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Não possui conta?'),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Criar conta',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          loginViewModel.loading
              ? ColoredBox(
                  color:
                      Theme.of(context).colorScheme.background.withOpacity(0.6),
                  child: SpinKitFadingFour(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
