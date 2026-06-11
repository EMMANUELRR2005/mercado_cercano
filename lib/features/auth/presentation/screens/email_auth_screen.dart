import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/auth_bloc.dart';
import '../providers/auth_provider.dart';

/// Acceso con email y contraseña (respaldo): tabs Iniciar sesión /
/// Registrarse, con "¿Olvidaste tu contraseña?".
class EmailAuthScreen extends ConsumerStatefulWidget {
  const EmailAuthScreen({super.key});

  @override
  ConsumerState<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends ConsumerState<EmailAuthScreen> {
  // --- Iniciar sesión ---
  final _loginFormKey = GlobalKey<FormState>();
  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();
  bool _loginObscure = true;

  // --- Registro ---
  final _signupFormKey = GlobalKey<FormState>();
  final _signupName = TextEditingController();
  final _signupEmail = TextEditingController();
  final _signupPassword = TextEditingController();
  final _signupConfirm = TextEditingController();
  bool _signupObscure = true;

  @override
  void dispose() {
    _loginEmail.dispose();
    _loginPassword.dispose();
    _signupName.dispose();
    _signupEmail.dispose();
    _signupPassword.dispose();
    _signupConfirm.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Ingresa tu email';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'El formato del email no es válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }

  void _submitLogin(AuthBloc bloc) {
    if (!(_loginFormKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    bloc.add(EmailSignInRequested(
      email: _loginEmail.text.trim(),
      password: _loginPassword.text,
    ));
  }

  void _submitSignup(AuthBloc bloc) {
    if (!(_signupFormKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    bloc.add(EmailSignUpRequested(
      name: _signupName.text.trim(),
      email: _signupEmail.text.trim(),
      password: _signupPassword.text,
    ));
  }

  void _forgotPassword(AuthBloc bloc) {
    final email = _loginEmail.text.trim();
    if (_validateEmail(email) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escribe tu email arriba para enviarte el enlace'),
        ),
      );
      return;
    }
    bloc.add(PasswordResetRequested(email));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = ref.watch(authBlocProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Email y contraseña'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Iniciar sesión'),
              Tab(text: 'Registrarse'),
            ],
          ),
        ),
        body: BlocConsumer<AuthBloc, AuthState>(
          bloc: bloc,
          listener: (context, state) {
            switch (state) {
              case Authenticated(:final user, :final isNewUser):
                if (isNewUser) {
                  context.goNamed(RouteNames.authRole);
                } else {
                  context.goNamed(
                    user.role.name == 'vendor'
                        ? RouteNames.vendorHome
                        : RouteNames.buyerHome,
                  );
                }
              case PasswordResetSent(:final email):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Te enviamos un enlace a $email para restablecer '
                      'tu contraseña',
                    ),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              case AuthError(:final message):
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: AppColors.errorRed,
                  ),
                );
              default:
                break;
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return TabBarView(
              children: [
                _buildLoginTab(bloc, isLoading),
                _buildSignupTab(bloc, isLoading),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoginTab(AuthBloc bloc, bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _loginEmail,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail_outline),
              ),
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _loginPassword,
              obscureText: _loginObscure,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_loginObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () =>
                      setState(() => _loginObscure = !_loginObscure),
                ),
              ),
              validator: (v) =>
                  (v ?? '').isEmpty ? 'Ingresa tu contraseña' : null,
              onFieldSubmitted: (_) => _submitLogin(bloc),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: isLoading ? null : () => _forgotPassword(bloc),
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(color: AppColors.primaryGreen),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: isLoading ? null : () => _submitLogin(bloc),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Iniciar sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignupTab(AuthBloc bloc, bool isLoading) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _signupFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _signupName,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nombre completo',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) =>
                  Validators.validateRequired(v, 'tu nombre'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _signupEmail,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail_outline),
              ),
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _signupPassword,
              obscureText: _signupObscure,
              decoration: InputDecoration(
                labelText: 'Contraseña (mínimo 8 caracteres)',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_signupObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined),
                  onPressed: () =>
                      setState(() => _signupObscure = !_signupObscure),
                ),
              ),
              validator: _validatePassword,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _signupConfirm,
              obscureText: _signupObscure,
              decoration: const InputDecoration(
                labelText: 'Confirmar contraseña',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              validator: (v) => v != _signupPassword.text
                  ? 'Las contraseñas no coinciden'
                  : null,
              onFieldSubmitted: (_) => _submitSignup(bloc),
            ),
            const SizedBox(height: 8),
            Text(
              'Te enviaremos un correo para verificar tu cuenta.',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textHint),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: isLoading ? null : () => _submitSignup(bloc),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Crear cuenta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
