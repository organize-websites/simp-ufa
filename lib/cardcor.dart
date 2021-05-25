import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simp/pushin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ajuda.dart';
import 'alerta.dart';
import 'api/apiAddCard.dart';
import 'homeb2cor.dart';
import 'homesimp2.dart';


class CardCor extends StatefulWidget {
  CardCor({Key key, this.title}) : super(key: key); 

  static Future<String> get _usrnm async {

  var prefs = await SharedPreferences.getInstance();
  String nome = (prefs.getString("nome") ?? "");

    await Future.delayed(Duration(seconds: 1));
    return '$nome';
  }

  static Future<String> get _usrimg async {


  var prefs = await SharedPreferences.getInstance();
  String logotipousuario = (prefs.getString("logotipousuario") ?? "");

    await Future.delayed(Duration(seconds: 1));
    return '$logotipousuario';
  }

  static Future<String> get _uslog async {

  var prefs = await SharedPreferences.getInstance();
  String login = (prefs.getString("login") ?? "");

    await Future.delayed(Duration(seconds: 1));
    return '$login';
  }  

  static Future<String> get _cartao async {

  var prefs = await SharedPreferences.getInstance();
  String cartao = (prefs.getString("cartao") ?? "");

    await Future.delayed(Duration(seconds: 1));
    print('Resposta: $cartao');
    return '$cartao';
  }  

  static Future<String> get _cdCor async {

  var prefs = await SharedPreferences.getInstance();
  String cartao = (prefs.getString("cartao") ?? null);

    await Future.delayed(Duration(seconds: 1));
    if(cartao == null){
      return null;
    }
    else{
    return '$cartao';
    }
  }  

 
  final String title;

  @override
  _CardCorState createState() => _CardCorState();
}

class _CardCorState extends State<CardCor> {

  final controledetexto = TextEditingController();

  final controledesenha = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _checkBoxVal = false;

