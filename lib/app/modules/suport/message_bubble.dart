import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/suport/suport_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'hero_pages.dart';
import 'package:open_file/open_file.dart';

class MessageBubble extends StatelessWidget {
  final String author;
  final String text;
  final String hour;
  final String fileName;
  final String isImage;
  final String fileLink;
  final String message;
  final String extension;
  final String downloaded;
  final String usAvatar;
  final String spAvatar;

  const MessageBubble({
    Key key,
    this.author,
    this.text,
    this.hour,
    this.fileName,
    this.isImage,
    this.fileLink,
    this.downloaded = 'false',
    this.message,
    this.extension,
    this.usAvatar,
    this.spAvatar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SuportStore store = Modular.get();
    final MainStore mainStore = Modular.get();

    return author == store.authStore.user.uid &&
            text != null &&
            isImage == null &&
            fileName == null
        ? Container(
            margin: EdgeInsets.only(
              bottom: wXD(16, context),
              left: wXD(44, context),
              right: wXD(16, context),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  // height: wXD(77, context),
                  // width: wXD(243, context),
                  decoration: BoxDecoration(
                    color: Color(0xff4c4c4c),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: wXD(20, context),
                          top: wXD(15, context),
                          right: wXD(20, context),
                          bottom: wXD(8, context),
                        ),
                        child: Container(
                          width: wXD(200, context),
                          child: Text(
                            text,
                            style: TextStyle(
                                color: Color(0xfffafafa),
                                fontSize: wXD(14, context),
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        margin: EdgeInsets.only(
                          right: wXD(17, context),
                          bottom: wXD(4, context),
                        ),
                        child: Text(
                          hour,
                          style: TextStyle(
                              color: Color(0xfffafafa),
                              fontSize: wXD(14, context),
                              fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: wXD(11, context),
                ),
                CircleAvatar(
                  radius: wXD(30, context),
                  backgroundImage: usAvatar == null || usAvatar == ''
                      ? AssetImage('assets/img/defaultUser.png')
                      : NetworkImage(usAvatar),
                ),
              ],
            ),
          )
        : author == store.authStore.user.uid &&
                isImage != null &&
                text == null &&
                fileName == null
            ? Container(
                margin: EdgeInsets.only(
                  bottom: wXD(16, context),
                  left: wXD(44, context),
                  right: wXD(16, context),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      // height: wXD(77, context),
                      width: wXD(243, context),
                      decoration: BoxDecoration(
                        color: Color(0xff4c4c4c),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Stack(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: wXD(5, context),
                              top: wXD(5, context),
                              right: wXD(5, context),
                              bottom: wXD(5, context),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HeroImage(
                                              imgLink: fileLink,
                                            )));
                              },
                              child: Hero(
                                tag: 'image',
                                child: Container(
                                  width: wXD(235, context),
                                  height: wXD(150, context),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(fileLink),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(25)),
                                  // child: Center(
                                  //   child: Image.network(
                                  //     isImage,
                                  //     fit: BoxFit.fitWidth,
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: wXD(20, context),
                            bottom: wXD(8, context),
                            child: Text(
                              hour,
                              style: TextStyle(
                                  color: Color(0xfffafafa),
                                  fontSize: wXD(14, context),
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: wXD(11, context),
                    ),
                    CircleAvatar(
                      radius: wXD(30, context),
                      backgroundImage: usAvatar == null || usAvatar == ''
                          ? AssetImage('assets/img/defaultUser.png')
                          : NetworkImage(usAvatar),
                    ),
                  ],
                ),
              )
            : author == store.authStore.user.uid &&
                    fileName != null &&
                    isImage == null &&
                    text == null
                ? Container(
                    margin: EdgeInsets.only(
                      bottom: wXD(16, context),
                      left: wXD(44, context),
                      right: wXD(16, context),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: wXD(180, context),
                          width: wXD(243, context),
                          decoration: BoxDecoration(
                            color: Color(0xff4c4c4c),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: wXD(5, context),
                                  top: wXD(5, context),
                                  right: wXD(5, context),
                                  bottom: wXD(1, context),
                                ),
                                child: Container(
                                  width: wXD(240, context),
                                  child: Column(
                                    children: [
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          await store.getDownloaded(fileName);
                                          if (downloaded == 'true') {
                                            OpenFile.open(store.localPath);
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25)),
                                            color: Color(0xffFFFFFF),
                                          ),
                                          height: wXD(117, context),
                                          width: wXD(235, context),
                                          child: Center(
                                            child: Image.asset(
                                              'assets/img/$extension.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: wXD(5, context)),
                                      Row(
                                        children: [
                                          Spacer(
                                            flex: 1,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              if (downloaded == 'true') {
                                              } else {
                                                await store.downloadFiles(
                                                    fileLink,
                                                    fileName,
                                                    mainStore.supportId,
                                                    message);
                                              }
                                            },
                                            child: downloaded == 'true'
                                                ? Icon(
                                                    Icons
                                                        .download_done_outlined,
                                                    color: Color(0xfffafafa),
                                                    size: wXD(30, context),
                                                  )
                                                : downloaded == 'false'
                                                    ? Icon(
                                                        Icons
                                                            .download_for_offline_outlined,
                                                        color:
                                                            Color(0xfffafafa),
                                                        size: wXD(30, context),
                                                      )
                                                    : Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        width: wXD(20, context),
                                                        height:
                                                            wXD(20, context),
                                                        child:
                                                            CircularProgressIndicator(
                                                          color:
                                                              Color(0xfffafafa),
                                                        )),
                                          ),
                                          Spacer(
                                            flex: 2,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .45,
                                            child: Text(
                                              fileName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Color(0xfffafafa),
                                                  fontSize: wXD(14, context),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Spacer(
                                            flex: 2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                margin: EdgeInsets.only(
                                  right: wXD(17, context),
                                  bottom: wXD(4, context),
                                ),
                                child: Text(
                                  hour,
                                  style: TextStyle(
                                      color: Color(0xfffafafa),
                                      fontSize: wXD(14, context),
                                      fontWeight: FontWeight.w300),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: wXD(11, context),
                        ),
                        CircleAvatar(
                          radius: wXD(30, context),
                          backgroundImage: usAvatar == null || usAvatar == ''
                              ? AssetImage('assets/img/defaultUser.png')
                              : NetworkImage(usAvatar),
                        ),
                      ],
                    ),
                  )
                : author != store.authStore.user.uid &&
                        text != null &&
                        isImage == null &&
                        fileName == null
                    ? Container(
                        margin: EdgeInsets.only(
                          bottom: wXD(16, context),
                          left: wXD(16, context),
                          right: wXD(44, context),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: wXD(30, context),
                              backgroundImage:
                                  spAvatar == null || spAvatar == ''
                                      ? AssetImage('assets/img/defaultUser.png')
                                      : NetworkImage(spAvatar),
                            ),
                            SizedBox(
                              width: wXD(11, context),
                            ),
                            Container(
                              // height: wXD(77, context),
                              width: wXD(243, context),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xff41C3B3),
                                    Color(0xff21BCCE),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: wXD(20, context),
                                      top: wXD(15, context),
                                      right: wXD(20, context),
                                      bottom: wXD(13, context),
                                    ),
                                    child: Container(
                                      width: wXD(200, context),
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                            color: Color(0xfffafafa),
                                            fontSize: wXD(14, context),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.only(
                                      right: wXD(17, context),
                                      bottom: wXD(4, context),
                                    ),
                                    child: Text(
                                      hour,
                                      style: TextStyle(
                                          color: Color(0xfffafafa),
                                          fontSize: wXD(14, context),
                                          fontWeight: FontWeight.w300),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : author != store.authStore.user.uid &&
                            isImage != null &&
                            text == null &&
                            fileName == null
                        ? Container(
                            margin: EdgeInsets.only(
                              bottom: wXD(16, context),
                              left: wXD(16, context),
                              right: wXD(44, context),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: wXD(30, context),
                                  backgroundImage: spAvatar == null ||
                                          spAvatar == ''
                                      ? AssetImage('assets/img/defaultUser.png')
                                      : NetworkImage(spAvatar),
                                ),
                                SizedBox(
                                  width: wXD(11, context),
                                ),
                                Container(
                                  // height: wXD(77, context),
                                  width: wXD(243, context),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xff41C3B3),
                                        Color(0xff21BCCE),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Stack(
                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: wXD(5, context),
                                          top: wXD(5, context),
                                          right: wXD(5, context),
                                          bottom: wXD(5, context),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        HeroImage(
                                                          imgLink: fileLink,
                                                        )));
                                          },
                                          child: Hero(
                                            tag: 'image',
                                            child: Container(
                                              width: wXD(235, context),
                                              height: wXD(150, context),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          fileLink),
                                                      fit: BoxFit.cover),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: wXD(20, context),
                                        bottom: wXD(8, context),
                                        child: Text(
                                          hour,
                                          style: TextStyle(
                                              color: Color(0xfffafafa),
                                              fontSize: wXD(14, context),
                                              fontWeight: FontWeight.w300),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : author != store.authStore.user.uid &&
                                fileName != null &&
                                isImage == null &&
                                text == null
                            ? Container(
                                margin: EdgeInsets.only(
                                  bottom: wXD(16, context),
                                  left: wXD(16, context),
                                  right: wXD(44, context),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: wXD(30, context),
                                      backgroundImage:
                                          spAvatar == null || spAvatar == ''
                                              ? AssetImage(
                                                  'assets/img/defaultUser.png')
                                              : NetworkImage(spAvatar),
                                    ),
                                    SizedBox(
                                      width: wXD(11, context),
                                    ),
                                    Container(
                                      // height: wXD(77, context),
                                      width: wXD(243, context),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0xff41C3B3),
                                            Color(0xff21BCCE),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: wXD(5, context),
                                              top: wXD(5, context),
                                              right: wXD(5, context),
                                            ),
                                            child: Container(
                                              width: wXD(240, context),
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    splashColor:
                                                        Colors.transparent,
                                                    highlightColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      await store.getDownloaded(
                                                          fileName);
                                                      if (downloaded ==
                                                          'true') {
                                                        OpenFile.open(
                                                            store.localPath);
                                                      }
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        25),
                                                                topRight: Radius
                                                                    .circular(
                                                                        25)),
                                                        color:
                                                            Color(0xffFFFFFF),
                                                      ),
                                                      height: wXD(117, context),
                                                      width: wXD(235, context),
                                                      child: Center(
                                                        child: Image.asset(
                                                          'assets/img/$extension.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: wXD(2, context)),
                                                  Row(
                                                    children: [
                                                      Spacer(
                                                        flex: 1,
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          if (downloaded ==
                                                              'true') {
                                                          } else {
                                                            await store
                                                                .downloadFiles(
                                                                    fileLink,
                                                                    fileName,
                                                                    mainStore
                                                                        .supportId,
                                                                    message);
                                                          }
                                                        },
                                                        child: downloaded ==
                                                                'true'
                                                            ? Icon(
                                                                Icons
                                                                    .download_done_outlined,
                                                                color: Color(
                                                                    0xfffafafa),
                                                                size: wXD(30,
                                                                    context),
                                                              )
                                                            : downloaded ==
                                                                    'false'
                                                                ? Icon(
                                                                    Icons
                                                                        .download_for_offline_outlined,
                                                                    color: Color(
                                                                        0xfffafafa),
                                                                    size: wXD(
                                                                        30,
                                                                        context),
                                                                  )
                                                                : Container(
                                                                    margin: EdgeInsets
                                                                        .all(5),
                                                                    width: wXD(
                                                                        20,
                                                                        context),
                                                                    height: wXD(
                                                                        20,
                                                                        context),
                                                                    child:
                                                                        CircularProgressIndicator(
                                                                      color: Color(
                                                                          0xfffafafa),
                                                                    )),
                                                      ),
                                                      Spacer(
                                                        flex: 2,
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .45,
                                                        child: Text(
                                                          fileName,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xfffafafa),
                                                              fontSize: wXD(
                                                                  14, context),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Spacer(
                                                        flex: 2,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.bottomRight,
                                            margin: EdgeInsets.only(
                                              right: wXD(17, context),
                                              bottom: wXD(4, context),
                                            ),
                                            child: Text(
                                              hour,
                                              style: TextStyle(
                                                  color: Color(0xfffafafa),
                                                  fontSize: wXD(14, context),
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container();
  }
}
