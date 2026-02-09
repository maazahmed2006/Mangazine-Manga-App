import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:manga_app/repositories/search_repositories.dart';
import '../models/manga_class.dart';
import '../repositories/manga_repositories.dart';

final mangaRepositoryProvider = Provider<MangaRepository>((ref) {
  return MangaRepository();
});

final mangaListProvider = FutureProvider<List<Manga>>((ref) async {
  final repository = ref.read(mangaRepositoryProvider);


  return repository.fetchManga();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchMangaProvider =
FutureProvider.family<List<Manga>, String>((ref, query) async {
  final repo = SearchRepository();
  return repo.searchManga(query);
});

