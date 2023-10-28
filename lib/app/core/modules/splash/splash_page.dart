import 'package:encontrar_cuidadodoctor/app/core/modules/root/root_store.dart';
import 'package:encontrar_cuidadodoctor/app/core/services/auth/auth_store.dart';
import 'package:encontrar_cuidadodoctor/app/core/utils/auth_status_enum.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

class SplashPage extends StatefulWidget {
  final String title;
  const SplashPage({Key key, this.title = 'SplashPage'}) : super(key: key);
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final RootStore rootController = Modular.get();
  final AuthStore auth = Modular.get();

  ReactionDisposer disposer;

  @override
  void initState() {
    super.initState();
    disposer = autorun((_) {
      print('auth: ${auth.status} ');
      if (auth.status == AuthStatus.signed_in) {
        print('logado');
        // Modular.to.pushReplacementNamed('/master');
        rootController.setSelectedTrunk(2); //Trunk 2 = master (tab)
      } else if (auth.status == AuthStatus.signed_out) {
        print('deslogado');
        rootController.setSelectedTrunk(1);
        //Trunk 1 = signin-email
        // Modular.to.pushReplacementNamed('/signin-email');
      } // otherwise, simply ignore (keeps on loading)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Container()));

    // Container(
    //   child: Center(
    //     child: Image.asset(
    //       "assets/aiyou_splash.png",
    //     ),
    //   ),
    // );
    // appBar: AppBar(
    //  title: Text(widget.title),
    //  ),
    // body: Center(
    //  child: CircularProgressIndicator(),
    //  ));
    //}

    //@override
    //void dispose() {
    // super.dispose();
    // disposer();
  }
}
