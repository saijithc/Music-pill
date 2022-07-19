import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../functions/functions.dart';
class FavCheck extends GetView {
   FavCheck({Key? key,this. id}) : super(key: key);
  final dynamic id;
  @override
  final controller = Get.put(Dbfunctions());
  @override
  Widget build(BuildContext context) {
    final finalIndex = controller.favsongids.indexWhere((element) => element == id);
    final indexCheck = controller.favsongids.contains(id);
    if ( indexCheck == true) {
      return IconButton(
          onPressed: () async {                   
            await controller.deletefav(finalIndex);        
            Get.snackbar("Removed from Liked Songs", "",snackPosition: SnackPosition.BOTTOM,backgroundColor: const Color.fromARGB(255, 172, 252, 174),
          margin: const EdgeInsets.all(35),duration:const Duration(seconds: 1));        
          },
          icon: const Icon(
            Icons.favorite,
            color: Colors.green,
          ));
    }
    return IconButton(
        onPressed: () async {        
          await controller.addsong(id);           
          Get.snackbar("added to Liked Songs", "",snackPosition: SnackPosition.BOTTOM,backgroundColor: const Color.fromARGB(255, 172, 252, 174),
          margin: const EdgeInsets.all(35),duration:const Duration(seconds: 1));         
        },
        icon: const Icon(
          Icons.favorite,
          color: Colors.white60,
        ));
  }
}
