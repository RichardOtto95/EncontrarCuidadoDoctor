import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/secretary_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/secretaries/widgets/confirm_secretary.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/confirm_popup.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/load_circular_overlay.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../secretaries_store.dart';

String secretaryId;

class SecretarieProfile extends StatefulWidget {
  final SecretaryModel secretary;

  const SecretarieProfile({Key key, this.secretary}) : super(key: key);
  @override
  _SecretarieProfileState createState() => _SecretarieProfileState();
}

final SecretariesStore store = Modular.get();

class _SecretarieProfileState extends State<SecretarieProfile> {
  final MainStore mainStore = Modular.get();

  int index = 0;
  bool remove = false;
  @override
  void initState() {
    secretaryId = widget.secretary.id;
    super.initState();
  }

  bool getPermission() {
    bool valid = false;
    if (widget.secretary.doctorId != null &&
        mainStore.authStore.type == 'SECRETARY') {
      valid = true;
    }

    if (widget.secretary.doctorId != null &&
        mainStore.authStore.type == 'DOCTOR' &&
        widget.secretary.doctorId == mainStore.authStore.user.uid) {
      valid = true;
    }

    return valid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EncontrarCuidadoAppBar(
                  onTap: () {
                    Modular.to.pop();
                  },
                  title: 'Perfil do secretário',
                ),
                Perfil(
                  secretary: widget.secretary,
                  onRemove: () {
                    OverlayEntry confirmOverlay;
                    confirmOverlay = OverlayEntry(
                        builder: (context) => ConfirmSecretary(
                              onConfirm: () async {
                                OverlayEntry loadOverlay;
                                loadOverlay = OverlayEntry(
                                    builder: (context) =>
                                        LoadCircularOverlay());
                                Overlay.of(context).insert(loadOverlay);
                                await store.confirmRemoveSecretary(
                                  secretaryId: widget.secretary.id,
                                );
                                loadOverlay.remove();
                                confirmOverlay.remove();
                                Modular.to.pop();
                              },
                              onBack: () {
                                confirmOverlay.remove();
                              },
                              svgWay: "./assets/svg/removesecretary.svg",
                              text:
                                  "Tem certeza que deseja remover\neste secretário?",
                            ));
                    Overlay.of(context).insert(confirmOverlay);
                  },
                ),
                Separator(),
                SecretarieDetails(
                  index: index,
                  onTap0: () {
                    if (index != 0) {
                      setState(() {
                        index = 0;
                      });
                    }
                  },
                  onTap1: () {
                    if (index != 1) {
                      setState(() {
                        index = 1;
                      });
                    }
                  },
                  onTap2: () {
                    if (index != 2) {
                      if (getPermission()) {
                        setState(() {
                          index = 2;
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "Espere o secretário aceitar se juntar à equipe para poder definir permissões.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Color(0xff21BCCE),
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    }
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: index == 0
                        ? Informations(
                            secretary: widget.secretary,
                          )
                        : index == 1
                            ? Contact(
                                secretary: widget.secretary,
                              )
                            : index == 2
                                ? Permissions()
                                : Container(),
                  ),
                )
              ],
            ),
            ConfirmPopUp(
              visible: remove,
              text: 'Tem certesa que deseja remover este secretário?',
              onCancel: () {
                setState(() {
                  remove = false;
                });
              },
              onConfirm: () async {
                await store.confirmRemoveSecretary(
                  secretaryId: widget.secretary.id,
                );
                setState(() {
                  remove = false;
                });
                Modular.to.pop();
              },
            )
          ],
        ),
      ),
    );
  }
}

class Permissions extends StatelessWidget {
  const Permissions({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Map permissions = {
      'PROFILE': 'Gerenciar Meu Perfil',
      'FEED': 'Gerenciar Postagens',
      'SCHEDULINGS': 'Gerenciar Agendamentos',
      'CARE': 'Gerenciar Atendimentos',
      'MESSAGES': 'Enviar Mensagens',
      'PAYMENTS': 'Gerenciar Pagamentos',
      'SECRETARIES': 'Gerenciar Secretários',
      'PREFERENCES': 'Gerenciar Preferências'
    };
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('doctors')
            .doc(secretaryId)
            .collection('permissions')
            .snapshots(),
        builder: (context, snapshot) {
          // print('snaaaaaaaaaaaaaaaaaaapshot ${snapshot.fro}');
          if (!snapshot.hasData) return Container();

          return Column(
            children: List.generate(snapshot.data.docs.length, (index) {
              var ref = snapshot.data.docs[index];
              return Permission(
                text: '${permissions[ref['label']]}',
                index: ref['label'],
                initialValue: ref['value'],
              );
            }),
          );
        });
  }
}

