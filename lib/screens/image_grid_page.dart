import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:test_images/pixabay/pixabay_class.dart';

import '../image_class/image_from_pixabay.dart';
import 'full_screen_page.dart';

class ImageGridPage extends StatefulWidget {

  @override
  ImageGridPageState createState() => ImageGridPageState();
}

class ImageGridPageState extends State<ImageGridPage> {

  List<ImageFromPixabay> list = [];

  bool loading = true;

  bool notMoreImage = false;
  
  String query = '';
  
  int page = 1;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {

    initializeScreen();
    super.initState();
  }

  Future<void> initializeScreen() async {

    setState(() {
      loading = true;
    });

    list = await PixabayClass.fetchData(query, page: page);

    setState(() {
      loading = false;
    });


  }

  Future<void> addImagesInList() async {
    page++;
    List<ImageFromPixabay> templist = await PixabayClass.fetchData(query, page: page);
    setState(() {
      if (templist.isNotEmpty){
        list.addAll(templist);
      } else {
        notMoreImage = true;
      }
    });

  }

  Future<void> searchImages(String inputQuery) async {
    setState(() {
      loading = true;
      notMoreImage = false;
    });
    list.clear();
    page = 1;
    query = inputQuery;

    List<ImageFromPixabay> templist = await PixabayClass.fetchData(query, page: page);
    setState(() {
      if (templist.isNotEmpty){
        list.addAll(templist);
      } else {
        notMoreImage = true;
      }

      loading = false;

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Image Grid'),
      ),*/
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo)
        {
          if (scrollInfo.metrics.maxScrollExtent == scrollInfo.metrics.pixels){

            EasyDebounce.debounce(
                'scroll-debouncer',                 // <-- An ID for this particular debouncer
                Duration(milliseconds: 500),    // <-- The debounce duration
                    () => addImagesInList()           // <-- The target method
            );
          }
          return false;
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Text(
                        'Картинки с PixaBay',
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Окунись в мир изображений',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Поиск',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                          controller: searchController,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)),
                        ),
                        onPressed: (){
                          EasyDebounce.debounce(
                              'search-debouncer',                 // <-- An ID for this particular debouncer
                              Duration(milliseconds: 500),    // <-- The debounce duration
                                  () => searchImages(searchController.text)           // <-- The target method
                          );
                        },
                        child: Text(
                          'Найти',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    if (searchController.text.isNotEmpty) Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)),
                        ),
                        onPressed: (){
                          EasyDebounce.debounce(
                              'search-debouncer',                 // <-- An ID for this particular debouncer
                              Duration(milliseconds: 500),    // <-- The debounce duration
                                  () => cleanField()        // <-- The target method
                          );
                        },
                        child: Text(
                          'Очистить',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                        ),
                      ),
                    )
                  ],
                ),

                if (loading) Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.black,),
                  ),
                ),
                if (list.isNotEmpty && !loading) Expanded(
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      // Получаем ширину экрана
                      double screenWidth = constraints.maxWidth;

                      // Вычисляем количество столбцов в сетке в зависимости от ширины экрана
                      int columnCount = getColumnCounters(screenWidth); // Предположим, что каждое изображение имеет ширину 150


                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columnCount,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return FullScreenImagePage(imageUrl: list[index].largeImageURL);
                                  },
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return SlideTransition(
                                      position: Tween<Offset>(
                                        begin: Offset(-1.0, 0.0), // Начальная позиция за пределами экрана слева
                                        end: Offset.zero, // Конечная позиция (центр экрана)
                                      ).animate(animation),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Hero(
                              tag: 'imageHero$index', // Уникальный тег для каждого изображения
                              child: Image.network(
                                list[index].imageURL,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                if (notMoreImage) // Проверяем условие notMoreImage
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Изображений больше нет",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ],
        ),
      )
    );
  }

  Future<void> cleanField() async {
    searchController.text = '';
    query = '';
    page = 1;
    list.clear();
    List<ImageFromPixabay> tempList = await PixabayClass.fetchData(query, page: page);
    setState(() {
      list = tempList;
    });

  }

  int getColumnCounters(double screenWidth){
    // Вычисляем количество столбцов в сетке в зависимости от ширины экрана
    int columnCount = (screenWidth / 250).round(); // Предположим, что каждое изображение имеет ширину 150

    switch (columnCount){
      case 1: return 1;
      case 2: return 2;
      case 3: return 4;
      case 4: return 4;
      default: return 6;
    }
  }
}