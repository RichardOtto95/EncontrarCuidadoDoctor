import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class AddressFields extends StatelessWidget {
  final bool enabled;

  const AddressFields({Key key, this.enabled}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DataTile(
          title: 'Endereço',
          enabled: enabled,
          hint: 'Rua 123, Quadra 321, Lote 123, Número 321',
        ),
        DataTile(
          title: 'Distrito/Bairro',
          enabled: enabled,
          hint: 'Vicente Pires',
        ),
        DataTile(
          title: 'Cidade',
          enabled: enabled,
          hint: 'Brasília',
        ),
        DataTile(
          title: 'Estado',
          enabled: enabled,
          hint: 'DF',
        ),
        DataTile(
          title: 'CEP',
          enabled: enabled,
          hint: '72005-505',
        ),
      ],
    );
  }
}

class DataTile extends StatelessWidget {
  final String title;
  final String hint;
  final bool enabled;
  final Function onChanged;

  const DataTile({
    Key key,
    this.title,
    this.enabled,
    this.onChanged,
    this.hint,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: wXD(50, context),
      margin: EdgeInsets.fromLTRB(
        wXD(44, context),
        wXD(0, context),
        wXD(44, context),
        wXD(17, context),
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0x50707070)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff707070)),
          ),
          Spacer(),
          Container(
            width: wXD(291, context),
            child: TextFormField(
              enabled: enabled,
              cursorColor: Color(0xff707070),
              decoration: InputDecoration.collapsed(
                border: InputBorder.none,
                hintText: enabled ? '' : hint,
                hintStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: enabled ? Color(0x50707070) : Color(0xff707070),
                ),
              ),
              onChanged: onChanged,
            ),
          )
        ],
      ),
    );
  }
}
