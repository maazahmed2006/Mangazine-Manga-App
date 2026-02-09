class ChapterImage {

  final String baseUrl;
  final String hash;
  final List<String> images;

  ChapterImage({
    required this.baseUrl,
    required this.hash,
    required this.images,
});

  factory ChapterImage.fromJson(Map<String , dynamic> json)
  {
    return ChapterImage(
        baseUrl: json['baseUrl'],
        hash: json['chapter']['hash'],
        images: List<String>.from(json['chapter']['data']),
    );
  }

}

