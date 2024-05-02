import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:test_images/design/logo_header.dart';
import 'package:test_images/pixabay/pixabay_class.dart';
import '../design/empty_result_widget.dart';
import '../design/image_widget.dart';
import '../design/loading_images_widget.dart';
import '../design/search_bar.dart';
import '../image_class/image_from_pixabay.dart';

class ImageGridPage extends StatefulWidget {
  const ImageGridPage({super.key});

  @override
  ImageGridPageState createState() => ImageGridPageState();
}

class ImageGridPageState extends State<ImageGridPage> {

  List<ImageFromPixabay> list = [];

  bool loading = true;
  bool lazyLoad = false;

  String query = '';
  int page = 1;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Загружаем картинки по умолчанию
    getImages('', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo)
          {
            // Если долистали до конца страницы
            if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels){

              // Включаем оповещение о подгрузке изображений
              setState(() {
                lazyLoad = true;
              });

              // Через дебоунсер вызываем метод загрузки следующей страницы с Pixabay
              EasyDebounce.debounce(
                  'scroll-debouncer',
                  const Duration(milliseconds: 500),
                      () => addImagesInList()
              );
            }

            return false;
          },
          child: Stack(
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Логотип
                  const LogoHeader(),

                  // Поисковая панель
                  SearchingBar(
                      searchController: searchController,
                      onClear: (){
                        getImages('', true);
                      },
                      onButtonClick: (){
                        // Если текст введен в форму поиска
                        if (searchController.text.isNotEmpty){
                          setState(() {
                            loading = true;
                          });
                          // С помощью дебоунс вызываем наш метод поиска
                          EasyDebounce.debounce(
                              'search-debouncer',
                              const Duration(milliseconds: 500),
                                  () => getImages(searchController.text, false)
                          );
                        } else {
                          // Если текст не ввели в форму, показываем ошибку
                          showSnackBar(
                              barColor: Colors.redAccent,
                              textColor: Colors.white,
                              text: 'Ошибка! Введите поисковый запрос'
                          );
                        }
                      }
                  ),

                  const SizedBox(height: 10,),

                  // Индикатор загрузки при ожидании подгрузки списка
                  if (loading) const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.orange,),
                    ),
                  ),

                  // Если список пустой - виджет-оповещение
                  if (!loading && list.isEmpty) EmptyResultWidget(
                    onTap: (){
                      getImages('', true);
                    }
                  ),

                  // Если список не пустой - сетка картинок
                  if (list.isNotEmpty && !loading) Expanded(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {

                        // Получаем ширину экрана
                        double screenWidth = constraints.maxWidth;

                        // Вычисляем количество столбцов в сетке в зависимости от ширины экрана
                        int columnCount = getColumnCounters(screenWidth);

                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columnCount,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ImageWidget(
                              image: list[index],
                              height: screenWidth / columnCount,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),

              // Виджет-оповещение при подгрузке изображений при скролле
              if (lazyLoad) const LoadingImagesWidget(),
            ],
          ),
        )
    );
  }

  // Метод получения списка картинок по запросу
  Future<void> getImages(String inputQuery, bool needClear) async {

    // Включаем экран загрузки
    setState(() {
      loading = true;
    });

    // Если нужно, сбрасывыаем текст в форме ввода
    if (needClear) searchController.text = '';

    // Сбрасываем счетчик страниц
    page = 1;
    // Сбрасываем ключевые слова для поиска
    query = inputQuery;

    // Очищаем основной список
    list.clear();

    // Подгружаем новый согласно ключевым словам
    List<ImageFromPixabay> tempList = await PixabayClass.fetchData(query, page: page);

    setState(() {
      if (tempList.isNotEmpty){
        list.addAll(tempList);
      }
      loading = false;
    });

  }

  Future<void> addImagesInList() async {

    // Инкрементируем счетчик страниц
    page++;

    // Получаем список картинок с нужной страницы
    List<ImageFromPixabay> tempList = await PixabayClass.fetchData(query, page: page);

    setState(() {

      // Убираем оповещение ленивой загрузки
      lazyLoad = false;

      if (tempList.isNotEmpty){
        // Если список не пустой, добавляем к основному списку подгруженную страницу
        list.addAll(tempList);
      } else {
        // Если ничего не загрузилось, значит страниц больше нет
        // Показываем оповещение
        showSnackBar(
            barColor: Colors.yellow,
            textColor: Colors.black,
            text: 'Изображений больше нет'
        );
      }
    });
  }

  void showSnackBar(
      {
        Color barColor = Colors.black,
        Color textColor = Colors.white,
        required String text,
        int time = 2,
      }
      ){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Center(
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: textColor
                ),
              )
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: barColor,
          duration: Duration(seconds: time),
        )
    );
  }

  int getColumnCounters(double screenWidth){
    // Вычисляем количество столбцов в сетке в зависимости от ширины экрана
    int columnCount = (screenWidth / 250).round(); // Предположим, что каждое изображение имеет ширину 250

    switch (columnCount){
      case 1: return 1;
      case 2: return 2;
      case 3: return 2;
      case 4: return 4;
      case 5: return 4;
      default: return 6;
    }
  }
}