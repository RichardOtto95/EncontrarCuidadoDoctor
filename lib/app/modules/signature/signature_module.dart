import 'package:encontrar_cuidadodoctor/app/modules/profile_edit/profileEdit_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile_edit/profileEdit_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/signature/signature_Page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/signature/signature_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/signature/widgets/add_card.dart';
import 'package:encontrar_cuidadodoctor/app/modules/signature/widgets/card_data.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SignatureModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SignatureStore()),
    Bind.lazySingleton((i) => ProfileEditStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SignaturePage()),
    ChildRoute('/add-card',
        child: (_, args) => AddCard(
              hasCard: args.data,
            )),
    ChildRoute('/card-data',
        child: (_, args) => CardData(
              cardModel: args.data,
            )),
    ChildRoute('/edit-profile',
        child: (_, args) => ProfileEditPage(
              doctorModel: args.data,
            )),
  ];
}
