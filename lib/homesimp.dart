import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simp/ajuda.dart';
import 'package:simp/cardcor.dart';
import 'package:simp/homesimp2.dart';
import 'package:simp/pushin.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'alerta.dart';
import 'homeb2cor.dart'; 

bool isLoading = true;
final _key = UniqueKey();

class HomeSimp3 extends StatefulWidget {

  static Future<String> get _url async {

    var pref = await SharedPreferences.getInstance();
  String token = (pref.getString("usr_tkn") ?? "");


    await Future.delayed(Duration(seconds: 1));
    return 'https://dashboard.simp.agencialink.com/login/autologin/$token';
  } 


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
  

  @override
  _HomeSimp3State createState() => _HomeSimp3State();
}

class _HomeSimp3State extends State<HomeSimp3> { 

  navOutra() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeSimp3n()));
  }

  paraOutraTela() async{
    var _duration = new Duration(seconds: 12);
    return new Timer(_duration, navOutra);
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
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
    osignUrl();
    paraOutraTela();
  }

  clearUsr() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }




  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();  
  
  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    body: Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Stack(
        children: [
          Center(
            child:FutureBuilder(
              future: HomeSimp3._url,
              builder: (BuildContext context, AsyncSnapshot snapshot) => snapshot.hasData
              ? WebViewWidget(url: snapshot.data,)
              : Image.asset('imagens/2.gif', width: 150, height: 150,)),
          ),
          Container(color: Colors.white, child: Center(child: Image.asset('imagens/2.gif', width: 150, height: 150,)))
        ],
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
                        future: HomeSimp3._usrimg,
                        builder: (BuildContext context, AsyncSnapshot snapshot) => snapshot.hasData
                        ? Container(width: 70, height: 100, decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(snapshot.data,) )),)
                        : CircularProgressIndicator()
                      ),
                      title: FutureBuilder(
                        future: HomeSimp3._usrnm,
                        builder: (BuildContext context, AsyncSnapshot snapshot) => snapshot.hasData
                        ? Text(snapshot.data, style: TextStyle(fontSize: 13),)
                        : CircularProgressIndicator()
                      ),
                      subtitle: FutureBuilder(
                        future: HomeSimp3._uslog,
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
                    future: HomeSimp3._cdCor,
                    builder: (BuildContext context, AsyncSnapshot snapshot) => snapshot.hasData
                    ? TextButton(
                        onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => CardCor()));},
                        child: 
                        Column(
                          children: [
                            Image.asset('imagens/card.png', width: 50, height: 50,),
                            Text('CardCor', style: TextStyle(color: Colors.grey[200]))
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
        backgroundColor: Color.fromRGBO(52, 58, 64, 1),
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: IconButton(
              icon: Icon(Icons.home, color: Colors.white,), 
              onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => HomeSimp3n()));}
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
              /*onPressed: (){clearUsr(); Navigator.push(context, MaterialPageRoute(builder: (context) => MudaUsr()));},*/
            ) 
          ),
        ],
      ),
    ),
  );
}

class WebViewWidget extends StatefulWidget {
  final String url;
  WebViewWidget({this.url});

  @override
  _WebViewWidget createState() => _WebViewWidget();
}

class _WebViewWidget extends State<WebViewWidget> {
  WebView _webView;
  @override
  void initState() {
    super.initState();
     _webView = WebView(
       key: _key,
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
      onProgress: (int progress) {
        print("loading ($progress%)");
      },
      onPageStarted: (start){
        setState(() {
          isLoading = true;
        });
      },
      onPageFinished: (finish){
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _webView = null;
  }

  @override
  Widget build(BuildContext context) => _webView;
}




