import 'package:flutter/material.dart';
import 'package:music/functions/functions.dart';
import 'package:music/functions/model/data_model.dart';
import 'package:music/pages/liked.dart';
import 'package:music/pages/playlist.dart';

class Library extends StatelessWidget {
  Library({Key? key}) : super(key: key);
  final folderNames = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Dbfunctions.getAllplaylist();
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
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AlertDialog(
                          backgroundColor:
                              const Color.fromARGB(255, 213, 245, 214),
                          content: const Center(
                            child: Text(
                              'Give your playlist a name',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 85, 85, 85),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          actions: [
                            TextField(
                              controller: folderNames,
                              decoration: const InputDecoration(
                                hintText: 'Enter the name',
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    )),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (folderNames.text.isNotEmpty) {
                                      final values = PlaylistsModel(
                                        foldername: folderNames.text,playlistsongs: []
                                      );
                                      Dbfunctions.addtoplaylist(values);
                                     
                                      Navigator.of(context).pop();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('PlayList Created'),
                                        margin: EdgeInsets.all(30),
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text('A name is required'),
                                        margin: EdgeInsets.all(30),
                                        behavior: SnackBarBehavior.floating,
                                      ));
                                    }
                                  },
                                  child: const Text(
                                    'Create',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    );
                  });
            },
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.11,
          ),
          ListTile(
            leading: Container(
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width * 0.18,
              height: MediaQuery.of(context).size.height * 0.19,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/fav.png'), fit: BoxFit.cover),
              ),
            ),
            title: const Text(
              'Liked Songs',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const LikedSongs()));
            },
          ),

          //<<...............playlist folders creation.........>>
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Dbfunctions.playlist,
              builder: (BuildContext context, List<PlaylistsModel> playlis,
                  Widget? child) {
                if (playlis.isEmpty) {
                  return const Text('');
                }
                return ListView.builder(
                  itemCount: playlis.length,
                  itemBuilder: (ctx, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => PlayList(folderindex:  index,
                                    name: playlis[index].foldername,
                                  )));
                        },
                        leading: Container(
                          width: MediaQuery.of(context).size.width * 0.18,
                          height: MediaQuery.of(context).size.height * 0.19,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/logo.jpg'),
                                fit: BoxFit.cover),
                          ),
                        ),
                        title: Text(
                          // Dbfunctions.playlist.value[index],
                          playlis[index].foldername!,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text(
                          'Playlist',
                          style: TextStyle(color: Colors.white70),
                        ),
                        trailing: IconButton( onPressed: () { showDialog( context: context,builder: (ctx) {
                          return Column( mainAxisAlignment: MainAxisAlignment.center,children: [ AlertDialog( backgroundColor: Colors.transparent,
                             content: Center(child: Text( 'Do you wanna delete ${Dbfunctions.playlist.value[index]} playlist?', style: const TextStyle( color: Colors.white), ), ),
                                 actions: [ Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                     children: [ ElevatedButton( onPressed: () { Navigator.of(context) .pop(); },
                                         child: const Text('Cancel', style: TextStyle(color: Colors.white), )),
                                            ElevatedButton( onPressed: () async { await Dbfunctions.deleteplaylist(index);Navigator.of(context).pop();
                                                ScaffoldMessenger.of( context).showSnackBar( const SnackBar(content: Text('Playlist Deleted'), margin: EdgeInsets.all(30),
                                                   behavior: SnackBarBehavior.floating, ));
                                                  },
                                                  child: const Text( 'Delete', style: TextStyle( color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.white70,
                            )),
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}


