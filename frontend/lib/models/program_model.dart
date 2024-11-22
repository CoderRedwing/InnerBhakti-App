// lib/models/program_model.dart
import 'audio_model.dart'; // Ensure you are importing the AudioTrack model

class Program {
  final String id;
  final String title; // Updated to match "title" field in JSON
  final String imageUrl; // Added to match "imageUrl" field in JSON
  final String description;
  final List<AudioTrack> audioTracks; // Updated to match "tracks" field in JSON

  Program({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.audioTracks,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    // Parse the "tracks" list
    var tracksList = (json['audioTracks'] as List<dynamic>?)
            ?.map((audioTrackJson) =>
                AudioTrack.fromJson(audioTrackJson as Map<String, dynamic>))
            .toList() ??
        [];

    return Program(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Untitled Program',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? 'No description available',
      audioTracks: tracksList,
    );
  }
}
