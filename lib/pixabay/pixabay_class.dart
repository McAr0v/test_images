import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_images/image_class/image_from_pixabay.dart';

class PixabayClass {

  static List<ImageFromPixabay> list = [];

  static String buildUrl(String query, {int page = 1}){
    const String key = '43678102-f9975c397788039c530f4a1c1';
    const String pixabayUrl = 'https://pixabay.com/api/';
    return query.isNotEmpty? '$pixabayUrl?key=$key&q=${replaceSpace(query)}&page=$page&per_page=24' : '$pixabayUrl?key=$key&page=$page&per_page=24';
  }

  static String replaceSpace(String inputString){
    return inputString.replaceAll(' ', '+');
  }

  static Future<List<ImageFromPixabay>> fetchData(String query, {int page = 1}) async {
    final response = await http.get(Uri.parse(buildUrl(query, page: page)));
    if (response.statusCode == 200) {
      // Если запрос успешен, преобразуйте JSON-ответ в объект Dart

      List<ImageFromPixabay> tempList = [];

      final Map<String, dynamic> data = jsonDecode(response.body);

      List<Map<String, dynamic>> hits = List.from(data['hits']);

      //print(hits);

      hits.forEach((hit) {
        ImageFromPixabay tempImage = ImageFromPixabay.fromJson(hit);
        tempList.add(tempImage);
      });

      list = tempList;

      return tempList;

    } else {
      return [];
    }
  }

}