
import 'package:flutter/cupertino.dart';

class Manga
{
  final String id;
  final String title;
  final List<String> altTitles;
  final String description;
  final bool hasEnglishTranslation;
  final String coverURl;
  // final String author;


  Manga({
    required this.id,
    required this.title,
    required this.altTitles,
    required this.description,
    required this.hasEnglishTranslation,
    required this.coverURl,
  });

  factory Manga.fromJson(Map<String , dynamic> json)
  {
      final attributes = json['attributes'];
      final titleMap = attributes['title'];
      final title = titleMap['en'] ?? titleMap.values.first ;
      final value = attributes['altTitles'] ;
      final altTitles = (attributes['altTitles'] as List)
          .map((e) => e.values.first.toString())
          .toList();

      final descMap = attributes['description'] ?? {};
      final description =
          descMap['en'] ?? (descMap.isNotEmpty ? descMap.values.first : '');

      final languages =
      List<String>.from(attributes['availableTranslatedLanguages']);
      final hasEnglishTranslation = languages.contains('en');

      String coverUrl = '';

      final relationships = json['relationships'] as List;

      for (final rel in relationships) {
        if (rel['type'] == 'cover_art' && rel['attributes'] != null) {
          final fileName = rel['attributes']['fileName'];
          coverUrl =
          'https://uploads.mangadex.org/covers/${json['id']}/$fileName';
          break;
        }
      }

      return Manga(
        id: json['id'],
        title: title,
        altTitles: altTitles,
        description: description,
        hasEnglishTranslation: hasEnglishTranslation,
        coverURl: coverUrl
      );

  }
  // this returns the hive object basically we porvided the map and gives
  // the returned Manga class object that is than used by the favorites provider
  factory Manga.fromHive(Map<String, dynamic> json) {
    return Manga(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      altTitles: List<String>.from(json['alternateTitle'] ?? []),
      description: json['description'] ?? '',
      hasEnglishTranslation: json['englishTranslation'] ?? false,
      coverURl: json['coverURl'] ?? '',
    );
  }

}