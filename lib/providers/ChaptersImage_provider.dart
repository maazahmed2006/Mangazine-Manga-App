
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_app/repositories/chapters_image_repositories.dart';

import '../models/chapters_image_class.dart';

final chaptersImageProvider = FutureProvider.family<ChapterImage , String >((ref , ChapterId){
  return ChapterImageRepository().fetchChaptersImage(id: ChapterId);
});