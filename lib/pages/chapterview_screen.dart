import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ChaptersImage_provider.dart';


class MangaViewerScreen extends ConsumerWidget {
  final String chapterId;
  final String chapterNo;
  final String chapterTitle;

  const MangaViewerScreen({
    super.key,
    required this.chapterId,
    required this.chapterNo,
    required this.chapterTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapterAsync = ref.watch(chaptersImageProvider(chapterId));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chapter $chapterNo'),
              Text(
                chapterTitle ,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextTheme.of(context).bodyMedium,
              ),
            ],
          ),
        ),
        body: chapterAsync.when(
          loading: () =>
          const Center(child: CircularProgressIndicator()),
          error: (error, _) =>
              Center(child: Text(error.toString())),
          data: (chapter) {
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: chapter.images.length,
              itemBuilder: (context, index) {
                final imageUrl =
                    '${chapter.baseUrl}/data/${chapter.hash}/${chapter.images[index]}';
      
                return SizedBox.expand(
                  child: InteractiveViewer(
                    minScale: 1,
                    maxScale: 4,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const SizedBox(); // NO per-image spinner
                      },
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
