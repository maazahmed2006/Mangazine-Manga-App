import 'package:flutter_riverpod/legacy.dart';
import 'package:manga_app/Local/hive_service.dart';
import '../models/manga_class.dart';

class FavoritesNotifier extends StateNotifier<List<Manga>> {
  final HiveService hiveService ;
  FavoritesNotifier(this.hiveService) : super([]){
    loadFavs();
  }

  void loadFavs()
  {
    state = hiveService.send_data();
  }

  void addmanga(Manga manga) {
    bool exist = false;
    for (var m in state) {
      if (m.id == manga.id) {
        exist = true;
        break;
      }
    }
    if (exist != true) {
      hiveService.add_data(manga);
      state = [...state, manga];
    }
  }

  void removeManga(Manga manga) {
    List<Manga> newList = [];
    for (var m in state) {
      if (m.id != manga.id) {
        newList.add(m);
      }
    }
    state = newList;
    hiveService.delete_data(manga.id);
  }
}

  // this the bridge provider between the consumer widget and the fav notifier class
  final favoritesProvider = StateNotifierProvider<FavoritesNotifier , List<Manga> > ((ref){
    return FavoritesNotifier(HiveService());
  });
