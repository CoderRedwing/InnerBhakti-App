import 'package:flutter/material.dart';
import '../models/program_model.dart';

class ProgramDetailsScreen extends StatelessWidget {
  const ProgramDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final program = ModalRoute.of(context)!.settings.arguments as Program;

    return Scaffold(
      body: Stack(
        children: [
          // Background with Hero Image
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFAA75F), Color(0xFFFAC898)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Section with Image
                Stack(
                  children: [
                    Image.network(
                      program.imageUrl, // Replace with program image
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Content Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          program.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          program.description,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Subcategories or Steps
                        Expanded(
                          child: ListView(
                            children: [
                              _buildStepCard(
                                'Getting Started',
                                'A few short intro sessions',
                              ),
                              _buildStepCard(
                                'Learning to Sit',
                                'Building up to 10 minutes',
                              ),
                              _buildStepCard(
                                'Mindfulness',
                                'Build your practice',
                              ),
                              _buildStepCard(
                                'Deepen your practice',
                                'Expand and deepen your knowledge',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom Action Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      print(program.audioTracks);
                      Navigator.pushNamed(
                        context,
                        '/audio_player',
                        arguments: program.audioTracks,
                      ).then((value) {
                        print(
                            'Navigate with audioTracks:${program.audioTracks}');
                      });
                    },
                    child: const Text(
                      'Start Audio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget for Steps/Subcategories
  Widget _buildStepCard(String title, String subtitle) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 3,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
