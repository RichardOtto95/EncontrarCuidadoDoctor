import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../secretaries_store.dart';

class PhoneCPFSearch extends StatefulWidget {
  const PhoneCPFSearch({
    Key key,
  }) : super(key: key);
  @override
  _PhoneCPFSearchState createState() => _PhoneCPFSearchState();
}

class _PhoneCPFSearchState extends State<PhoneCPFSearch> {
  final SecretariesStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final FocusNode focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
  }

  void showSecretaryDialog(bool value, int length) {
    if (value && store.overlayEntry.mounted) {
      store.overlayEntry.remove();
      store.haveDialog = false;
    } else {
      if (length == 1 && !store.haveDialog) {
        store.haveDialog = true;
        store.overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(store.overlayEntry);
      }
    }
  }

  @override
  void dispose() {
    if (store.overlayEntry != null && store.overlayEntry.mounted) {
      store.overlayEntry.remove();
    }

    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          offset: Offset(0, size.height - wXD(15, context)),
          link: _layerLink,
          child: Material(
            color: Colors.transparent,
            child: SecretariesSuggestions(
              store: store,
              onTap: () {
                store.overlayEntry.remove();
                store.haveDialog = false;
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('doctors')
              .where('type', isEqualTo: 'SECRETARY')
              .snapshots(),
          builder: (context, snapshotSecretaries) {
            if (snapshotSecretaries.hasData) {
              store.getSecretaries(snapshotSecretaries.data);
            }
            return Container(
              padding: EdgeInsets.only(left: wXD(16, context)),
              margin: EdgeInsets.fromLTRB(
                wXD(20, context),
                wXD(0, context),
                wXD(20, context),
                wXD(28, context),
              ),
              width: wXD(337, context),
              height: wXD(41, context),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff707070),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(17))),
              child: Row(
                children: [
                  Container(
                    width: wXD(285, context),
                    child: TextFormField(
                      onTap: () {
                        store.textEditingController.clear();
                        if (store.overlayEntry != null &&
                            store.overlayEntry.mounted) {
                          store.overlayEntry.remove();
                        }
                        store.haveDialog = false;
                      },
                      keyboardType: TextInputType.number,
                      controller: store.textEditingController,
                      focusNode: focusNode,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Busque pelo telefone ou CPF',
                          hintStyle: TextStyle(
                              color: Color(0xff707070).withOpacity(.6),
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                      onChanged: (String value) async {
                        store.textSearch = value;
                        showSecretaryDialog(value == '', value.length);
                        store.filterSecretaries();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(),
                    child: Icon(
                      Icons.search,
                      size: wXD(25, context),
                      color: Color(0xff707070).withOpacity(.6),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

class SecretariesSuggestions extends StatelessWidget {
  final Function onTap;
  final SecretariesStore store;

  const SecretariesSuggestions({
    Key key,
    this.onTap,
    this.store,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double functionHeight(int length) {
      return length <= 1
          ? wXD(75, context)
          : length == 2
              ? wXD(127, context)
              : wXD(150, context);
    }

    return Observer(builder: (context) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: wXD(20, context)),
        width: wXD(337, context),
        height: functionHeight(store.searchSecretaries.length),
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
          children: [
            Expanded(
              child: store.searchSecretaries.length != 0
                  ? SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(14, 10, 14, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(store.searchSecretaries.length,
                            (index) {
                          return SecretarieSuggestion(
                            store: store,
                            name: store.searchSecretaries[index]['username'],
                            avatar: store.searchSecretaries[index]['avatar'],
                            cpf: store.searchSecretaries[index]['cpf'],
                            phone: store.searchSecretaries[index]['phone'],
                            onTap: () {
                              onTap();
                              store.confirmAddSecretary(
                                secretary: store.searchSecretaries[index],
                              );
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                            },
                          );
                        }),
                      ),
                    )
                  : Center(
                      child: Text(
                        'Nenhum secretário com esse número ou cpf\ncadastrado.',
                        textAlign: TextAlign.left,
                      ),
                    ),
            ),
          ],
        ),
      );
    });
  }
}

class SecretarieSuggestion extends StatelessWidget {
  final String name;
  final String avatar;
  final Function onTap;
  final String phone;
  final String cpf;
  final SecretariesStore store;

  const SecretarieSuggestion({
    Key key,
    this.name,
    this.avatar,
    this.onTap,
    this.phone,
    this.cpf,
    this.store,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          height: 45,
          width: 300,
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(90),
                child: avatar == null
                    ? Image.asset(
                        'assets/img/defaultUser.png',
                        height: 45,
                        width: 45,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: avatar,
                        width: 43,
                        height: 43,
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 215,
                    child: Text(
                      '$name',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff707070),
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff707070),
                      ),
                      children: [
                        TextSpan(text: 'Telefone: '),
                        TextSpan(
                            text: store.getMask(phone, 'phone'),
                            style: TextStyle(
                                color: Color(0xff707070).withOpacity(.6))),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff707070),
                      ),
                      children: [
                        TextSpan(text: 'CPF: '),
                        TextSpan(
                            text: store.getMask(cpf, 'cpf'),
                            style: TextStyle(
                                color: Color(0xff707070).withOpacity(.6))),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
