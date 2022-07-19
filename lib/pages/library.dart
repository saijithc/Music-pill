import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/functions/functions.dart';
import 'package:music/functions/model/data_model.dart';
import 'package:music/pages/liked.dart';
import 'package:music/pages/playlist.dart';

class Library extends GetView {
  Library({Key? key}) : super(key: key);
  final folderNames = TextEditingController();
  @override
  final controller = Get.put(Dbfunctions());
  @override
  Widget build(BuildContext context) {
    controller.getAllplaylist();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Your Library',
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline_outlined,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Get.defaultDialog(title: "Give your playlist a name",middleText: "",cancelTextColor: Colors.black,confirmTextColor: Colors.white,
              buttonColor: const Color.fromARGB(255, 172, 252, 174),
              content: Column(children: [TextField(controller: folderNames,decoration:const InputDecoration( hintText: 'Enter the name') ,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,)]),
              onCancel: (){Get.back();},onConfirm: (){if (folderNames.text.isNotEmpty) {
               final values = PlaylistsModel(foldername: folderNames.text,playlistsongs: [] );
                controller.addtoplaylist(values);
                  Get.back();
                  Get.snackbar("PlayList Created", "",snackPosition: SnackPosition.BOTTOM,backgroundColor: const Color.fromARGB(255, 193, 253, 195),
                    colorText: const Color.fromARGB(255, 24, 23, 23),margin: const EdgeInsets.all(35));
              }else{
                 Get.snackbar("   A name is required ", "",colorText: Colors.white,snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red,margin: const EdgeInsets.all(35));             
              }});
              // showDialog(
              //     context: context,
              //     builder: (ctx) {
              //       return Column(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           AlertDialog(
              //             backgroundColor:
              //                 const Color.fromARGB(255, 213, 245, 214),
              //             content: const Center(
              //               child: Text(
              //                 'Give your playlist a name',
              //                 style: TextStyle(
              //                     color: Color.fromARGB(255, 85, 85, 85),
              //                     fontWeight: FontWeight.w500),
              //               ),
              //             ),
              //             actions: [
              //               TextField( controller: folderNames,
              //                 decoration: const InputDecoration( hintText: 'Enter the name')
              //               ),
              //               Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: [
              //                   ElevatedButton( onPressed: () { Get.back();},
              //                       child: const Text('Cancel', style: TextStyle(color: Colors.white))
              //                       ),
              //                   ElevatedButton(onPressed: () async {
              //                       if (folderNames.text.isNotEmpty) {
              //                         final values = PlaylistsModel(foldername: folderNames.text,playlistsongs: [] );
              //                         controller.addtoplaylist(values);
              //                         Get.back();
              //                         Get.snackbar("PlayList Created", "",snackPosition: SnackPosition.BOTTOM,backgroundColor: const Color.fromARGB(255, 193, 253, 195),
              //                         colorText: const Color.fromARGB(255, 24, 23, 23),margin: const EdgeInsets.all(35));
              //                       } else {
              //                         Get.snackbar("   A name is required ", "",colorText: Colors.white,snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.red,margin: const EdgeInsets.all(35));                                      
              //                       }
              //                     },
              //                     child: const Text('Create',style: TextStyle(color: Colors.white)
              //                     ),
              //                   )
              //                 ],
              //               )
              //             ],
              //           ),
              //         ],
              //       );
              //     });
            },
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.11),
          ListTile( leading: Container( child: const Icon(Icons.favorite,color: Colors.white),
              width: MediaQuery.of(context).size.width * 0.18, height: MediaQuery.of(context).size.height * 0.19,
              decoration: const BoxDecoration(image: DecorationImage( image: AssetImage('assets/fav.png'), fit: BoxFit.cover)
              ),
            ),
            title: const Text( 'Liked Songs', style:TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
            onTap: () { Get.to( LikedSongs()); },
          ),

          //<<...............playlist folders creation.........>>
          Expanded(
            child:
            //  ValueListenableBuilder(
            //   valueListenable: Dbfunctions.playlist,
            //   builder: (BuildContext context, List<PlaylistsModel> playlis,Widget? child) {
              GetBuilder<Dbfunctions>(init: Dbfunctions(),
                builder: (controller) {
              if (controller.playlist.isEmpty) {
                  return const Text('');
                }
                return ListView.builder(
                  itemCount: controller.playlist.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      child: ListTile(
                        onTap: () { 
                         Get.to(PlayList(name: controller.playlist[index].foldername, folderindex: index));
                        },
                        leading: Container(
                          width: MediaQuery.of(context).size.width * 0.18,
                          height: MediaQuery.of(context).size.height * 0.19,
                          decoration: const BoxDecoration(image: DecorationImage( image: AssetImage('assets/logo.jpg'),fit: BoxFit.cover)),
                        ),
                        title: Text( controller.playlist[index].foldername!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        subtitle: const Text('Playlist',style: TextStyle(color: Colors.white70) ),
                        trailing: IconButton( onPressed: () { 
                          Get.defaultDialog(backgroundColor:const Color.fromARGB(255, 125, 207, 162),middleText: "",
                          buttonColor: Colors.black,cancelTextColor: Colors.white,confirmTextColor: Colors.white,
                            title: "Do you want to delete ${controller.playlist[index].foldername} playlist?".toUpperCase(),onCancel: (){Get.back();},
                          onConfirm: (){controller.deleteplaylist(index);Get.back();
                          Get.snackbar("Playlist Deleted", "",snackPosition: SnackPosition.BOTTOM,backgroundColor: const Color.fromARGB(255, 193, 253, 195),
                          margin: const EdgeInsets.all(35));});
                          // showDialog( context: context,builder: (ctx) {
                          // return Column( mainAxisAlignment: MainAxisAlignment.center,children: [ AlertDialog( backgroundColor: Colors.transparent,
                          //    content: Center(child: Text( 'Do you wanna delete ${Dbfunctions.playlist.value[index].foldername} playlist?', style: const TextStyle( color: Colors.white), ), ),
                          //        actions: [ Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //            children: [ ElevatedButton( onPressed: () { Navigator.of(context) .pop(); },
                          //                child: const Text('Cancel', style: TextStyle(color: Colors.white), )),
                          //                   ElevatedButton( onPressed: () async { await Dbfunctions.deleteplaylist(index);Navigator.of(context).pop();
                          //                       ScaffoldMessenger.of( context).showSnackBar( const SnackBar(content: Text('Playlist Deleted'), margin: EdgeInsets.all(30),
                          //                          behavior: SnackBarBehavior.floating, ));
                          //                         },
                          //                         child: const Text( 'Delete', style: TextStyle( color: Colors.white),
                          //                         ),
                          //                       )
                          //                     ],
                          //                   )
                          //                 ],
                          //               ),
                          //             ],
                          //           );
                          //         });
                            },
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white70,
                            )),
                      ),
                    );
                  },
                );
                }
            ),
          )
        ],
      ),
    );
  }
}


