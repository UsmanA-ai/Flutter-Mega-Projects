import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condition_report/provider/assessment_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class SelectSelctionScreen extends StatefulWidget {
  const SelectSelctionScreen({super.key});

  @override
  State<SelectSelctionScreen> createState() => _SelectSelctionScreenState();
}

class _SelectSelctionScreenState extends State<SelectSelctionScreen> {
  String? button; // Location dropdown value
  String? button1; // Sub-selection dropdown value
  List<String> dropdownItemList = [
    'Add own element',
    'Bathroom',
    'Bedroom 1',
    'Bedroom 2',
    'Bedroom 3',
    'Living room',
    'Kitchen',
    'Dining room',
    'Study',
    'Utility room',
    'External Elevation',
    'Loft',
    // Add more items here as needed
  ];
  List<String> dropdownItemList1 = ["Sub-item 1", "Sub-item 2", "Sub-item 3"];
  TextEditingController customElementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Select Selection",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
            color: Color.fromRGBO(57, 55, 56, 1),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Image.asset("assets/images/Filters (1).png"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select the location for the picture",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0X7F626262),
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField2<String>(
                value: button,
                hint: const Text("Select the Option"),
                items: dropdownItemList.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    button = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0X19626262),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    borderSide: const BorderSide(
                      color: Color(0X19626262),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    borderSide: const BorderSide(
                      color: Color(0X19626262),
                      width: 2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    borderSide: const BorderSide(
                      color: Color(0X19626262),
                      width: 2,
                    ),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.only(
                      left: 0, right: 16, top: 18, bottom: 18),
                ),
                isExpanded: true,
                isDense: true,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w300,
                  color: Color.fromRGBO(57, 55, 56, 1),
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              if (button == 'Add own element')
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: customElementController,
                    decoration: InputDecoration(
                      labelText: 'Enter your custom element',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              const Text(
                "Select the sub-selection",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0X7F626262),
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField2<String>(
                value: button1,
                hint: const Text("Select the Sub-option"),
                items: dropdownItemList1.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    button1 = value;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0X19626262),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    borderSide: const BorderSide(
                      color: Color(0X19626262),
                      width: 2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    borderSide: const BorderSide(
                      color: Color(0X19626262),
                      width: 2,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    borderSide: const BorderSide(
                      color: Color(0X19626262),
                      width: 2,
                    ),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.only(
                      left: 0, right: 16, top: 18, bottom: 18),
                ),
                isExpanded: true,
                isDense: true,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w300,
                  color: Color.fromRGBO(57, 55, 56, 1),
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(98, 98, 98, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            minimumSize: const Size(double.infinity, 60),
          ),
          onPressed: () {
            // Example Firestore logic
            FirebaseFirestore.instance
                .collection("assessment")
                .doc(currentId) // Replace with actual document ID
                .get()
                .then((snapshot) async {
              if (snapshot.exists) {
                var data = snapshot.data() as Map<String, dynamic>;
                var images = data['images'] as List<dynamic>?;

                if (images != null && images.isNotEmpty) {
                  var updatedImages = images.map((image) {
                    if (image is Map<String, dynamic>) {
                      image['location'] = button ?? "Default Location";
                    }
                    return image;
                  }).toList();

                  await FirebaseFirestore.instance
                      .collection("assessment")
                      .doc(currentId)
                      .update({'images': updatedImages});

                  log('Images updated successfully.');
                } else {
                  log('No images data found to update.');
                }
              } else {
                log('Document does not exist.');
              }
            }).catchError((error) {
              log('Error updating data: $error');
            });
          },
          child: const Text(
            "Save",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
