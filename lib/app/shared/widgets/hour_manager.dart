import 'package:encontrar_cuidadodoctor/app/modules/schedule/schedule_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/white_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HourManager extends StatelessWidget {
  final bool visible;
  final Function onCancel;
  final Function onActualise;
  final Function onDelete;

  HourManager({
    Key key,
    this.visible = false,
    this.onCancel,
    this.onActualise,
    this.onDelete,
  }) : super(key: key);

  final ScheduleStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: onCancel,
            child: Container(
              height: maxHeight(context),
              width: maxWidth(context),
              color: Color(0xff000000).withOpacity(.6),
            ),
          ),
          Container(
            height: wXD(240, context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              color: Color(0xfffafafa),
              boxShadow: [
                BoxShadow(
                  color: Color(0x50000000),
                  offset: Offset(0, -5),
                  blurRadius: 7,
                )
              ],
            ),
            child: Column(
              children: [
                Spacer(),
                Text(
                  'O que deseja fazer?',
                  style: TextStyle(
                    color: Color(0xff4c4c4c),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                WhiteButton(
                  onTap: () {
                    Modular.to.pushNamed('/schedule/edit-time-register');
                    store.setShowModalAppointment(false);
                  },
                  bottom: 0,
                  top: 0,
                  text: 'Encaixar paciente',
                  color: Color(0xff2185D0),
                  width: wXD(300, context),
                  height: wXD(47, context),
                ),
                Spacer(),
                WhiteButton(
                  onTap: () {
                    Modular.to.pushNamed('/schedule/cancel-time-register');
                    store.setShowModalAppointment(false);
                  },
                  top: 0,
                  bottom: 0,
                  text: 'Excluir horários',
                  width: wXD(300, context),
                  height: wXD(47, context),
                ),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
