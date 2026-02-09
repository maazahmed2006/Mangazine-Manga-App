import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manga_app/models/chapters_class.dart';

class ChaptersRepository {
  Future<List<Chapter>> fetchChapters({
    required String id,
    int limit = 10,
    int offset = 0,
  }) async {
    final url = Uri.parse(
      'https://api.mangadex.org/chapter?manga=$id&translatedLanguage[]=en&order[chapter]=asc&limit=$limit&offset=$offset',
    );

    final response = await http.get(url);
    final decoded = jsonDecode(response.body);
    final List data = decoded['data'];
    final List<Chapter> chapterList = [];

    final Set<String> seen = {}; // track unique chapters

    for (final item in data) {
      final chapter = Chapter.fromJson(item);

      if (chapter.id.isEmpty) continue;

      final key = '${chapter.volume ?? ''}-${chapter.chapter ?? ''}';

      if (!seen.contains(key)) {
        chapterList.add(chapter);
        seen.add(key); // mark as seen
      }
    }

    return chapterList;
  }
}