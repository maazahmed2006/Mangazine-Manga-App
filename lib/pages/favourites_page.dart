import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_app/pages/homepage.dart';
import 'package:manga_app/providers/favorites_provider.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPadding = MediaQuery.of(context).padding.top;
    final appBarHeight = 100.0;
    final bottomNavHeight = 100.0; // for your bottom nav
    final screenHeight = MediaQuery.of(context).size.height;
    final listHeight = screenHeight - topPadding - appBarHeight - bottomNavHeight - 16;
    final favs = ref.watch(favoritesProvider) ;

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
              Colors.black,
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 HEADER (acts like AppBar)
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "FAVORITES",
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text(
                            "Your Favorite Manga's Dump",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),

                      // Avatar / Actions
                      const CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    "Your List",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),

                SizedBox(
                  height: listHeight,
                  child: ListView.builder(
                    itemCount: favs.length,
                    itemBuilder: (context, index) {
                      final fav = favs[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.15),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Cover Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      fav.coverURl,
                                      width: 70,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // Text Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            children: [
                                              const TextSpan(
                                                text: "Name: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                              TextSpan(text: fav.title),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        RichText(
                                          text: const TextSpan(
                                            style: TextStyle(
                                              color: Colors.white70,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: "Author: ",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                              TextSpan(text: "Isayama"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Action Button
                                  Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Center(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // frosted blur
                                                child: AlertDialog(
                                                  backgroundColor: Colors.white.withOpacity(0.1), // semi-transparent
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  title: Text('Confirm Delete', style: TextStyle(color: Colors.white)),
                                                  content: Text(
                                                    'Are you sure you want to delete this manga from your list?',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      child: Text('No', style: TextStyle(color: Colors.white)),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        ref.read(favoritesProvider.notifier).removeManga(fav);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Yes', style: TextStyle(color: Colors.white)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height:  20,),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: favNavBar(context, ref),
    );
  }
}

Widget favNavBar(BuildContext context, WidgetRef ref) {
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
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomeScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      // Slide from right to left
                      const begin = Offset(0.0, 1.0);
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
              icon: const Icon(
                Icons.home,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () {
              },
              icon: const Icon(Icons.favorite, size: 30 , color:  Colors.purple),
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

