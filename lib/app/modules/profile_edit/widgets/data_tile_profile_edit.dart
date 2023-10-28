import 'package:encontrar_cuidadodoctor/app/modules/profile_edit/profileEdit_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile_edit/widgets/float_menu_city.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile_edit/widgets/float_menu_states.dart';
import 'package:encontrar_cuidadodoctor/app/modules/sign/widgets/masktextinputformatter.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'float_menu_specialties.dart';

class DataTileProfileEdit extends StatelessWidget {
  @required
  final String title;
  final String hint;
  final Function onChanged;
  final Function iconTap;
  final FocusNode focusNode;
  final int maxLines;
  final String type;
  final bool mandatory;
  final Function onEditingComplete;
  final String initialValue;
  final bool secretaryEditDoctor;

  const DataTileProfileEdit({
    Key key,
    this.title,
    this.onChanged,
    this.hint = '',
    this.iconTap,
    this.focusNode,
    this.maxLines = 1,
    this.type,
    this.mandatory = false,
    this.onEditingComplete,
    this.initialValue,
    this.secretaryEditDoctor = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileEditStore store = Modular.get();
    MaskTextInputFormatter maskFormatterCpf = new MaskTextInputFormatter(
        mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

    MaskTextInputFormatter maskFormatterCep = new MaskTextInputFormatter(
        mask: '##.###-###', filter: {"#": RegExp(r'[0-9]')});

    MaskTextInputFormatter maskFormatterPhone = new MaskTextInputFormatter(
        mask: '+## (##) #####-####', filter: {"#": RegExp(r'[0-9]')});

    MaskTextInputFormatter maskFormatterLandline = new MaskTextInputFormatter(
        mask: '(##) ####-####', filter: {"#": RegExp(r'[0-9]')});

    List<MaskTextInputFormatter> getInputFormatter() {
      switch (type) {
        case 'cpf':
          return [maskFormatterCpf];
          break;

        case 'cep':
          return [maskFormatterCep];
          break;

        case 'phone':
          return [maskFormatterPhone];
          break;

        case 'landline':
          return [maskFormatterLandline];
          break;

        default:
          return [];
          break;
      }
    }

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(
            wXD(11, context),
            wXD(0, context),
            wXD(11, context),
            wXD(12, context),
          ),
          padding: EdgeInsets.only(
            left: wXD(8, context),
          ),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0x50707070),
              ),
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        mandatory ? '$title*' : '$title',
                        style: TextStyle(
                            fontSize: wXD(20, context),
                            fontWeight: FontWeight.w600,
                            color: Color(0xff95989A)),
                      ),
                      Spacer(),
                      type == 'country' ||
                              type == 'phone' ||
                              secretaryEditDoctor
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.only(right: wXD(13, context)),
                              child: InkWell(
                                onTap: iconTap != null
                                    ? iconTap
                                    : () {
                                        focusNode.requestFocus();
                                      },
                                child: Icon(
                                  Icons.edit,
                                  color: Color(0xff95989A),
                                  size: wXD(20, context),
                                ),
                              ),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: wXD(5, context),
                  ),
                  textFieldPermission()
                      ? TextFormField(
                          enabled: type == 'country' ||
                                  type == 'phone' ||
                                  secretaryEditDoctor
                              ? false
                              : true,
                          autocorrect: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          initialValue: store.getMask(initialValue, type),
                          textCapitalization: type == 'email' ||
                                  type == 'email2' ||
                                  type == 'social'
                              ? TextCapitalization.none
                              : type != 'fullname'
                                  ? TextCapitalization.sentences
                                  : TextCapitalization.words,
                          maxLines: maxLines,
                          focusNode: focusNode,
                          inputFormatters: getInputFormatter(),
                          keyboardType: getKeyboardType(),
                          onEditingComplete: type != 'fullname' &&
                                  type != 'cpf' &&
                                  type != 'language'
                              ? () {
                                  onEditingComplete();
                                }
                              : null,
                          validator: (value) {
                            if (mandatory) {
                              if (value.isEmpty) {
                                return 'Este campo não pode ser vazio';
                              } else {
                                switch (type) {
                                  case 'email':
                                    bool emailValid = RegExp(
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                        .hasMatch(value);

                                    if (!emailValid) {
                                      return 'Digite um e-mail válido';
                                    } else {
                                      return null;
                                    }
                                    break;

                                  case 'email2':
                                    bool emailValid = true;

                                    if (store.email != null) {
                                      emailValid = store.email.toLowerCase() ==
                                          store.mapDoctor['email']
                                              .toLowerCase();
                                    }
                                    if (!emailValid) {
                                      return 'Os e-mails estão diferentes';
                                    } else {
                                      return null;
                                    }
                                    break;

                                  case 'cep':
                                    if (value.length < 10) {
                                      return 'Digite o CEP por completo';
                                    } else {
                                      return null;
                                    }
                                    break;

                                  case 'cpf':
                                    if (value.length < 14) {
                                      return 'Digite o CPF por completo';
                                    } else {
                                      return null;
                                    }
                                    break;

                                  case 'phone':
                                    if (value.length < 19) {
                                      return 'Digite o número por completo';
                                    } else {
                                      return null;
                                    }
                                    break;

                                  case 'landline':
                                    if (value.length < 14) {
                                      return 'Digite o número por completo';
                                    } else {
                                      return null;
                                    }
                                    break;

                                  default:
                                    return null;
                                    break;
                                }
                              }
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
                            hintText: '$hint',
                            hintStyle: TextStyle(
                              fontSize: wXD(17, context),
                              fontWeight: FontWeight.w400,
                              color: Color(0x30707070),
                            ),
                          ),
                          onChanged: (value) {
                            if (type == 'cpf') {
                              onChanged(maskFormatterCpf.getUnmaskedText());
                            } else {
                              if (type == 'cep') {
                                onChanged(maskFormatterCep.getUnmaskedText());
                              } else {
                                if (type == 'phone') {
                                  onChanged(
                                      maskFormatterPhone.getUnmaskedText());
                                } else {
                                  if (type == 'landline') {
                                    onChanged(maskFormatterLandline
                                        .getUnmaskedText());
                                  } else {
                                    onChanged(value);
                                  }
                                }
                              }
                            }
                          },
                        )
                      : type == 'gender' || type == 'birthday'
                          ? Observer(
                              builder: (context) {
                                return InkWell(
                                  onTap: iconTap,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: wXD(250, context),
                                        child: Text(
                                          type == 'gender'
                                              ? store.mapDoctor['gender'] !=
                                                      null
                                                  ? store.mapDoctor['gender']
                                                  : hint
                                              : store.mapDoctor['birthday'] !=
                                                      null
                                                  ? store.converterDate(store
                                                      .mapDoctor['birthday'])
                                                  : hint,
                                          style: TextStyle(
                                            fontSize: wXD(17, context),
                                            fontWeight: FontWeight.w400,
                                            color: type == 'gender'
                                                ? store.mapDoctor['gender'] !=
                                                        null
                                                    ? Color(0xff707070)
                                                    : Color(0x30707070)
                                                : store.mapDoctor['birthday'] !=
                                                        null
                                                    ? Color(0xff707070)
                                                    : Color(0x30707070),
                                          ),
                                        ),
                                      ),
                                      store.genderError && type == 'gender'
                                          ? Container(
                                              margin: EdgeInsets.only(top: 7),
                                              width: wXD(250, context),
                                              child: Text(
                                                'Este campo não pode ser vazio',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.red[700],
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      store.dateError && type != 'gender'
                                          ? Container(
                                              margin: EdgeInsets.only(top: 7),
                                              width: wXD(250, context),
                                              child: Text(
                                                'Este campo não pode ser vazio',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.red[700],
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                );
                              },
                            )
                          : Container(),
                  type == 'city' ? CitysField() : Container(),
                  type == 'state' ? StatesField() : Container(),
                  type == 'aboutMe' ? SpecialtiesField() : Container(),
                  SizedBox(height: wXD(10, context))
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool textFieldPermission() {
    bool valid = type != 'gender' &&
        type != 'birthday' &&
        type != 'state' &&
        type != 'city';
    return valid;
  }

  TextInputType getKeyboardType() {
    if (type == 'cpf' ||
        type == 'cep' ||
        type == 'phone' ||
        type == 'number' ||
        type == 'crm' ||
        type == 'rqe' ||
        type == 'landline') {
      return TextInputType.number;
    } else {
      return null;
    }
  }
}
