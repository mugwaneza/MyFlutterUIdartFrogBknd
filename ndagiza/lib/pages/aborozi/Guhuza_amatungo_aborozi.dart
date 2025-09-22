import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndagiza/statics/ApiUrls.dart';

class Guhuza_amatungo_aborozi extends StatefulWidget {
  const Guhuza_amatungo_aborozi({super.key});

  @override
  State<Guhuza_amatungo_aborozi> createState() => _GuhuzaAmatungoAboroziState();
}

class _GuhuzaAmatungoAboroziState extends State<Guhuza_amatungo_aborozi> {
  List<Map<String, dynamic>> AmatungoList = [];
  List<Map<String, dynamic>> AllListAborozi = [];
  List<Map<String, dynamic>> Aborozi = [];
  List<Map<String, dynamic>> Abishingizi = [];

  String? selectedAnimal;
  String? selectedFarmer;
  String? selectedSupervisor;

  final List<Map<String, dynamic>> assignments = [];

  @override
  void initState() {
    super.initState();
    fetchAmatungoList();
    fetchAboroziList();
  }

  Future<void> fetchAmatungoList() async {
    try {
      final response = await http.get(Uri.parse(ApiUrls.fetchListAmatungo));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded is List ? decoded : [];

        setState(() {
          AmatungoList = data
              .where((item) => item is Map)
              .map<Map<String, dynamic>>((item) {
            final mapItem = Map<String, dynamic>.from(item as Map);
            mapItem['itunguui'] = (mapItem['itunguui'] ?? '').toString();
            mapItem['itngcode'] = (mapItem['itngcode'] ?? '').toString();
            mapItem['ibara'] = (mapItem['ibara'] ?? '').toString();

            return mapItem;
          }).toList();

          selectedAnimal =
              AmatungoList.isNotEmpty ? AmatungoList.first['itunguui'] : null;
        });
      } else {
        print('Failed to load Amatungo data: ${response.statusCode}');
      }
    } catch (e, st) {
      print('Error fetching AmatungoList: $e\n$st');
      setState(() {
        AmatungoList = [];
        selectedAnimal = null;
      });
    }
  }

  Future<void> fetchAboroziList() async {
    try {
      final response = await http.get(Uri.parse(ApiUrls.fetchListAborozi));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data = decoded is List ? decoded : [];

        setState(() {
          AllListAborozi = data
              .map((item) => {
                    'abshuui': item[0].toString(),
                    'name': item[1].toString() +
                        " " +
                        item[2].toString() +
                        "(" +
                        item[6].toString() +
                        "/" +
                        item[7].toString() +
                        ")",
                    'duty': item[9].toString()
                  })
              .toList();

          Aborozi =
              AllListAborozi.where((u) => u['duty'] == 'Umworozi').toList();
          Abishingizi =
              AllListAborozi.where((u) => u['duty'] == 'Uhagarariye itungo')
                  .toList();

          // Auto-select first
          selectedFarmer = Aborozi.isNotEmpty ? Aborozi.first['abshuui'] : null;
          selectedSupervisor =
              Abishingizi.isNotEmpty ? Abishingizi.first['abshuui'] : null;
        });
      } else {
        print('Error fetching Aborozi: ${response.statusCode}');
      }
    } catch (e, st) {
      print('Exception fetching AboroziList: $e\n$st');
      setState(() {
        Aborozi = [];
        Abishingizi = [];
        selectedFarmer = null;
        selectedSupervisor = null;
      });
    }
  }

  void assignAnimal() {
    if (selectedAnimal != null &&
        selectedFarmer != null &&
        selectedSupervisor != null) {
      setState(() {
        assignments.add({
          "itungo": selectedAnimal,
          "umworozi": selectedFarmer,
          "umwishingizi": selectedSupervisor,
          "itariki": DateTime.now(),
        });

        // Reset selections
        selectedAnimal =
            AmatungoList.isNotEmpty ? AmatungoList.first['itunguui'] : null;
        selectedFarmer = Aborozi.isNotEmpty ? Aborozi.first['abshuui'] : null;
        selectedSupervisor =
            Abishingizi.isNotEmpty ? Abishingizi.first['abshuui'] : null;

        Aborozi.clear();
        Abishingizi.clear();
        AmatungoList.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select all fields")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kuragiza Amatungo",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BorderedSearchDropdown(
              label: "Amatungo",
              items: AmatungoList.map((a) => {
                    'value': (a['itunguui'] ?? '').toString(),
                    'display': (a['itngcode'] ?? '').toString() +
                        "(" +
                        (a['ibara'] ?? '').toString() +
                        ")"
                  }).toList(),
              selectedValue: selectedAnimal,
              onChanged: (val) => setState(() => selectedAnimal = val),
            ),
            const SizedBox(height: 12),
            BorderedSearchDropdown(
              label: "Aborozi",
              items: Aborozi.map((f) => {
                    'value': (f['abshuui'] ?? '').toString(),
                    'display': (f['name'] ?? '').toString()
                  }).toList(),
              selectedValue: selectedFarmer,
              onChanged: (val) => setState(() => selectedFarmer = val),
            ),
            const SizedBox(height: 12),
            BorderedSearchDropdown(
              label: "Abishingizi",
              items: Abishingizi.map((f) => {
                    'value': (f['abshuui'] ?? '').toString(),
                    'display': (f['name'] ?? '').toString()
                  }).toList(),
              selectedValue: selectedSupervisor,
              onChanged: (val) => setState(() => selectedSupervisor = val),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: assignAnimal,
              icon: const Icon(Icons.check),
              label: const Text("Ragiza"),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: assignments.isEmpty
                  ? const Center(child: Text("Nta ndagizo zihari"))
                  : ListView.builder(
                      itemCount: assignments.length,
                      itemBuilder: (context, index) {
                        final a = assignments[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.pets),
                            title: Text("Itungo: ${a['itungo']}"),
                            subtitle: Text(
                              "Umworozi: ${a['umworozi']}\n"
                              "Umwishingizi: ${a['umwishingizi']}\n"
                              "Itariki byabereye: ${a['itariki'].toString().split('.')[0]}",
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}

/// Custom searchable dropdown with auto-select first filtered item
class BorderedSearchDropdown extends StatefulWidget {
  final String label;
  final List<Map<String, String>> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const BorderedSearchDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  State<BorderedSearchDropdown> createState() => _BorderedSearchDropdownState();
}

class _BorderedSearchDropdownState extends State<BorderedSearchDropdown> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    final filteredItems = widget.items.where((item) {
      final display = item['display'] ?? '';
      return display.toLowerCase().contains(search.toLowerCase());
    }).toList();

    // Auto-select first filtered item
    String? selected =
        filteredItems.any((item) => item['value'] == widget.selectedValue)
            ? widget.selectedValue
            : (filteredItems.isNotEmpty ? filteredItems.first['value'] : null);

    if (selected != widget.selectedValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(selected);
      });
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Search ${widget.label}",
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            ),
            onChanged: (val) => setState(() => search = val),
          ),
          DropdownButtonFormField<String>(
            value: selected,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            ),
            items: filteredItems.map((item) {
              return DropdownMenuItem<String>(
                value: item['value'],
                child: Text(item['display'] ?? ''),
              );
            }).toList(),
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}
