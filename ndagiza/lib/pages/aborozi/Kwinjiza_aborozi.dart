import 'dart:typed_data';
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/foundation.dart'; // for kIsWeb

import 'package:ndagiza/pages/aborozi/Aborozilist.dart';

class Kwinjiza_aborozi extends StatefulWidget {
  const Kwinjiza_aborozi({super.key});

  @override
  State<Kwinjiza_aborozi> createState() => _KwinjizaAboroziState();
}

class _KwinjizaAboroziState extends State<Kwinjiza_aborozi> {
  final TextEditingController _IzinaryababyeyiController =
      TextEditingController();
  final TextEditingController _IzinarindiController = TextEditingController();
  final TextEditingController igitsinaController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _phone2Controller = TextEditingController();
  final TextEditingController _icyoakoraController = TextEditingController();
  dynamic _selectedIcyoashinzwe;
  final List<Map<String, dynamic>> _ListIcyoashinzwe = [
    {'value': 1, 'text': 'Uhagarariye itungo'},
    {'value': 2, 'text': 'Umworozi'}
  ];

  final TextEditingController _locationController = TextEditingController();

  XFile? pickedImage;
  Uint8List? pickedImageBytes;

  List<PlatformFile> attachedFiles = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = image;
      });
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          pickedImageBytes = bytes;
        });
      }
    }
  }

  Future<void> _pickFile() async {
    if (attachedFiles.length >= 3) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        attachedFiles.add(result.files.first);
      });
    }
  }

  Widget _buildTextField(String label,
      {TextEditingController? controller,
      TextInputType? keyboardType,
      List<TextInputFormatter>? inputFormatters,
      bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.green[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildGenderSelector(TextEditingController igitsinaController) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.green.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Itsina",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade900,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'Female',
                      groupValue: igitsinaController.text,
                      onChanged: (String? value) {
                        setState(() {
                          igitsinaController.text = value!;
                        });
                      },
                    ),
                    const Text('Female'),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Radio<String>(
                      value: 'Male',
                      groupValue: igitsinaController.text,
                      onChanged: (String? value) {
                        setState(() {
                          igitsinaController.text = value!;
                        });
                      },
                    ),
                    const Text('Male'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    dynamic selectedValue,
    List<Map<String, dynamic>> options,
    void Function(dynamic) onChanged,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          hint: Text(label),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ongeramo Amakuru"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.08,
              vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Two fields in one row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Izina ryababyeyi',
                        controller: _IzinaryababyeyiController),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField('Izina rindi',
                        controller: _IzinarindiController),
                  ),
                ],
              ),
              // Another row of two fields
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Telefoni',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\+?\d*$')),
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildTextField(
                      'Indi Telefoni',
                      controller: _phone2Controller,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\+?\d*$')),
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                  ),
                ],
              ),

              // Gender selector full width
              _buildGenderSelector(igitsinaController),

              _buildTextField(
                'Nimero yirangamuntu',
                controller: _nidController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  LengthLimitingTextInputFormatter(16),
                ],
              ),

              _buildTextField('Icyo akora', controller: _icyoakoraController),

              _buildDropdownField(
                "Icyo ashinzwe *",
                _selectedIcyoashinzwe,
                _ListIcyoashinzwe,
                (val) {
                  setState(() {
                    _selectedIcyoashinzwe = val;
                  });
                },
              ),

              _buildTextField(
                'Aderesi:akarere/umurenge/Akagari/umudugudu',
                controller: _locationController,
              ),

              const SizedBox(height: 16),

              // Image picker & preview
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: pickedImage != null || pickedImageBytes != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: kIsWeb
                              ? Image.memory(pickedImageBytes!,
                                  fit: BoxFit.cover)
                              : Image.file(io.File(pickedImage!.path),
                                  fit: BoxFit.cover),
                        )
                      : Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.cloud_upload,
                                  size: 40, color: Colors.green[200]),
                              const SizedBox(height: 8),
                              const Text(
                                "Kanda hano uhitemo ifoto",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: const Icon(Icons.attach_file),
                  label: const Text("Shyiraho Dosiye (PDF/DOC)"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[200],
                    foregroundColor: Colors.green[900],
                  ),
                ),
              ),

              if (attachedFiles.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: attachedFiles.map((file) {
                      return ListTile(
                        leading: const Icon(Icons.insert_drive_file),
                        title: Text(file.name),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              attachedFiles.remove(file);
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _handleSubmit, //Submit the form
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Ohereza",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    final uri = Uri.parse('http://127.0.0.1:8080/aborozi/kwinjiza_aborozi');
    var request = http.MultipartRequest('POST', uri);

    // Add text fields
    request.fields['izina_ryababyeyi'] = _IzinaryababyeyiController.text;
    request.fields['izina_rindi'] = _IzinarindiController.text;
    request.fields['igitsina'] = igitsinaController.text;
    request.fields['nid'] = _nidController.text;
    request.fields['tel1'] = _phoneController.text;
    request.fields['tel2'] = _phone2Controller.text;
    request.fields['icyo_akora'] = _icyoakoraController.text;
    request.fields['icyo_ashinzwe'] = _ListIcyoashinzwe.firstWhere(
        (item) => item['value'] == _selectedIcyoashinzwe)['text'];
    request.fields['ahoatuye'] = _locationController.text;

    // Add image

    if (pickedImage != null) {
      if (kIsWeb) {
        final bytes = await pickedImage!.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: pickedImage!.name,
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            pickedImage!.path,
          ),
        );
      }
    }

// Add document file
    for (var file in attachedFiles) {
      if (kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'documents',
            file.bytes!,
            filename: file.name,
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            'documents',
            file.path!,
          ),
        );
      }
    }

    for (int i = 0; i < attachedFiles.length; i++) {
      final file = attachedFiles[i];

      final fieldName = 'documents[$i]';

      if (kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(
            fieldName,
            file.bytes!,
            filename: file.name,
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            fieldName,
            file.path!,
          ),
        );
      }
    }

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Amakuru yinjijwe neza",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ); // Wait for 1 second before navigating
        await Future.delayed(Duration(seconds: 1));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AboroziList()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Amakuru yinjijwe neza",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ); // Wait for 1 second before navigating
        await Future.delayed(Duration(seconds: 1));

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AboroziList()),
        );
      }
    } catch (e) {
      print("Error: $e");
      print('errorrrrrrrrrrr $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color.fromRGBO(244, 235, 54, 1),
          content: Text(
            "Network error",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
