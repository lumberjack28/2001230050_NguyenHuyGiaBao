import '../common/file_store.dart';
import '../models/home_task.dart';

class HomeTaskFile {
  Future<List<HomeTask>> load() async {
    final rows = await FileStore.readList('home_tasks.json');
    return rows.map(HomeTask.fromJson).toList();
  }

  Future<void> save(List<HomeTask> tasks) => FileStore.saveList(
        'home_tasks.json',
        tasks.map((task) => task.toJson()).toList(),
      );
}
