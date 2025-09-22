import 'package:flutter/material.dart';
import 'package:ndagiza/pages/aborozi/Kwinjiza_aborozi.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:ndagiza/statics/ApiUrls.dart';

class AboroziList extends StatefulWidget {
  const AboroziList({super.key});

  @override
  State<AboroziList> createState() => _AboroziListState();
}

class _AboroziListState extends State<AboroziList> {
  List<Map<String, String>> aboroziList = [];
  List<Map<String, String>> filteredList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAboroziList();
  }

  Future<void> fetchAboroziList() async {
    final response = await http.get(
      Uri.parse(ApiUrls.fetchListAborozi),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      setState(() {
        aboroziList = data
            .map((item) => {
                  'name': item[1].toString() + " " + item[2].toString(),
                  'phone': item[6].toString() + "," + item[7].toString(),
                  'location': item[10].toString(),
                  'duty': item[9].toString()
                })
            .toList();
        filteredList = List.from(aboroziList);
      });
    } else {
      print('Failed to load data');
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredList = List.from(aboroziList);
      } else {
        filteredList = aboroziList
            .where((item) =>
                item['name']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Urutonde rw'Aborozi"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Shakisha izina",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: filterSearchResults,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final aboroziItem = filteredList[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.green),
                    title: Text('Izina: ${aboroziItem['name'] ?? ''}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Telefoni: ${aboroziItem['phone'] ?? ''}'),
                        Text('Aho atuye: ${aboroziItem['location'] ?? ''}'),
                        Text('Icyo ashinzwe: ${aboroziItem['duty'] ?? ''}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.call, color: Colors.green),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Calling ${aboroziItem['phone'] ?? ''}'),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 106, 218, 115),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Kwinjiza_aborozi()),
          );
        },
      ),
    );
  }
}
