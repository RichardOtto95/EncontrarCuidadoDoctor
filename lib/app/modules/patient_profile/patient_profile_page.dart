import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/patient_model.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/separator.dart';
import 'patient_profile_store.dart';

class PatientProfilePage extends StatefulWidget {
  final PatientModel userModel;
  const PatientProfilePage({
    Key key,
    this.userModel,
  }) : super(key: key);
  @override
  PatientProfilePageState createState() => PatientProfilePageState();
}

class PatientProfilePageState extends State<PatientProfilePage> {
  int index = 0;
  final PatientProfileStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EncontrarCuidadoAppBar(
              onTap: () {
                Navigator.pop(context);
              },
              title: 'Perfil do paciente',
            ),
            Perfil(userModel: widget.userModel),
            Separator(),
            PatientDetails(
              index: index,
              onTap1: () {
                if (index != 0) {
                  setState(() {
                    index = 0;
                  });
                }
              },
              onTap2: () {
                if (index != 1) {
                  setState(() {
                    index = 1;
                  });
                }
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: index == 0
                    ? Informations(userModel: widget.userModel)
                    : index == 1
                        ? Contact(userModel: widget.userModel)
                        : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Perfil extends StatelessWidget {
  final PatientModel userModel;

  const Perfil({
    Key key,
    this.userModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: wXD(18, context),
        left: wXD(18, context),
        right: wXD(15, context),
      ),
      height: wXD(120, context),
      width: wXD(375, context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: wXD(44, context),
            backgroundImage: userModel.avatar == null
                ? AssetImage('assets/img/defaultUser.png')
                : NetworkImage(
                    userModel.avatar,
                  ),
          ),
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
                  userModel.fullname != null
                      ? userModel.fullname
                      : 'Não informado',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xff484D54),
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                userModel.type == 'DEPENDENT' ? 'Depente' : 'Paciente',
                style: TextStyle(
                  color: Color(0xff484D54),
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PatientDetails extends StatelessWidget {
  final int index;
  final Function onTap1;
  final Function onTap2;

  const PatientDetails({
    Key key,
    this.index = 0,
    this.onTap1,
    this.onTap2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: wXD(5, context),
      ),
      height: wXD(62, context),
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              InkWell(
                onTap: onTap1,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: wXD(20, context)),
                  width: wXD(100, context),
                  alignment: Alignment.center,
                  child: Text(
                    'Informações',
                    style: TextStyle(
                      color: index == 0 ? Color(0xff2185D0) : Color(0xff707070),
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(width: wXD(45, context)),
              InkWell(
                onTap: onTap2,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: wXD(20, context)),
                  width: wXD(100, context),
                  alignment: Alignment.center,
                  child: Text(
                    'Contato',
                    style: TextStyle(
                      color: index == 1 ? Color(0xff2185D0) : Color(0xff707070),
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
          Spacer(),
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: wXD(3, context),
              ),
              AnimatedPositioned(
                bottom: 0,
                left: index == 0
                    ? MediaQuery.of(context).size.width * .16
                    : MediaQuery.of(context).size.width * .55,
                curve: Curves.ease,
                duration: Duration(milliseconds: 300),
                child: AnimatedContainer(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 300),
                  height: wXD(8, context),
                  width: MediaQuery.of(context).size.width * .3,
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
    );
  }
}

class Informations extends StatelessWidget {
  final PatientModel userModel;

  const Informations({
    Key key,
    this.userModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: wXD(20, context),
        ),
        InformationTitle(
          icon: Icons.person,
          title: 'Nome completo:',
        ),
        InfoText(
          title:
              userModel.fullname != null ? userModel.fullname : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.cake,
          title: 'Data de nascimento:',
        ),
        InfoText(
          title: getMask(timestamp: userModel.birthday),
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.account_box,
          title: 'CPF:',
        ),
        InfoText(
          title: getMask(cpf: userModel.cpf, index: 1),
        ),
        Separator(vertical: wXD(9, context)),
        InformationTitle(
          icon: Icons.wc_sharp,
          title: 'Gênero:',
        ),
        InfoText(
          title: userModel.gender != null ? userModel.gender : 'Não informado',
        ),
        Separator(vertical: wXD(9, context)),
      ],
    );
  }

  String getMask({Timestamp timestamp, String cpf, int index = 0}) {
    String text;
    if (index == 0) {
      if (timestamp != null) {
        DateTime date = timestamp.toDate();
        text = date.day.toString().padLeft(2, '0') +
            '/' +
            date.month.toString().padLeft(2, '0') +
            '/' +
            date.year.toString();

        return text;
      } else {
        return 'Não informado';
      }
    } else {
      if (cpf != null) {
        text = cpf.substring(0, 3) +
            '.' +
            cpf.substring(3, 6) +
            '.' +
            cpf.substring(6, 9) +
            '-' +
            cpf.substring(9, 11);
        return text;
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
          fontSize: size,
        ),
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
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Contact extends StatelessWidget {
  final PatientModel userModel;

  const Contact({Key key, this.userModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: wXD(20, context),
        ),
        InformationTitle(icon: Icons.phone, title: 'Número de telefone'),
        InfoText(title: getMask(userModel.phone)),
        Separator(vertical: wXD(9, context)),
        InformationTitle(icon: Icons.email, title: 'E-mail'),
        InfoText(
            title: userModel.email != null ? userModel.email : 'Não informado'),
        Separator(vertical: wXD(9, context)),
      ],
    );
  }

  String getMask(String value) {
    String text;

    if (value != null) {
      text = value.substring(0, 3) +
          ' (${value.substring(3, 5)}) ' +
          '${value.substring(5, 10)}-' +
          value.substring(10, 14);

      return text;
    } else {
      return 'Não informado';
    }
  }
}