  Future<void> osignUrl() async {
    var settings = {
      OSiOSSettings.autoPrompt: true,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    };
    await OneSignal.shared.init("f23a7bb4-e910-4230-8b8c-530d50587cb7", iOSSettings: settings);
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) async {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var url;
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);    
    OneSignal.shared.promptUserForPushNotificationPermission();
    OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {       
      url = notification.payload.additionalData["url"];
      /*Map mapResponse = json.decode(url);
      if(mapResponse["url"] != null){
        prefs.setString("urlpush", mapResponse["url"]);
      }*/
      }
    ); 
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
      /*var prefs = await SharedPreferences.getInstance();
      String url2 = (prefs.getString("urlpush") ?? "");
      print('Resultado:: $url2');*/
      print('Resultado: $url');       
      if( url != null ) {
        var prefs = await SharedPreferences.getInstance();
        prefs.setString("urlpush", url);
        String u2 = prefs.getString("urlpush");
        print("Resultado:: $u2");
        Navigator.push(context, MaterialPageRoute(builder: (context) => UrlPush()));
        }
      }
    );
    if (status.permissionStatus.hasPrompted)
      // we know that the user was prompted for push permission      
    if (status.permissionStatus.status == OSNotificationPermission.notDetermined)
      // boolean telling you if the user enabled notifications
    if (status.subscriptionStatus.subscribed)
      // boolean telling you if the user is subscribed with OneSignal's backend
    // the user's ID with OneSignal
    String onesignalUserId = status.subscriptionStatus.userId;
    // the user's APNS or FCM/GCM push token
    String token = status.subscriptionStatus.pushToken;
    String emailPlayerId = status.emailSubscriptionStatus.emailUserId;
    String emailAddress = status.emailSubscriptionStatus.emailAddress;
  }

  @override
  initState() {
    super.initState();
    osignUrl();
  }

  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  void _doSomething() async {
    Timer(Duration(seconds: 3), () {
      _btnController.reset();
    });
  }

  clearUsr() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIMP Simuladores Online',
      theme: ThemeData.light(),
      home: Scaffold(
        key: _scaffoldKey,
        body: 
        Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('imagens/bgcor.jpg'), fit: BoxFit.cover,)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Column(
                        verticalDirection: VerticalDirection.up,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15, left: 15),
                            child: Container(
                              width: 500,
                              height: 550,
                              decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.9), borderRadius: BorderRadius.circular(10),),
                              child: _body(context)
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]
              ),
            ),
          ),
        ),
        drawer: 
        ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
          child: 
          Drawer(
            child: 
            Container(
              color: Colors.white,
              child: 
              CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: 
                    SliverChildListDelegate(
                      [
                        Padding(
                          padding: EdgeInsets.only(top: 50, bottom: 0, right: 80, left: 80),
                          child: Image.asset('imagens/logo.png'),
                        ),
                      ]
                    )
                  ),
                  SliverList(
                    delegate: 
                    SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Divider(),
                        ),   
                      ]
                    )
                  ),
                  SliverList(
                    delegate: 
                    SliverChildListDelegate(
                      [
                        ListTile(
                          leading: FutureBuilder(
                            future: CardCor._usrimg,
                            builder: (BuildContext context, AsyncSnapshot snapshot) => snapshot.hasData
                            ? Container(width: 70, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(snapshot.data,) )),)
                            : CircularProgressIndicator()
                          ),
                          title: FutureBuilder(
                            future: CardCor._usrnm,
                            builder: (BuildContext context, AsyncSnapshot snapshot) => snapshot.hasData
                            ? Text(snapshot.data, style: TextStyle(fontSize: 13),)
                            : CircularProgressIndicator()
                          ),
                          subtitle: FutureBuilder(
                            future: CardCor._uslog,
                            builder: (BuildContext context, AsyncSnapshot snapshot) => snapshot.hasData
                            ? Text(snapshot.data, style: TextStyle(fontSize: 10),)
                            : CircularProgressIndicator()
                          ),
                        ),
                        Center(
                          child:
                          TextButton(onPressed: (){alert4(context, "Ao sair, não receberá mais notificações...");}, child: Text('Trocar Usuário'))
                        )
                      ]
                    )
                  ),
                  SliverList(
                    delegate: 
                    SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Divider(),
                        ),   
                      ]
                    )
                  ),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
                    delegate: SliverChildListDelegate(
                      [
                        TextButton(
                          onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => HomeSimp3n()));},
                          child: 
                          Column(
                            children: [
                              Image.asset('imagens/ic_launcher.png', width: 50, height: 50,),
                              Text('SIMP', style: TextStyle(color: Colors.grey[700]))
                            ],
                          )
                        ),
                        TextButton(
                          onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Homeb2cor()));},
                          child: 
                          Column(
                            children: [
                              Image.asset('imagens/b2cor.png', width: 50, height: 50,),
                              Text('B2Cor', style: TextStyle(color: Colors.grey[700]))
                            ],
                          )
                        ),
                        FutureBuilder(
                        future: CardCor._cdCor,
                        builder: (BuildContext context, AsyncSnapshot snapshot) => snapshot.hasData
                        ? TextButton(
                            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => CardCor()));},
                            child: 
                            Column(
                              children: [
                                Image.asset('imagens/card.png', width: 50, height: 50,),
                                Text('CardCor', style: TextStyle(color: Colors.grey[700]))
                              ],
                            )
                          )
                        : TextButton(
                            onPressed: null,
                            child: 
                            Column(
                              children: [
                                Image.asset('imagens/card-off.png', width: 50, height: 50,),
                                Text('CardCor', style: TextStyle(color: Colors.grey[700]))
                              ],
                            )
                          )
                        ), 
                      ]
                    )
                  ),
                  SliverList(
                    delegate: 
                    SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Divider(),
                        ),   
                      ]
                    )
                  ),
                  SliverList(
                    delegate: 
                    SliverChildListDelegate(
                      [
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Divider(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text('Suporte', style: TextStyle(fontSize: 20), textAlign: TextAlign.left,),
                              ),
                              TextButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Ajuda()));}, child: Text('  Base de Conhecimento')),                 
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 65, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            verticalDirection: VerticalDirection.up,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 105, right: 105),
                                child: Image.asset('imagens/ag.png'),
                              )
                            ],
                          ),
                        ) 
                      ]
                    )
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: 
        SizedBox(
          height: 60,
          child: BottomNavigationBar(
            backgroundColor: Color.fromRGBO(108, 48, 255, 1),
            items: [
              BottomNavigationBarItem(
                label: '',
                icon: IconButton(
                  icon: Icon(Icons.home, color: Colors.white,), 
                  onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Homeb2cor()));}
                ) 
              ),
              BottomNavigationBarItem(
                label: '',
                icon: IconButton(
                  icon: Icon(Icons.apps, color: Colors.white,), 
                  onPressed: () => _scaffoldKey.currentState.openDrawer(),
                ) 
              ),
              BottomNavigationBarItem(
                label: '',
                icon: IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.white,), 
                  onPressed: (){alert4(context, "Ao sair, não receberá mais notificações...");},
                ) 
              ),
            ],
          ),
        ),
      ),
    );
  }



  _body(BuildContext context) {
  return Form(
    key: _formKey,
    child: Padding(
      padding: const EdgeInsets.only(left: 25, right: 25),
      child: ListView(
        children: <Widget>[
          Image.asset('imagens/card.png', width: 70, height: 70, alignment: Alignment.center,),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text('Link do seu cartão de visita digital:', style: TextStyle(color: Color.fromRGBO(108, 48, 255, 1), fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white,),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                FutureBuilder(
                  future: CardCor._cartao,
                  builder: (BuildContext context, AsyncSnapshot snapshot) => snapshot.hasData
                  ? Text(snapshot.data, style: TextStyle(color: Colors.grey), textAlign: TextAlign.center,)
                  : CircularProgressIndicator()
                ),
                 /*Text('http://meucartao.in/v078l', style: TextStyle(color: Colors.grey), textAlign: TextAlign.center,),*/
              ),
            ),
          ),
          FutureBuilder(
            future: CardCor._cartao,
            builder: (BuildContext context, AsyncSnapshot snapshot) => snapshot.hasData
            ? TextButton(onPressed: () {FlutterClipboard.copy(snapshot.data);}, child: Text('Clique para Copiar', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[400]),),)
            : CircularProgressIndicator()
          ),
          /*Text('Clique para Copiar', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[400]),),*/
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10, bottom: 6),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: Text('Insira os dados para compartilhar este cartão digital interativo:', style: TextStyle(color: Color.fromRGBO(108, 48, 255, 1), fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
          ),
          textFormFieldLogin(),
          textFormFieldSenha(),
          checkBut(),
          containerButton(context),
        ],
      ),
    )
  );
}


