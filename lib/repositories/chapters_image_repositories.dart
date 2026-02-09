import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manga_app/models/chapters_image_class.dart';

class ChapterImageRepository
{

  Future<ChapterImage> fetchChaptersImage({required String id }) async
  {

    final url = Uri.parse("https://api.mangadex.org/at-home/server/$id") ;
    final response = await http.get(url);
    final decoded = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception('Failed to load chapter images');
    }

    return ChapterImage.fromJson(decoded);
  }


}
