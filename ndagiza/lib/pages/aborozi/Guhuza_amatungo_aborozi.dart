import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndagiza/statics/ApiUrls.dart';

class Guhuza_amatungo_aborozi extends StatefulWidget {
  final Map<String, dynamic> clickedItem;

  const Guhuza_amatungo_aborozi({super.key, required this.clickedItem});

  @override
  State<Guhuza_amatungo_aborozi> createState() => _GuhuzaAmatungoAboroziState();
}

class _GuhuzaAmatungoAboroziState extends State<Guhuza_amatungo_aborozi> {
  List<Map<String, String>> AmatungoList = [];
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
    print("Clicked animal>>>>>>>>>>>>>>: ${widget.clickedItem['code']}");
    print("itunguui itunguui>>>>>>>>>>>>>>: ${widget.clickedItem['itunguui']}");

    AmatungoList.add({
      'value': widget.clickedItem['itunguui']?.toString() ?? '',
      'display':
          "${widget.clickedItem['code'] ?? ''} (${widget.clickedItem['name'] ?? ''})",
    });
    selectedAnimal = widget.clickedItem['itunguui']?.toString();

    fetchAboroziList();
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
                        " (" +
                        item[6].toString() +
                        (item[7] != null && item[7].toString().isNotEmpty
                            ? "/" + item[7].toString()
                            : "") +
                        ")",
                    'duty': item[9].toString(),
                  })
              .toList();

          Aborozi =
              AllListAborozi.where((u) => u['duty'] == 'Umworozi').toList();

          Abishingizi =
              AllListAborozi.where((u) => u['duty'] == 'Uhagarariye itungo')
                  .toList();

          // Auto-select first
          selectedFarmer = Aborozi.isNotEmpty ? Aborozi.first['select'] : null;
          selectedSupervisor =
              Abishingizi.isNotEmpty ? Abishingizi.first['select'] : null;
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
    if (selectedAnimal == null ||
        selectedFarmer == 'select' ||
        selectedSupervisor == 'select') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select all fields"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final abishing = (Abishingizi.firstWhere(
      (item) => item['value'] == selectedSupervisor,
      orElse: () => <String, String>{'display': ''},
    ))['display'];

    print("abish>>>>>>> $abishing ");

    if (selectedAnimal == null ||
        selectedAnimal!.isEmpty ||
        selectedFarmer == null ||
        selectedFarmer!.isEmpty ||
        selectedSupervisor == null ||
        selectedSupervisor!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content:
              Text("Hitamo itungo, umworozi n'umushingizi mbere yo kohereza"),
        ),
      );
      return;
    }

    if (selectedAnimal != null &&
        selectedFarmer != null &&
        selectedSupervisor != null) {
      setState(() {
        RagizaItungo(); // Save

        assignments.add({
          // display saved info
          "itungo": (AmatungoList.firstWhere(
            (item) => item['value'] == selectedAnimal,
            orElse: () => <String, String>{'display': ''},
          ))['display'],

          "umworozi": (Aborozi.firstWhere(
            (item) => item['value'] == selectedFarmer,
            orElse: () => <String, String>{'display': ''},
          ))['display'],
          "umwishingizi": (Abishingizi.firstWhere(
            (item) => item['value'] == selectedSupervisor,
            orElse: () => <String, String>{'name': ''},
          ))['name'],

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
              items: AmatungoList, // now contains value + display maps
              selectedValue: selectedAnimal,
              onChanged: (val) => setState(() => selectedAnimal = val),
            ),
            const SizedBox(height: 12),
            BorderedSearchDropdown(
              label: "Aborozi",
              items: [
                {
                  'value': 'select',
                  'display': '-- Select Aborozi --',
                },
                ...Aborozi.map((f) => {
                      'value': (f['abshuui'] ?? '').toString(),
                      'display': (f['name'] ?? '').toString(),
                    }),
              ],
              selectedValue: selectedFarmer,
              onChanged: (val) => setState(() => selectedFarmer = val),
            ),
            const SizedBox(height: 12),
            BorderedSearchDropdown(
              label: "Abishingizi",
              items: [
                {
                  'value': 'select',
                  'display': '-- Select Abishingizi --',
                },
                ...Abishingizi.map((f) => {
                      'value': (f['abshuui'] ?? '').toString(),
                      'display': (f['name'] ?? '').toString(),
                    }),
              ],
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

  void RagizaItungo() async {
    final uri = Uri.parse(ApiUrls.postIndagizo);

    try {
      // Send JSON instead of multipart
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'itunguui': selectedAnimal,
          'abshuui_umworoz': selectedFarmer,
          'abshuui_uhagariy': selectedSupervisor,
        }),
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Itungo Ryaragijwe",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 185, 79, 105),
            content: Text(
              "Itungo Ryaragijwe Abandi",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color.fromARGB(255, 204, 107, 17),
            content: Text(
              "Habayemo ikibazo",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Color.fromRGBO(244, 235, 54, 1),
          content: Text(
            "Network error",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
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
