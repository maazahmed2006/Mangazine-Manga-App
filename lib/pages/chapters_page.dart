import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_app/providers/favorites_provider.dart';
import '../providers/Chapters_provider.dart';
import 'chapterview_screen.dart';

class Chapters_Page extends StatelessWidget
{
  final mangaid;
  final image ;
  final String name;

  const Chapters_Page({
    required this.mangaid,
    required this.image,
    required this.name,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height ;
    final double width = MediaQuery.of(context).size.width ;
    return Scaffold(
      body:Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(1, -1.5),
            radius: 2.5,
            colors: [
              Color(0xFF9B30FF), // bright violet
              Color(0xFF1E0923), // deep purple
              Colors.black, // outer edges
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
      child: SafeArea(
          child: Column(
              children: [
                ChapterDetails(h1 : height , w1: width , coverImage : image , coverName: name),
                Chapters_Display(h2 : height , w2 : width , id: mangaid, coverURL : image),
              ],
      ),
      ),
      ),
    );
  }
}

class ChapterDetails extends ConsumerWidget
{
  final double h1;
  final double w1;
  final  coverImage;
  final String coverName;

  const ChapterDetails({
    required this.h1,
    required this.w1,
    required this.coverImage,
    required this.coverName,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(favoritesProvider) ;
    return SizedBox(
      height: h1 * 0.25,
      width: w1,
      child: Padding(
        padding: EdgeInsets.only( right: 20 , top: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
              // color: Colors.red,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15 , top: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                                 coverImage,
                                 fit: BoxFit.cover,
                                 height: h1* 0.2,
                                  width: 100,
                            ),
                          ),
                          const SizedBox(width: 10,),
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                    coverName ,
                                   style:  Theme.of(context).textTheme.headlineMedium, maxLines: 3,
                                   overflow: TextOverflow.ellipsis,
                                 ),
                                 const SizedBox(height: 10,),
                                 Text(
                                   "Author:" , style:  Theme.of(context).textTheme.bodyLarge, maxLines: 1,),

                                 Text(
                                   "Yakoshi Satoru:" , style:  Theme.of(context).textTheme.bodySmall, maxLines: 1,),


                               ],
                             ),
                           ),

                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}


class Chapters_Display extends ConsumerStatefulWidget {
  final double h2;
  final double w2;
  final String id;
  final String coverURL;

  const Chapters_Display({
    required this.h2,
    required this.w2,
    required this.id,
    required this.coverURL,
    super.key,
  });

  @override
  ConsumerState<Chapters_Display> createState() => _Chapters_DisplayState();
}

class _Chapters_DisplayState extends ConsumerState<Chapters_Display> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Add scroll listener to fetch next batch
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        // Near bottom → fetch next batch
        ref.read(chaptersPagedProvider(widget.id).notifier).fetchNextBatch();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chapters = ref.watch(chaptersPagedProvider(widget.id));
    final notifier = ref.read(chaptersPagedProvider(widget.id).notifier);

    return SizedBox(
      height: widget.h2 * 0.65,
      width: widget.w2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Chapters",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: chapters.length + (notifier.hasMore ? 1 : 0),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == chapters.length) {
                        // Loading indicator for next batch
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final chapter = chapters[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 5),
                        child: Container(
                          height: 120,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  widget.coverURL,
                                  width: 70,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Chapter No: ${chapter.chapter}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(color: Colors.white70),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      chapter.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                      Theme.of(context).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: BackdropFilter(
                                  filter:
                                  ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.play_arrow),
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => MangaViewerScreen(
                                              chapterId: chapter.id,
                                              chapterNo: chapter.chapter,
                                              chapterTitle: chapter.title,// pass your real chapter id here
                                            ),
                                          ),
                                        );
                                      },

                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

