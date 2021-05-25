class UsuarioCard {
  String nome;
  String fone;
  String responsavel;
 
  UsuarioCard({this.nome, this.fone, this.responsavel});

  UsuarioCard.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    fone = json['fone'];
    responsavel = json['responsavel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['fone'] = this.fone;
    data['responsavel'] = this.responsavel;
    return data;
  }

  String toString() {
    return 'Usuario(nome: $nome)';
  }
  
  String toInt() {
    return responsavel;
  }
}