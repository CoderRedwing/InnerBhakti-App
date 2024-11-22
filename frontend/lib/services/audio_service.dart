import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import '../models/audio_model.dart';

class AudioService {
  static final String? _baseUrl = dotenv.env['BASE_URL_AUDIO'];

  // Fetch audio tracks from API
  static Future<List<AudioTrack>> fetchAudioTracks() async {
    final response = await http.get(Uri.parse(_baseUrl!));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((audioTrack) => AudioTrack.fromJson(audioTrack)).toList();
    } else {
      throw Exception('Failed to load audio tracks');
    }
  }

  // Play audio from the given URL
  static void playAudio(String url) {
    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.play(url as Source);
    if (kDebugMode) {
      print('Playing audio from: $url');
    }
  }

  // Stop the audio
  static void pauseAudio() {
    AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.stop();
    if (kDebugMode) {
      print('Audio stopped');
    }
  }
}
