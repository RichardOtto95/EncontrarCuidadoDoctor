import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/utilities.dart';
import '../signature_store.dart';

class StatesField extends StatefulWidget {
  const StatesField({
    Key key,
  }) : super(key: key);
  @override
  _StatesFieldState createState() => _StatesFieldState();
}

class _StatesFieldState extends State<StatesField> {
  final SignatureStore store = Modular.get();
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    store.getStates();
    store.focusNodeMap['billing_state'].addListener(() {
      if (store.focusNodeMap['billing_state'].hasFocus) {
        store.inputState = true && store.newListStates.isNotEmpty;
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry);
      } else {
        store.inputState = false;
        _overlayEntry.remove();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_overlayEntry != null && _overlayEntry.mounted) {
      _overlayEntry.remove();
    }

    store.focusNodeMap['billing_state'].removeListener(() {});
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
        builder: (context) => Positioned(
              width: wXD(291, context),
              child: CompositedTransformFollower(
                  offset: Offset(0, size.height),
                  link: _layerLink,
                  child: Material(
                      color: Colors.transparent,
                      child: FloatMenuState(
                        onTap: () {
                          store.filterListCity(store
                              .textEditingControllerCity.text
                              .toLowerCase());
                          store.focusNodeMap['billing_state'].unfocus();
                          store.focusNodeMap['billing_city'].requestFocus();
                        },
                      ))),
            ));
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
                  'Estado',
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
                      store.filterListState(
                          store.textEditingControllerState.text.toLowerCase());
                      store.input = true;
                    },
                    focusNode: store.focusNodeMap['billing_state'],
                    controller: store.textEditingControllerState,
                    autocorrect: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.sentences,
                    onEditingComplete: () {
                      store.filterListCity(
                          store.textEditingControllerCity.text.toLowerCase());
                      store.focusNodeMap['billing_state'].unfocus();
                      store.focusNodeMap['billing_city'].requestFocus();
                    },
                    validator: (value) {
                      if (store.cardMap['billing_state'] !=
                          store.textEditingControllerState.text) {
                        return 'Selecione um estado';
                      } else if (value.isEmpty) {
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
                      hintText: 'Distrito Federal',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0x50707070),
                      ),
                    ),
                    onChanged: (value) {
                      store.filterListState(value.toLowerCase());
                      store.inputState = true && store.newListStates.isNotEmpty;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
        // );
      },
    );
  }
}

class FloatMenuState extends StatelessWidget {
  final SignatureStore store = Modular.get();
  final Function onTap;
  FloatMenuState({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
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
          height: store.newListStates.length > 6
              ? wXD(150, context)
              : store.newListStates.length * wXD(25, context),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                store.newListStates.length,
                (index) => FloatMenuButton(
                  title: store.newListStates[index],
                  onTap: () async {
                    int count = store.newListStates[index].length;

                    String name =
                        store.newListStates[index].substring(0, count - 5);

                    store.cardMap['billing_state'] = name;

                    store.textEditingControllerState.clear();

                    store.textEditingControllerState.text = name;

                    await store.getCitys();
                    onTap();
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
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
