
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/chapters_class.dart';
import '../repositories/chapters_repositories.dart';


final chaptersRepositoryProvider = Provider(
      (ref) => ChaptersRepository(),
);

final chaptersProvider =
FutureProvider.family<List<Chapter>, String>((ref, mangaId) {
  return ref.read(chaptersRepositoryProvider).fetchChapters(
    id: mangaId,
  );
});

final chaptersPagedProvider = StateNotifierProvider.family<ChaptersPagedNotifier, List<Chapter>, String>(
      (ref, mangaId) => ChaptersPagedNotifier(mangaId: mangaId),
);

class ChaptersPagedNotifier extends StateNotifier<List<Chapter>> {
  final String mangaId;
  int offset = 0;
  final int limit = 30;
  bool hasMore = true;
  bool isLoading = false;

  ChaptersPagedNotifier({required this.mangaId}) : super([]) {
    fetchNextBatch();
  }

  Future<void> fetchNextBatch() async {
    if (!hasMore || isLoading) return;

    isLoading = true;
    final repo = ChaptersRepository();
    final batch = await repo.fetchChapters(
      id: mangaId,
      limit: limit,
      offset: offset,
    );

    if (batch.isEmpty) {
      hasMore = false;
      isLoading = false;
      return;
    }

    final existingChapterNumbers = state.map((c) => c.chapter).toSet();

    final uniqueNewChapters = batch
        .where((chapter) => !existingChapterNumbers.contains(chapter.chapter))
        .toList();

    state = [...state, ...uniqueNewChapters];

    offset += limit; // Increment by limit, not batch.length
    isLoading = false;
  }
}