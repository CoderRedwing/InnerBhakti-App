import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  const GuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> guides = [
      {
        'name': 'Guide 1',
        'description': 'Specializes in Gayatri Mantra Meditation.',
        'profilePic': 'assets/guide.jpg',
        'contact': '9876543210',
        'rating': 4.5,
        'meditations': [
          'Gayatri Mantra Meditation',
          'Om Meditation',
        ],
      },
      {
        'name': 'Guide 2',
        'description': 'Expert in Chakra and Zen Meditation.',
        'profilePic': 'assets/guide.jpg',
        'contact': '9876543211',
        'rating': 4.7,
        'meditations': [
          'Chakra Meditation',
          'Zen Meditation',
        ],
      },
      {
        'name': 'Guide 3',
        'description': 'Focuses on Kundalini and Nada Yoga practices.',
        'profilePic': 'assets/guide.jpg',
        'contact': '9876543212',
        'rating': 4.6,
        'meditations': [
          'Kundalini Meditation',
          'Nada Yoga',
        ],
      },
      {
        'name': 'Guide 4',
        'description': 'Specialist in Trataka and Jnana Meditation.',
        'profilePic': 'assets/guide.jpg',
        'contact': '9876543213',
        'rating': 4.8,
        'meditations': [
          'Trataka (Gazing Meditation)',
          'Jnana Meditation',
        ],
      },
      {
        'name': 'Guide 5',
        'description':
            'Highly rated for Mindfulness and Loving-Kindness practices.',
        'profilePic': 'assets/guide.jpg',
        'contact': '9876543214',
        'rating': 4.9,
        'meditations': [
          'Mindfulness Meditation',
          'Loving-Kindness Meditation',
        ],
      },
      {
        'name': 'Guide 6',
        'description':
            'Expert in Healing Light and Breath Awareness Meditation.',
        'profilePic': 'assets/guide.jpg',
        'contact': '9876543215',
        'rating': 4.7,
        'meditations': [
          'Healing Light Meditation',
          'Breath Awareness Meditation',
        ],
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Guide',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spiritual Guides',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two cards per row
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: guides.length,
                itemBuilder: (context, index) {
                  final guide = guides[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GuideDetailPage(guide: guide),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage(guide['profilePic']),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              guide['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              guide['description'],
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GuideDetailPage extends StatefulWidget {
  final Map<String, dynamic> guide;

  const GuideDetailPage({super.key, required this.guide});

  @override
  State<GuideDetailPage> createState() => _GuideDetailPageState();
}

class _GuideDetailPageState extends State<GuideDetailPage> {
  bool _isImageFullscreen = false; // Track if the image is in full-screen mode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.guide['name']),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isImageFullscreen = true; // Enable full-screen mode
                    });
                  },
                  child: Center(
                    child: Hero(
                      tag: 'guide-image-${widget.guide['name']}',
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage(widget.guide['profilePic']),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  'Name: ${widget.guide['name']}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Contact: ${widget.guide['contact']}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Rating: ${widget.guide['rating']} ⭐',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Specialized Meditations:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.guide['meditations'].length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.self_improvement),
                        title: Text(widget.guide['meditations'][index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
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
                  tag: 'guide-image-${widget.guide['name']}',
                  child: Image.asset(
                    widget.guide['profilePic'],
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
