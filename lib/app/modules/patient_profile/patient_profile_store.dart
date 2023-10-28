import 'package:mobx/mobx.dart';

part 'patient_profile_store.g.dart';

class PatientProfileStore = _PatientProfileStoreBase with _$PatientProfileStore;
abstract class _PatientProfileStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 
}