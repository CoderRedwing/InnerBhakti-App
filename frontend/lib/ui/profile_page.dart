import 'package:flutter/material.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  bool _isImageFullscreen =
      false; // To track if the image is in full-screen mode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'SansSerif',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.orange),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isImageFullscreen = true; // Enable full-screen mode
                        });
                      },
                      child: const Hero(
                        tag: 'profile-image',
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage(
                              'assets/guide.jpg'), // Replace with user profile image
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'User Name',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'user.email@example.com',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                const Text(
                  'Completed Challenges',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: 3, // Example count
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.check_circle,
                              color: Colors.green),
                          title: Text('Challenge ${index + 1}'),
                          subtitle: const Text(
                              'Details about the completed challenge.'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to settings or log out
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Settings',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          // Full-screen image overlay
          if (_isImageFullscreen)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isImageFullscreen = false; // Exit full-screen mode
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.9), // Background overlay
                alignment: Alignment.center,
                child: Hero(
                  tag: 'profile-image',
                  child: Image.asset(
                    'assets/guide.jpg', // Full image
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
