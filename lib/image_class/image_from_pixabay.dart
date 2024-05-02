class ImageFromPixabay {
  final int id;
  final String imageURL;
  final String largeImageURL;
  final int views;
  final int likes;

  ImageFromPixabay({
    required this.id,
    required this.imageURL,
    required this.likes,
    required this.views,
    required this.largeImageURL,
  });

  // Метод для создания объекта из JSON

  factory ImageFromPixabay.fromJson(Map<String, dynamic> json) {
    return ImageFromPixabay(
      id: json['id'] as int,
      imageURL: json['webformatURL'],
      largeImageURL: json['largeImageURL'],
      likes: json['likes'] as int,
      views: json['views'] as int,
    );
  }
}