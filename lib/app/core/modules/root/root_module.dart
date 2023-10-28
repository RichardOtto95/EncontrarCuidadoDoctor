import 'package:encontrar_cuidadodoctor/app/core/modules/root/root_page.dart';
import 'package:encontrar_cuidadodoctor/app/core/modules/root/root_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/consultations/consultations_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/consultations/consultations_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/feed/feed_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/finances/finances_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/messages/messages_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/patient_profile/patient_profile_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile/profile_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile/widgets/choose_doctor.dart';
import 'package:encontrar_cuidadodoctor/app/modules/ratings/ratings_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/schedule_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedulings/scheduling_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/settings/settings_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/sign/sign_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/sign/sign_page_verify.dart';
import 'package:encontrar_cuidadodoctor/app/modules/signature/signature_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/suport/suport_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/secretaries/secretaries_module.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/choose_type.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RootModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => RootStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => RootPage()),
    ModuleRoute('/ratings', module: RatingsModule()),
    ModuleRoute('/consultations', module: ConsultationsModule()),
    ModuleRoute('/feed', module: FeedModule()),
    ModuleRoute('/finances', module: FinancesModule()),
    ModuleRoute('/main', module: MainModule()),
    ModuleRoute('/messages', module: MessagesModule()),
    ChildRoute('/patient-profile',
        child: (_, args) => PatientProfilePage(
              userModel: args.data,
            )),
    ChildRoute('/consulation-detail',
        child: (_, args) => ConsultationsPage(
              appointmentModel: args.data,
            )),
    ChildRoute('/phone-verify', child: (_, args) => SignVerifyPage()),
    ModuleRoute('/profile', module: ProfileModule()),
    ModuleRoute('/scheduling', module: SchedulingModule()),
    ModuleRoute('/schedule', module: ScheduleModule()),
    ModuleRoute('/secretaries', module: SecretariesModule()),
    ModuleRoute('/settings', module: SettingsModule()),
    ModuleRoute('/signature', module: SignatureModule()),
    ModuleRoute('/suport', module: SuportModule()),
    ModuleRoute('/sign', module: SignModule()),
    ChildRoute('/choose-type', child: (_, args) => ChooseType()),
    ChildRoute('/choose-doctor',
        child: (_, args) => ChooseDoctor(
              doctorId: args.data,
            )),
  ];
}
