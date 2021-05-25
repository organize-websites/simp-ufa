import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simp/privacidade.dart';
import 'package:simp/api/home_block.dart';
import 'package:simp/pushin.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import 'alerta.dart';
import 'api/api.dart';
import 'esqueci_a_senha.dart';
import 'homesimp.dart';
import 'cadastro.dart';

const androidString = const AndroidAuthMessages(
  cancelButton: 'Cancelar',
  signInTitle: 'Autenticação Biometrica',
  biometricHint: 'Use sua Digital',
  biometricNotRecognized: 'Não confere, tente novamente',
  biometricSuccess: 'Sucesso! Aguarde...',
  goToSettingsButton: 'Configurações',
  goToSettingsDescription: 'Você precisa usar a biometria',
  biometricRequiredTitle: 'Biometria Necessaria'
);

const iosString = const IOSAuthMessages(
  lockOut: 'Você precisa habilitar uma biometria',
  goToSettingsButton: 'Configurações',
  goToSettingsDescription: 'Configure uma biometria',
  cancelButton: 'Cancelar'
);
 

Future<void> main() async {
  var prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('tokenjwt');
  print(token);
  runApp(MaterialApp(home: token == null ? HomePage() : HomeSimp3()));
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
 
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric;
  String authorized = "Not authorized";

  // verificação bimétrica
  // esta função irá verificar os sensores e nos informará
  // se podemos usá-los ou não
  Future<void> _checkBiometric() async{
    bool canCheckBiometric;
    try{
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch(e){
      print(e);
    }
    if(!mounted) return;
    setState(() {
      _canCheckBiometric = canCheckBiometric;
    });
  }

  // esta função abrirá uma caixa de diálogo de autenticação
  // e verificará se estamos autenticados ou não
  // então adicionaremos a ação principal aqui, como mudar para outra atividade
  // ou apenas exibir um texto que nos diga que estamos autenticados
  Future<void> _authenticate() async{
    bool authenticated = false;
    try{
      authenticated = await auth.authenticate(
          localizedReason: "Use a biometria para autenticar",
          useErrorDialogs: false,
          androidAuthStrings: androidString,
          iOSAuthStrings: iosString,
          stickyAuth: true,
          biometricOnly: true
      );
    } on PlatformException catch(e){
      if (e.code == auth_error.notEnrolled) {
        usrauth();
      }
      if (e.code == auth_error.notAvailable){
        usrauth();
      }
      if (e.code == auth_error.passcodeNotSet){
        usrauth();
      }
      print(e);
    }
    if(!mounted) return;
    setState(() {
       authorized = authenticated ? usrauth() : "Falha ao autenticar";
    });
  }

  usrauth(){
    OneSignal.shared.setSubscription(true); _onClickLogin(context); _doSomething();
  }

  var bloc = BlocHome();

  paraOutraTela() async{
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, main);
  }

  osignStt() async{
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, bloc.initOneSignal);
  }

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
    paraOutraTela();
    _checkBiometric();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  void _doSomething() async {
    Timer(Duration(seconds: 3), () {
      _btnController.reset();
    });
  }

static Future<String> get _usrid async {

  var prefs = await SharedPreferences.getInstance();
  String oneid = (prefs.getString("oneid") ?? "");

String toString() {
    return '$oneid';
  }

    await Future.delayed(Duration(seconds: 1));
    return '$oneid';
  } 
  
  final _tLogin = TextEditingController();

  final _tSenha = TextEditingController();

  final _tonesignalUserId = _usrid;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIMP Simuladores Online',
      theme: ThemeData.light(),
      home: Scaffold(
        body: 
        Container(
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage('imagens/bg.png'), fit: BoxFit.cover,)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Column(
                        verticalDirection: VerticalDirection.up,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Não possuí login e senha', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,),
                                TextButton(child: Text('Faça seu cadastro aqui!', style: TextStyle(color: Colors.white), textAlign: TextAlign.center,), onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Cadastro()));},)
                              ]
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                            child: Container(
                              height: 500,
                              width: 400,                              
                              decoration: BoxDecoration(image: DecorationImage(image: AssetImage('imagens/bg-f.png'), fit: BoxFit.fitWidth,)),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 110),
                                child:
                                _body(context),
                              )
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
      ),
    );
  }



  _body(BuildContext context) {
  return Form(
    key: _formKey,
    child: Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 40, left: 25, right: 25),
      child: ListView(
        children: <Widget>[
          textFormFieldLogin(),
          textFormFieldSenha(),
          containerButton(context),
          Row(
            verticalDirection: VerticalDirection.up,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>Privacidade()));}, child: Text('Privacidade', style: TextStyle(color: Colors.grey[600]),)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>Esqueci()));}, child: Text('? Lembrar Senha', style: TextStyle(color: Colors.grey[600]),)),
                ],
              ),
            ],
          )
        ],
      ),
    )
  );
}

textFormFieldLogin() {
  return Padding(
    padding: const EdgeInsets.only(top: 55),
    child: TextFormField(
      controller: _tLogin,
             validator: _validateLogin,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.grey[600]),
      decoration: InputDecoration( 
        labelText: "Login",
        labelStyle: TextStyle(color: Colors.grey[600]),
        hintText: "Informe o login"
      )
    ),
  );
}

textFormFieldSenha() {
  return TextFormField( 
    controller: _tSenha,
            validator: _validateSenha,
    obscureText: true,
    keyboardType: TextInputType.text,
    style: TextStyle(color: Colors.grey[600]),
    decoration: InputDecoration( 
      labelText: "Senha",
      labelStyle: TextStyle(color: Colors.grey[600]),
      hintText: "Informe a senha"
    )
  );
}

containerButton(BuildContext context) {
  return Container(
    height: 35.0,
    width: 90.0,
    margin: EdgeInsets.only(top: 10.0, right: 55, left: 55),
    child: 
    RoundedLoadingButton(
      borderRadius: 5,
      color: Color.fromRGBO(42, 69, 124, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Acessar  ", style: TextStyle(color: Colors.white, fontSize: 17.0)),
          Icon(Icons.arrow_forward, color: Colors.white,)
        ],
      ),
      controller: _btnController,
      onPressed: () {/*OneSignal.shared.setSubscription(true); _onClickLogin(context); _doSomething(); */if(_canCheckBiometric == true){_authenticate();}else{OneSignal.shared.setSubscription(true); _onClickLogin(context); _doSomething();}},
      width: 200,
    ),
  );
}

  _onClickLogin(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();
    final login = _tLogin.text;
    final senha = _tSenha.text;
    final onesignalUserId = _tonesignalUserId;
    print("Login: $login , Senha: $senha , os: $onesignalUserId" );      

    if( login.isEmpty || senha.isEmpty ){
      alert2(context, "Preencha os Dados");
     }
     else {
       var usuario = await LoginApi.login(login,senha,toString());
       if( usuario != null ) {
          navegaHomeSimp(context);
        }
       else {
        String msg = (prefs.getString("msg") ?? "");
        alert(context, '$msg');
       }    
     }
  }

  navegaHomeSimp(BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeSimp3()),);
  }

String _validateLogin(String text){
    if(text.isEmpty){
      return alert(context, "Informe o login");
    }
    return null;
}

String _validateSenha(String text){
    if(text.isEmpty){
      return "Informe a senha";
    }
    return null;
  } 
}
