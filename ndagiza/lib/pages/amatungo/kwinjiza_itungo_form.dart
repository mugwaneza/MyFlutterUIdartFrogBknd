import 'dart:convert';
import 'dart:io';
import 'dart:js_interop';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:ndagiza/models/Itungo_ukozororoka_model.dart';
import 'package:ndagiza/models/itungo_formsubmit_model.dart';
import 'package:ndagiza/models/itungo_isokoryaryo_model.dart';
import 'package:ndagiza/models/itungo_model.dart';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:ndagiza/models/itungo_ubuzimabwaryo_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:ndagiza/statics/ApiUrls.dart';
import 'package:path/path.dart' as path;
import 'dart:typed_data';

class kwinjiza_itungo_form extends StatelessWidget {
  const kwinjiza_itungo_form({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'NdagizaNange',
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon:
              Icon(Icons.arrow_back, color: Colors.white), // Change color here
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: MultiStepForm(),
    );
  }
}

class MultiStepForm extends StatefulWidget {
  const MultiStepForm({super.key});

  @override
  _MultiStepFormState createState() => _MultiStepFormState();
}

class _MultiStepFormState extends State<MultiStepForm> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  int _maxStepReached = 0; // Tracks the farthest step reached

  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    setState(() {
      formData.photoBytes = bytes; // for upload
      formData.photoName = picked.name; // filename
      formData.photoPath = picked.path; // local path (mobile only)
    });
  }

  // Data persistence across steps
  TextEditingController ibaraController = TextEditingController();
  TextEditingController ubukureController = TextEditingController();
  TextEditingController igitsinaController = TextEditingController();
  TextEditingController ifotoController = TextEditingController();
  final ValueNotifier<String?> _selectedGender = ValueNotifier(null);

// Data persistence across steps
  final SharedFormData formData = SharedFormData();
  void nextPage() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
        _maxStepReached =
            (_currentStep > _maxStepReached) ? _currentStep : _maxStepReached;
        // Updates max step only when moving forward
      });
      _pageController.animateToPage(
        _currentStep,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--; // Move back one step
        _maxStepReached =
            _currentStep; // Ensure previous steps turn gray progressively
      });
      _pageController.animateToPage(
        _currentStep,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center, // Centers everything
      children: [
        /// **Step Tabs**
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8), // Reduced padding
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStepIndicator("Itungo Rishya", 0),
              _buildStepIndicator("Imiterer y' Itungo", 1),
              _buildStepIndicator("Ibindi", 2),
            ],
          ),
        ),

        /// **Form Steps**
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              PersonalDetailsStep(
                nextPage,
                ibaraController,
                ubukureController,
                _selectedGender,
                formData,
                onPickImage: _pickImage, // pass down callback
              ),
              IDProofStep(
                onPrevious: previousPage,
                onNext: nextPage,
                formData: formData,
              ),
              IbindiDetailsStep(
                onPrevious: previousPage,
                formData: formData,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// **Step Indicator with Dynamic Underline**
  Widget _buildStepIndicator(String title, int stepIndex) {
    bool isActive = _currentStep == stepIndex;
    bool isVisited = _maxStepReached >= stepIndex;
    Color underlineColor =
        isActive || isVisited ? Colors.green : Colors.grey[300]!;

    return Column(
      mainAxisSize: MainAxisSize.min, // Ensures minimal space
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.green : Colors.grey,
          ),
        ),
        SizedBox(height: 2), // Reduced spacing
        Container(
          height: 3,
          width: _textWidth(title) + 20,
          color: underlineColor,
        ),
      ],
    );
  }

  /// **Calculate text width dynamically**
  double _textWidth(String text) {
    TextPainter painter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.width;
  }
}

class SharedFormData {
  String? ibara;
  double? ubukure;
  String? igitsina;
// Image-related:
  Uint8List? photoBytes; // preview & bytes to upload
  String? photoName; // original filename
  String? photoPath; // saved path (mobile real path, web pseudo path)

