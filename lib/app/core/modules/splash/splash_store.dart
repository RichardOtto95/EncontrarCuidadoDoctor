import 'package:mobx/mobx.dart';

part 'splash_store.g.dart';

class SplashStore = _SplashStoreBase with _$SplashStore;
abstract class _SplashStoreBase with Store {

  @observable
  int value = 0;

  @action
  void increment() {
    value++;
  } 
}