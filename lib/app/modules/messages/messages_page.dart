import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/modules/root/root_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'empty_state.dart';
import 'messages_store.dart';

class MessagesPage extends StatefulWidget {
  final String title;
  final ScrollController scrollController;
  const MessagesPage(
      {Key key, this.title = 'MessagesPage', this.scrollController})
      : super(key: key);
  @override
  MessagesPageState createState() => MessagesPageState();
}

String search;

class MessagesPageState extends State<MessagesPage> {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  final MessagesStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  RootStore rootStore = Modular.get();
  FocusNode focusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  bool isScrollingDown = false;
  bool navBarEnable = true;

  @override
  void initState() {
    if (!mainStore.consultChat) {
      store.chatsDispose();
    }

    focusListener();
    store.srch.clear();
    store.getChats();
    mainStore.getUser();
    store.searchResult.clear();
    store.srch.clear();
    search = null;
    super.initState();
    handleScroll();
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          navBarEnable) {
        if (!isScrollingDown) {
          mainStore.setShowNav(false);
        }
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          navBarEnable) {
        if (!isScrollingDown) {
          mainStore.setShowNav(true);
        }
      }
    });
  }

  focusListener() {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        print('With focus');
        mainStore.setShowNav(false);
        navBarEnable = false;
      } else {
        print('Without focus');
        mainStore.setShowNav(true);
        navBarEnable = true;
      }
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    focusNode.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageStorage(
          bucket: rootStore.bucketGlobal,
          child: GestureDetector(
            onTap: () {
              focusNode.unfocus();
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EncontrarCuidadoAppBar(title: 'Mensagens'),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: wXD(5, context),
                        horizontal: wXD(16, context),
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0x50707070),
                          ),
                        ),
                      ),
                      width: wXD(343, context),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: wXD(15, context)),
                            child: Icon(
                              Icons.search,
                              size: wXD(25, context),
                              color: Color(0xff707070).withOpacity(.6),
                            ),
                          ),
                          Container(
                            width: wXD(288, context),
                            child: TextField(
                              controller: store.srch,
                              onChanged: (txt) async {
                                if (txt.characters.length >= 1) {
                                  await store.search(txt);
                                  store.setJump(true);
                                  setState(() {
                                    search = txt;
                                  });
                                }
                                if (txt.isEmpty) {
                                  await store.search(txt);
                                  store.searchResult.clear();
                                  store.srch.clear();
                                  setState(() {
                                    search = null;
                                  });
                                }
                              },
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                counterText: "",
                                labelText: 'Procurar mensagens',
                                labelStyle: TextStyle(
                                  color:
                                      const Color(0xff707070).withOpacity(.6),
                                  fontSize: wXD(16, context),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          top: wXD(15, context),
                          left: wXD(20, context),
                          bottom: wXD(15, context)),
                      child: Text(
                        'Minhas conversas',
                        style: TextStyle(
                            color: Color(0xff707070),
                            fontSize: wXD(19, context),
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('chats')
                            .where('doctor_id',
                                isEqualTo: mainStore.authStore.viewDoctorId)
                            .snapshots(),
                        builder: (context, snapshotUser) {
                          QuerySnapshot query;

                          if (snapshotUser.hasData) {
                            query = snapshotUser.data;
                          }

                          if (snapshotUser.connectionState ==
                              ConnectionState.waiting) {
                            return Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .3,
                                    ),
                                    Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (!snapshotUser.hasData || query.docs.isEmpty) {
                            return Expanded(
                              child: GestureDetector(
                                onVerticalDragUpdate: (details) {
                                  if (details.delta.direction < 0) {
                                    mainStore.setShowNav(false);
                                  }
                                  if (details.delta.direction > 0) {
                                    mainStore.setShowNav(true);
                                  }
                                },
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    children: [
                                      EmptyState(
                                        image: 'assets/img/work_on2.png',
                                        description:
                                            'Envie e receba mensagens dos pacientes com quem você agendou consultas',
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .2,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return Observer(builder: (_) {
                            return Expanded(
                              child: GestureDetector(
                                onVerticalDragUpdate: (details) {
                                  if (details.delta.direction < 0) {
                                    mainStore.setShowNav(false);
                                  }
                                  if (details.delta.direction > 0) {
                                    mainStore.setShowNav(true);
                                  }
                                },
                                child: SingleChildScrollView(
                                  controller: scrollController,
                                  key: PageStorageKey<String>('msgsKey'),
                                  child: store.searchResult.isEmpty &&
                                          search == null
                                      ? Column(
                                          children: [
                                            Column(
                                                children:
                                                    store.userChats.map((cht) {
                                              return StreamBuilder(
                                                  stream: FirebaseFirestore
                                                      .instance
                                                      .collection('chats')
                                                      .doc(cht['id'])
                                                      .collection('messages')
                                                      .orderBy('created_at',
                                                          descending: true)
                                                      .snapshots(),
                                                  builder: (context, snapshot) {
                                                    QuerySnapshot message =
                                                        snapshot.data;

                                                    if (snapshot == null ||
                                                        !snapshot.hasData ||
                                                        message.docs.length ==
                                                            0) {
                                                      return Container();
                                                    }

                                                    if (message.docs.first.id ==
                                                        null) {
                                                      return Container();
                                                    } else {
                                                      return PerfilTile(
                                                        patId:
                                                            cht['patient_id'],
                                                        msgs: message,
                                                        jump: false,
                                                        chatId: cht['id'],
                                                        name: store.patient[cht[
                                                                'patient_id']]
                                                            ['username'],
                                                        time: cht['updated_at'] ==
                                                                null
                                                            ? ''
                                                            : store.messageTimer(
                                                                cht['updated_at']),
                                                        description: message
                                                                    .docs.first
                                                                    .get(
                                                                        'text') !=
                                                                null
                                                            ? message.docs.first
                                                                .get('text')
                                                            : message.docs.first
                                                                        .get(
                                                                            'image') !=
                                                                    null
                                                                ? message
                                                                    .docs.first
                                                                    .get(
                                                                        'image')
                                                                : message.docs
                                                                            .first
                                                                            .get(
                                                                                'file') !=
                                                                        null
                                                                    ? message
                                                                        .docs
                                                                        .first
                                                                        .get(
                                                                            'file')
                                                                    : '',
                                                        notifications: cht[
                                                            'dr_notifications'],
                                                      );
                                                    }
                                                  });
                                            }).toList()),
                                            SizedBox(
                                              height: wXD(15, context),
                                            )
                                          ],
                                        )
                                      : store.searchResult.isNotEmpty
                                          ? Column(
                                              children: [
                                                Column(
                                                    children: store.searchResult
                                                        .map((cht) {
                                                  return StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('chats')
                                                          .doc(cht['id'])
                                                          .collection(
                                                              'messages')
                                                          .orderBy('created_at',
                                                              descending: true)
                                                          .snapshots(),
                                                      builder:
                                                          (context, snapshot) {
                                                        String searched;
                                                        QuerySnapshot message =
                                                            snapshot.data;
                                                        if ((snapshot
                                                                .hasError) ||
                                                            snapshot == null ||
                                                            !snapshot.hasData ||
                                                            message.docs
                                                                    .length ==
                                                                0) {
                                                          return Container();
                                                        }

                                                        if (search != null) {
                                                          searched =
                                                              store.getSearched(
                                                                  message,
                                                                  search);
                                                        }

                                                        return PerfilTile(
                                                          patId:
                                                              cht['patient_id'],
                                                          msgs: message,
                                                          jump: true,
                                                          chatId: cht['id'],
                                                          name: store.patient[cht[
                                                                  'patient_id']]
                                                              ['username'],
                                                          time: cht['updated_at'] ==
                                                                  null
                                                              ? ''
                                                              : store.messageTimer(
                                                                  cht['updated_at']),
                                                          description: searched !=
                                                                  null
                                                              ? searched
                                                              : message.docs
                                                                          .first
                                                                          .get(
                                                                              'text') !=
                                                                      null
                                                                  ? message.docs
                                                                      .first
                                                                      .get(
                                                                          'text')
                                                                  : '',
                                                        );
                                                      });
                                                }).toList()),
                                                SizedBox(
                                                  height: wXD(15, context),
                                                )
                                              ],
                                            )
                                          : store.searchResult.isEmpty &&
                                                  search != null
                                              ? Column(children: [
                                                  EmptyState(
                                                    image:
                                                        'assets/img/work_on2.png',
                                                    description:
                                                        'Não foram encontrados resultados para esta pesquisa',
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .2,
                                                  )
                                                ])
                                              : Container(),
                                ),
                              ),
                            );
                          });
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PerfilTile extends StatelessWidget {
  final String patId;
  final String name;
  final String text;
  final int notifications;
  final String time;
  final String description;
  final String chatId;
  final QuerySnapshot msgs;
  final bool jump;

  const PerfilTile({
    Key key,
    this.name,
    this.text,
    this.notifications = 0,
    this.time,
    this.description,
    this.chatId,
    this.jump,
    this.msgs,
    this.patId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String avatar;
    bool connected = false;
    final MessagesStore store = Modular.get();
    final MainStore mainStore = Modular.get();
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('patients')
            .doc(patId)
            .snapshots(),
        builder: (context, snapshot) {
          DocumentSnapshot user = snapshot.data;

          if (user == null) {
            return Container();
          }

          avatar = user.get('avatar');
          connected = user.get('connected');

          return InkWell(
            onTap: () async {
              mainStore.getInfo();
              store.chatTitle = name;
              store.setPAvatar(user.get('avatar'));
              mainStore.hasChat = true;
              store.setChatId(chatId);
              if (jump == true) {
                store.searchedQuery = msgs;
                store.searchedText = search;
                store.setPos(
                    store.getIndex(store.searchedQuery, store.searchedText));
              }
              await store.getMessages(chatId, name);
              store.handleNotifications(chatId, false);
              Modular.to.pushNamed('/messages/chat');
            },
            child: Container(
              width: maxWidth(context),
              padding: EdgeInsets.only(
                left: wXD(15, context),
                top: wXD(19, context),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: wXD(5, context)),
                        child: CircleAvatar(
                          backgroundImage: avatar != null
                              ? NetworkImage(avatar)
                              : AssetImage('assets/img/defaultUser.png'),
                          backgroundColor: Colors.white,
                          radius: wXD(30, context),
                        ),
                      ),
                      Positioned(
                        bottom: wXD(0, context),
                        right: wXD(2, context),
                        child: Container(
                          height: wXD(17.61, context),
                          width: wXD(17.61, context),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white, width: wXD(3, context)),
                            borderRadius: BorderRadius.circular(90),
                            color: connected ? Color(0xff41C3B3) : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: wXD(12, context)),
                    width: wXD(215, context),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$name',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: wXD(16, context),
                              fontWeight: FontWeight.w900),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: wXD(3, context)),
                          child: Column(
                            children: [
                              Text(
                                '$description',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Color(0xff707070),
                                    fontSize: wXD(15, context),
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: wXD(65, context),
                        alignment: Alignment.center,
                        child: Text(
                          '$time',
                          style: TextStyle(
                              color: Color(0xff707070),
                              fontSize: wXD(13, context),
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      notifications == 0
                          ? Container(
                              height: wXD(18, context),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: wXD(3, context)),
                              height: wXD(18, context),
                              width: wXD(18, context),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(90),
                                color: Color(0xff41C3B3),
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                child: Center(
                                  child: Text(
                                    '$notifications',
                                    style: TextStyle(
                                        color: Color(0xffFAFAFA),
                                        fontSize: wXD(13, context),
                                        height: 1,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