class Permission extends StatefulWidget {
  final String text;
  final String index;
  final bool initialValue;

  const Permission({
    Key key,
    this.text,
    this.index,
    this.initialValue = false,
  }) : super(key: key);

  @override
  _PermissionState createState() => _PermissionState();
}

class _PermissionState extends State<Permission> {
  bool showHint = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: wXD(20, context),
        vertical: wXD(7, context),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                showHint = true;
              });
              Timer(Duration(seconds: 3), () {
                setState(() {
                  showHint = false;
                });
              });
            },
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                if (store.canShowToast) {
                  store.canShowToast = false;
                  Fluttertoast.showToast(
                      msg: store.getTooltip(widget.index),
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Color(0xff21BCCE),
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Timer(Duration(seconds: 4), () {
                    store.canShowToast = true;
                  });
                }
              },
              child: Container(
                alignment: Alignment.centerLeft,
                height: MediaQuery.of(context).size.height * .05,
                width: MediaQuery.of(context).size.width * .7,
                child: Text(
                  '${widget.text}',
                  style: TextStyle(
                      color: Color(0xff000000),
                      fontSize: wXD(17, context),
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Spacer(),
          Switch(
            value: widget.initialValue,
            onChanged: (value) {
              store.changedSwitch(
                  index: widget.index, value: value, secretaryId: secretaryId);
            },
          ),
        ],
      ),
    );
  }
}

class Perfil extends StatelessWidget {
  final Function onRemove;
  final SecretaryModel secretary;

  const Perfil({Key key, this.onRemove, this.secretary}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: wXD(18, context),
        left: wXD(18, context),
        right: wXD(15, context),
      ),
      width: wXD(375, context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: secretary.avatar == null
                  ? Container(
                      color: Color(0xff41c3b3),
                      child: Image.asset(
                        'assets/img/defaultUser.png',
                        height: wXD(88, context),
                        width: wXD(88, context),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      color: Color(0xff41c3b3),
                      child: CachedNetworkImage(
                        imageUrl: secretary.avatar,
                        width: wXD(88, context),
                        height: wXD(88, context),
                        fit: BoxFit.cover,
                      ),
                    )),
          SizedBox(
            width: wXD(8, context),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: wXD(10, context),
              ),
              Container(
                width: wXD(245, context),
                child: Text(
                  // 'Cirilo Fulano de Tal Ferraz',
                  secretary.username,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: Color(0xff484D54),
                    fontWeight: FontWeight.w900,
                    fontSize: wXD(16, context),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: wXD(4, context), left: wXD(5, context)),
                child: Text(
                  'Secretário',
                  style: TextStyle(
                    color: Color(0xff000000),
                    fontWeight: FontWeight.w400,
                    fontSize: wXD(14, context),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: wXD(15, context),
                  top: wXD(10, context),
                  bottom: wXD(10, context),
                ),
                child: RemoveSecretarie(onTap: onRemove),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RemoveSecretarie extends StatelessWidget {
  final Function onTap;

  const RemoveSecretarie({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: wXD(217, context),
          height: wXD(30, context),
          decoration: BoxDecoration(
              border: Border.all(color: Color(0xff41C3B3), width: 2),
              color: Color(0xfffafafa),
              borderRadius: BorderRadius.circular(20)),
          alignment: Alignment.center,
          child: Text('Remover secretário',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xffDB2828)))),
    );
  }
}

class SecretarieDetails extends StatelessWidget {
  final int index;
  final Function onTap0;
  final Function onTap1;
  final Function onTap2;

