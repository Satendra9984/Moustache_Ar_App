import 'package:hive/hive.dart';
import 'package:moustache_ar/models/HiveImageModel.dart';
import 'package:moustache_ar/utils/app_constants.dart';

class LocalStorageUtils {
  final Box<HiveImageModel> _myDataBox = Hive.box<HiveImageModel>(hiveMoustachedImageBox);

  Future<void> storeMyData(HiveImageModel myData) async {
    await _myDataBox.put(myData.id, myData);
  }

  List<HiveImageModel> retrieveAllMyData() {
    return _myDataBox.values.toList();
  }
}
