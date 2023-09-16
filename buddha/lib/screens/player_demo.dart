import 'dart:developer';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:buddha/screens/list.dart';
import 'package:buddha/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PlayerDemo extends StatefulWidget {
  const PlayerDemo({super.key});

  @override
  State<PlayerDemo> createState() => _PlayerDemoState();
}

class _PlayerDemoState extends State<PlayerDemo> {
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  bool isPlay1 = false;
  bool isPlay2 = false;
  double hgt = 0;
  bool check = false;
  @override
  void initState() {
    super.initState();
    //getAudios();
  }

  getAudios() {
    List<Audio> audios = [];
    for (int i = 0; i < byteSong.length; i++) {
      audios.add(Audio('assets/bytes/${byteSong[i]}'));
    }

    audioPlayer.open(
      Playlist(audios: audios),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: byteSongName.length,
            itemBuilder: (context, index) {
              double value = 0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text(byteSongName[index]),
                  height(context),
                  slider(context, index, value, check),
                ],
              );
            },
          ),
        ),

        /*  child: Column(
          children: [
            Row(
              children: [
                const Text("Light Wind"),
                InkWell(
                    onTap: () async {
                      AssetsAudioPlayer.newPlayer()
                          .open(Audio('assets/bytes/thunder.mp3'));
                    },
                    child: Icon(isPlay1 ? Icons.pause : Icons.play_arrow))
              ],
            ),
            Row(
              children: [
                const Text("Chimes"),
                InkWell(
                    onTap: () async {
                      AssetsAudioPlayer.newPlayer().open(
                          Audio('assets/bytes/chimes.mp3'),
                          showNotification: true,
                          loopMode: LoopMode.single);
                    },
                    child: Icon(isPlay2 ? Icons.pause : Icons.play_arrow))
              ],
            )
          ],
        ),*/
      ),
    );
  }

  int count = 0;

  Text text(String text) => Text(text, style: const TextStyle(fontSize: 17));

  SizedBox height(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * 0.02);

  Row slider(BuildContext context, int index, double sliderValue, bool chk) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.height * 0.03,
          child: StatefulBuilder(
            builder: (BuildContext context,
                void Function(void Function()) setState) {
              return SliderTheme(
                data: SliderThemeData(
                  overlayShape: SliderComponentShape.noThumb,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 10),
                ),
                child: Slider(
                  min: 0,
                  max: 1,
                  activeColor: blue,
                  inactiveColor: grey400,
                  onChanged: (double value) {
                    setState(() {
                      log(value.toString());
                      sliderValue = value;

                      if (value == 0) {
                        AssetsAudioPlayer.newPlayer().stop();
                      }
                    });
                  },
                  value: sliderValue,
                ),
              );
            },
          ),
        ),
        StatefulBuilder(
          builder: (context, setState) {
            return InkWell(
              onTap: () {
                if (chk == false) {
                  if (count < 3) {
                    setState(() {
                      chk = true;
                      count += 1;
                    });
                    AssetsAudioPlayer.newPlayer().open(
                        Audio('assets/bytes/${byteSong[index]}'),
                        showNotification: true,
                        loopMode: LoopMode.single);

                    // audioPlayer.playlistPlayAtIndex(index);
                  } else {
                    Fluttertoast.showToast(
                        msg: "You can select only 3 songs",
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: black,
                        textColor: white);
                  }
                } else {
                  setState(
                    () {
                      chk = false;
                      count -= 1;
                    },
                  );
                }

                print("Count : $count");
                print('assets/bytes/${byteSong[index]}');
              },
              child: Icon(chk ? Icons.close : Icons.check),
            );
          },
        )

        //SongPlay(false, byteSong[index], index)
      ],
    );
  }
}

/*

*/