import 'package:get/get.dart';
import 'group_posting_logic.dart';

class GroupPostingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupPostingLogic>(() => GroupPostingLogic());
  }
}
