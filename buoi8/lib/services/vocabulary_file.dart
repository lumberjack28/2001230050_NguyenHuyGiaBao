import '../common/file_store.dart';
import '../models/vocabulary_word.dart';

class VocabularyFile {
  Future<List<VocabularyWord>> load() async {
    final rows = await FileStore.readList('vocabulary.json');
    return rows.map(VocabularyWord.fromJson).toList();
  }

  Future<void> save(List<VocabularyWord> words) => FileStore.saveList(
        'vocabulary.json',
        words.map((item) => item.toJson()).toList(),
      );
}
