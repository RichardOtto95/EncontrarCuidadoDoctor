import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/suport/suport_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MessageBar extends StatefulWidget {
  final FocusScopeNode focus;
  const MessageBar({Key key, this.focus}) : super(key: key);

  @override
  _MessageBarState createState() => _MessageBarState();
}

class _MessageBarState extends State<MessageBar> {
  final SuportStore store = Modular.get();
  final MainStore mainStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;

    return Container(
      height: wXD(72, context),
      width: wXD(375, context),
      decoration: BoxDecoration(color: Color(0xfffafafa), boxShadow: [
        BoxShadow(
            offset: Offset(0, -3), color: Color(0x15000000), blurRadius: 3)
      ]),
      child: Row(
        children: [
          SizedBox(
            width: wXD(5, context),
          ),
          InkWell(
              onTap: () {
                setState(() {
                  widget.focus.unfocus();
                  mainStore.emojisShowC = !mainStore.emojisShowC;
                  print(
                      'mainStore.emojisShowCmainStore.emojisShowC ${mainStore.emojisShowC}');
                });
              },
              child: Container(
                height: wXD(40, context),
                width: wXD(40, context),
                child: Icon(
                  Icons.sentiment_satisfied_alt,
                  size: wXD(28, context),
                  color: Color(0xff434B56).withOpacity(.8),
                ),
              )),
          SizedBox(
            width: wXD(5, context),
          ),
          Container(
            height: wXD(45, context),
            width: wXD(235, context),
            decoration: BoxDecoration(
                border: Border.all(color: Color(0xff9A9EA4).withOpacity(.7)),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: wXD(10, context)),
                  width: maxWidth * .45,
                  height: maxHeight * .03,
                  alignment: Alignment.center,
                  child: TextField(
                    onTap: () {
                      mainStore.emojisShowC = false;
                    },
                    controller: store.txtcontrol,
                    onChanged: (txt) {
                      store.setText(store.txtcontrol.text);
                      print('text > ${store.text}');
                    },
                    cursorColor: Color(0xff707070),
                    maxLines: 2,
                    decoration: InputDecoration.collapsed(
                      border: InputBorder.none,
                      hintText: 'Digite uma mensagem...',
                      hintStyle: TextStyle(
                        fontSize: wXD(14, context),
                        fontWeight: FontWeight.w600,
                        color: Color(0xff7C8085).withOpacity(.8),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (!mainStore.hasSupport) {
                      await mainStore.setSupportChat();
                      store.txtcontrol.clear();
                      if (store.text != null) {
                        store.sendMessage(mainStore.supportId);
                      }
                    } else {
                      store.txtcontrol.clear();
                      if (store.text != null) {
                        store.sendMessage(mainStore.supportId);
                      }
                    }
                  },
                  icon: Icon(Icons.send,
                      color: Color(0xff434B56).withOpacity(.85),
                      size: wXD(25, context)),
                ),
                // SizedBox(
                //   width: 5,
                // )
              ],
            ),
          ),
          SizedBox(width: wXD(5, context)),
          InkWell(
            onTap: () async {
              await store.pickImage(mainStore.supportId);
            },
            child: Container(
              height: wXD(40, context),
              width: wXD(40, context),
              child: Icon(
                Icons.camera_alt,
                color: Color(0xff434B56).withOpacity(.85),
                size: wXD(25, context),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              store.uploadFiles(mainStore.supportId);
            },
            child: Container(
              height: wXD(40, context),
              width: wXD(40, context),
              child: Icon(
                Icons.attachment_outlined,
                color: Color(0xff434B56).withOpacity(.85),
                size: wXD(25, context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
