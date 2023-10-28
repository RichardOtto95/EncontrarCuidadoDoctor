import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'message_bubble.dart';
import 'messages_store.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

MessagesStore store = Modular.get();
final List<GlobalKey> scrollJumper = [];
FocusScopeNode focus;

class _ChatState extends State<Chat> {
  final MainStore mainStore = Modular.get();
  final MessagesStore store = Modular.get();
  TextEditingController txtcontrol = TextEditingController();
  bool searchedPaint = false;

  @override
  void initState() {
    if (mainStore.consultChat) {
      store.getConsultChat();
    } else if (store.chatStream == null) {
      store.getChats();
    }
    super.initState();
  }

  @override
  void dispose() {
    // store.chatsDispose();
    store.handleNotifications(store.chatId, false);
    store.getChats();
    store.searchPos = null;
    super.dispose();
  }

  _onEmojiSelected(Emoji emoji) {
    txtcontrol
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: txtcontrol.text.length));
    store.setText(txtcontrol.text);
  }

  onBackspacePressed() {
    txtcontrol
      ..text = txtcontrol.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: txtcontrol.text.length));
  }

  handleScroll() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (store.scrollJump && store.searchPos != null) {
        store.chatScroll.jumpTo(index: store.searchPos);
      }
      store.setJump(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    FocusScopeNode currentFocus = FocusScope.of(context);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        if (store.mainStore.consultChat == true) {
          store.mainStore.setSelectedTrunk(2);
          store.emojisShowM = false;
          // store.mainStore.consultChat = false;
        } else {
          store.mainStore.setSelectedTrunk(3);
          store.emojisShowM = false;
          store.mainStore.hasChat = false;
        }
        Modular.to.pop();
      },
      child: Scaffold(
          body: SafeArea(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('doctors')
                .doc(mainStore.authStore.user != null
                    ? mainStore.authStore.user.uid
                    : '')
                .collection('permissions')
                .where('label', isEqualTo: 'MESSAGES')
                .snapshots(),
            builder: (context, snapermissions) {
              QuerySnapshot permissions;

              if (mainStore.authStore.type == 'SECRETARY') {
                if (snapermissions.hasData) {
                  permissions = snapermissions.data;
                  store.allowed = permissions.docs.first.get('value');
                }
              }
              return StatefulBuilder(builder: (context, stateSet) {
                return Observer(
                  builder: (context) {
                    return Column(
                      children: [
                        EncontrarCuidadoNavBar(
                          leading: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: wXD(11, context),
                                    right: wXD(11, context)),
                                child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () {},
                                    child: IconButton(
                                      onPressed: () {
                                        if (store.mainStore.consultChat ==
                                            true) {
                                          store.mainStore.setSelectedTrunk(2);
                                          store.emojisShowM = false;
                                          // store.mainStore.consultChat = false;
                                        } else {
                                          store.mainStore.setSelectedTrunk(3);
                                          store.emojisShowM = false;
                                          store.mainStore.hasChat = false;
                                        }
                                        Modular.to.pop();
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios_outlined,
                                        size: wXD(26, context),
                                        color: Color(0xff707070),
                                      ),
                                    )),
                              ),
                              Text(
                                store.chatTitle != null ? store.chatTitle : '',
                                style: TextStyle(
                                  color: Color(0xff707070),
                                  fontSize: wXD(20, context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        store.chatId != null && store.chatId != ''
                            ? Expanded(
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('chats')
                                        .doc(store.chatId)
                                        .collection('messages')
                                        .orderBy('created_at', descending: true)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      QuerySnapshot messages = snapshot.data;
                                      String id;

                                      if (!snapshot.hasData) {
                                        return Container();
                                      }

                                      return GestureDetector(
                                        onTap: () {
                                          if (store.emojisShowM == true) {
                                            store.emojisShowM = false;
                                          }
                                          if (!currentFocus.hasPrimaryFocus) {
                                            currentFocus.unfocus();
                                          }
                                        },
                                        child: ScrollablePositionedList.builder(
                                            padding: EdgeInsets.only(
                                                top: wXD(10, context)),
                                            reverse: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: messages.docs.length,
                                            itemScrollController:
                                                store.chatScroll,
                                            itemBuilder: (context, index) {
                                              if (store.scrollJump == true) {
                                                handleScroll();
                                              }

                                              if (index == store.searchPos) {
                                                searchedPaint = true;
                                              }
                                              id = messages.docs[index]
                                                  .get('id');
                                              return MessageBubble(
                                                searched:
                                                    index == store.searchPos
                                                        ? searchedPaint
                                                        : false,
                                                author: messages.docs[index]
                                                    .get('author'),
                                                text: messages.docs[index]
                                                            .get('text') !=
                                                        null
                                                    ? messages.docs[index]
                                                        .get('text')
                                                    : null,
                                                isImage: messages.docs[index]
                                                            .get('image') !=
                                                        null
                                                    ? messages.docs[index]
                                                        .get('image')
                                                    : null,
                                                downloaded: messages.docs[index]
                                                    .get('dr_download'),
                                                message: id,
                                                fileName: messages.docs[index]
                                                            .get('file') !=
                                                        null
                                                    ? messages.docs[index]
                                                        .get('file')
                                                    : null,
                                                fileLink: messages.docs[index]
                                                            .get('data') !=
                                                        null
                                                    ? messages.docs[index]
                                                        .get('data')
                                                    : null,
                                                extension: messages.docs[index]
                                                            .get('extension') !=
                                                        null
                                                    ? messages.docs[index]
                                                        .get('extension')
                                                        .toString()
                                                        .toLowerCase()
                                                    : null,
                                                hour: messages.docs[index].get(
                                                            'created_at') !=
                                                        null
                                                    ? DateFormat('kk:mm')
                                                        .format(messages
                                                            .docs[index]
                                                            .get('created_at')
                                                            .toDate())
                                                    : '',
                                              );
                                            }),
                                      );
                                    }))
                            : Expanded(child: Container()),
                        store.mainStore.authStore.type == 'DOCTOR' ||
                                (store.mainStore.authStore.type ==
                                        'SECRETARY' &&
                                    store.allowed == true)
                            ? Container(
                                height: wXD(72, context),
                                width: wXD(375, context),
                                decoration: BoxDecoration(
                                    color: Color(0xfffafafa),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, -3),
                                          color: Color(0x15000000),
                                          blurRadius: 3)
                                    ]),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: wXD(5, context),
                                    ),
                                    InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          currentFocus.unfocus();
                                          store.emojisShowM =
                                              !store.emojisShowM;
                                        },
                                        child: Container(
                                          height: wXD(40, context),
                                          width: wXD(40, context),
                                          child: Icon(
                                            Icons.sentiment_satisfied_alt,
                                            size: wXD(28, context),
                                            color: Color(0xff434B56)
                                                .withOpacity(.8),
                                          ),
                                        )),
                                    SizedBox(
                                      width: wXD(5, context),
                                    ),
                                    Container(
                                      height: wXD(45, context),
                                      width: wXD(235, context),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xff9A9EA4)
                                                  .withOpacity(.7)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
                                      child: Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: wXD(10, context)),
                                            width: maxWidth * .45,
                                            height: maxHeight * .03,
                                            alignment: Alignment.center,
                                            child: TextField(
                                              // focusNode: focus,
                                              onTap: () {
                                                if (mainStore.consultChat !=
                                                    null) {}
                                                setState(() {
                                                  store.emojisShowM = false;
                                                });
                                              },
                                              controller: txtcontrol,
                                              onChanged: (txt) {
                                                store.setText(txtcontrol.text);
                                              },
                                              cursorColor: Color(0xff707070),
                                              maxLines: 2,
                                              decoration:
                                                  InputDecoration.collapsed(
                                                border: InputBorder.none,
                                                hintText:
                                                    'Digite uma mensagem...',
                                                hintStyle: TextStyle(
                                                  fontSize: wXD(14, context),
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff7C8085)
                                                      .withOpacity(.8),
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (store.text.isNotEmpty &&
                                                  store.text != null) {
                                                store.sendMessage();
                                                txtcontrol.clear();
                                              }
                                            },
                                            icon: Icon(Icons.send,
                                                color: Color(0xff434B56)
                                                    .withOpacity(.85),
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
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        await store.pickImage(store.chatId);
                                      },
                                      child: Container(
                                        height: wXD(40, context),
                                        width: wXD(40, context),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Color(0xff434B56)
                                              .withOpacity(.85),
                                          size: wXD(25, context),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        store.uploadFiles();
                                      },
                                      child: Container(
                                        height: wXD(40, context),
                                        width: wXD(40, context),
                                        child: Icon(
                                          Icons.attachment_outlined,
                                          color: Color(0xff434B56)
                                              .withOpacity(.85),
                                          size: wXD(25, context),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        Visibility(
                          visible: store.emojisShowM,
                          child: SizedBox(
                            height: 250,
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {},
                              child: EmojiPicker(
                                  onEmojiSelected:
                                      (Category category, Emoji emoji) {
                                    _onEmojiSelected(emoji);
                                  },
                                  onBackspacePressed: onBackspacePressed,
                                  config: const Config(
                                      columns: 7,
                                      emojiSizeMax: 32.0,
                                      verticalSpacing: 0,
                                      horizontalSpacing: 0,
                                      initCategory: Category.RECENT,
                                      bgColor: Color(0xFFF2F2F2),
                                      indicatorColor: Colors.blue,
                                      iconColor: Colors.grey,
                                      iconColorSelected: Colors.blue,
                                      progressIndicatorColor: Colors.blue,
                                      backspaceColor: Colors.blue,
                                      showRecentsTab: true,
                                      recentsLimit: 28,
                                      noRecentsText: 'No Recents',
                                      noRecentsStyle: TextStyle(
                                          fontSize: 20, color: Colors.black26),
                                      categoryIcons: CategoryIcons(),
                                      buttonMode: ButtonMode.MATERIAL)),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              });
            }),
      )),
    );
  }
}

class SeparatorDay extends StatelessWidget {
  final String date;

  const SeparatorDay({Key key, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: wXD(15, context)),
      child: Row(
        children: [
          Container(
            height: wXD(1, context),
            width: wXD(100, context),
            color: Color(0xff787C81),
          ),
          Spacer(),
          Text(
            '$date',
            style: TextStyle(
              color: Color(0xff787C81),
            ),
          ),
          Spacer(),
          Container(
            height: wXD(1, context),
            width: wXD(100, context),
            color: Color(0xff787C81),
          ),
        ],
      ),
    );
  }
}
