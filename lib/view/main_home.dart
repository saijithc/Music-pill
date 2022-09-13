import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music/controller/bottom/bottom_controllers.dart';
import 'package:music/controller/main/main_home_controller.dart';
import 'package:music/controller/nowplaying/nowplaying_controller.dart';
import 'package:music/view/home.dart';
import 'package:music/view/library.dart';
import 'package:music/view/miniplayer.dart';
import 'package:music/view/now_playing.dart';
import 'package:music/view/search.dart';
import 'package:we_slide/we_slide.dart';

class Mainhome extends StatelessWidget {
  Mainhome({Key? key}) : super(key: key);
  final controllerForBottom = Get.put(BottomController());
  final maincontroller = Get.put(MainHomeController());
  final playercontroller = Get.put(NowPlayingController());
  final PageController controller = PageController();
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      body: WeSlide(
        hidePanelHeader: true,
        panelMaxSize: MediaQuery.of(context).size.height,
        panelMinSize: h * 0.18,
        blur: true,
        panel: GetBuilder<NowPlayingController>(
          init: NowPlayingController(),
          builder: (_) {
            return playercontroller.player.currentIndex != null ||
                    playercontroller.player.playing
                ? NowPlaying()
                : const SizedBox();
          },
        ),
        panelHeader: GetBuilder<NowPlayingController>(
            init: NowPlayingController(),
            builder: (context) {
              return MiniPlayer();
            }),
        body: PageView(
          children: <Widget>[
            Home(),
            Search(),
            Library(),
          ],
          controller: controller,
          onPageChanged: (page) {
            controllerForBottom.changeIndex(page);
          },
        ),
        footerHeight: h * .18,
        footer: Padding(
          padding: const EdgeInsets.only(top: 60),
          child: Obx(() => BottomNavigationBar(
                unselectedItemColor: const Color.fromARGB(153, 156, 151, 151),
                currentIndex: controllerForBottom.selectedIndex.value,
                onTap: _onItemTapped,
                backgroundColor: Colors.black,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      activeIcon: CircleAvatar(
                        radius: MediaQuery.of(context).size.aspectRatio * 40,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 1,
                          width: MediaQuery.of(context).size.width * 1,
                          child: const Icon(
                            Icons.home,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage('assets/bottom.png'),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                      icon: const Icon(Icons.home),
                      label: ''),
                  BottomNavigationBarItem(
                      activeIcon: CircleAvatar(
                        radius: MediaQuery.of(context).size.aspectRatio * 60,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 1,
                          width: MediaQuery.of(context).size.width * 1,
                          child: const Icon(
                            Icons.search,
                            size: 50,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage('assets/bottom.png'),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      icon: const Icon(Icons.search),
                      label: ''),
                  BottomNavigationBarItem(
                      activeIcon: CircleAvatar(
                        radius: MediaQuery.of(context).size.aspectRatio * 40,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 1,
                          width: MediaQuery.of(context).size.width * 1,
                          child: const Icon(
                            Icons.music_note_outlined,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                              image: const DecorationImage(
                                  image: AssetImage('assets/bottom.png'),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(28)),
                        ),
                      ),
                      icon: const Icon(
                        Icons.music_note_outlined,
                      ),
                      label: ''),
                ],
              )),
        ),
      ),
    );
  }

  _onItemTapped(int index) {
    controllerForBottom.changeIndex(index);
    controller.jumpToPage(index);
  }
}
