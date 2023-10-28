import 'dart:convert';
import 'package:flutter/services.dart';

class Citys {
  String keyword;
  int id;
  String autocompleteterm;
  String country;

  Citys({
    this.keyword,
    this.id,
    this.autocompleteterm,
    this.country,
  });

  factory Citys.fromJson(Map<String, dynamic> parsedJson) {
    return Citys(
        keyword: parsedJson['keyword'] as String,
        id: parsedJson['id'],
        autocompleteterm: parsedJson['autocompleteTerm'] as String,
        country: parsedJson['country'] as String);
  }
}

class CitysViewModel {
  static List<Citys> citys;

  static Future loadCitys() async {
    try {
      citys = [];
      String jsonString = await rootBundle.loadString('assets/citys.json');

      Map parsedJson = json.decode(jsonString);

      var categoryJson = parsedJson['citys'] as List;
      for (int i = 0; i < categoryJson.length; i++) {
        citys.add(new Citys.fromJson(categoryJson[i]));
      }
    } catch (e) {
      print(e);
    }
  }
}

class ListsCitys {
  static List<String> listCitysDF = [
    'Ceilândia',
    'Samambaia',
    'Taguatinga',
    'Plano Piloto',
    'Planaltina',
    'Águas Claras',
    'Recanto das Emas',
    'Gama',
    'Guará',
    'Santa Maria',
    'Sobradinho II',
    'São Sebastião',
    'Vicente Pires',
    'Itapoã',
    'Sobradinho',
    'Sudoeste/Octogonal',
    'Brazlândia',
    'Riacho Fundo II',
    'Paranoá',
    'Riacho Fundo',
    'SCIA',
    'Lago Norte',
    'Cruzeiro',
    'Lago Sul',
    'Jardim Botânico',
    'Núcleo Bandeirante',
    'Park Way',
    'Candangolândia',
    'Varjão',
    'Fercal',
    'SIA',
  ];
  static List<String> listCitysAC = [
    'Acrelândia',
    'Assis Brasil',
    'Brasiléia',
    'Bujari',
    'Capixaba',
    'Cruzeiro do Sul',
    'Epitaciolândia',
    'Feijó',
    'Jordão',
    'Manoel Urbano',
    'Marechal Thaumaturgo',
    'Mâncio Lima',
    'Plácido de Castro',
    'Porto Acre',
    'Porto Walter',
    'Rio Branco',
    'Rodrigues Alves',
    'Santa Rosa do Purus',
    'Sena Madureira',
    'Senador Guiomard',
    'Tarauacá',
    'Xapuri',
  ];
  static List<String> listCitysAP = [
    'Amapá',
    'Calçoene',
    'Cutias',
    'Ferreira Gomes',
    'Itaulbal',
    'Laranjal do Jari',
    'Macapá',
    'Mazagão',
    'Oiapoque',
    'Pedra branca do Amaparí',
    'Porto Grande',
    'Parúba',
    'Santana',
    'Itapoã',
    'Sobradinho',
    'Sudoeste/Octogonal',
    'Brazlândia',
    'Riacho Fundo II',
    'Paranoá',
    'Riacho Fundo',
    'SCIA',
    'Lago Norte',
    'Cruzeiro',
    'Lago Sul',
    'Jardim Botânico',
    'Núcleo Bandeirante',
    'Park Way',
    'Candangolândia',
    'Varjão',
    'Fercal',
    'SIA',
  ];
}
