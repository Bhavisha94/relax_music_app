import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_session/audio_session.dart';
import 'package:buddha/screens/drawer.dart';
import 'package:buddha/screens/list.dart';
import 'package:buddha/screens/new_player_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:buddha/utils/colors.dart';
import 'package:buddha/widgets/text.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';

List<String> images = [
  'assets/images/group.png',
  'assets/images/mask_group.png',
  'assets/images/group.png',
  'assets/images/mask_group.png',
  'assets/images/group.png',
];

List<String> icons = [
  'assets/images/icon1.png',
  'assets/images/icon2.png',
  'assets/images/icon1.png',
  'assets/images/icon2.png',
  'assets/images/icon1.png',
];

List<String> tablist = ["ALL", "ZEN", "MOOD", "AMBIENT", "RELAX"];

List<String> songList = [
  'assets/moods/forest_mood.mp3',
  'assets/moods/healing_sound.mp3',
  'assets/moods/hills_mood.mp3',
  'assets/moods/inspiration_mood.mp3',
  'assets/moods/meditation_mood_ohm.mp3',
];

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  int selectedTab = 0;
  List<AudioSource> audiolist = [];
  static int _nextMediaId = 0;
  late AudioPlayer _player;
  late AssetsAudioPlayer _assetsAudioPlayer;
  List<Audio> audios = [];
  late TabController _tabController;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _tabController = TabController(length: tablist.length, vsync: this);

    void _setActiveTabIndex() {
      setState(() {
        selectedTab = _tabController.index;
      });
    }

    _tabController.addListener(_setActiveTabIndex);

    _assetsAudioPlayer = AssetsAudioPlayer();

    // _player.setLoopMode(LoopMode.one);
  }

  @override
  Widget build(BuildContext context) {
    getTabs();

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
          key: _scafoldKey,
          drawer: const DrawerWidget(),
          body: Column(
            children: [appbar(context), bodyBuild()],
          )),
    );
  }

  List<Widget> tabs = [];
  List<Widget> tabbarsview = [];
  getTabs() {
    tabs = [];
    tabbarsview = [];
    for (int i = 0; i < tablist.length; i++) {
      tabs.add(Tab(
        child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: selectedTab == i ? white : null),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: displayText(text: tablist[i], fontSize: 17),
            )),
      ));

      if (i == 0) {
        tabbarsview.add(tabbarview(allImages, songName));
      } else if (i == 1) {
        tabbarsview.add(tabbarview(zenImages, zenName));
      } else if (i == 2) {
        tabbarsview.add(tabbarview(moodImages, moodName));
      } else if (i == 3) {
        tabbarsview.add(tabbarview(ambientImages, ambientName));
      } else if (i == 4) {
        tabbarsview.add(tabbarview(relaxImages, relaxName));
      }
    }
    setState(() {});
  }

  Widget appbar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [parrotGreen, blue],
          end: Alignment.bottomRight,
          begin: Alignment.topLeft,
        ),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      ),
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          AppBar(
            elevation: 0,
            backgroundColor: transparent,
            leading: IconButton(
              icon: Icon(Icons.menu, color: white),
              onPressed: () {
                _scafoldKey.currentState!.openDrawer();
              },
            ),
            title: Column(
              children: [
                displayText(
                  text: "WELCOME TO",
                  fontSize: 13,
                ),
                const SizedBox(
                  height: 5,
                ),
                displayText(
                  text: "BUDDHA LOUNGE",
                  fontSize: 22,
                ),
              ],
            ),
            centerTitle: true,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          TabBar(
            tabs: tabs,

            unselectedLabelStyle: const TextStyle(fontSize: 18),
            //labelPadding: const EdgeInsets.symmetric(horizontal: 5),
            indicatorColor: transparent,
            labelColor: textBlue,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            labelPadding: EdgeInsets.zero,
            isScrollable: true,
            unselectedLabelColor: Colors.white.withOpacity(0.54),
            controller: _tabController,
            onTap: (value) {
              setState(() {
                selectedTab = value;
              });
              void _setActiveTabIndex() {
                selectedTab = _tabController.index;
              }
            },
          )
        ],
      ),
    );
  }

  Widget bodyBuild() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.75,
      color: background,
      child: TabBarView(
        children: tabbarsview,
        controller: _tabController,
      ),
    );
  }

  Widget tabbarview(List<String> images, List<String> songname) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: GridView.builder(
        itemCount: images.length,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            mainAxisExtent: MediaQuery.of(context).size.height * 0.285),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // print("Index is : $idx");
              if (selectedTab == 0) {
                audioSourceList(allSongs, songName, notiImg);
              } else if (selectedTab == 1) {
                audioSourceList(zenSong, zenName, notiImg);
              } else if (selectedTab == 2) {
                audioSourceList(moodSong, moodName, notiImg);
              } else if (selectedTab == 3) {
                audioSourceList(ambientSong, ambientName, notiImg);
              } else if (selectedTab == 4) {
                audioSourceList(relaxSong, relaxName, notiImg);
              }
              /*  _init(audiolist, index);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      PlayerScreen(audiolist, index, _player))); */
              //openPlayer();

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewPlayerScreen(
                      audios,
                      _assetsAudioPlayer,
                      index,
                      'assets/buddha_img/${buddhaImg[index]}')));
            },
            child: Stack(children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.27,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: cardBackground),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(
                        bottom: 35, left: 20, right: 20, top: 20),
                    // width: 150,
                    // height: MediaQuery.of(context).size.height * 0.15,
                    child: SvgPicture.asset(
                        'assets/buddha_img/${buddhaImg[index]}',
                        fit: BoxFit.contain),
                  ),
                ),
              ),
              Positioned(
                  bottom: 1,
                  right: 5,
                  left: 5,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          // height: MediaQuery.of(context).size.height * 0.05,
                          padding: const EdgeInsets.symmetric(
                              vertical: 09, horizontal: 20),
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(25)),
                          child: Center(
                              child: displayText(
                                  text: songname[index],
                                  fontSize: 17,
                                  fontFamily: 'Meditation',
                                  fontWeight: FontWeight.w500)),
                        )
                      ],
                    ),
                  )),
              Positioned(
                top: 10,
                left: 10,
                child: CircleAvatar(
                  backgroundColor: cardIcon,
                  child: Image.asset(
                      'assets/img/mood_sym/${symbol[_random.nextInt(images.length)]}',
                      height: 25,
                      width: 25),
                ),
              )
            ]),
          );
        },
      ),
    );
  }

  audioSourceList(List<String> song, List<String> name, List<String> img) {
    audiolist = [];
    audios = [];

    for (int i = 0; i < song.length; i++) {
      // audios.add(Audio(song[i],
      //     metas: Metas(
      //         id: name[i],
      //         title: '',
      //         album: name[i],
      //         image: MetasImage.asset(song[i]))));

      audios.add(Audio(song[i],
          metas: Metas(
              id: name[i],
              title: name[i],
              album: "Buddha Lounge",
              image: MetasImage.asset("assets/svgtopng/${img[i]}"))));
    }
    /*  for (int i = 0; i < song.length; i++) {
      audiolist.add(
        AudioSource.uri(
          Uri.parse('asset:///${song[i]}'),
          tag: MediaItem(
            id: '${_nextMediaId++}',
            album: name[i],
            title: "",
          ),
        ),
      );
    } */
    setState(() {});

    print("AUDIO LIST : ${audios.length}");
  }

  Future<void> _init(List<AudioSource> list, index) async {
    final playerPlaylist = ConcatenatingAudioSource(children: list);
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    _player.playbackEventStream
        .listen((event) {}, onError: (Object e, StackTrace stackTrace) {});
    try {
      await _player.setAudioSource(playerPlaylist, initialIndex: index);
    } catch (e, stackTrace) {
      print(stackTrace);
    }
  }
}


/*



*/
