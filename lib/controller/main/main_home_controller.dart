import 'package:get/get.dart';
import '../nowplaying/nowplaying_controller.dart';

class MainHomeController extends GetxController{
final playercontroller = Get.put(NowPlayingController());
  @override
  void onInit() {
 playercontroller. player.currentIndexStream.listen((event) {if(event!=null){update();} });
    super.onInit();
  }
}