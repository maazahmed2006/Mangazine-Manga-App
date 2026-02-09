
import 'package:hive_flutter/adapters.dart';
import '../models/manga_class.dart';
class HiveService {

  static const favbox = 'favorites' ;
  final box = Hive.box(favbox);

  void add_data(Manga mangaData)
  {
    box.put(
        mangaData.id ,
        {
          'id' : mangaData.id,
          'title' : mangaData.title ,
          'description' : mangaData.description,
          'coverURl' : mangaData.coverURl ,
          'alternateTitle' : mangaData.altTitles,
          'englishTranslation'  : mangaData.hasEnglishTranslation ,
        }
    );
  }

  void delete_data(String id)
  {
    box.delete(id);
  }

  List<Manga> send_data() {
    List<Manga> results = [];
    for (var item in box.values) {
      final data = Map<String, dynamic>.from(item);
      results.add(Manga.fromHive(data));
    }
    return results;
  }

  bool isFavorite(String id) {
    return box.containsKey(id);
  }


}
