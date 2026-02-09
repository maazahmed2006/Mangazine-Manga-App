class Chapter {
  final String id;
  final String title;
  final String chapter;
  final String volume;
  final String? externalUrl; // Add this
  final int pages; // Add this

  Chapter({
    required this.id,
    required this.title,
    required this.chapter,
    required this.volume,
    this.externalUrl,
    required this.pages,
  });

  bool get isExternal => externalUrl != null && externalUrl!.isNotEmpty;
  bool get isReadableOnMangaDex => pages > 0;

  factory Chapter.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'] ?? {};

    return Chapter(
      id: json['id'] ?? '',
      title: (attributes['title'] as String?)?.isNotEmpty == true
          ? attributes['title'] as String
          : '',
      chapter: (attributes['chapter'] as String?)?.isNotEmpty == true
          ? attributes['chapter'] as String
          : '',
      volume: (attributes['volume'] as String?)?.isNotEmpty == true
          ? attributes['volume'] as String
          : '-',
      externalUrl: attributes['externalUrl'] as String?,
      pages: attributes['pages'] ?? 0,
    );
  }
}