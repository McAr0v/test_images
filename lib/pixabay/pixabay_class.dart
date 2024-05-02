import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_images/image_class/image_from_pixabay.dart';

class PixabayClass {

  static String buildUrl(String query, {int page = 1}){

    const String key = '43678102-f9975c397788039c530f4a1c1';
    const String pixabayUrl = 'https://pixabay.com/api/';

    return query.isNotEmpty ?
      '$pixabayUrl?key=$key&q=${replaceSpace(query)}&page=$page&per_page=24'
        : '$pixabayUrl?key=$key&page=$page&per_page=24';

  }

  static String replaceSpace(String inputString){
    return inputString.replaceAll(' ', '+');
  }

  static Future<List<ImageFromPixabay>> fetchData(String query, {int page = 1}) async {

    // Делаем запрос на сервер
    final response = await http.get(Uri.parse(buildUrl(query, page: page)));

    // Если сервер отвечает об успешной загрузке
    if (response.statusCode == 200) {

      // Создаем временный список изображений
      List<ImageFromPixabay> tempList = [];

      // Декодируем полученный ответ от Pixabay
      final Map<String, dynamic> data = jsonDecode(response.body);

      // "Забираем" наши картинки из общего json
      List<Map<String, dynamic>> hits = List.from(data['hits']);

      // Проходимся по каждому элементу списка
      for (var hit in hits) {
        // Преобразуем json в объект картинки
        ImageFromPixabay tempImage = ImageFromPixabay.fromJson(hit);
        // Добавляем во временный список
        tempList.add(tempImage);
      }
      return tempList;

    } else {
      // Если нет результатов запроса, возвращаем пустой список
      return [];
    }
  }

}