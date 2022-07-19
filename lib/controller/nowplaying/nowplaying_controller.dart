import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../pages/now_playing.dart';

class NowPlayingController extends GetxController {
  final AudioPlayer player = AudioPlayer();
  List<SongModel>? playingdetails = [];
  @override
  void onInit() {
    playingdetails!.clear();
    for (var i = 0; i < playingdetails!.length; i++) {
      NowPlaying.songlists.add(playingdetails![i]);
      super.onInit();
      player.currentIndexStream.listen((index) {
        if (index != null) {
          update();
        }
      });
    }
    player.currentIndexStream.listen((index) {
      if (index != null) {
        update();
      }
    });
  }
}
