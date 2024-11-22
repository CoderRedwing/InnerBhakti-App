import 'package:flutter/material.dart';
import '../models/audio_model.dart';
import '../services/audio_service.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  _AudioPlayerScreenState createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  late List<AudioTrack> _audioTracks;
  bool _isLoading = true;
  String? _errorMessage;
  AudioTrack? _currentTrack;
  bool _isPlaying = false;
  double _currentTime = 0.0; // Current track time
// Track loading state

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      final List<AudioTrack> audioTracks =
          ModalRoute.of(context)!.settings.arguments as List<AudioTrack>;
      setState(() {
        _audioTracks = audioTracks;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to load audio tracks';
        _isLoading = false;
      });
    }
  }

  void _playAudio(AudioTrack track) {
    setState(() {
      _currentTrack = track;
      _isPlaying = true;
      _currentTime = 0.0;
    });
    try {
      AudioService.playAudio(track.audioUrl);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Playing "${track.title}"')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error playing audio: $error')),
      );
    }
  }

  void _pauseAudio() {
    setState(() {
      _isPlaying = false;
    });
    AudioService.pauseAudio();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Audio paused')),
    );
  }

  void _nextTrack() {
    if (_audioTracks.isEmpty || _currentTrack == null) return;

    int currentIndex = _audioTracks.indexOf(_currentTrack!);
    if (currentIndex + 1 < _audioTracks.length) {
      _playAudio(_audioTracks[currentIndex + 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : Stack(
                  children: [
                    // Gradient Background
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFA500), Color(0xFFFFDAB9)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Header Section
                          Container(
                            height: 300,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Current Track Image
                                CircleAvatar(
                                  radius: 80,
                                  backgroundImage: _currentTrack != null
                                      ? NetworkImage(_currentTrack!.imageUrl)
                                      : null,
                                  backgroundColor: Colors.grey.shade300,
                                  child: _currentTrack == null
                                      ? const Icon(
                                          Icons.music_note,
                                          size: 60,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 20),
                                // Current Track Title
                                Text(
                                  _currentTrack?.title ?? 'Select a Track',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                // Current Track Subtitle
                                Text(
                                  _currentTrack?.duration ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Tracks List or Default Message
                          Expanded(
                            child: _audioTracks.isEmpty
                                ? const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.music_note,
                                          size: 60,
                                          color: Colors.orange,
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: _audioTracks.length,
                                    itemBuilder: (context, index) {
                                      final track = _audioTracks[index];
                                      return Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 16),
                                        elevation: 3,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(track.imageUrl),
                                          ),
                                          title: Text(
                                            track.title,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                              'Duration: ${track.duration}'),
                                          trailing: Icon(
                                            Icons.play_arrow,
                                            color: _currentTrack == track &&
                                                    _isPlaying
                                                ? Colors.orange
                                                : Colors.black,
                                          ),
                                          onTap: () {
                                            _playAudio(track);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          // Audio Player Controls
                          if (_currentTrack != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Audio Timer
                                  Slider(
                                    value: _currentTime,
                                    min: 0.0,
                                    max: _currentTrack!.durationInSeconds
                                        .toDouble(),
                                    onChanged: (newTime) {
                                      setState(() {
                                        _currentTime = newTime;
                                      });
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          _isPlaying
                                              ? Icons.pause_circle
                                              : Icons.play_circle,
                                          size: 50,
                                          color: Colors.orange,
                                        ),
                                        onPressed: _isPlaying
                                            ? _pauseAudio
                                            : () {
                                                if (_currentTrack != null) {
                                                  _playAudio(_currentTrack!);
                                                }
                                              },
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.skip_next,
                                          size: 40,
                                          color: Colors.orange,
                                        ),
                                        onPressed: _nextTrack,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        _currentTrack?.title ?? '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Duration: ${_currentTrack?.duration ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
