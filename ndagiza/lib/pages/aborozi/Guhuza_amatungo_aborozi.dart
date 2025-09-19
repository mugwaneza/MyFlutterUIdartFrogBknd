import 'package:flutter/material.dart';

class Guhuza_amatungo_aborozi extends StatefulWidget {
  const Guhuza_amatungo_aborozi({super.key});

  @override
  State<Guhuza_amatungo_aborozi> createState() =>
      _Guhuza_amatungo_aboroziState();
}

class _Guhuza_amatungo_aboroziState extends State<Guhuza_amatungo_aborozi> {
  final List<String> animals = [
    "Cow",
    "Goat",
    "Sheep",
    "Dog",
    "Cat",
    "Horse",
    "Donkey"
  ];
  final List<String> farmers = ["Farmer A", "Farmer B", "Farmer C", "Farmer D"];
  final List<String> supervisors = [
    "Supervisor X",
    "Supervisor Y",
    "Supervisor Z"
  ];

  String? selectedAnimal;
  String? selectedFarmer;
  String? selectedSupervisor;

  final List<Map<String, dynamic>> assignments = [];

  void assignAnimal() {
    if (selectedAnimal != null &&
        selectedFarmer != null &&
        selectedSupervisor != null) {
      setState(() {
        assignments.add({
          "animal": selectedAnimal,
          "farmer": selectedFarmer,
          "supervisor": selectedSupervisor,
          "date": DateTime.now(),
        });
        selectedAnimal = null;
        selectedFarmer = null;
        selectedSupervisor = null;
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
        title: const Text(
          "Guhuza Amatungo n'Aborozi",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Animal combo
            BorderedSearchDropdown(
              label: "Animal",
              items: animals,
              selectedValue: selectedAnimal,
              onChanged: (val) => setState(() => selectedAnimal = val),
            ),
            const SizedBox(height: 12),
            // Farmer combo
            BorderedSearchDropdown(
              label: "Farmer",
              items: farmers,
              selectedValue: selectedFarmer,
              onChanged: (val) => setState(() => selectedFarmer = val),
            ),
            const SizedBox(height: 12),
            // Supervisor combo
            BorderedSearchDropdown(
              label: "Supervisor",
              items: supervisors,
              selectedValue: selectedSupervisor,
              onChanged: (val) => setState(() => selectedSupervisor = val),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: assignAnimal,
              icon: const Icon(Icons.check),
              label: const Text("Assign"),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: assignments.isEmpty
                  ? const Center(child: Text("No assignments yet"))
                  : ListView.builder(
                      itemCount: assignments.length,
                      itemBuilder: (context, index) {
                        final a = assignments[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(Icons.pets),
                            title: Text("${a['animal']} assigned"),
                            subtitle: Text(
                              "Farmer: ${a['farmer']}\n"
                              "Supervisor: ${a['supervisor']}\n"
                              "Date: ${a['date'].toString().split('.')[0]}",
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

/// Custom widget: one rectangle containing search + dropdown
class BorderedSearchDropdown extends StatefulWidget {
  final String label;
  final List<String> items;
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
    // Filter items
    final filteredItems = widget.items
        .where((item) => item.toLowerCase().contains(search.toLowerCase()))
        .toList();

    // Auto-select first match if current value invalid
    final selected = filteredItems.contains(widget.selectedValue)
        ? widget.selectedValue
        : (filteredItems.isNotEmpty ? filteredItems.first : null);

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
            items: filteredItems
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}
