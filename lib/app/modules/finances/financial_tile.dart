import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class FinancialTile extends StatelessWidget {
  final String value;
  final String date;
  final String text;
  final bool info;
  final Function onTap;
  final String id;

  const FinancialTile({
    Key key,
    this.value,
    this.date,
    this.text,
    this.info = false,
    this.onTap,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          wXD(22, context),
          wXD(2, context),
          wXD(22, context),
          wXD(8, context),
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: wXD(8, context)),
              padding: EdgeInsets.all(wXD(5, context)),
              height: wXD(32, context),
              width: wXD(32, context),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color(0xff707070), width: wXD(1, context)),
                borderRadius: BorderRadius.circular(90),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff707070),
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Center(
                  child: Icon(
                    Icons.attach_money,
                    color: Color(0xfffafafa),
                    size: wXD(20, context),
                  ),
                ),
              ),
            ),
            Container(
              width: wXD(190, context),
              child: Text(
                '$text',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff707070),
                ),
              ),
            ),
            Visibility(
              visible: info,
              child: Icon(
                Icons.info_outline,
                size: wXD(15, context),
                color: Color(0xffFBBD08),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(top: wXD(15, context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    ' R\$ $value',
                    style: TextStyle(
                      fontSize: wXD(15, context),
                      fontWeight: FontWeight.w400,
                      color: Color(0xff707070),
                    ),
                  ),
                  SizedBox(
                    height: wXD(3, context),
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: wXD(12.5, context),
                      fontWeight: FontWeight.w400,
                      color: Color(0x85787C81),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
