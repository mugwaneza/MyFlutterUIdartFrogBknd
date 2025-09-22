import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndagiza/pages/aborozi/guhuza_amatungo_aborozi.dart';
import 'package:ndagiza/pages/amatungo/kwinjiza_itungo_form.dart';
import 'package:ndagiza/pages/aborozi/Aborozilist.dart';
import 'package:ndagiza/statics/ApiUrls.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: DefaultTabController(
        length: 2, // Number of tabs
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + kTextTabBarHeight),
            child: Column(
              children: [
                // Custom status bar color (top of the screen)
                Container(
                  color: Colors.red, // Color for the status bar area
                  height: MediaQuery.of(context).padding.top,
                ),
                // AppBar content
                Container(
                  color: Colors.green, // AppBar background
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "NdagizaNange",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.notifications,
                                      color: Colors.white),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Notifications Clicked!')),
                                    );
                                  },
                                ),
                                Builder(
                                  builder: (innerContext) =>
                                      PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert,
                                        color: Colors.white),
                                    onSelected: (String value) {
                                      if (value == 'Aborozi') {
                                        Navigator.push(
                                          innerContext,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AboroziList(),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text('Selected: $value')),
                                        );
                                      }
                                    },
                                    itemBuilder: (BuildContext context) => [
                                      const PopupMenuItem(
                                          value: 'Ibindanga',
                                          child: Text('Ibindanga')),
                                      const PopupMenuItem(
                                        value: 'Aborozi',
                                        child: Text('Aborozi'),
                                      ),
                                      const PopupMenuItem(
                                          value: 'Gusohoka',
                                          child: Text('Gusohoka')),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const TabBar(
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white,
                        indicatorColor: Colors.orange,
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        tabs: [
                          Tab(text: "Amakuru y'ubworozi"),
                          Tab(text: "Amatungo yacu"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              HomeTab(), // Show Home Tab
              AnimalsGuardians(), // Your new tab content
            ],
          ),
        ),
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _selectedIndex = 0; // Track selected bottom menu index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Selected: ${_getLabel(index)}")),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchAmatungoIcyiciroList();
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return "Ahabanza";
      case 1:
        return "Raporo";
      case 2:
        return "Konti";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 12.0), // Adds 12px left and right

        child: Column(
          children: [
            // Success Alert Card (Displaying the total number of animals)
            Card(
              color: const Color.fromRGBO(139, 210, 142, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Total animals: ', // Regular text
                              style: TextStyle(
                                color: const Color.fromARGB(207, 255, 255,
                                    255), // Gray color for "Total animals"
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: '5', // Bolded green number
                              style: TextStyle(
                                color:
                                    Colors.green, // Green color for the number
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    14, // Optional: increase size of the number
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10), // Space between the alert and grid

            // 🔵 GridView for Card Buttons
            GridView.builder(
              shrinkWrap: true,
              physics:
                  NeverScrollableScrollPhysics(), // Prevents scrolling inside Column
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    (MediaQuery.of(context).size.width ~/ 100).clamp(3, 6),
                crossAxisSpacing: 8.0, // Adjust spacing between columns
                mainAxisSpacing: 8.0, // Adjust spacing between rows
                childAspectRatio: 1.1, // Adjust height relative to width
              ),
              itemCount: choices.length,
              itemBuilder: (context, index) {
                return SelectCard(choice: choices[index]);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white, // Set the icon color inside FAB
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => kwinjiza_itungo_form()),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor:
            const Color.fromARGB(255, 22, 228, 143), // Selected item color
        unselectedItemColor:
            const Color.fromARGB(255, 158, 158, 158), // Unselected item color
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Ahabanza"),
          BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner_outlined), label: "Raporo"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Konti"),
        ],
      ),
    );
  }

  Future<void> fetchAmatungoIcyiciroList() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8080/amatungo/itungo'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          choices = data.map((item) {
            return Choice(label: item[0].toString(), title: item[1].toString());
          }).toList();

