import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> lehraFiles = [
    'assets/taals/Addha.wav',
    'assets/taals/Ektaal.wav',
    'assets/taals/Jhaptaal.wav',
    'assets/taals/Jhaptaal2.wav',
    'assets/taals/short ektaal.wav',
    'assets/taals/Teentaal.wav',
    'assets/taals/Teentaal2.wav',
    "assets/taals/teental delay.wav"
  ];
  bool isPlaying = false;
  int lehraIdx = 3;
  late AudioPlayer lehra;
  late FixedExtentScrollController _scrollController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lehra = AudioPlayer();
    _scrollController = FixedExtentScrollController(initialItem: lehraIdx);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    lehra.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: const Text('tabla and lehra'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // create a dropdown for selecting the taal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: CupertinoPicker(
                        scrollController: _scrollController,
                        itemExtent: 30,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            lehraIdx = index;
                          });
                          lehra.setAsset(lehraFiles[lehraIdx]);
                        },
                        children: lehraFiles
                            .map((e) => Text(e.substring(
                                e.lastIndexOf('/') + 1, e.length - 4)))
                            .toList()),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton.filledTonal(
                              onPressed: () {
                                if (isPlaying) {
                                  lehra.pause();
                                  setState(() {
                                    isPlaying = false;
                                  });
                                  return;
                                }
                                // play the selected lehra on loop
                                lehra.setAsset(lehraFiles[lehraIdx]);
                                lehra.setLoopMode(LoopMode.one);
                                lehra.play();
                                setState(() {
                                  isPlaying = true;
                                });
                              },
                              icon: Icon(
                                  isPlaying ? Icons.pause : Icons.play_arrow)),
                          Text('Speed: ${lehra.speed.toStringAsFixed(1)}x',
                              style: const TextStyle(fontSize: 17)),
                        ],
                      ),
                      Wrap(
                        spacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // reset speed button

                          IconButton.outlined(
                              onPressed: () {
                                setState(() {
                                  lehra.setSpeed(lehra.speed - 0.1);
                                });
                              },
                              icon: const Icon(Icons.fast_rewind)),
                          IconButton.outlined(
                              onPressed: () {
                                setState(() {
                                  lehra.setSpeed(1.0);
                                });
                              },
                              icon: const Icon(Icons.restore)),
                          IconButton.outlined(
                              onPressed: () {
                                setState(() {
                                  lehra.setSpeed(lehra.speed + 0.1);
                                });
                              },
                              icon: const Icon(Icons.fast_forward)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // create 2 buttons to increase and decrease playback speed
            ],
          ),
        ),
      ),
    );
  }
}
