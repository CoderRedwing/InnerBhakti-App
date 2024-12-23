import 'package:flutter/material.dart';
import 'package:frontend/ui/guide_page.dart';
import 'package:frontend/ui/profile_page.dart';
import 'package:frontend/widgets/program_card.dart';
import '../services/program_service.dart';
import '../models/program_model.dart';

class ProgramListScreen extends StatefulWidget {
  const ProgramListScreen({super.key});

  @override
  _ProgramListScreenState createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  late Future<List<Program>> _programs;

  @override
  void initState() {
    super.initState();
    _programs = ProgramService.fetchPrograms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'InnerBhakti',
          style: TextStyle(
            fontFamily: 'SansSerif',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.messenger,
              color: Colors.orange,
            ),
            onPressed: () {
              // Handle Messenger Button Press
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.orange,
            ),
            onPressed: () {
              // Handle Add Button Press
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: FutureBuilder<List<Program>>(
          future: _programs,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Programs Available'));
            } else {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top -
                          30 +
                          kToolbarHeight -
                          30,
                    ),
                    // Text above the grid
                    const Text(
                      'Prarthana Plans',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Adjust as needed
                      ),
                    ),
                    const SizedBox(height: 16.0), // Space between text and grid
                    Expanded(
                      child: GridView.builder(
                        itemCount: snapshot.data!.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Two items per row
                          crossAxisSpacing: 16.0,
                          mainAxisSpacing: 16.0,
                          childAspectRatio: 3 / 4, // Aspect ratio for card
                        ),
                        itemBuilder: (context, index) {
                          var program = snapshot.data![index];
                          return ProgramCard(
                            program: program,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/program_details',
                                arguments: program, // Pass the Program object
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // 'Explore' is active
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GuidePage()),
            );
          } else if (index == 1) {
            // Stay on Explore (Current Page)
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MePage()),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Guide',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}
