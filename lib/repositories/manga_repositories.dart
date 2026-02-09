import 'dart:convert';
import '../models/manga_class.dart';
import 'package:http/http.dart' as http;
class MangaRepository {

  Future<List<Manga>> fetchManga() async {
    final url = Uri.parse(
      'https://api.mangadex.org/manga?includes[]=cover_art',
    );

    final response = await http.get(url);

    final decoded = jsonDecode(response.body);

    final List data = decoded['data'];

    final List<Manga> mangaList = [];

    for (var e in data) {
      mangaList.add(Manga.fromJson(e)); // this line does is basically
      // manga.fromjson return krta hai manga object humei to then hum add krtei
      // mangaList mei.
    }

    return mangaList;
  }
}