  dynamic selectedCategory;
  dynamic selectedUbwokobwitungo;
  dynamic category;
  double? amafaranga_rihagaze;
  dynamic ukozruui;
  dynamic uzmuui;
  dynamic selectedIsoko;
  String? categoryText;
  String? itariki_ribyariye;
  String? itariki_ryimiye;
  String? itariki_rivukiye;
  String? ibisobanuro;
}

/// **Step 1 - Personal Details**
class PersonalDetailsStep extends StatelessWidget {
  final VoidCallback onNext;
  final TextEditingController ibaraController;
  final TextEditingController ubukureController;
  final SharedFormData formData;
  final VoidCallback onPickImage;
  final ValueNotifier<String?> selectedGender;

  const PersonalDetailsStep(
    this.onNext,
    this.ibaraController,
    this.ubukureController,
    this.selectedGender,
    this.formData, {
    super.key,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Injiza Umwirondoro w'Itungo *",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildTextField(
            "Ibara ry'itungo *",
            ibaraController,
            keyboardType: TextInputType.text,
            inputFormatters: [
              LengthLimitingTextInputFormatter(20),
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
          ),
          _buildTextField(
            "Ubukure (mumezi)",
            ubukureController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              LengthLimitingTextInputFormatter(6),
            ],
          ),
          SizedBox(height: 10),
          Text(
            "Ifoto y'ítungo *",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: onPickImage,
            child: Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: formData.photoBytes != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          Image.memory(formData.photoBytes!, fit: BoxFit.cover),
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cloud_upload,
                              size: 40, color: Colors.green[200]),
                          SizedBox(height: 8),
                          Text("Kanda hano uhitemo ifoto",
                              style:
                                  TextStyle(color: Colors.green, fontSize: 14)),
                        ],
                      ),
                    ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final messenger = ScaffoldMessenger.of(context);
              void showError(String msg) {
                messenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(msg),
                      backgroundColor: Colors.red,
                    ),
                  );
              }

              final ubukure = double.tryParse(ubukureController.text);

              // Validation
              if (ibaraController.text.trim().isEmpty) {
                showError("Ibara ry'itungo rirakenewe");
                return;
              } else if (ubukure == null || ubukure <= 0) {
                showError("Shyiramo ubukure bwemewe (burenze 0)");
                return;
              } else if (formData.photoBytes == null) {
                showError("Ifoto y'itungo irakenewe");
                return;
              }

              // Fill formData fields from controllers
              formData.ibara = ibaraController.text.trim();
              formData.ubukure = ubukure;

              onNext(); // navigate to the next step
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 20, 105, 20),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            child: Text("Komeza", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    required TextInputType keyboardType,
    required List<TextInputFormatter> inputFormatters,
  }) {
    return Container(
      width: 280,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.green[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

/// **Step 2 - ID Proof**

class IDProofStep extends StatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final SharedFormData formData;

  const IDProofStep(
      {super.key,
      required this.onPrevious,
      required this.onNext,
      required this.formData});

  @override
  State<IDProofStep> createState() => _IDProofStepState();
}

class _IDProofStepState extends State<IDProofStep> {
  final TextEditingController _imyakayokororokaController =
      TextEditingController();
  final TextEditingController _amaeziibyariraController =
      TextEditingController();
  dynamic _selectedCategory;
  dynamic _selectedUbwokobwitungo;
  dynamic _selectedIgitsina;
  String? _selectedText;

  final List<Map<String, dynamic>> _categories = [];
  final List<Map<String, dynamic>> _ubwokobwitungo = [];
  final List<Map<String, dynamic>> listIgitsinaInka = [
    {'value': 'Inyana', 'text': 'Inyana'},
    {'value': 'Ijigija', 'text': 'Ijigija'},
    {'value': 'Imbyeyi', 'text': 'Imbyeyi'},
    {'value': 'Imfizi', 'text': 'Imfizi'},
  ];
  final List<Map<String, dynamic>> listIgitsinaIhene = [
    {'value': 'Ishashi', 'text': 'Ishashi'},
    {'value': 'Ijigija', 'text': 'Ijigija'},
    {'value': 'Isekurume', 'text': 'Isekurume'},
  ];

  bool isUbwokobwitungoAvailable = false;
  bool isImyakayokororokaAvailable = false;

  @override
  void initState() {
    super.initState();
    fetchIcyiciroList();
  }

  Future<void> fetchIcyiciroList() async {
    // get list of icyiciro cy'inka
    try {
      final response = await http.get(Uri.parse(ApiUrls.IcyiciroCyamatungo));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          _categories.clear();
          _categories.addAll(data
              .map((item) => {'text': item[1].toString(), 'value': item[0]}));
        });
      } else {
        // Handle error
        print('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchUbwokobwitungoList() async {
    //get list of ubwoko bw'inka based on selected icyiciro
    try {
      setState(() {
        _ubwokobwitungo.clear(); // Clear while waiting
        isUbwokobwitungoAvailable = false;
      });
      final response = await http
          .get(Uri.parse('${ApiUrls.Ibwokobwamatungo}/$_selectedCategory'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          if (data.isNotEmpty) {
            _ubwokobwitungo.addAll(data
                .map((item) => {'text': item[1].toString(), 'value': item[0]}));
            isUbwokobwitungoAvailable = true;
          } else {
            _ubwokobwitungo.clear();
            isUbwokobwitungoAvailable = false;
          }
        });
      } else {
        // Handle error
        print('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> fetchImyakayokororokaList() async {
    //Get the data of Imyororocyere based on selected Icyiciro
    try {
      setState(() {
        _imyakayokororokaController.clear(); // Clear while waiting
        isImyakayokororokaAvailable = false;
      });
      final response = await http.get(
          Uri.parse('${ApiUrls.ImyakayoKororoka}/$_selectedUbwokobwitungo'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        setState(() {
          if (data.isNotEmpty) {
            _imyakayokororokaController.text = data[0][0].toString();
            _amaeziibyariraController.text = data[0][1].toString();
            isImyakayokororokaAvailable = true;
          } else {
            _imyakayokororokaController.clear();
            isImyakayokororokaAvailable = false;
          }
        });
      } else {
        // Handle error
        print('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDropdownField(
            "Icyiciro cy’itungo *",
            _selectedCategory,
            _categories,
            (val) {
              setState(() {
                _selectedCategory = val;
                _selectedIgitsina = null; //Reset Inka igitsina dropdown
                final selected = _categories.firstWhere(
                  (e) => e['value'] == val,
                  orElse: () => {},
                );

                _selectedText = selected['text'];

                _selectedUbwokobwitungo = null;
                _imyakayokororokaController.text = '';
                _amaeziibyariraController.text = '';
              });
              fetchUbwokobwitungoList();
            },
          ),
          if (_selectedText == 'Inka')
            _buildDropdownField(
              "Igitsina cy’inka *",
              _selectedIgitsina,
              listIgitsinaInka,
              (val) {
                setState(() {
                  _selectedIgitsina = val;
                  widget.formData.igitsina = val;
                  widget.formData.categoryText = _selectedText;
                });
              },
            ),
          if (_selectedText == 'Ihene')
            _buildDropdownField(
              "Igitsina cy’ihene *",
              _selectedIgitsina,
              listIgitsinaIhene,
              (val) {
                setState(() {
                  _selectedIgitsina = val;
                  widget.formData.igitsina = val;
                  widget.formData.categoryText = _selectedText;
                  print('igitsia>>>>>, $val');
                });
              },
            ),
          Visibility(
              visible: isUbwokobwitungoAvailable,
              child: _buildDropdownField(
                "Ubwoko bw’itungo *",
                _selectedUbwokobwitungo,
                _ubwokobwitungo,
                (val) {
                  setState(() {
                    _selectedUbwokobwitungo = val;
                    _imyakayokororokaController.text = '';
                    _amaeziibyariraController.text = '';
                  });
                  fetchImyakayokororokaList();
                },
              )),
          Visibility(
              visible: isImyakayokororokaAvailable,
              child: _buildTextField(
                "Ribyara rimaze imyaka: *",
                controller: _imyakayokororokaController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                enabled: false,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  LengthLimitingTextInputFormatter(6),
                ],
              )),
          Visibility(
            visible: isImyakayokororokaAvailable,
            child: _buildTextField(
              "Amezi ibyarira: *",
              controller: _amaeziibyariraController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              enabled: false,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                LengthLimitingTextInputFormatter(6),
              ],
            ),
          ),
          SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: widget.onPrevious, child: Text("Subira inyuma")),
              SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {
                    final messenger = ScaffoldMessenger.of(context);
                    void showError(String msg) {
                      messenger
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(msg),
                            backgroundColor: Colors.red,
                          ),
                        );
                    }

                    if (_selectedCategory == null) {
                      showError("Hitamo icyiciro cy’itungo");
                      return;
                    } else if (_selectedIgitsina == null) {
                      showError("Hitamo igitsina cy’itungo");
                      return;
                    } else if (isUbwokobwitungoAvailable &&
                        _selectedUbwokobwitungo == null) {
                      showError("Hitamo ubwoko bw’itungo");
                      return;
                    } else if (isImyakayokororokaAvailable &&
                        _imyakayokororokaController.text.trim().isEmpty) {
                      showError("Imyaka yo kororoka irakenewe");
                      return;
                    } else if (isImyakayokororokaAvailable &&
                        _amaeziibyariraController.text.trim().isEmpty) {
                      showError("Amezi ibyarira arakenewe");
                      return;
                    }
                    // Save only after validation passes
                    widget.formData.selectedUbwokobwitungo =
                        _selectedUbwokobwitungo;
                    widget.formData.category = _categories.firstWhere(
                        (item) => item['value'] == _selectedCategory)['text'];
                    widget.formData.igitsina = _selectedIgitsina;
                    widget.formData.categoryText = _selectedText;
                    widget.onNext();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 20, 105, 20),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: Text("Komeza", style: TextStyle(color: Colors.white))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    TextEditingController? controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool enabled = true,
  }) {
    return Stack(
      children: [
        Container(
          width: 280,
          margin: EdgeInsets.symmetric(vertical: 12),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            enabled: enabled,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.green[100],
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),
        ),

        /// 🔖 Top-edge label
        Positioned(
          left: 16,
          top: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            color: Colors.green[100],
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    dynamic selectedValue,
    List<Map<String, dynamic>> options,
    void Function(dynamic) onChanged,
  ) {
    return Stack(
      children: [
        Container(
          width: 280,
          margin: EdgeInsets.symmetric(vertical: 12),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<dynamic>(
              hint: Text("Hitamo"),
              value: selectedValue,
              isExpanded: true,
              items: options.map((item) {
                return DropdownMenuItem<dynamic>(
                  value: item['value'],
                  child: Text(item['text']),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),

        /// 🔖 Top-edge label
        Positioned(
          left: 16,
          top: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            color: Colors.green[100],
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// **Step 3 - other Details**

class IbindiDetailsStep extends StatefulWidget {
  final VoidCallback onPrevious;
  final SharedFormData formData;

  const IbindiDetailsStep({
    super.key,
    required this.onPrevious,
    required this.formData,
  });

  @override
  State<IbindiDetailsStep> createState() => _IbindiDetailsStepState();
}

class _IbindiDetailsStepState extends State<IbindiDetailsStep> {
  String? _selectedUkozororoka;
  String? _selectedUbuzimabwazo;
  String? _selectedIsoko;
  List<Map<String, dynamic>> _ListUkozororoka = [];
  List<Map<String, dynamic>> _ListUbuzimabwazo = [];
  List<Map<String, dynamic>> _ListIsoko = [];
  final TextEditingController _ItarikiyokwimaDateController =
      TextEditingController();
  final TextEditingController _ItarikiRyabyariyeDateController =
      TextEditingController();
  final TextEditingController _ItarikiRyavukiyehoDateController =
      TextEditingController();
  final TextEditingController _IbisobanuroUbuzimabwaryoController =
      TextEditingController();

  final TextEditingController _amountController = TextEditingController();

  DateTime? _selectedDate;

  MediaType? getImageMediaType(String? filename) {
    if (filename == null) return null;

    final ext = filename.toLowerCase().split('.').last;

    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUkozororokaList();
    fetchUbuzimabwazoList();
    fetchIsokoryayoList();
  }

  Future<void> fetchUkozororokaList() async {
    final response = await http.get(Uri.parse(ApiUrls.Ukozororoka));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      setState(() {
        _ListUkozororoka.clear();
        _ListUkozororoka.addAll(
            data.map((item) => {'text': item[1].toString(), 'value': item[0]}));
      });
    } else {
      // Handle error
      print('Failed to load data');
    }
  }

  Future<void> fetchUbuzimabwazoList() async {
    final response = await http.get(Uri.parse(ApiUrls.UbuzimaBwayo));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      setState(() {
        _ListUbuzimabwazo.clear();
        _ListUbuzimabwazo.addAll(
            data.map((item) => {'text': item[1].toString(), 'value': item[0]}));
      });
    } else {
      // Handle error
      print('Failed to load data');
    }
  }

  Future<void> fetchIsokoryayoList() async {
    final response = await http.get(Uri.parse(ApiUrls.Isokoryayo));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      setState(() {
        _ListIsoko.clear();
        _ListIsoko.addAll(
            data.map((item) => {'text': item[1].toString(), 'value': item[0]}));
      });
    } else {
      // Handle error
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? selectedUkozororokaText = _ListUkozororoka.firstWhere(
      (e) => e['value'] == _selectedUkozororoka,
      orElse: () => {},
    )['text'];

    String? selectedUbuzimabwaryoText = _ListUbuzimabwazo.firstWhere(
      (e) => e['value'] == _selectedUbuzimabwazo,
      orElse: () => {},
    )['text'];

    String? selectedUbugureBwaryoText = _ListIsoko.firstWhere(
      (e) => e['value'] == _selectedIsoko,
      orElse: () => {},
    )['text'];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Ubusobanuro bwimbitse",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          if (widget.formData.categoryText == 'Ihene' &&
              widget.formData.igitsina != 'Isekurume')
            _buildDropdownField(
              "Uko Itungo ryororoka *",
              _selectedUkozororoka,
              _ListUkozororoka.where((e) =>
                      e['text'] != 'Ni impfizi' &&
                      e['text'] !=
                          'Ni isekurume') //List Filtered Ihene yishashi Ukozororoka
                  .toList(),
              (val) {
                setState(() {
                  _selectedUkozororoka = val;
                  _ItarikiyokwimaDateController.clear(); // optional reset
                  _ItarikiRyabyariyeDateController.clear();
                  _ItarikiRyavukiyehoDateController.clear();
                });
              },
            ),
          if (selectedUkozororokaText == 'Ryimye' ||
              selectedUkozororokaText == 'Rirahaka')
            _buildDatePickerField(
              "Itariki ryimiyeho *",
              _ItarikiyokwimaDateController,
            ),
          if (selectedUkozororokaText == 'Ryabyaye' ||
              selectedUkozororokaText == 'Rironsa')
            _buildDatePickerField(
              "Itariki Ryabyariyeho *",
              _ItarikiRyabyariyeDateController,
            ),
          if (selectedUkozororokaText == 'Ntirirakura')
            _buildDatePickerField(
              "Itariki Ryavukiyeho",
              _ItarikiRyavukiyehoDateController,
            ),
          if (widget.formData.categoryText == 'Ihene' &&
              widget.formData.igitsina == 'Isekurume')
            _buildDropdownField(
              "Uko Itungo ryororoka *",
              _selectedUkozororoka,
              _ListUkozororoka.where((e) =>
                      e['text'] == 'Ni isekurume' ||
                      e['text'] ==
                          'Ntirirakura') //List Filtered Ihene yisekurume Ukozororoka
                  .toList(),
              (val) {
                setState(() {
                  _selectedUkozororoka = val;
                });
              },
            ),
          if (widget.formData.categoryText == 'Inka' &&
              widget.formData.igitsina != 'Imfizi')
            _buildDropdownField(
              "Uko itungo ryororoka *",
              _selectedUkozororoka,
              _ListUkozororoka.where((e) =>
                      e['text'] != 'Ni impfizi' &&
                      e['text'] !=
                          'Ni isekurume') //List Filtered Inka yishashi Ukozororoka
                  .toList(),
              (val) {
                setState(() {
                  _selectedUkozororoka = val;
                });
              },
            ),
          if (widget.formData.categoryText == 'Inka' &&
              widget.formData.igitsina == 'Imfizi')
            _buildDropdownField(
              "Uko itungo ryororoka *",
              _selectedUkozororoka,
              _ListUkozororoka.where((e) =>
                      e['text'] == 'Ni impfizi' ||
                      e['text'] ==
                          'Ntirirakura') //List Filtered Inka yimfizi Ukozororoka
                  .toList(),
              (val) {
                setState(() {
                  _selectedUkozororoka = val;
                });
              },
            ),
          _buildDropdownField(
            "Ubuzima bw'azo *",
            _selectedUbuzimabwazo,
            _ListUbuzimabwazo.where((e) =>
                    e['text'] == 'Ni rizima' ||
                    e['text'] == 'Ryavunitse' ||
                    e['text'] == 'Rirarwaye') //List Filtered ubuzima bwamatungo
                .toList(),
            (val) {
              if (_selectedUkozororoka == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Banza uhitemo uko itungo ryororoka!'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              // Only update state if validation passes
              setState(() {
                _selectedUbuzimabwazo = val;
                _IbisobanuroUbuzimabwaryoController.clear();
              });
            },
          ),
          if (selectedUbuzimabwaryoText == "Ryavunitse" ||
              selectedUbuzimabwaryoText == "Rirarwaye")
            _buildTextField(
              "Ibisobanuro kukuvuzwa *",
              _IbisobanuroUbuzimabwaryoController,
              keyboardType: TextInputType.text,
              inputFormatters: [
                LengthLimitingTextInputFormatter(100),
              ],
            ),
          _buildDropdownField(
            "Aho ryaturutse *",
            _selectedIsoko,
            _ListIsoko.where((e) =>
                    e['text'] == 'Ni impano' ||
                    e['text'] == 'Ni iryavutse' ||
                    e['text'] == 'Ryaguzwe') //List Filtered  Ibijyanye n'isoko
                .toList(), // pass the list as it is
            (val) {
              if (_selectedUkozororoka == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Banza uhitemo uko itungo ryororoka!'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              setState(() {
                _selectedIsoko = val;
                _amountController.clear();
              });
            },
          ),
          if (selectedUbugureBwaryoText == "Ryaguzwe")
            _buildTextField(
              "Amafaranga ryaguzwe (Rwf) *",
              _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                LengthLimitingTextInputFormatter(6),
              ],
            ),
          SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: widget.onPrevious, child: Text("Subira inyuma")),
              SizedBox(width: 10),
              ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 20, 105, 20),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child:
                      Text("Ohereza", style: TextStyle(color: Colors.white))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    required TextInputType keyboardType,
    required List<TextInputFormatter> inputFormatters,
  }) {
    return Container(
      width: 280,
      margin: EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.green[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    dynamic selectedValue,
    List<Map<String, dynamic>> options,
    void Function(dynamic) onChanged,
  ) {
    return Stack(
      children: [
        Container(
          width: 280,
          margin: EdgeInsets.symmetric(vertical: 12),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<dynamic>(
              hint: Text("Hitamo"),
              value: selectedValue,
              isExpanded: true,
              items: options.map((item) {
                return DropdownMenuItem<dynamic>(
                  value: item['value'],
                  child: Text(item['text']),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),

        /// 🔖 Top-edge label
        Positioned(
          left: 16,
          top: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            color: Colors.green[100],
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField(
    String label,
    TextEditingController controller,
  ) {
    return Stack(
      children: [
        Container(
          width: 280,
          margin: EdgeInsets.symmetric(vertical: 12),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
          child: InkWell(
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );

              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                  controller.text =
                      "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                });
              }
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    controller.text.isEmpty
                        ? "Hitamo itariki"
                        : controller.text,
                    style: TextStyle(
                      color: controller.text.isEmpty
                          ? Colors.black54
                          : Colors.black,
                    ),
                  ),
                ),
                Icon(Icons.calendar_month, color: Colors.grey[700]),
              ],
            ),
          ),
        ),

        /// 🔖 Top-edge label
        Positioned(
          left: 16,
          top: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            color: Colors.green[100], // same as field bg
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() async {
    final messenger = ScaffoldMessenger.of(context);
    void showError(String msg) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
    }

    // Resolve selected texts
    final selectedUkozororokaText = _ListUkozororoka.firstWhere(
      (e) => e['value'] == _selectedUkozororoka,
      orElse: () => {},
    )['text'];

    final selectedUbuzimabwaryoText = _ListUbuzimabwazo.firstWhere(
      (e) => e['value'] == _selectedUbuzimabwazo,
      orElse: () => {},
    )['text'];

    final selectedIsokoText = _ListIsoko.firstWhere(
      (e) => e['value'] == _selectedIsoko,
      orElse: () => {},
    )['text'];

    // ---- VALIDATIONS ----

    // Uko yororoka
    if (_selectedUkozororoka == null) {
      showError("Hitamo uko itungo yororoka");
      return;
    }

    // if ((selectedUkozororokaText == 'Ryimye' ||
    //         selectedUkozororokaText == 'Rirahaka') &&
    //     _ItarikiyokwimaDateController.text.trim().isEmpty) {
    //   showError("Itariki ryimiyeho irakenewe");
    //   return;
    // }

    // if ((selectedUkozororokaText == 'Ryabyaye' ||
    //         selectedUkozororokaText == 'Rironsa') &&
    //     _ItarikiRyabyariyeDateController.text.trim().isEmpty) {
    //   showError("Itariki ryabyariyeho irakenewe");
    //   return;
    // }

    // Itariki ryavukiyeho
    //    if (selectedUkozororokaText == 'Ntirirakura' &&
    //     _ItarikiRyavukiyehoDateController.text.trim().isEmpty) {
    //   showError("Itariki ryavukiyeho irakenewe");
    //   return;
    //  }

    else if (_selectedUbuzimabwazo == null) {
      showError("Hitamo ubuzima bw’azo");
      return;
    } else if ((selectedUbuzimabwaryoText == 'Ryavunitse' ||
            selectedUbuzimabwaryoText == 'Rirarwaye') &&
        _IbisobanuroUbuzimabwaryoController.text.trim().isEmpty) {
      showError("Andika ibisobanuro by'ubuzima bw’azo");
      return;
    } else if (_selectedIsoko == null) {
      showError("Hitamo aho itungo ryaturutse");
      return;
    } else if (selectedIsokoText == 'Ryaguzwe' &&
        _amountController.text.trim().isEmpty) {
      showError("Shyiramo amafaranga ryaguzwe");
      return;
    }

    widget.formData.ukozruui = _selectedUkozororoka;
    widget.formData.uzmuui = _selectedUbuzimabwazo;
    widget.formData.itariki_ryimiye =
        _ItarikiyokwimaDateController.text.trim().isEmpty
            ? null
            : _ItarikiyokwimaDateController.text.trim();

    widget.formData.itariki_ribyariye =
        _ItarikiRyabyariyeDateController.text.trim().isEmpty
            ? null
            : _ItarikiRyabyariyeDateController.text.trim();

    widget.formData.itariki_rivukiye =
        _ItarikiRyavukiyehoDateController.text.trim().isEmpty
            ? null
            : _ItarikiRyavukiyehoDateController.text.trim();

    widget.formData.ibisobanuro =
        _IbisobanuroUbuzimabwaryoController.text.trim().isEmpty
            ? null
            : _IbisobanuroUbuzimabwaryoController.text.trim();

    widget.formData.selectedIsoko = _selectedIsoko;

    widget.formData.amafaranga_rihagaze = _amountController.text.trim().isEmpty
        ? null
        : double.tryParse(_amountController.text.trim());

    final data = widget.formData;
    final url = Uri.parse(ApiUrls.RegisterNewPets); //Url for  registration
    debugFormData();

    final submission = FormSubmission(
      itungo: Itungo(
        itunguui_imyruui: data.selectedUbwokobwitungo,
        igitsina: data.igitsina!,
        ubukure: data.ubukure!,
        itngcode: data.category,
        ibara: data.ibara!,
      ),
      isokoryaryo: ItungoIsokoryaryo(
        itunguui: '',
        amafaranga_rihagaze: data.amafaranga_rihagaze,
        isoko: data.selectedIsoko!,
      ),
      ubuzimabwaryo: ItungoUbuzimabwaryo(
        itunguui: '',
        uzmuui: data.uzmuui!,
        ibisobanuro: data.ibisobanuro ?? '',
      ),
      ukozororoka: ItungoUkozororoka(
        itunguui: '',
        ukozruui: data.ukozruui!,
        itari_ryimiye: data.itariki_ryimiye ?? '',
        itariki_ribyariye: data.itariki_ribyariye ?? '',
        itariki_rivukiye: data.itariki_rivukiye ?? '',
        igitsina_cyavutse:
            selectedUkozororokaText == 'Ryabyaye' ? data.igitsina : null,
      ),
    );

    try {
      final request = http.MultipartRequest('POST', url);
      //Add JSON body as a field
      request.fields['itungo'] = jsonEncode(submission.itungo.toJson());
      request.fields['ukozororoka'] =
          jsonEncode(submission.ukozororoka.toJson());
      request.fields['ubuzimabwaryo'] =
          jsonEncode(submission.ubuzimabwaryo.toJson());
      request.fields['isokoryaryo'] =
          jsonEncode(submission.isokoryaryo.toJson());

      if (data.photoBytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'photo',
            data.photoBytes!, // <-- Uint8List
            filename: data.photoName,
          ),
        );
      }
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print("Status code: ${response.statusCode}");
      print("Response body: $responseBody");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        //  Reset fields
        setState(() {
          widget.formData.igitsina = null;
          widget.formData.photoPath = null;
          widget.formData.ubukure = null;
          widget.formData.category = '';
          data.ibara = null;
          widget.formData.amafaranga_rihagaze = null;
          widget.formData.selectedUbwokobwitungo = null;
          widget.formData.selectedIsoko = null;
          widget.formData.uzmuui = null;
          widget.formData.ukozruui = null;
          setState(() {
            widget.formData.photoPath = null;
            widget.formData.photoBytes = null;
          });
          _selectedUkozororoka = null;
          _selectedUbuzimabwazo = null;
          _selectedIsoko = null;
          _ItarikiyokwimaDateController.clear();
          _ItarikiRyabyariyeDateController.clear();
          _ItarikiRyavukiyehoDateController.clear();
        });
        // Success
        print("Data submitted successfully");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Amakuru yinjijwe neza",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      } else {
        // Error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Kwinjiza amakuru byanze",
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } on Exception catch (e) {
      print("Exception: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromRGBO(244, 235, 54, 1),
          content: Text(
            "Network error",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } catch (e, stackTrace) {
      print("Unknown error: $e");
      print("Stack trace:\n$stackTrace");
    }
  }

  void debugFormData() {
    final formData = widget.formData; // shortcut

    print("===== FORM DATA DEBUG =====");

    print("selectedUbwokobwitungo: ${formData.selectedUbwokobwitungo}");
    print("igitsina: ${formData.igitsina}");
    print("ubukure: ${formData.ubukure}");
    print("category: ${formData.category}");
    print("ibara: ${formData.ibara}");
    print("amafaranga_rihagaze: ${formData.amafaranga_rihagaze}");
    print("selectedIsoko: ${formData.selectedIsoko}");
    print("uzmuui: ${formData.uzmuui}");
    print("ibisobanuro: ${formData.ibisobanuro}");
    print("ukozruui: ${formData.ukozruui}");
    print("itari_ryimiye: ${formData.itariki_ryimiye}");
    print("itariki_ribyariye: ${formData.itariki_ribyariye}");
    print("itariki_rivukiye: ${formData.itariki_rivukiye}");
    print("igitsina_cyavutse: ${formData.igitsina}");
    print("photoBytes: ${formData.photoBytes != null ? "has photo" : "null"}");
    print("photoName: ${formData.photoName}");

    print("===========================");
  }
}
