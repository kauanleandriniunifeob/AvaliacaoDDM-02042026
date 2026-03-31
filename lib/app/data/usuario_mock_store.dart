import '../models/usuario_model.dart';

class UsuarioMockStore {
  // A lista precisa ser static para persistir entre as trocas de tela
  static final List<UsuarioModel> _usuarios = [
    UsuarioModel(
      id: '1',
      nome: 'João Silva',
      email: 'user1@example.com',
      senha: '123',
    ),
  ];

  static bool validarLogin(String email, String senha) {
    return _usuarios.any(
      (u) => u.email == email && u.senha == senha,
    );
  }

  static bool registrar(UsuarioModel usuario) {
    final jaExiste = _usuarios.any((u) => u.email == usuario.email);
    if (!jaExiste) {
      usuario.id = (_usuarios.length + 1).toString();
      _usuarios.add(usuario);
      return true;
    }
    return false;
  }
}