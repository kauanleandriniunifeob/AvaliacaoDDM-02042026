import '../data/usuario_mock_store.dart';

class LoginViewModel {
  final UsuarioMockStore _store = UsuarioMockStore();

  bool fazerLogin(String email, String senha) {
    if (email.isEmpty || senha.isEmpty) {
      return false;
    }

    return _store.validarLogin(email, senha);
  }

  String obterMensagemErro(String email, String senha) {
    if (email.isEmpty) {
      return 'Por favor, informe seu email';
    }

    if (senha.isEmpty) {
      return 'Por favor, informe sua senha';
    }

    if (!email.contains('@')) {
      return 'Email inválido';
    }

    if (senha.length < 4) {
      return 'Senha deve ter no mínimo 4 caracteres';
    }

    return 'Email ou senha incorretos';
  }

  String? validarEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email é obrigatório';
    }
    if (!email.contains('@')) {
      return 'Email inválido';
    }
    return null;
  }

  String? validarSenha(String? senha) {
    if (senha == null || senha.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (senha.length < 4) {
      return 'Senha deve ter no mínimo 4 caracteres';
    }
    return null;
  }
}


