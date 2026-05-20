import 'package:hive_flutter/hive_flutter.dart';

class HiveDatasource {
  static const String boxName = "tasksBox";

  Future<void> saveTask(String title) async {
    var box = Hive.box(boxName);

    await box.add({
      "title": title,
      "createdAt": DateTime.now().toString(),
    });
  }
}