import 'package:flutter/material.dart';

import '../../../app/core/widgets/app_background.dart';
import '../../../app/core/widgets/glass_card.dart';
import '../../../app/routes/app_routes.dart';
import '../viewmodel/login_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginViewModel get _viewModel => widget.viewModel;

  Future<void> _submit() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final result = await _viewModel.authenticate();

    if (!mounted) {
      return;
    }

    if (!result.success || result.data == null) {
      _showMessage(result.message, isError: true);
      return;
    }

    _showMessage(result.message);

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.home,
      arguments: result.data!.name,
    );
  }

  Future<void> _openRegister() async {
    final Object? message = await Navigator.pushNamed(
      context,
      AppRoutes.register,
    );

    if (!mounted) {
      return;
    }

    if (message is String && message.trim().isNotEmpty) {
      _showMessage(message);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color backgroundColor = isError
        ? scheme.errorContainer
        : scheme.primary;
    final Brightness brightness = ThemeData.estimateBrightnessForColor(
      backgroundColor,
    );
    final Color foregroundColor = brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyle(color: foregroundColor)),
          backgroundColor: backgroundColor,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text('Login')),
      body: AppBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: GlassCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Acesse sua conta',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        onChanged: _viewModel.updateEmail,
                        validator: _viewModel.validateEmail,
                      ),
                      const SizedBox(height: 12),
                      AnimatedBuilder(
                        animation: _viewModel,
                        builder: (BuildContext context, Widget? child) {
                          return TextFormField(
                            obscureText: _viewModel.obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              suffixIcon: IconButton(
                                onPressed: _viewModel.togglePasswordVisibility,
                                icon: Icon(
                                  _viewModel.obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            onChanged: _viewModel.updatePassword,
                            validator: _viewModel.validatePassword,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _submit,
                        child: const Text('Entrar'),
                      ),
                      TextButton(
                        onPressed: _openRegister,
                        child: const Text(
                          'Não possui uma conta? Ir para cadastro!',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
