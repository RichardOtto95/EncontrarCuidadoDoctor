import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'settings_store.dart';

class SettingsPage extends StatefulWidget {
  final String title;
  const SettingsPage({Key key, this.title = 'SettingsPage'}) : super(key: key);
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final SettingsStore store = Modular.get();
  final MainStore mainStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            EncontrarCuidadoNavBar(
              leading: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: wXD(11, context), right: wXD(11, context)),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: maxWidth * 26 / 375,
                        color: Color(0xff707070),
                      ),
                    ),
                  ),
                  Text(
                    'Configurações',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: wXD(20, context),
                    ),
                  ),
                ],
              ),
            ),
            PerfilTill(
              ontap: () async {
                List<num> listNum = await mainStore.getInitialValues();
                Modular.to
                    .pushNamed('/settings/preferences', arguments: listNum);
              },
              title: 'Preferências',
              icon: Icons.build,
            ),
            PerfilTill(
              ontap: () {
                Modular.to.pushNamed('/settings/info');
              },
              title: 'Informações do App',
              icon: Icons.info,
            ),
            PerfilTill(
              ontap: () {
                Modular.to.pushNamed('/settings/terms-of-usage');
              },
              title: 'Termos de uso',
              icon: Icons.article_rounded,
            ),
            PerfilTill(
              ontap: () {
                Modular.to.pushNamed('/settings/privacy-policy');
              },
              title: 'Política de privacidade',
              icon: Icons.lock,
            ),
            Spacer(
              flex: 8,
            ),
            Image.asset(
              'assets/img/Grupo de máscara 1.png',
              height: wXD(47, context),
            ),
            Spacer(
              flex: 1,
            ),
            Text(
              'Versão 1.0',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color(0xff707070).withOpacity(.6),
                fontSize: wXD(20, context),
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class PerfilTill extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function ontap;

  const PerfilTill({Key key, this.icon, this.title, this.ontap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double maxHeight = MediaQuery.of(context).size.height;
    double maxWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: ontap,
      child: Container(
        width: maxWidth,
        height: maxHeight * 41 / 375,
        child: Row(children: [
          Container(
            padding: EdgeInsets.only(
              top: maxHeight * 1 / 375,
              left: maxWidth * 1 / 375,
            ),
            child: Icon(
              icon,
              size: wXD(29, context),
              color: Color(0xff707070).withOpacity(.9),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: maxHeight * 1 / 375, left: maxWidth * 13 / 375),
            child: Text(
              '$title',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Color(0xff707070).withOpacity(.9),
                fontSize: wXD(19, context),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            size: wXD(20, context),
            color: Color(0xff707070).withOpacity(.5),
          ),
        ]),
        margin: EdgeInsets.symmetric(horizontal: maxWidth * 26 / 375),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0x40707070),
            ),
          ),
        ),
      ),
    );
  }
}
