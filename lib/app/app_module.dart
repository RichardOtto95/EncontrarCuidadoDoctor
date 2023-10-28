import 'package:encontrar_cuidadodoctor/app/core/models/doctor_model.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/patient_model.dart';
import 'package:encontrar_cuidadodoctor/app/core/modules/root/root_module.dart';
import 'package:encontrar_cuidadodoctor/app/modules/drprofile/drprofile_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/feed/feed_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/messages/messages_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile/profile_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/schedule_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'core/services/auth/auth_service.dart';
import 'core/services/auth/auth_store.dart';
import 'modules/consultations/consultations_store.dart';
import 'modules/finances/finances_store.dart';
import 'modules/patient_profile/patient_profile_store.dart';
import 'modules/schedulings/scheduling_store.dart';
import 'modules/settings/settings_store.dart';
import 'modules/sign/sign_store.dart';
import 'modules/suport/suport_store.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => SignStore(i.get())),
    Bind((i) => AuthStore()),
    Bind((i) => MainStore()),
    Bind((i) => FeedStore()),
    Bind((i) => MessagesStore()),
    Bind((i) => DrProfileStore()),
    Bind((i) => ScheduleStore()),
    Bind((i) => ConsultationsStore()),
    Bind((i) => FinancesStore()),
    Bind((i) => PatientProfileStore()),
    Bind((i) => SettingsStore()),
    Bind((i) => SuportStore()),
    Bind((i) => ProfileStore()),
    Bind((i) => SchedulingStore()),
    Bind<AuthService>((i) => AuthService()),
    Bind<PatientModel>((i) => PatientModel()),
    Bind<DoctorModel>((i) => DoctorModel()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: RootModule()),
  ];
}
