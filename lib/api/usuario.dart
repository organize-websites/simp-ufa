class Usuario {
  String token;
  String usertoken;
  String userpass;
  String name;
  String logotipousuario;
  String email;
  String id;
  String login;
  String msg;
 
  Usuario({this.token, this.userpass, this.usertoken, this.name, this.logotipousuario, this.email, this.id, this.login, this.msg});

  Usuario.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    usertoken = json['user_token'];
    userpass = json['user_pass'];
    name = json['name'];
    logotipousuario = json['logotipo_usuario'];
    email = json['email'];
    id = json['id'];
    login = json['login'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['user_token'] = this.usertoken;
    data['user_pass'] = this.userpass;
    data['name'] = this.name;
    data['logotipo_usuario'] = this.logotipousuario;
    data['email'] = this.email;
    data['id'] = this.id;
    data['login'] = this.login;
    data['msg'] = this.msg;
    return data;
  }

  String toString() {
    return 'Usuario(token: $token)';
  }

  String toString2() {
    return 'Usuario(user_token: $usertoken)';
  }

  String toString3() {
    return 'Usuario(user_pass: $userpass)';
  }

  String toString4() {
    return 'Usuario(name: $name)';
  }

  String toString5() {
    return 'Usuario(logotipo_usuario: $logotipousuario)';
  }

  String toString6() {
    return 'Usuario(email: $email)';
  }
  
  String toString7() {
    return 'Usuario(id: $id)';
  }
  
  String toString8() {
    return 'Usuario(login: $login)';
  }

  String toString9() {
    return '$token';
  }

  String toString10() {
    return '$msg';
  }

}