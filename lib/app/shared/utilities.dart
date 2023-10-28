import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

double wXD(double size, BuildContext context) {
  double finalValue = MediaQuery.of(context).size.width * size / 375;
  return finalValue;
}

double hXD(double size, BuildContext context) {
  double finalValue = MediaQuery.of(context).size.height * size / 667;
  return finalValue;
}

double maxHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double maxWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

String cpfMasked(String text) {
  if (text == null) {
    return '- - -';
  } else {
    return '${text.substring(0, 3)}.${text.substring(3, 6)}.${text.substring(6, 9)}-${text.substring(9, 11)}';
  }
}

Future callFunction(String function, Map<String, dynamic> params) async {
  HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(function);
  try {
    print('no try');
    return callable.call(params);
  } on FirebaseFunctionsException catch (e) {
    print('caught firebase functions exception');
    print(e);
    print(e.code);
    print(e.message);
    print(e.details);
    return false;
  } catch (e) {
    print('caught generic exception');
    print(e);
    return false;
  }
}
