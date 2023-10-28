import 'package:encontrar_cuidadodoctor/app/modules/patient_profile/patient_profile_page.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/material.dart';

class CancelConsultation extends StatefulWidget {
  @override
  _CancelConsultationState createState() => _CancelConsultationState();
}

class _CancelConsultationState extends State<CancelConsultation> {
  @override
  Widget build(BuildContext context) {
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
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: wXD(26, context),
                        color: Color(0xff707070),
                      ),
                    ),
                  ),
                  Text(
                    'Cancelamento de consulta',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: wXD(20, context),
                    ),
                  ),
                ],
              ),
            ),
            InfoText(
              color: Color(0xff4c4c4c),
              left: 18,
              top: 25,
              size: 17,
              title: 'Justificativa pelo cancelamento',
            ),
            DoctorNote(
              text:
                  'Adicione aqui a informação para justificar ao paciente o motivo do cancelamento da consulta',
            ),
            Spacer(),
            Center(
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.only(
                    top: wXD(25, context),
                    bottom: wXD(30, context),
                  ),
                  height: wXD(47, context),
                  width: wXD(240, context),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                      border: Border.all(
                        color: Color(0xff707070).withOpacity(.40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 3,
                          color: Color(0x30000000),
                        )
                      ],
                      color: Color(0xfffafafa)),
                  alignment: Alignment.center,
                  child: Text(
                    'Cancelar Consulta',
                    style: TextStyle(
                      color: Color(0xffFF4444),
                      fontWeight: FontWeight.w500,
                      fontSize: wXD(18, context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorNote extends StatelessWidget {
  final String text;

  const DoctorNote({Key key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: wXD(16, context)),
        padding: EdgeInsets.symmetric(
          horizontal: wXD(13, context),
          vertical: wXD(16, context),
        ),
        height: wXD(101, context),
        width: wXD(334, context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7)),
          border: Border.all(
            color: Color(0xff707070),
          ),
        ),
        alignment: Alignment.topLeft,
        child: TextFormField(
          maxLines: 5,
          cursorColor: Color(0xff707070),
          decoration: InputDecoration.collapsed(
            border: InputBorder.none,
            hintText: '$text',
            hintStyle: TextStyle(
                height: 1.3,
                fontSize: wXD(16, context),
                fontWeight: FontWeight.w600,
                color: Color(0xff707070).withOpacity(.5)),
          ),
        ),
      ),
    );
  }
}
