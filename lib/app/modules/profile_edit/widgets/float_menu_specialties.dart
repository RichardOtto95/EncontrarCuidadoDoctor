import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/utilities.dart';
import '../profileEdit_store.dart';

class SpecialtiesField extends StatefulWidget {
  const SpecialtiesField({Key key}) : super(key: key);
  @override
  _SpecialtiesFieldState createState() => _SpecialtiesFieldState();
}

class _SpecialtiesFieldState extends State<SpecialtiesField> {
  final ProfileEditStore store = Modular.get();

  OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    store.getSpecialites();
    store.focusNodeSpecialty = FocusNode();
    store.textEditingControllerSpeciality.text =
        store.mapDoctor['speciality_name'] != null
            ? store.mapDoctor['speciality_name']
            : '';
    store.focusNodeSpecialty.addListener(() {
      if (store.focusNodeSpecialty.hasFocus) {
        store.inputSpecialty = true && store.newListSpecialites.isNotEmpty;

        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry);
      } else {
        store.inputSpecialty = false;
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

    store.focusNodeSpecialty.removeListener(() {});

    store.focusNodeSpecialty.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
        builder: (context) => Positioned(
              width: wXD(300, context),
              child: CompositedTransformFollower(
                  offset: Offset(0, size.height + 5),
                  link: _layerLink,
                  child: Material(
                      color: Colors.transparent,
                      child: FloatMenuSpeciality(
                        onTap: () {
                          store.focusNodeSpecialty.unfocus();
                          store.filterListSpeciality(store
                              .textEditingControllerSpeciality.text
                              .toLowerCase());
                        },
                      ))),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(bottom: 5),
            height: wXD(40, context),
            child: Row(
              children: [
                Text(
                  'Especialidade*',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xff95989A),
                    fontSize: wXD(17, context),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
        DropDownSpeciality(),
      ],
    );
  }
}

class DropDownSpeciality extends StatefulWidget {
  const DropDownSpeciality({
    Key key,
  }) : super(key: key);
  @override
  _DropDownSpecialityState createState() => _DropDownSpecialityState();
}

class _DropDownSpecialityState extends State<DropDownSpeciality> {
  final ProfileEditStore store = Modular.get();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Container(
          alignment: Alignment.bottomLeft,
          width: wXD(250, context),
          child: TextFormField(
            onTap: () {
              store.filterListCity(
                  store.textEditingControllerCity.text.toLowerCase());
            },
            focusNode: store.focusNodeSpecialty,
            controller: store.textEditingControllerSpeciality,
            autocorrect: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if (store.mapDoctor['speciality_name'] !=
                  store.textEditingControllerSpeciality.text) {
                return 'Selecione uma especialidade';
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
              hintText: 'Ex: Angiologia',
              hintStyle: TextStyle(
                fontSize: wXD(17, context),
                fontWeight: FontWeight.w400,
                color: Color(0x30707070),
              ),
            ),
            onChanged: (value) {
              store.filterListSpeciality(value.toLowerCase());
              store.inputSpecialty =
                  true && store.newListSpecialites.isNotEmpty;
            },
          ),
        );
      },
    );
  }
}

class FloatMenuSpeciality extends StatelessWidget {
  final ProfileEditStore store = Modular.get();
  final Function onTap;
  final bool fieldState;
  final bool fieldCity;
  FloatMenuSpeciality({
    Key key,
    this.onTap,
    this.fieldState = false,
    this.fieldCity = false,
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
            ],
          ),
          child: Container(
              height: store.newListSpecialites.length > 6
                  ? wXD(150, context)
                  : store.newListSpecialites.length * wXD(25, context),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                    store.newListSpecialites.length,
                    (index) { 
                      // print('store.newListSpecialites.length: $');
                      return FloatMenuButton(
                        title: store.newListSpecialites[index],
                        onTap: () {
                          store.textEditingControllerSpeciality.text =
                              store.newListSpecialites[index];

                          store.setSpeciality(
                              store.newListSpecialites[index]);
                          onTap();
                        },
                      );
                    },
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
