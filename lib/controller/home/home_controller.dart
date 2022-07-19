import 'package:flutter/foundation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomeController extends GetxController{
    final OnAudioQuery audioQuery = OnAudioQuery();
    
    //  final controller = Get.put(Dbfunctions());
  @override
   onInit() {
    requestStorapermission();
   // controller.displaySongs();
    super.onInit();
  } 
   requestStorapermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await audioQuery.permissionsRequest();
          update();
      }
    
    }  
  }
}
