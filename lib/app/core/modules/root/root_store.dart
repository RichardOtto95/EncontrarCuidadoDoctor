import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'root_store.g.dart';

class RootStore = _RootStoreBase with _$RootStore;

abstract class _RootStoreBase with Store {
  @observable
  int value = 0;
  @observable
  int selectedTrunk = 0;
  @observable
  PageStorageBucket bucketGlobal;

  @action
  setBucket(PageStorageBucket bck) => bucketGlobal = bck;
  @action
  setSelectedTrunk(int value) => selectedTrunk = value;
  @action
  void increment() {
    value++;
  }
}
