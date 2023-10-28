import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/modules/sign/widgets/masktextinputformatter.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../signature_store.dart';
import 'float_menu_city.dart';
import 'float_menu_states.dart';

class CardFields extends StatelessWidget {
  final SignatureStore store;
  const CardFields({
    Key key,
    this.store,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: wXD(15, context)),
        TitleWidget(
          title: 'Dados do cartão',
          left: 44,
          bottom: 10,
        ),
        CardTile(
          store: store,
          title: 'Número do cartão',
          hint: 'Digite o número do cartão',
          type: 'card_number',
          nextFocusNode: store.focusNodeMap['name_card_holder'],
          inputFormatters: [
            MaskTextInputFormatter(
                mask: '#### #### #### ####', filter: {"#": RegExp(r'[0-9]')})
          ],
          keyboardType: TextInputType.number,
          onTap: () {
            store.input = true;
          },
        ),
        CardTile(
          store: store,
          title: 'Nome do titular do cartão',
          hint: 'Digite o nome do titular do cartão',
          type: 'name_card_holder',
          nextFocusNode: store.focusNodeMap['due_date'],
          onTap: () {
            store.input = true;
          },
        ),
        CardTile(
          store: store,
          title: 'Data de vencimento',
          hint: 'MM/AA',
          type: 'due_date',
          nextFocusNode: store.focusNodeMap['security_code'],
          inputFormatters: [
            MaskTextInputFormatter(
                mask: '##/##', filter: {"#": RegExp(r'[0-9]')})
          ],
          keyboardType: TextInputType.number,
          onTap: () {
            store.input = true;
          },
        ),
        CardTile(
          store: store,
          title: 'Código de segurança',
          hint: 'CVV',
          type: 'security_code',
          nextFocusNode: store.focusNodeMap['cpf'],
          inputFormatters: [
            MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')})
          ],
          keyboardType: TextInputType.number,
          onTap: () {
            store.input = true;
          },
        ),
        CardTile(
          store: store,
          title: 'CPF',
          hint: 'Digite o cpf do titular do cartão',
          type: 'cpf',
          nextFocusNode: store.focusNodeMap['billing_address'],
          inputFormatters: [
            MaskTextInputFormatter(
                mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')})
          ],
          keyboardType: TextInputType.number,
          onTap: () {
            store.input = true;
          },
        ),
        TitleWidget(
          title: 'Endereço de cobrança',
          top: 25,
          left: 44,
          bottom: 10,
        ),
        CardTile(
          store: store,
          title: 'Endereço',
          hint: 'Rua 123, Quadra 321, Lote 123, Número 321',
          type: 'billing_address',
          nextFocusNode: store.focusNodeMap['billing_district'],
          onTap: () {
            store.input = true;
          },
        ),
        CardTile(
          store: store,
          title: 'Distrito/Bairro',
          hint: 'Vicente Pires',
          type: 'billing_district',
          nextFocusNode: store.focusNodeMap['billing_state'],
          onTap: () {
            store.input = true;
          },
        ),
        StatesField(),
        SizedBox(
          height: wXD(17, context),
        ),
        CitysField(),
        SizedBox(
          height: wXD(17, context),
        ),
        CardTile(
          store: store,
          title: 'CEP',
          hint: '55555-333',
          type: 'billing_cep',
          inputFormatters: [
            MaskTextInputFormatter(
                mask: '#####-###', filter: {"#": RegExp(r'[0-9]')})
          ],
          keyboardType: TextInputType.number,
          onTap: () {
            store.input = true;
          },
        ),
      ],
    );
  }
}

class CardTile extends StatelessWidget {
  final String title, hint, type;
  final Function onTap;
  final SignatureStore store;
  final FocusNode nextFocusNode;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;

  const CardTile({
    Key key,
    this.title,
    this.hint,
    this.onTap,
    this.type,
    this.store,
    this.nextFocusNode,
    this.inputFormatters,
    this.keyboardType,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        wXD(44, context),
        wXD(0, context),
        wXD(44, context),
        wXD(17, context),
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0x50707070)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
              textCapitalization: type != 'name_card_holder'
                  ? TextCapitalization.sentences
                  : TextCapitalization.words,
              focusNode: store.focusNodeMap[type],
              inputFormatters: inputFormatters,
              keyboardType: keyboardType,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onTap: () {
                onTap();
              },
              cursorColor: Color(0xff707070),
              decoration: InputDecoration.collapsed(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0x50707070),
                ),
              ),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff707070),
              ),
              onEditingComplete: type != 'billing_cep'
                  ? () {
                      nextFocusNode.requestFocus();
                    }
                  : () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
              onChanged: (value) {
                switch (type) {
                  case 'card_number':
                    store.cardMap[type] = value.replaceAll(' ', '');

                    break;

                  case 'due_date':
                    store.cardMap[type] = value.replaceAll('/', '');

                    break;

                  case 'cpf':
                    store.cardMap[type] = value.replaceAll(RegExp(r'[.-]'), '');

                    break;

                  case 'billing_cep':
                    store.cardMap[type] = value.replaceAll('-', '');

                    break;

                  default:
                    store.cardMap[type] = value;

                    break;
                }
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Este campo não pode ser vazio';
                } else {
                  switch (type) {
                    case 'billing_cep':
                      if (value.length < 9) {
                        return 'Digite o CEP por completo';
                      } else {
                        return null;
                      }
                      break;

                    case 'card_number':
                      if (value.length < 19) {
                        return 'Digite o número do cartão por completo';
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

                    case 'due_date':
                      print('xxxxxxxxxxxx validator ${value.length} - $value');
                      if (value.length == 2) {
                        print('xxxxxxxxxxxxx else $value');
                        String monthString = value;
                        int month = int.parse(monthString);
                        print('xxxxxxxxxxxxx month $month ${month < 13}');

                        if (month > 12) {
                          return 'Digite um mês válido.';
                        }

                        return 'Digite a data de vencimento por completo.';
                      } else {
                        if (value.length < 5) {
                          return 'Digite a data de vencimento por completo.';
                        } else {
                          DateTime dateTimeNow = Timestamp.now().toDate();
                          int yearNow = dateTimeNow.year;
                          int monthNow = dateTimeNow.month;

                          String yearString =
                              yearNow.toString().substring(0, 2) +
                                  value.substring(3, 5);
                          int year = int.parse(yearString);

                          String monthString = value.substring(0, 2);
                          int month = int.parse(monthString);

                          bool isEqual = year == yearNow;

                          bool isCurrentDate = yearNow > year;
                          print(
                              'xxxxxxxxxxxx yearNow $yearNow > $year = ${yearNow > year}');

                          if (month > 12) {
                            return 'Digite um mês válido.';
                          }

                          if (isCurrentDate || isEqual && monthNow >= month) {
                            return 'Digite uma data futura.';
                          } else {
                            return null;
                          }
                        }
                      }
                      break;

                    case 'security_code':
                      if (value.length < 3) {
                        return 'Digite o código por completo';
                      } else {
                        return null;
                      }
                      break;

                    default:
                      return null;
                      break;
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
