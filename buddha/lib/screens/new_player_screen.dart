// ignore_for_file: must_be_immutable

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:buddha/screens/player_demo.dart';
import 'package:buddha/screens/playerscreen.dart';
import 'package:buddha/utils/colors.dart';
import 'package:buddha/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

class NewPlayerScreen extends StatefulWidget {
  List<Audio> audios = [];
  AssetsAudioPlayer player;
  int index;
  String image;
  NewPlayerScreen(this.audios, this.player, this.index, this.image,
      {super.key});

  @override
  State<NewPlayerScreen> createState() => _NewPlayerScreenState();
}

class _NewPlayerScreenState extends State<NewPlayerScreen> {
  double _setVolumeValue = 0;

  @override
  void initState() {
    super.initState();
    VolumeController().listener((volume) {});
    openPlayer();
    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
  }

  void openPlayer() async {
    print("METHOD CALL");

    await widget.player.open(
        Playlist(audios: widget.audios, startIndex: widget.index),
        showNotification: true,
        notificationSettings: const NotificationSettings(),
        autoStart: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ClipPath(
            clipper: CurveClipper(),
            child: Container(
              color: Colors.blue[50],
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  ClipPath(
                    clipper: CurveClipper(),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.56,
                      color: white,
                      child: SafeArea(
                        child: Column(
                          children: [
                            back(context),
                            appbar(),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            image()
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //addNotification(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          //musicAdd(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          mucisProgress(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          controllButtons(context),
        ],
      ),
    );
  }

  SizedBox musicAdd(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.07,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icons('assets/images/music.png', 25.00, 30.00, () {
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (context) => AddMixSong(_setVolumeValue, '')));

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PlayerDemo()));
          }),
          icons('assets/images/alarm.png', 25.00, 30.00, () {})
        ],
      ),
    );
  }

  SizedBox addNotification(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: iconBg,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: transparent,
                      backgroundImage:
                          const AssetImage('assets/images/notify.png'),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      displayText(
                          text: "Join the movement",
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                      displayText(
                          text: "make the world a better place", color: grey400)
                    ],
                  )
                ],
              ))
        ],
      ),
    );
  }

  Widget image() {
    return StreamBuilder<Playing?>(
        stream: widget.player.current,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final audio =
                find(widget.audios, snapshot.data!.audio.assetAudioPath);
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              //  color: Colors.amber,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Image.asset(
                audio.metas.image!.path.toString(),
                fit: BoxFit.contain,
              ),
            );
          }
          return const SizedBox.shrink();
        });
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  Widget appbar() {
    return StreamBuilder<Playing?>(
        stream: widget.player.current,
        builder: (context, playing) {
          if (playing.data != null) {
            final audio =
                find(widget.audios, playing.data!.audio.assetAudioPath);
            return AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: transparent,
              title: displayText(
                text: audio.metas.title!,
              ),
              titleTextStyle: TextStyle(
                  color: black, fontSize: 28, fontFamily: 'Meditation'),
            );
          }
          return const SizedBox.shrink();
        });
  }

  Widget back(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.05,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(Icons.arrow_back_ios, color: black),
            displayText(text: "Back", fontSize: 15)
          ],
        ),
      ),
    );
  }

  Widget icons(String image, double radius, double size, VoidCallback ontap) {
    return InkWell(
      onTap: ontap,
      child: CircleAvatar(
        backgroundColor: white,
        radius: radius,
        child: Image.asset(image,
            height: MediaQuery.of(context).size.height * 0.04),
      ),
    );
  }

  SizedBox mucisProgress(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.07,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              VolumeController().muteVolume();
              setState(() {
                _setVolumeValue = 0;
              });
            },
            child: Icon(
              Icons.volume_off_outlined,
              color: grey400,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.03,
            child: Slider(
              min: 0,
              max: 1,
              activeColor: blue,
              inactiveColor: grey400,
              onChanged: (double value) {
                _setVolumeValue = value;
                VolumeController().setVolume(_setVolumeValue);
                setState(() {});
              },
              value: _setVolumeValue,
            ),
          ),
          InkWell(
            onTap: () {
              VolumeController().maxVolume();
              setState(() {
                _setVolumeValue = 1;
              });
            },
            child: Icon(
              Icons.volume_up,
              color: grey400,
            ),
          ),
        ],
      ),
    );
  }

  Widget controllButtons(BuildContext context) {
    return widget.player.builderCurrent(
      builder: (context, Playing? playing) {
        return widget.player.builderLoopMode(
          builder: (context, loopMode) {
            return PlayerBuilder.isPlaying(
              player: widget.player,
              builder: (context, isPlaying) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.audios.length > 0
                            ? widget.player.previous()
                            : null;
                      },
                      child: CircleAvatar(
                        backgroundColor: white,
                        radius: 25,
                        child: Icon(
                          Icons.skip_previous_rounded,
                          color: grey400,
                          size: 30,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: white,
                      radius: 45,
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [blue, parrotGreen],
                          tileMode: TileMode.repeated,
                        ).createShader(bounds),
                        child: IconButton(
                            icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: white),
                            iconSize: 64.0,
                            onPressed: () {
                              widget.player.playOrPause();
                            }),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (widget.audios.length < widget.audios.length + 1) {
                          widget.player.next();
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: white,
                        radius: 25,
                        child: Icon(
                          Icons.skip_next_rounded,
                          color: grey400,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
        );
      },
    );

    /*  return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: widget.player.previous,
            child: CircleAvatar(
              backgroundColor: white,
              radius: 25,
              child: Icon(
                Icons.skip_previous_rounded,
                color: grey400,
                size: 30,
              ),
            ),
          ),
          StreamBuilder(
              stream: widget.player.isPlaying,
              builder: (context, snapshot) {
                final Object? isPlaying = snapshot.data;
                return CircleAvatar(
                  backgroundColor: white,
                  radius: 45,
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [blue, parrotGreen],
                      tileMode: TileMode.repeated,
                    ).createShader(bounds),
                    child: IconButton(
                        icon: Icon(
                            isPlaying != null ? Icons.play_arrow : Icons.pause,
                            color: white),
                        iconSize: 64.0,
                        onPressed: () {
                          widget.player.play();
                        }),
                  ),
                );
              }),
          GestureDetector(
            onTap: () {
              widget.player.next();
            },
            child: CircleAvatar(
              backgroundColor: white,
              radius: 25,
              child: Icon(
                Icons.skip_next_rounded,
                color: grey400,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );*/
  }
}
