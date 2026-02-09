import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_app/pages/chapters_page.dart';
import 'package:riverpod/src/framework.dart';
import '../models/manga_class.dart';
import '../providers/favorites_provider.dart';
import '../providers/manga_details_provider.dart';
import 'favourites_page.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override

  Widget build(BuildContext context , WidgetRef ref) {
    final mangaAsync = ref.watch(mangaListProvider);
    final query = ref.watch(searchQueryProvider); // current search text
    final searchResultsAsync = ref.watch(searchMangaProvider(query)); // get results from API

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
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
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "MANGAZINE" ,
                          style: Theme.of(context).textTheme.headlineLarge,

                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Your Favourite Mangas Hub",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

               FrostedSearchBar(),

              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (query.isEmpty)
                        mangaAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Text(e.toString()),
                          data: (mangas) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MangaCard(title: "Suggested", mangas: mangas),
                              ],
                            );
                          },
                        )
                      else
                        searchResultsAsync.when(
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Text("Error: $e"),
                          data: (mangas) {
                            if (mangas.isEmpty) {
                              return const Text(
                                "No results found",
                                style: TextStyle(color: Colors.white),
                              );
                            }
                            return MangaCard(title: "Search Results", mangas: mangas);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: customNavBar(context, ref),
    );
  }
}
Widget customNavBar(BuildContext context, WidgetRef ref) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                // Home button action
              },
              icon: const Icon(
                Icons.home,
                size: 30,
                color: Colors.purple,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                    const FavoritesPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      // Slide from right to left
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      final tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      final offsetAnimation = animation.drive(tween);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              icon: const Icon(Icons.favorite, size: 30),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const FavoritesPage(), // replace with target screen
                  ),
                );
              },
              icon: const Icon(
                Icons.download,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



// Frosted iOS-style search bar
class FrostedSearchBar extends ConsumerStatefulWidget {
  const FrostedSearchBar({super.key});

  @override
  ConsumerState<FrostedSearchBar> createState() => _FrostedSearchBarState();

}

class _FrostedSearchBarState extends ConsumerState<FrostedSearchBar> {
  final TextEditingController searchController = TextEditingController() ;
  @override
  Widget build(BuildContext context ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              children:  [
                Icon(Icons.search, color: Colors.white70),
                SizedBox(width: 10),
                Expanded(
                    child: TextField(
                    controller: searchController,
                    onChanged: (value)
                      {
                        ref.read(searchQueryProvider.notifier).state = value;
                      },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search Manga...",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
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

// MangaCard Widget
class MangaCard extends ConsumerWidget {
  final String title;
  final List<Manga> mangas;

  const MangaCard({
    super.key,
    required this.title,
    required this.mangas,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Vertical grid of mangas
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemCount: mangas.length,
          itemBuilder: (context, index) {
            final manga = mangas[index];

            return GestureDetector(
              onTap: () {
                // Frosted glass AlertDialog
                showDialog(
                  context: context,
                  builder: (context) => Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: AlertDialog(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Manga image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      manga.coverURl,
                                      width: 120,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Right side details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Title: ${manga.title}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          "Author: Dummy Author",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Description",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                manga.description,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      ref.read(favoritesProvider.notifier).addmanga(manga);
                                    },
                                    icon: const Icon(Icons.favorite, color: Colors.redAccent),
                                    label: const Text(
                                      "Favorite",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white24,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) =>
                                           Chapters_Page(
                                               mangaid: manga.id,
                                               image : manga.coverURl,
                                               name : manga.title,
                                           ),
                                          transitionsBuilder:
                                              (context, animation, secondaryAnimation, child) {
                                            // Slide from right to left
                                            const begin = Offset(1.0, 0.0);
                                            const end = Offset.zero;
                                            const curve = Curves.ease;

                                            final tween =
                                            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                            final offsetAnimation = animation.drive(tween);

                                            return SlideTransition(
                                              position: offsetAnimation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.play_arrow, color: Colors.white),
                                    label: const Text(
                                      "Watch",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white24,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      manga.coverURl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;

                        return Container(
                          height: 150,
                          color: Colors.white10,
                          child: const LinearProgressIndicator(
                            color: Colors.purple,
                            backgroundColor: Colors.transparent,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                    ),
                  const SizedBox(height: 5),
                  Text(
                    manga.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}