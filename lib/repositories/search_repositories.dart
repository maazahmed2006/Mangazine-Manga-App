import 'dart:convert';
import '../models/manga_class.dart';
import 'package:http/http.dart' as http;
class SearchRepository {

  Future<List<Manga>> searchManga(String query) async {
    final url = Uri.parse(
        'https://api.mangadex.org/manga?title=$query&includes[]=cover_art' ,
    );

    final response = await http.get(url);

    final decoded = jsonDecode(response.body);

    final List data = decoded['data'];

    final List<Manga> mangaList = [];

    for (var e in data) {
      mangaList.add(Manga.fromJson(e));
    }

    return mangaList;
  }
}