  const SecretarieDetails({
    Key key,
    this.index = 0,
    this.onTap0,
    this.onTap1,
    this.onTap2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: wXD(5, context),
      ),
      height: wXD(63, context),
      width: wXD(375, context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 3),
            blurRadius: 3,
            color: Color(0x30000000),
          )
        ],
        color: Color(0xfffafafa),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: maxWidth(context),
                    child: Row(
                      children: [
                        Spacer(),
                        // SizedBox(width: wXD(15, context)),
                        InkWell(
                          onTap: onTap0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: wXD(20, context)),
                            width: wXD(95, context),
                            alignment: Alignment.center,
                            child: Text(
                              'Informações',
                              style: TextStyle(
                                color: index == 0
                                    ? Color(0xff2185D0)
                                    : Color(0xff707070),
                                fontWeight: FontWeight.w700,
                                fontSize: wXD(15, context),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        // SizedBox(width: wXD(15, context)),
                        InkWell(
                          onTap: onTap1,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: wXD(20, context)),
                            width: wXD(94, context),
                            alignment: Alignment.center,
                            child: Text(
                              'Contato',
                              style: TextStyle(
                                color: index == 1
                                    ? Color(0xff2185D0)
                                    : Color(0xff707070),
                                fontWeight: FontWeight.w700,
                                fontSize: wXD(15, context),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        // SizedBox(width: wXD(15, context)),
                        InkWell(
                          onTap: onTap2,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: wXD(20, context)),
                            width: wXD(90, context),
                            alignment: Alignment.center,
                            child: Text(
                              'Permissões',
                              style: TextStyle(
                                color: index == 2
                                    ? Color(0xff2185D0)
                                    : Color(0xff707070),
                                fontWeight: FontWeight.w700,
                                fontSize: wXD(15, context),
                              ),
                            ),
                          ),
                        ),
                        Spacer(),
                        // SizedBox(width: wXD(15, context)),
                      ],
                    ),
                  ),
                  Spacer(),
                  Stack(
                    children: [
                      Container(
                        width: wXD(435, context),
                        height: wXD(3, context),
                      ),
                      AnimatedPositioned(
                        bottom: 0,
                        left: index == 0
                            ? wXD(25, context)
                            : index == 1
                                ? wXD(161, context)
                                : wXD(262, context),
                        curve: Curves.ease,
                        duration: Duration(milliseconds: 300),
                        child: AnimatedContainer(
                          curve: Curves.ease,
                          duration: Duration(milliseconds: 300),
                          height: wXD(8, context),
                          width: index == 0
                              ? wXD(94, context)
                              : index == 1
                                  ? wXD(59, context)
                                  : index == 2
                                      ? wXD(90, context)
                                      : wXD(94, context),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(8)),
                            color: Color(0xff2185d0),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Informations extends StatelessWidget {
  final SecretaryModel secretary;

  const Informations({Key key, this.secretary}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: wXD(6, context)),
        InformationTitle(icon: Icons.person, title: 'Nome Completo'),
        InfoText(
            title: secretary.fullname != null
                ? secretary.fullname
                : 'Não informado'),
        Separator(vertical: wXD(9, context)),
        InformationTitle(icon: Icons.cake, title: 'Data de nascimento'),
        InfoText(title: getMask(type: 'birthday', date: secretary.birthday)),
        Separator(vertical: wXD(9, context)),
        InformationTitle(icon: Icons.person_pin_rounded, title: 'CPF'),
        InfoText(title: getMask(type: 'cpf', cpf: secretary.cpf)),
        Separator(vertical: wXD(9, context)),
        InformationTitle(icon: Icons.wc, title: 'Gênero'),
        InfoText(
            title:
                secretary.gender != null ? secretary.gender : 'Não informado'),
        Separator(vertical: wXD(9, context)),
      ],
    );
  }

  dynamic getMask({String type, String cpf, Timestamp date}) {
    if (type == 'cpf') {
      if (cpf != null) {
        String newCpf = cpf.substring(0, 3) +
            '.' +
            cpf.substring(3, 6) +
            '.' +
            cpf.substring(6, 9) +
            '-' +
            cpf.substring(9, 11);

        return newCpf;
      } else {
        return 'Não informado';
      }
    } else {
      if (date != null) {
        DateTime dt = date.toDate();
        String newDate = dt.day.toString().padLeft(2, '0') +
            '/' +
            dt.month.toString().padLeft(2, '0') +
            '/' +
            dt.year.toString();
        return newDate;
      } else {
        return 'Não informado';
      }
    }
  }
}

class InfoText extends StatelessWidget {
  final String title;
  final double size;
  final double left;
  final double right;
  final double top;
  final double height;
  final Color color;
  final FontWeight weight;

  const InfoText({
    Key key,
    this.title,
    this.size = 15,
    this.left = 40,
    this.right = 20,
    this.top = 10,
    this.height = 1,
    this.color,
    this.weight,
  }) : super(key: key);

  getColor() {
    Color _color;
    if (color == null) {
      _color = Color(0xff707070);
    } else {
      _color = color;
    }
    return _color;
  }

  getWeight() {
    FontWeight _weight;
    if (weight == null) {
      _weight = FontWeight.w400;
    } else {
      _weight = weight;
    }
    return _weight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: wXD(375, context),
      padding: EdgeInsets.only(
        left: wXD(left, context),
        right: wXD(right, context),
        top: wXD(top, context),
      ),
      child: Text(
        '$title',
        style: TextStyle(
          height: height,
          color: getColor(),
          fontWeight: getWeight(),
          fontSize: wXD(size, context),
        ),
      ),
    );
  }
}

class Topic extends StatelessWidget {
  final String title;

