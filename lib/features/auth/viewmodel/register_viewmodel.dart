import 'package:flutter/foundation.dart';

import '../../../app/core/constants/app_constants.dart';
import '../../../app/core/models/operation_result.dart';
import '../data/user_repository.dart';
import '../model/user_model.dart';

class RegisterViewModel extends ChangeNotifier {
  RegisterViewModel({required IUserRepository repository})
    : _repository = repository;

  final IUserRepository _repository;

  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get obscurePassword => _obscurePassword;

  bool get obscureConfirmPassword => _obscureConfirmPassword;

  String get currentPassword => _password.trim();

  void updateName(String value) {
    _name = value;
  }

  void updateEmail(String value) {
    _email = value;
  }

  void updatePassword(String value) {
    _password = value;
  }

  void updateConfirmPassword(String value) {
    _confirmPassword = value;
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  String? validateName(String? value) {
    final String normalized = (value ?? '').trim();
    if (normalized.isEmpty) {
      return 'O nome é obrigatório.';
    }
    if (normalized.length < AppConstants.minNameLength) {
      return 'O nome deve ter ao menos ${AppConstants.minNameLength} caracteres.';
    }
    return null;
  }

  String? validateEmail(String? value) {
    final String normalized = (value ?? '').trim();
    if (normalized.isEmpty) {
      return 'O email é obrigatório.';
    }
    final RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(normalized)) {
      return 'Informe um email válido.';
    }
    if (_repository.emailExists(normalized)) {
      return 'Este email já está cadastrado.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    final String normalized = (value ?? '').trim();
    if (normalized.isEmpty) {
      return 'A senha é obrigatória.';
    }
    if (normalized.length < AppConstants.minPasswordLength) {
      return 'Senha deve ter ao menos ${AppConstants.minPasswordLength} caracteres.';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    final String normalized = (value ?? '').trim();
    if (normalized.isEmpty) {
      return 'Confirme a senha.';
    }
    if (_password.trim() != normalized) {
      return 'As senhas não coincidem.';
    }
    return null;
  }

  Future<OperationResult<UserModel>> register() async {
    final String name = _name.trim();
    final String email = _email.trim().toLowerCase();
    final String password = _password.trim();
    final String confirmPassword = _confirmPassword.trim();

    final String? nameError = validateName(name);
    if (nameError != null) {
      return OperationResult<UserModel>(success: false, message: nameError);
    }

    final String? emailError = validateEmail(email);
    if (emailError != null) {
      return OperationResult<UserModel>(success: false, message: emailError);
    }

    final String? passwordError = validatePassword(password);
    if (passwordError != null) {
      return OperationResult<UserModel>(success: false, message: passwordError);
    }

    if (password != confirmPassword) {
      return const OperationResult<UserModel>(
        success: false,
        message: 'As senhas não coincidem.',
      );
    }

    final UserModel newUser = UserModel(
      id: '0',
      name: name,
      email: email,
      password: password,
    );

    final bool registered = _repository.register(newUser);
    if (!registered) {
      return const OperationResult<UserModel>(
        success: false,
        message: 'Não foi possível concluir o cadastro. Tente novamente.',
      );
    }

    return OperationResult<UserModel>(
      success: true,
      message: 'Cadastro realizado com sucesso.',
      data: newUser,
    );
  }
}