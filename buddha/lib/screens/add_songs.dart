// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:buddha/screens/list.dart';
import 'package:buddha/screens/songplay.dart';
import 'package:buddha/utils/colors.dart';
import 'package:buddha/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:volume_controller/volume_controller.dart';

class AddMixSong extends StatefulWidget {
  double setVolumeValue;
  String name = '';
  AddMixSong(this.setVolumeValue, this.name, {super.key});

  @override
  State<AddMixSong> createState() => _AddMixSongState();
}

class _AddMixSongState extends State<AddMixSong> {
  double sliderValue = 0;

  @override
  void initState() {
    super.initState();
    // VolumeController().listener((volume) {
    //   setState(() => sliderValue = volume);
    // });

    // VolumeController().getVolume().then((volume) => sliderValue = volume);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: transparent,
        title: displayText(text: 'NOW PLAYING: ${widget.name}'),
        titleTextStyle: TextStyle(color: black, fontSize: 17),
        iconTheme: IconThemeData(
          color: black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    text("Main Music"),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.03,
                      child: SliderTheme(
                        data: SliderThemeData(
                            overlayShape: SliderComponentShape.noThumb),
                        child: Slider(
                          min: 0,
                          max: 1,
                          activeColor: blue,
                          inactiveColor: grey400,
                          onChanged: (double value) {
                            widget.setVolumeValue = value;
                            VolumeController().setVolume(widget.setVolumeValue);
                            setState(() {});
                          },
                          value: widget.setVolumeValue,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    text("Equalizer"),
                    const Text("Maximum three sounds can be selected"),
                    height(context),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 1.65,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: byteSongName.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              text(byteSongName[index]),
                              height(context),
                              slider(context, index),
                            ],
                          );
                        },
                      ),
                    )
                    /*  text("Light Wind"),
                    height(context),
                    slider(context, 0),
                    height(context),
                    text("Chimes"),
                    height(context),
                    slider(context, 1),
                    height(context),
                    text("Bells"),
                    height(context),
                    slider(context, 2),
                    height(context),
                    text("Thunder"),
                    height(context),
                    slider(context, 3),
                    height(context),
                    text("Meadow"),
                    height(context),
                    slider(context, 4),
                    height(context),
                    text("Mountain River"),
                    height(context),
                    slider(context, 5),
                    height(context),
                    text("Birds"),
                    height(context),
                    slider(context, 6),
                    height(context),
                    text("River"),
                    height(context),
                    slider(context, 7),
                    height(context),
                    text("Sea waves"),
                    height(context),
                    slider(context, 8),
                    height(context),
                    text("Piano"),
                    height(context),
                    slider(context, 9),
                    height(context),
                    text("Seagulls"),
                    height(context),
                    slider(context, 10),
                    height(context),
                    text("Bowl"),
                    height(context),
                    slider(context, 11),
                    height(context),
                    text("Cat Purr"),
                    height(context),
                    slider(context, 12),
                    height(context),
                    text("Chant"),
                    height(context),
                    slider(context, 13),
                    height(context),
                    text("Guitar"),
                    height(context),
                    slider(context, 14),
                    height(context),
                    text("Aircon"),
                    height(context),
                    slider(context, 15),
                    height(context),
                    text("Bubbles"),
                    height(context),
                    slider(context, 16),
                    height(context),
                    text("Bonfire"),
                    height(context),
                    slider(context, 17),
                    height(context),
                    text("Breathing"),
                    height(context),
                    slider(context, 18),
                    text("Fan"),
                    height(context),
                    slider(context, 19),*/
                  ],
                ),
              ),
            ),
            saveButton(context)
          ],
        ),
      ),
    );
  }

  SizedBox height(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * 0.02);

  Row slider(BuildContext context, int index) {
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
                data:
                    SliderThemeData(overlayShape: SliderComponentShape.noThumb),
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
        SongPlay(false, byteSong[index], index)
      ],
    );
  }

  Text text(String text) => Text(text, style: const TextStyle(fontSize: 17));

  SizedBox saveButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.085,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [parrotGreen, blue],
                end: Alignment.bottomRight,
                begin: Alignment.topLeft,
              ),
              borderRadius: BorderRadius.circular(25)),
          child: Center(
            child: Text(
              "Save",
              style: TextStyle(color: white, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  songPlay(play, song, index) {
    return InkWell(
      onTap: () {
        if (play == true) {
          setState(() {
            play = false;
          });
        } else {
          setState(() {
            play = true;
          });
        }
        print(play);
      },
      child: play ? const Icon(Icons.close) : const Icon(Icons.check),
    );
  }
}
