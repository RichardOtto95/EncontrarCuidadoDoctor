import 'package:flutter/material.dart';

class AccountBalance extends StatefulWidget {
  final String value;
  final String date;
  final double left;
  final double top;
  final double right;
  final double bottom;

  const AccountBalance({
    Key key,
    this.value,
    this.date,
    this.left,
    this.top,
    this.right,
    this.bottom,
  }) : super(key: key);

  @override
  _AccountBalanceState createState() => _AccountBalanceState();
}

class _AccountBalanceState extends State<AccountBalance> {
  bool hideAccount = true;

  @override
  Widget build(BuildContext context) {
    double wXD(double size, BuildContext context) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        wXD(22, context),
        wXD(15, context),
        wXD(5, context),
        wXD(5, context),
      ),
      child: Row(
        children: [
          Container(
            child: Text(
              'Saldo em conta',
              style: TextStyle(
                fontSize: wXD(18, context),
                fontWeight: FontWeight.w400,
                color: Color(0xff707070),
              ),
            ),
          ),
          Spacer(),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  hideAccount == false ? 'R\$${widget.value}' : 'R\$ ****',
                  style: TextStyle(
                    fontSize: wXD(17, context),
                    fontWeight: FontWeight.w400,
                    color: Color(0xff707070),
                  ),
                ),
                SizedBox(
                  width: wXD(15, context),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                  onTap: () {
                    setState(() {
                      hideAccount = !hideAccount;
                    });
                  },
                  child: hideAccount == false
                      ? Icon(
                          Icons.visibility_outlined,
                          color: Color(0xff41C3B3),
                          size: wXD(25, context),
                        )
                      : Icon(
                          Icons.visibility_off_outlined,
                          color: Color(0xff41C3B3),
                          size: wXD(25, context),
                        ),
                ),
                SizedBox(
                  width: wXD(15, context),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
