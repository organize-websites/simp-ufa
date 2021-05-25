import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simp/api/usuariocard.dart';

class ApiCard{  

  static Future<UsuarioCard> login(String nome, String fone, String responsavel,) async {

    var pref = await SharedPreferences.getInstance();
    String token = (pref.getString("usr_tkn") ?? "");

    var url = 'https://b2corapi.agencialink.com.br/lead/add/cardcor';

    var header = {"Content-Type" : "application/json", "x-api-key" : "$token"};

    Map params = {
      "nome" : nome,
      "fone": fone,
      "responsavel" : responsavel
    };

    var usuarioCard;

    var _body = json.encode(params);  
    print("json enviado : $_body"); 

    var response = await http.post(url, headers: header, body: _body);
    print('Response status: ${response.statusCode}');

    Map mapResponse = json.decode(response.body);

    if(response.statusCode == 200){  
      usuarioCard = UsuarioCard.fromJson(mapResponse); 
      }
      else{
        usuarioCard = null;
      }
      return usuarioCard;
    }

}

