class UsuarioModel {
  String? id;
  final String nome;
  final String email;
  final String senha;

  UsuarioModel({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'],
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      senha: map['senha'] ?? '',
    );
  }

  @override
  String toString() => 'UsuarioModel(nome: $nome, email: $email)';
}
