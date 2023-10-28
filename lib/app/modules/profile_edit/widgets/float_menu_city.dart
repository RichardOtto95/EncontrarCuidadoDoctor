import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/utilities.dart';
import '../profileEdit_store.dart';

class CitysField extends StatefulWidget {
  const CitysField({
    Key key,
  }) : super(key: key);
  @override
  _CitysFieldState createState() => _CitysFieldState();
}

class _CitysFieldState extends State<CitysField> {
  final ProfileEditStore store = Modular.get();
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    store.getCitys();
    store.focusNodeCity = FocusNode();
    store.textEditingControllerCity.text =
        store.mapDoctor['city'] != null ? store.mapDoctor['city'] : '';
    store.focusNodeCity.addListener(() {
      if (store.focusNodeCity.hasFocus) {
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

    store.focusNodeCity.removeListener(() {});

    store.focusNodeCity.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: wXD(300, context),
        child: CompositedTransformFollower(
          offset: Offset(0, size.height + 5),
          link: this._layerLink,
          child: Material(
            color: Colors.transparent,
            child: FloatMenuCity(
              onTap: () {
                store.focusNodeCity.unfocus();
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
        return CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            alignment: Alignment.bottomLeft,
            width: wXD(250, context),
            child: TextFormField(
              onTap: () {
                store.filterListCity(
                    store.textEditingControllerCity.text.toLowerCase());
              },
              focusNode: store.focusNodeCity,
              controller: store.textEditingControllerCity,
              autocorrect: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textCapitalization: TextCapitalization.sentences,
              validator: (value) {
                if (store.mapDoctor['city'] !=
                    store.textEditingControllerCity.text) {
                  return 'Selecione uma cidade';
                } else if (value.isEmpty) {
                  return 'Este campo não pode ser vazio';
                } else {
                  return null;
                }
              },
              cursorColor: Color(0xff707070),
              style: TextStyle(
                  fontSize: wXD(17, context),
                  fontWeight: FontWeight.w400,
                  color: Color(0xff707070)),
              decoration: InputDecoration.collapsed(
                hintText: 'Ex: Taguatinga',
                hintStyle: TextStyle(
                  fontSize: wXD(17, context),
                  fontWeight: FontWeight.w400,
                  color: Color(0x30707070),
                ),
              ),
              onChanged: (value) {
                store.filterListCity(value.toLowerCase());
                store.inputCity = true && store.newListCitys.isNotEmpty;
              },
            ),
          ),
        );
      },
    );
  }
}

class FloatMenuCity extends StatelessWidget {
  final ProfileEditStore store = Modular.get();
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
                              store.textEditingControllerCity.text =
                                  store.newListCitys[index];
                              store.mapDoctor['city'] =
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
