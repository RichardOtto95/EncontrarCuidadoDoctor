import 'package:encontrar_cuidadodoctor/app/modules/profile/profile_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/white_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileManager extends StatelessWidget {
  const ProfileManager({
    Key key,
    this.onCancel,
    this.viewProfile,
    this.editProfile,
  }) : super(key: key);
  final Function onCancel;
  final Function viewProfile;
  final Function editProfile;
  @override
  Widget build(BuildContext context) {
    final ProfileStore store = Modular.get();

    return Observer(
      builder: (context) {
        return Visibility(
          visible: store.visibleProfileManager,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: onCancel,
                child: Container(
                  height: maxHeight(context),
                  width: maxWidth(context),
                  color: Color(0xff000000).withOpacity(.6),
                ),
              ),
              Container(
                height: wXD(240, context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  color: Color(0xfffafafa),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x50000000),
                      offset: Offset(0, -5),
                      blurRadius: 7,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Spacer(),
                    Text(
                      'O que deseja fazer?',
                      style: TextStyle(
                        color: Color(0xff4c4c4c),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: viewProfile,
                      child: WhiteButton(
                        bottom: 0,
                        top: 0,
                        text: 'Visualizar o perfil do médico',
                        color: Color(0xff2185D0),
                        width: wXD(300, context),
                        height: wXD(47, context),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: editProfile,
                      child: WhiteButton(
                        top: 0,
                        bottom: 0,
                        text: 'Editar perfil do médico',
                        color: Color(0xff2185D0),
                        width: wXD(300, context),
                        height: wXD(47, context),
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