  const Topic({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: wXD(375, context),
      padding: EdgeInsets.only(
        top: wXD(4.5, context),
        bottom: wXD(4.5, context),
        left: wXD(40, context),
        right: wXD(20, context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin:
                EdgeInsets.only(right: wXD(4, context), top: wXD(5, context)),
            height: wXD(6, context),
            width: wXD(6, context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color(0xff707070),
            ),
          ),
          Container(
            width: wXD(300, context),
            child: Text(
              '$title',
              maxLines: 5,
              style: TextStyle(
                color: Color(0xff707070),
                fontWeight: FontWeight.w400,
                fontSize: wXD(15, context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InformationTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final double left;
  final Color color;

  const InformationTitle({
    Key key,
    this.icon,
    this.title,
    this.color,
    this.left,
  }) : super(key: key);

  getColor() {
    Color _color;
    if (color == null) {
      _color = Color(0xff707070);
    } else {
      _color = color;
    }
    return _color;
  }

  getLeft(BuildContext context) {
    double _left;
    if (left == null) {
      _left = wXD(30, context);
    } else {
      _left = left;
    }
    return _left;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: getLeft(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: wXD(22, context),
            color: Color(0xff707070).withOpacity(.8),
          ),
          SizedBox(
            width: wXD(10, context),
          ),
          Container(
            width: wXD(294, context),
            padding: EdgeInsets.only(top: wXD(2, context)),
            child: Text(
              '$title',
              style: TextStyle(
                color: getColor(),
                fontWeight: FontWeight.w500,
                fontSize: wXD(15, context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Contact extends StatelessWidget {
  final SecretaryModel secretary;

  const Contact({
    Key key,
    this.secretary,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: wXD(20, context)),
        InformationTitle(icon: Icons.phone, title: 'Número de telefone'),
        InfoText(title: getMask(phone: secretary.landline, type: 'landline')),
        InfoText(title: getMask(phone: secretary.phone, type: 'mobile')),
        Separator(vertical: wXD(9, context)),
        InformationTitle(icon: Icons.email, title: 'E-mail'),
        InfoText(
            title: secretary.email != null ? secretary.email : 'Não informado'),
        Separator(vertical: wXD(9, context)),
      ],
    );
  }

  String getMask({String phone, String type}) {
    if (type == 'mobile') {
      if (phone != null) {
        String newPhone = phone.substring(0, 3) +
            ' (' +
            phone.substring(3, 5) +
            ') ' +
            phone.substring(5, 10) +
            ' ' +
            phone.substring(10, 14);
        return newPhone;
      } else {
        return 'Não informado';
      }
    } else {
      if (phone != null) {
        String newPhone = '(' +
            phone.substring(0, 2) +
            ') ' +
            phone.substring(2, 6) +
            '-' +
            phone.substring(6, 10);
        return newPhone;
      } else {
        return 'Não informado';
      }
    }
  }
}
