import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MusicPlayerScreen(),
    );
  }
}

class MusicPlayerScreen extends StatefulWidget {
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  List<String> _musicFiles = [];
  AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentPlaying;

  @override
  void initState() {
    super.initState();
  }

  // Function to pick files from the directory
  Future<void> _pickMusicFiles() async {
    // Picking multiple music files (you can limit file type as needed)
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'mp3',
        'wav',
        'flac'
      ], // Add your supported music formats
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _musicFiles = result.files.map((e) => e.path!).toList();
      });
    }
  }

  // Function to play selected music
  void _playMusic(String path) async {
    await _audioPlayer.setFilePath(path);
    _audioPlayer.play();
    setState(() {
      _currentPlaying = path;
    });
  }

  // Function to stop the music
  void _stopMusic() async {
    await _audioPlayer.stop();
    setState(() {
      _currentPlaying = null;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickMusicFiles,
              child: Text('Select Music Files'),
            ),
            SizedBox(height: 20),
            if (_musicFiles.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _musicFiles.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_musicFiles[index].split('/').last),
                      onTap: () => _playMusic(_musicFiles[index]),
                    );
                  },
                ),
              ),
            if (_currentPlaying != null)
              Text('Now Playing: ${_currentPlaying!.split('/').last}'),
            SizedBox(height: 10),
            if (_currentPlaying != null)
              ElevatedButton(
                onPressed: _stopMusic,
                child: Text('Stop Music'),
              ),
          ],
        ),
      ),
    );
  }
}