// Manually add other static items
          choices.addAll([
            Choice(label: 'Intama', title: '0'),
            Choice(label: 'Ingurube', title: '0'),
          ]);
        });
      } else {
        print('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}

class AnimalsGuardians extends StatefulWidget {
  const AnimalsGuardians({super.key});

  @override
  _AnimalsGuardiansState createState() => _AnimalsGuardiansState();
}

class _AnimalsGuardiansState extends State<AnimalsGuardians> {
  List<Map<String, String>> allAmatungo = [];
  List<Map<String, String>> filteredList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAmatungoList();
  }

  Future<void> fetchAmatungoList() async {
    final response = await http.get(
      Uri.parse(ApiUrls.fetchListAmatungo),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      setState(() {
        allAmatungo = data
            .map((item) => {
                  'image':
                      'http://127.0.0.1:8080/amatungo/imagesdirectory/${item['ifoto_url'] ?? ''}',
                  'name': '${item['ibara'] ?? ''}',
                  'price': '${item['amafaranga_rihagaze'] ?? ''}',
                  'reproduction': '${item['ubwokobwitungo'] ?? ''}',
                  'guardian': '${item['abashumba'] ?? ''}',
                  'supervisor': '${item['supervisor'] ?? ''}',
                  'gender': '${item['igitsina'] ?? ''}',
                  'age': '${item['ubukure'] ?? ''}',
                  'arrival_date': '${item['igihe'] ?? ''}',
                  'code': '${item['itngcode'] ?? ''}',
                })
            .toList();

        filteredList = List.from(allAmatungo);
      });
    } else {
      print('Failed to load data');
    }
  }

  void filterSearch(String query) {
    setState(() {
      filteredList = allAmatungo.where((itungo) {
        final q = query.toLowerCase();
        return itungo['name']!.toLowerCase().contains(q) ||
            itungo['guardian']!.toLowerCase().contains(q) ||
            itungo['supervisor']!.toLowerCase().contains(q) ||
            itungo['code']!.toLowerCase().contains(q);
      }).toList();
    });
  }

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredAmatungo = allAmatungo.where((itungo) {
      final query = searchQuery.toLowerCase();
      return itungo['name']!.toLowerCase().contains(query) ||
          itungo['guardian']!.toLowerCase().contains(query) ||
          itungo['supervisor']!.toLowerCase().contains(query) ||
          itungo['code']!.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Amatungo')),
      body: Column(
        children: [
          //  Search box
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText:
                    'Shakisha izina, ushinzwe, umugenzuzi, cyangwa code...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // List of filtered items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredAmatungo.length,
              itemBuilder: (context, index) {
                final itungo = filteredAmatungo[index];
                final guardianPresent = itungo['guardian'] != null &&
                    itungo['guardian']!.trim().isNotEmpty;

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Guhuza_amatungo_aborozi(), // pass the data
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              itungo['image']!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Table(
                              columnWidths: const {
                                0: FlexColumnWidth(),
                                1: FlexColumnWidth(),
                              },
                              children: [
                                TableRow(children: [
                                  _buildField("Ibara", itungo['name']),
                                  _buildField("Igitsina", itungo['gender']),
                                ]),
                                TableRow(children: [
                                  _buildField("Igiciro", itungo['price']),
                                  _buildField("Ubukure", itungo['age']),
                                ]),
                                TableRow(children: [
                                  _buildField(
                                      "Imyororokere", itungo['reproduction']),
                                  _buildField(
                                      "Igihe ryaziye", itungo['arrival_date']),
                                ]),
                                TableRow(children: [
                                  _buildField("Ushinzwe", itungo['guardian']),
                                  _buildField("Code", itungo['code']),
                                ]),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 100, // Match image height
                            child: Align(
                              alignment: Alignment.center,
                              child: !guardianPresent
                                  ? Icon(
                                      Icons.add_circle,
                                      color: Colors.green,
                                      size: 28,
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        _showAssignGuardianDialog(
                                            context, itungo);
                                      },
                                      child: Icon(
                                        Icons.check_circle,
                                        color: Colors.orange,
                                        size: 28,
                                      ),
                                    ),
                            ),
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
    );
  }

  Widget _buildField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: value ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAssignGuardianDialog(
      BuildContext context, Map<String, String> itungo) {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Abashinzwe itungo'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Andika izina ry\'ushinzwe',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}

class Choice {
  const Choice({required this.label, required this.title});
  final String label;
  final String title;
}

List<Choice> choices = [];

class SelectCard extends StatelessWidget {
  const SelectCard({super.key, required this.choice});
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Card(
            color: Colors.white,
            elevation: 2, // Optional: adds shadow
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(8), // Optional: rounded corners
            ),
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      choice.title,
                      style: const TextStyle(
                        fontSize: 14, // Large font size
                        color: Colors.green, // Customize color here
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Label as a smaller text
                    Text(choice.label,
                        style: const TextStyle(
                          fontSize: 12, // Smaller font size
                          color: Colors.grey, // Customize color here
                          fontWeight: FontWeight.bold,
                        )),
                  ]),
            )),
      ),
    );
  }
}
