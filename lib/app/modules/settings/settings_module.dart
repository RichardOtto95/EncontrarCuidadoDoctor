import 'package:encontrar_cuidadodoctor/app/modules/settings/preferences_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'app_info_page.dart';
import 'privacy_policy.dart';
import 'settings_page.dart';
import 'settings_store.dart';
import 'terms_of_use_page.dart';

class SettingsModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => SettingsStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => SettingsPage()),
    ChildRoute('/preferences',
        child: (_, args) => PreferencesPage(
              listInitialValues: args.data,
            )),
    ChildRoute('/info', child: (_, args) => AppInfo()),
    ChildRoute('/terms-of-usage', child: (_, args) => TermsOfUsagePage()),
    ChildRoute('/privacy-policy', child: (_, args) => PrivacyPolicyPage()),
  ];

  @override
  Widget get view => SettingsPage();
}
