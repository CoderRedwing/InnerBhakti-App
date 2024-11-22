// lib/models/audio_model.dart
class AudioTrack {
  final String id;
  final String title;
  final String duration;
  final String audioUrl;
  final String imageUrl; // New field for track image
  final String? subtitle; // Optional subtitle for extra information

  AudioTrack({
    required this.id,
    required this.title,
    required this.duration,
    required this.audioUrl,
    required this.imageUrl,
    this.subtitle, // Subtitle is optional
  });

  int get durationInSeconds {
    final parts = duration.split(':');
    final minutes = int.parse(parts[0]);
    final seconds = int.parse(parts[1]);
    return minutes * 60 + seconds;
  }

  factory AudioTrack.fromJson(Map<String, dynamic> json) {
    return AudioTrack(
      id: json['_id'],
      title: json['title'],
      duration: json['duration'],
      audioUrl: json['audioUrl'],
      imageUrl: json['imageUrl'], // Added image URL mapping
      subtitle: json['subtitle'], // Added subtitle mapping (optional)
    );
  }
}
