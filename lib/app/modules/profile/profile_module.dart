import 'package:encontrar_cuidadodoctor/app/modules/drprofile/drprofile_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile/profile_Page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile/profile_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile/widgets/notifications.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile_edit/profileEdit_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile_edit/profileEdit_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ProfileStore()),
    Bind.lazySingleton((i) => ProfileEditStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => ProfilePage()),
    ChildRoute('/main', child: (_, args) => MainPage()),
    ChildRoute('/edit-profile',
        child: (_, args) => ProfileEditPage(
              doctorModel: args.data,
            )),
    ChildRoute('/dr-profile',
        child: (_, args) => DrProfilePage(
              doctorModel: args.data,
            )),
    ChildRoute('/notifications', child: (_, args) => Notifications()),
  ];
}
