import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

const String audioURL = "https://www.crossone.ro/crossdata/uploads/2022/01/Episod-1-BoW.mp3";
const String imageURL = "https://www.crossone.ro/crossdata/uploads/2022/04/Beat_of_worship_3_ok.jpg";
const String title = "Caracterul lui Dumnezeu";
const String artist = "Sabin Cîrstoveanu";

class SeekbarDemo extends StatefulWidget {
  const SeekbarDemo({Key? key}) : super(key: key);

  @override
  _SeekbarDemoState createState() => _SeekbarDemoState();
}

class _SeekbarDemoState extends State<SeekbarDemo> {
  late AssetsAudioPlayer _assetsAudioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();

    _openPlayer();

    _assetsAudioPlayer.realtimePlayingInfos.listen((RealtimePlayingInfos infos) {
      setState(() {
        duration = infos.duration;
        position = infos.currentPosition;
        isPlaying = infos.isPlaying;
      });
    });
  }

  void _openPlayer() async {
    await _assetsAudioPlayer.open(
      Audio.network(
        audioURL,
        metas: Metas(
          title: title,
          artist: artist,
          image: const MetasImage.network(imageURL),
        ),
      ),
      autoStart: false,
    );
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  String formatTime(Duration duration) {
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Seekbar demo")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageURL,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              artist,
              style: TextStyle(fontSize: 20),
            ),
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await _assetsAudioPlayer.seek(position);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),
                  Text(formatTime(duration)),
                ],
              ),
            ),
            CircleAvatar(
              radius: 35,
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                iconSize: 50,
                onPressed: () async {
                  await _assetsAudioPlayer.playOrPause();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    super.dispose();
  }
}
