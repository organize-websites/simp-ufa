class Usuario2 {
  String url;
 
  Usuario2({this.url});

  Usuario2.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }

  String toString() {
    return 'Usuario(token: $url)';
  }

}