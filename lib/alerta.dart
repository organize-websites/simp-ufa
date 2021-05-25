import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mudausr.dart';

clearUsr() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
}

alert(BuildContext context, String msg){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title:
        Center(
          child: 
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesome5.sad_tear, size: 90, color: Colors.red[700],),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Oops...", style: TextStyle(color: Colors.red[700], fontSize:25), textAlign: TextAlign.center,),
              ),
            ],
          )
        ),
        content: Text(msg, textAlign: TextAlign.center,),
        actions: <Widget>[
          TextButton(onPressed: () {Navigator.pop(context);}, child: Text('Tentar Novamente'))
        ]
      );
    }
  );
}

alert2(BuildContext context, String msg){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title:
        Center(
          child: 
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesome5.edit, size: 90, color: Colors.blue[900],),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Oops...", style: TextStyle(color: Colors.blue[900], fontSize:25), textAlign: TextAlign.center,),
              ),
            ],
          )
        ),
        content: Text(msg, textAlign: TextAlign.center,),
        actions: <Widget>[
          TextButton(onPressed: () {Navigator.pop(context);}, child: Text('Tentar Novamente'))
        ]
      );
    }
  );
}

alert3(BuildContext context, String msg){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title:
        Center(
          child: 
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesome5.edit, size: 90, color: Colors.red[900],),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Bloqueado...", style: TextStyle(color: Colors.red[900], fontSize:25), textAlign: TextAlign.center,),
              ),
            ],
          )
        ),
        content: Text(msg, textAlign: TextAlign.center,),
        actions: <Widget>[
          TextButton(onPressed: () {Navigator.pop(context);}, child: Text('Tentar Novamente'))
        ]
      );
    }
  );
}

alert4(BuildContext context, String msg){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title:
        Center(
          child: 
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesome.exclamation_triangle, size: 90, color: Colors.yellow[900],),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Atenção!!!", style: TextStyle(color: Colors.yellow[900], fontSize:25), textAlign: TextAlign.center,),
              ),
            ],
          )
        ),
        content: Text(msg, textAlign: TextAlign.center,),
        actions: <Widget>[
          TextButton(onPressed: () {Navigator.pop(context);}, child: Text('Cancelar')),
          TextButton(onPressed: () {OneSignal.shared.setSubscription(false); clearUsr(); Navigator.push(context, MaterialPageRoute(builder: (context) => MudaUsr()));}, child: Text('Sair', style: TextStyle(color: Colors.red),)),
        ]
      );
    }
  );
}

alertAddLead(BuildContext context, String msg){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title:
        Center(
          child: 
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesome.check, size: 90, color: Colors.green[900],),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Sucesso!!!", style: TextStyle(color: Colors.green[900], fontSize:25), textAlign: TextAlign.center,),
              ),
            ],
          )
        ),
        content: Text(msg, textAlign: TextAlign.center,),
        actions: <Widget>[
          TextButton(onPressed: () {Navigator.pop(context);}, child: Text('Ok')),
        ]
      );
    }
  );
}

alertNoAddLead(BuildContext context, String msg){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title:
        Center(
          child: 
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesome5.times_circle, size: 90, color: Colors.red[900],),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Erro", style: TextStyle(color: Colors.red[900], fontSize:25), textAlign: TextAlign.center,),
              ),
            ],
          )
        ),
        content: Text(msg, textAlign: TextAlign.center,),
        actions: <Widget>[
          TextButton(onPressed: () {Navigator.pop(context);}, child: Text('Tentar Novamente'))
        ]
      );
    }
  );
}