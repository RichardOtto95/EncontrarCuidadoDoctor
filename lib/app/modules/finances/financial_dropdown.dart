import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class FinancialDrowdown extends StatefulWidget {
  const FinancialDrowdown({Key key}) : super(key: key);

  @override
  _FinancialDrowdownState createState() => _FinancialDrowdownState();
}

class _FinancialDrowdownState extends State<FinancialDrowdown> {
  bool showMenu = false;

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            setState(() {
              showMenu = !showMenu;
            });
          },
          child: Icon(Icons.filter_list_outlined),
        ),
        Visibility(
          visible: showMenu,
          child: Container(
            height: maxHeight,
            width: maxWidth,
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(
              right: wXD(40, context),
              top: wXD(16, context),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: wXD(10, context),
                // horizontal: wXD(20, context)
              ),
              height: wXD(111, context),
              width: wXD(160, context),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff707070).withOpacity(.1)),
                color: Color(0xfffafafa),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x15000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: wXD(20, context)),
                    width: wXD(160, context),
                    height: wXD(22, context),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xff41C3B3).withOpacity(.25)),
                    child: Text(
                      'Todos',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: wXD(15, context),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: wXD(20, context)),
                    width: wXD(160, context),
                    height: wXD(22, context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Entradas',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: wXD(15, context),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: wXD(20, context)),
                    width: wXD(160, context),
                    height: wXD(22, context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Saídas',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: wXD(15, context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
