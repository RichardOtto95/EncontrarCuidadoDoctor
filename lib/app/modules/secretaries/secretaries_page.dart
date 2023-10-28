import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/secretary_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/empty_state.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/separator.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:encontrar_cuidadodoctor/app/modules/secretaries/secretaries_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/secretaries/widgets/phone_cpf_search.dart';
import 'package:flutter/material.dart';

class SecretariesPage extends StatefulWidget {
  const SecretariesPage({Key key}) : super(key: key);
  @override
  SecretariesPageState createState() => SecretariesPageState();
}

class SecretariesPageState extends State<SecretariesPage> {
  final SecretariesStore store = Modular.get();
  final MainStore mainStore = Modular.get();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mainStore.getQueries();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () async {
        if (store.overlayEntry != null && store.overlayEntry.mounted) {
          store.overlayEntry.remove();
        }
        return true;
      },
      child: Listener(
        onPointerDown: (covariant) =>
            FocusScope.of(context).requestFocus(new FocusNode()),
        child: Scaffold(
            body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EncontrarCuidadoAppBar(
                  title: 'Meus secretários',
                  onTap: () {
                    if (store.overlayEntry != null &&
                        store.overlayEntry.mounted) {
                      store.overlayEntry.remove();
                    }

                    Modular.to.pop();
                  }),
              SecretarieTitle(27, 19, 25, title: 'Convidar secretário'),
              PhoneCPFSearch(),
              SecretarieTitle(27, 0, 15, title: 'Meus secretários'),
              Separator(horizontal: 27),
              Expanded(
                child: SingleChildScrollView(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('doctors')
                          .doc(mainStore.authStore.viewDoctorId)
                          .collection('secretaries')
                          .snapshots(),
                      builder: (context, snapshotSecretaries) {
                        if (!snapshotSecretaries.hasData) return Container();

                        if (snapshotSecretaries.data.docs.isEmpty) {
                          return EmptyStateList(
                            top: 0,
                            image: 'assets/img/tired.png',
                            title: 'Sem secretários!',
                            description: 'Sem secretários para serem exibidos',
                          );
                        } else {
                          return Column(
                            children: List.generate(
                                snapshotSecretaries.data.docs.length, (index) {
                              String secretaryId =
                                  snapshotSecretaries.data.docs[index].id;

                              return StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('doctors')
                                      .doc(secretaryId)
                                      .snapshots(),
                                  builder: (context, snapshotSecretary) {
                                    if (!snapshotSecretary.hasData)
                                      return Container();

                                    DocumentSnapshot secretary =
                                        snapshotSecretary.data;

                                    return SecretariesTile(
                                        onTap: () {
                                          if (store.overlayEntry != null &&
                                              store.overlayEntry.mounted) {
                                            store.overlayEntry.remove();
                                          }
                                        },
                                        secretary: secretary,
                                        text: secretary['fullname'] != null
                                            ? secretary['fullname']
                                            : secretary['username']);
                                  });
                            }),
                          );
                        }
                      }),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }
}

class SecretariesTile extends StatelessWidget {
  final String text;
  final double top;
  final double bottom;
  final double horizontal;
  final double fontSize;
  final FontWeight fontWeight;
  final Color iconColor;
  final Function onTap;
  final DocumentSnapshot secretary;

  const SecretariesTile({
    Key key,
    this.text,
    this.top = 21,
    this.bottom = 21,
    this.horizontal = 28,
    this.fontSize = 19,
    this.fontWeight = FontWeight.normal,
    this.iconColor = const Color(0xff707070),
    this.onTap,
    this.secretary,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
        SecretaryModel secretaryModel = SecretaryModel.fromDocument(secretary);
        Modular.to.pushNamed('/secretaries/profile', arguments: secretaryModel);
      },
      child: Container(
        padding: EdgeInsets.only(
          top: wXD(top, context),
          bottom: wXD(bottom, context),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: wXD(horizontal, context),
        ),
        child: Row(
          children: [
            Container(
              width: wXD(290, context),
              child: Text(
                '$text',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: wXD(fontSize, context),
                  color: Color(0xff707070),
                  fontWeight: fontWeight,
                ),
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_outlined,
              size: wXD(15, context),
              color: iconColor,
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0x40707070),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class SecretarieTitle extends StatelessWidget {
  final double left;
  final double top;
  final double right;
  final double bottom;
  final String title;

  const SecretarieTitle(
    this.left,
    this.top,
    this.bottom, {
    Key key,
    this.title,
    this.right = 0,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: wXD(left, context),
        top: wXD(top, context),
        bottom: wXD(bottom, context),
      ),
      child: Text(
        title,
        style: TextStyle(
            color: Color(0xff41C3B3),
            fontSize: wXD(19, context),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
