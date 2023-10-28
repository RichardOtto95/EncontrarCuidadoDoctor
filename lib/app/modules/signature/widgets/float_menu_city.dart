import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/utilities.dart';
import '../signature_store.dart';

class CitysField extends StatefulWidget {
  const CitysField({
    Key key,
  }) : super(key: key);
  @override
  _CitysFieldState createState() => _CitysFieldState();
}

class _CitysFieldState extends State<CitysField> {
  final SignatureStore store = Modular.get();
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    store.getCitys();
    store.focusNodeMap['billing_city'].addListener(() {
      if (store.focusNodeMap['billing_city'].hasFocus) {
        store.inputCity = true && store.newListCitys.isNotEmpty;
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      } else {
        store.inputCity = false;
        this._overlayEntry.remove();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_overlayEntry != null && _overlayEntry.mounted) {
      _overlayEntry.remove();
    }

    store.focusNodeMap['billing_city'].removeListener(() {});
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: wXD(300, context),
        child: CompositedTransformFollower(
          offset: Offset(0, size.height),
          link: this._layerLink,
          child: Material(
            color: Colors.transparent,
            child: FloatMenuCity(
              onTap: () {
                store.focusNodeMap['billing_city'].unfocus();
                store.focusNodeMap['billing_cep'].requestFocus();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Container(
          margin: EdgeInsets.fromLTRB(
            wXD(44, context),
            wXD(0, context),
            wXD(44, context),
            wXD(0, context),
          ),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0x50707070)))),
          child: CompositedTransformTarget(
            link: _layerLink,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cidade',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff707070)),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: wXD(291, context),
                  child: TextFormField(
                    onTap: () {
                      store.filterListCity(
                          store.textEditingControllerCity.text.toLowerCase());
                      store.input = true;
                    },
                    focusNode: store.focusNodeMap['billing_city'],
                    controller: store.textEditingControllerCity,
                    autocorrect: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (store.cardMap['city'] !=
                          store.textEditingControllerCity.text) {
                        return 'Selecione uma cidade';
                      }
                      if (value.isEmpty) {
                        return 'Este campo não pode ser vazio';
                      } else {
                        return null;
                      }
                    },
                    cursorColor: Color(0xff707070),
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff707070)),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Taguatinga',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0x50707070),
                      ),
                    ),
                    onChanged: (value) {
                      store.filterListCity(value.toLowerCase());
                      store.inputCity = true && store.newListCitys.isNotEmpty;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FloatMenuCity extends StatelessWidget {
  final SignatureStore store = Modular.get();
  final Function onTap;
  FloatMenuCity({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    offset: Offset(0, 3),
                    color: Color(0x30000000),
                  )
                ]),
            child: Container(
              height: store.newListCitys.length > 6
                  ? wXD(150, context)
                  : store.newListCitys.length * wXD(25, context),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                      store.newListCitys.length,
                      (index) => FloatMenuButton(
                            title: store.newListCitys[index],
                            onTap: () {
                              store.textEditingControllerCity.clear();

                              store.cardMap['city'] = store.newListCitys[index];

                              store.textEditingControllerCity.text =
                                  store.newListCitys[index];
                              onTap();
                            },
                          )),
                ),
              ),
            ));
      },
    );
  }
}

class FloatMenuButton extends StatelessWidget {
  final String title;
  final Function onTap;
  const FloatMenuButton({
    Key key,
    this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: wXD(25, context),
        padding: EdgeInsets.only(left: wXD(14, context)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: wXD(16, context),
                color: Color(0xfa707070),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
