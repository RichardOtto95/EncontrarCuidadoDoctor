import 'package:encontrar_cuidadodoctor/app/core/modules/root/root_store.dart';
import 'package:encontrar_cuidadodoctor/app/core/modules/splash/splash_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/sign/sign_module.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  final String title;
  const RootPage({Key key, this.title = 'RootPage'}) : super(key: key);
  @override
  RootPageState createState() => RootPageState();
}

class RootPageState extends ModularState<RootPage, RootStore> {
  final RootStore store = Modular.get();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.setBucket(PageStorageBucket());
    });
    super.initState();
  }

  // final RootStore storeAuth = Modular.get();
  // Future<bool> _onWillPop() async {
  //   return (await showDialog(
  //         context: context,
  //         builder: (context) => new RichAlertDialog(
  //           alertTitle: richTitle("Deseja sair?"),
  //           alertSubtitle: richSubtitle("O aplicativo será fechado"),
  //           alertType: RichAlertType.WARNING,
  //           actions: <Widget>[
  //             new FlatButton(
  //               onPressed: () => Navigator.of(context).pop(),
  //               child: new Text('Não'),
  //             ),
  //             new FlatButton(
  //               onPressed: () => exit(0),
  //               child: new Text('Sim'),
  //             ),
  //           ],
  //         ),
  //       )) ??
  //       false;
  // }
  List<Widget> trunkModule = [SplashModule(), SignModule(), MainModule()];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          // backgroundColor: ThemeConecta().backgroundColor,
          body: Observer(builder: (_) {
        return trunkModule[controller.selectedTrunk];
      })),
    );
  }
}
