import 'dart:ui';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import '../../../shared/utilities.dart';
import '../feed_store.dart';

class NewPost extends StatelessWidget {
  final File imageFile;
  final Function pickedImage;
  final Function canceled;
  final Function postOrEdit;
  const NewPost({
    Key key,
    this.pickedImage,
    this.imageFile,
    this.canceled,
    this.postOrEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FeedStore store = Modular.get();
    final MainStore mainStore = Modular.get();
    bool loadCircular = false;
    return Observer(
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return (store.editPost == 'editing' && store.imageFile == null)
                    ? InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          final permitted =
                              await PhotoManager.requestPermission();
                          if (permitted) {
                            pickedImage();
                          }
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Center(
                              child: Image.network(
                                store.imageString,
                                fit: BoxFit.cover,
                                width: constraints.maxWidth - 30,
                                height: wXD(160, context),
                              ),
                            ),
                            Container(
                              width: constraints.maxWidth - 10,
                              height: wXD(190, context),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                    color: Color(0xfffafafa),
                                    width: wXD(15, context)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                            ),
                          ],
                        ),
                      )
                    : (store.imageFile != null)
                        ? InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              final permitted =
                                  await PhotoManager.requestPermission();
                              if (permitted) {
                                pickedImage();
                              }
                            },
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Center(
                                  child: Image.file(
                                    store.imageFile,
                                    fit: BoxFit.cover,
                                    width: constraints.maxWidth - 30,
                                    height: wXD(160, context),
                                  ),
                                ),
                                Container(
                                  width: constraints.maxWidth - 10,
                                  height: wXD(190, context),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                        color: Color(0xfffafafa),
                                        width: wXD(15, context)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              final permitted =
                                  await PhotoManager.requestPermission();
                              if (permitted) {
                                pickedImage();
                              }
                            },
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                Positioned(
                                  bottom: wXD(30, context),
                                  child: Text(
                                    'Insira sua imagem aqui',
                                    style: TextStyle(
                                      color: Color(0xff41C3B3).withOpacity(.8),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    width: wXD(400, context),
                                    height: wXD(200, context),
                                    child: Image.asset(
                                      'assets/img/gallery.png',
                                      fit: BoxFit.cover,
                                      color: Color(0xff7C8085).withOpacity(.2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
              },
            ),
            SizedBox(
              height: wXD(15, context),
            ),
            Center(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: wXD(8, context)),
                    margin: EdgeInsets.symmetric(
                      horizontal: wXD(16, context),
                    ),
                    height: wXD(70, context),
                    width: wXD(280, context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(7)),
                      border: Border.all(
                        color: Color(0xff707070),
                      ),
                    ),
                    child: TextFormField(
                      onTap: () {
                        mainStore.setShowNav(false);
                      },
                      maxLines: 3,
                      cursorColor: Color(0xff707070),
                      initialValue: store.postText,
                      onChanged: (value) {
                        store.setPostText(value);
                      },
                      decoration: InputDecoration(
                        border:
                            store.imageFile == null ? InputBorder.none : null,
                        isDense: true,
                        hintText: 'Digite aqui o seu texto...',
                        hintStyle: TextStyle(
                          fontSize: wXD(14, context),
                          fontWeight: FontWeight.w600,
                          color: Color(0xff7C8085).withOpacity(.8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: wXD(30, context),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return StatefulBuilder(
                  builder: (context, stateSet) {
                    return loadCircular
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: constraints.maxWidth * .5,
                                height: wXD(40, context),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: canceled,
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: constraints.maxWidth * .4,
                                    margin: EdgeInsets.only(
                                        bottom: wXD(10, context)),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xff41C3B3), width: 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Text(
                                      'Cancelar',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: constraints.maxWidth * .5,
                                height: wXD(40, context),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    stateSet(() {
                                      loadCircular = true;
                                    });
                                    postOrEdit();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: constraints.maxWidth * .4,
                                    margin: EdgeInsets.only(
                                        bottom: wXD(10, context)),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xff41C3B3), width: 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Text(
                                      store.editPost == null
                                          ? 'Publicar'
                                          : 'Editar',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                  },
                );
              },
            )
          ],
        );
      },
    );
  }
}
