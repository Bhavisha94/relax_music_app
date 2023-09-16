// ignore_for_file: unrelated_type_equality_checks, must_be_immutable, unused_field, prefer_final_fields, unused_local_variable

import 'dart:developer';

import 'package:buddha/screens/add_songs.dart';
import 'package:buddha/screens/dashboard.dart';
import 'package:buddha/screens/progressbarstate.dart';
import 'package:buddha/screens/songplay.dart';
import 'package:buddha/utils/colors.dart';
import 'package:buddha/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:audio_service/audio_service.dart';

class PlayerScreen extends StatefulWidget {
  List<AudioSource> list = [];
  int index;
  AudioPlayer player;
  PlayerScreen(this.list, this.index, this.player, {Key? key})
      : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  bool play = false;
  // late AudioPlayer _player;
  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );

  double _volumeListenerValue = 0;
  double _getVolume = 0;
  double _setVolumeValue = 0;
  bool isRepeat = true;
  bool isPlay = false;
  String songName = '';

  @override
  void initState() {
    super.initState();

    widget.player.setLoopMode(LoopMode.all);

    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: background,
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
          addNotification(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          musicAdd(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          mucisProgress(context),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          controllButtons(context),
          // back(context),
          // appbar(),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.05,
          // ),
          // image(),
          // addNotification(context),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.01,
          // ),
          // musicAdd(context),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.01,
          // ),
          // mucisProgress(context),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.01,
          // ),
          // controllButtons(context),
        ],
      ),
    );
  }

  SizedBox controllButtons(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StreamBuilder<SequenceState?>(
              stream: widget.player.sequenceStateStream,
              builder: (context, snapshot) {
                return GestureDetector(
                    onTap: widget.player.hasPrevious
                        ? widget.player.seekToPrevious
                        : null,
                    child: CircleAvatar(
                      backgroundColor: white,
                      radius: 25,
                      child: Icon(
                        Icons.skip_previous_rounded,
                        color: grey400,
                        size: 30,
                      ),
                    ));
              }),
          StreamBuilder<PlayerState>(
            stream: widget.player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 64.0,
                  height: 64.0,
                  child: CircularProgressIndicator(
                    color: blue,
                  ),
                );
              } else if (playing != true) {
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
                        icon: Icon(Icons.play_arrow, color: white),
                        iconSize: 64.0,
                        onPressed: () {
                          widget.player.play();
                        }),
                  ),
                );
              } else if (processingState != ProcessingState.completed) {
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
                        Icons.pause,
                        color: white,
                      ),
                      iconSize: 64.0,
                      onPressed: () {
                        widget.player.pause();
                      },
                    ),
                  ),
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.replay),
                  iconSize: 64.0,
                  onPressed: () => widget.player.seek(Duration.zero,
                      index: widget.player.effectiveIndices!.first),
                );
              }
            },
          ),
          StreamBuilder<SequenceState?>(
              stream: widget.player.sequenceStateStream,
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () {
                    widget.player.hasNext ? widget.player.seekToNext() : null;
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
                );
              }),
        ],
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

  SizedBox musicAdd(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.07,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icons('assets/images/music.png', 25.00, 30.00, () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddMixSong(_setVolumeValue, songName)));
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
                    // child: ShaderMask(
                    //     shaderCallback: (bounds) => LinearGradient(
                    //           begin: Alignment.topCenter,
                    //           end: Alignment.bottomCenter,
                    //           colors: [blue, parrotGreen],
                    //           tileMode: TileMode.repeated,
                    //         ).createShader(bounds),
                    //     child: const Icon(
                    //       Icons.notifications,
                    //       color: Colors.white,
                    //     )),
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

  Widget icons(String image, double radius, double size, VoidCallback ontap) {
    return InkWell(
      onTap: ontap,
      child: CircleAvatar(
        backgroundColor: white,
        radius: radius,
        child: Image.asset(image,
            height: MediaQuery.of(context).size.height * 0.04),
        // child: ShaderMask(
        //     shaderCallback: (bounds) => LinearGradient(
        //           begin: Alignment.topCenter,
        //           end: Alignment.bottomCenter,
        //           colors: [blue, parrotGreen],
        //           tileMode: TileMode.repeated,
        //         ).createShader(bounds),
        //     child: Icon(
        //       icon,
        //       color: white,
        //       size: size,
        //     )),
      ),
    );
  }

  Widget image() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.3,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/group.png',
              ),
              fit: BoxFit.fill)),
    );
  }

  Widget appbar() {
    return StreamBuilder<SequenceState?>(
        stream: widget.player.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          if (state?.sequence.isEmpty ?? true) return const SizedBox();
          final metadata = state!.currentSource!.tag as MediaItem;
          songName = metadata.album.toString();
          return AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: transparent,
            title: displayText(
                text: 'NOW PLAYING: ${metadata.album?.toUpperCase()}'),
            titleTextStyle: TextStyle(color: black, fontSize: 20),
          );
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

  void setProcessing() async {
    setState(() {});

    widget.player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;

      final processingState = playerState.processingState;
    });

    widget.player.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    widget.player.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    widget.player.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  double sliderValue = 0;

  void modalBottomSheetMenu(context) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Wrap(children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.builder(
                    itemCount: songList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tablist[index],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  height:
                                      MediaQuery.of(context).size.height * 0.03,
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        void Function(void Function())
                                            setState) {
                                      return SliderTheme(
                                        data: SliderThemeData(
                                            overlayShape:
                                                SliderComponentShape.noThumb),
                                        child: Slider(
                                          min: 0,
                                          max: 1,
                                          activeColor: blue,
                                          inactiveColor: grey400,
                                          onChanged: (double value) {
                                            setState(() {
                                              log(value.toString());
                                              sliderValue = value;
                                            });
                                          },
                                          value: sliderValue,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SongPlay(false, songList[index], index)
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ]);
            },
          );
        });
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