textFormFieldLogin() {
  String valor ="";
  return TextFormField(
    controller: controledetexto,
    onChanged: (text) {valor = text; print("O Texto: $text");},
    keyboardType: TextInputType.text,
    style: TextStyle(color: Colors.grey[600]),
    decoration: InputDecoration( 
      labelText: "Nome",
      labelStyle: TextStyle(color: Colors.grey[600]),
      hintText: "Nome do Cliente"
    )
  );  
}

textFormFieldSenha() {
  return TextFormField(
    controller: controledesenha, 
    style: TextStyle(color: Colors.grey[600]),
    decoration: InputDecoration( 
      labelText: "WhatsApp",
      labelStyle: TextStyle(color: Colors.grey[600]),
      hintText: "DDD + Número"
    )
  );
}

checkBut(){
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: Row(
      children: [
        Checkbox(value: this._checkBoxVal, onChanged: (bool value) {setState(() => this._checkBoxVal = value);}, ),
        Text('Salvar como indicação no B2Cor', style: TextStyle(color: Colors.grey[600], fontSize: 8.0,),),
      ],
    ),
  );
}

containerButton(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: 10.0, right: 25, left: 25),
    child: 
    RoundedLoadingButton(
      borderRadius: 5,
      color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Icon(FontAwesome5Brands.whatsapp, color: Colors.white,),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Text("  Compartilhar", style: TextStyle(color: Colors.white, fontSize: 17.0)),
          ),          
        ],
      ),
      controller: _btnController,
      onPressed: () { _doSomething(); if(_checkBoxVal == true){_onClickLogin(context); _launchURL();} else{_launchURL();}},
      width: 260,
    ),
  );
}

_launchURL() async {
  var prefs = await SharedPreferences.getInstance();
  String cartao = (prefs.getString("cartao") ?? "");
  var nm = controledetexto.text;
  var wts = controledesenha.text;
  var url = 'http://wa.me/55$wts?text=Olá+$nm+veja+meu+cartao+$cartao';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


_onClickLogin(BuildContext context) async {
  var prefs = await SharedPreferences.getInstance();
  String id = (prefs.getString("id") ?? "");
    final nome = controledetexto.text;
    final fone = controledesenha.text;
    final responsavel = '$id';
    print("Nome: $nome , Celular: $fone , Responsavel: $id");      

    if( nome.isEmpty ){
      alert2(context, "Preencha os Dados");
     }
     else {
       var usuarioCard = await ApiCard.login(nome,fone,responsavel);
       if( usuarioCard != null ) {
          alertAddLead(context, 'Indicação Adicionada');
        }
       else {
        alertNoAddLead(context, 'Indicação Não Adicionada');
       }    
     }
  }



}

