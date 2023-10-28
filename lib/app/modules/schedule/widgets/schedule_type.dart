import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../schedule_store.dart';

class AppointmentType extends StatefulWidget {
  final Function tap;
  final bool hasFocus, enabled;
  final type;
  const AppointmentType(
      {Key key, this.hasFocus, this.enabled = true, this.type, this.tap})
      : super(key: key);
  @override
  _AppointmentTypeState createState() => _AppointmentTypeState();
}

class _AppointmentTypeState extends State<AppointmentType> {
  final ScheduleStore store = Modular.get();
  FocusNode focusNode = FocusNode();
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus && widget.enabled) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      } else if (widget.enabled) {
        this._overlayEntry.remove();
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          offset: Offset(0, size.height),
          link: this._layerLink,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: wXD(14, context), vertical: wXD(9, context)),
              width: wXD(250, context),
              height: wXD(75, context),
              decoration: BoxDecoration(
                color: Color(0xfffafafa),
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x30000000),
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      store.appointmentType = 'Hora marcada';
                      store.textEditingController.text = '1';
                      widget.tap();

                      focusNode.unfocus();
                    },
                    child: Container(
                      width: wXD(222, context),
                      height: wXD(23.5, context),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Hora marcada',
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      store.appointmentType = 'Ordem de chegada';
                      focusNode.unfocus();
                    },
                    child: Container(
                      width: wXD(222, context),
                      height: wXD(23.5, context),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Ordem de chegada',
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: this._layerLink,
      child: Focus(
        focusNode: focusNode,
        child: Observer(builder: (context) {
          return InkWell(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              focusNode.requestFocus();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: wXD(10, context)),
              height: wXD(32, context),
              width: wXD(250, context),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff707070)),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Spacer(),
                  Text(
                    store.appointmentType == ''
                        ? 'Selecione o tipo da consulta'
                        : widget.enabled == true
                            ? store.appointmentType
                            : widget.type == 'Horário cadastrado'
                                ? 'Hora marcada'
                                : 'Ordem de chegada',
                    style: TextStyle(
                      color: store.appointmentType == ''
                          ? Color(0xff707070).withOpacity(.4)
                          : Color(0xff4c4c4c),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  widget.enabled
                      ? Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xff707070).withOpacity(.4),
                          size: wXD(20, context),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
