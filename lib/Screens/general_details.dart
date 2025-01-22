import 'dart:io';
import 'package:condition_report/Screens/condition_report.dart';
import 'package:condition_report/Screens/outstanding_photos..dart';
import 'package:condition_report/Screens/photo_stream.dart';
import 'package:condition_report/models/general_details_model.dart';
import 'package:condition_report/provider/assessment_provider.dart';
import 'package:condition_report/services/firestore_services.dart';
import 'package:condition_report/services/supabase_services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class GeneralDetails extends StatefulWidget {
  const GeneralDetails({super.key});

  @override
  State<GeneralDetails> createState() => _GeneralDetailsState();
}

class _GeneralDetailsState extends State<GeneralDetails> {
  final TextEditingController _refNoController = TextEditingController();
  final TextEditingController _myRefController = TextEditingController();
  final TextEditingController _houseNameController = TextEditingController();
  final TextEditingController _houseNoController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _localiityController = TextEditingController();
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  final TextEditingController _assessmentDateController =
      TextEditingController();
  String? selectedRegion; // Holds the currently selected value
  String? selectedProperty; // Holds the currently selected value

  bool isAdded = false; // State to track if "Add" button is pressed
  String? elementName;

  String? button1;
  final List<String> items = ['Yes', 'No'];
  final List<String> region = [
    'England',
    'Wales',
    'Scotland',
    'Northern Ireland'
  ];
  String? button2;
  final List<String> items2 = ['Item 1', 'Item 2', 'Item 3'];
  final formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  List<String> imagePaths = [];
  List<DateTime> imageDates = [];
  String? selectedImagePath;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(source: source);
      if (photo == null) return; // User canceled image picking

      // Capture the current date and time when the image is picked
      DateTime imageDateTime = DateTime.now();

      // Add the image path to the list
      setState(() {
        imagePaths.add(photo.path);
        imageDates.add(imageDateTime);
      });

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => OutstandingPhotos(imagePaths: imagePaths),
      //   ),
      // );

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => PhotoStreamScreen(
      //       imagePaths: imagePaths,
      //       imageDates: imageDates,
      //     ),
      //   ),
      // );
    } catch (e) {
      print('Error picking or processing image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            top: 20,
            bottom: 12,
          ),
          child: SizedBox(
            height: 24,
            width: 24,
            child: IconButton(
              padding: const EdgeInsets.all(0.0),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConditionReport()),
                );
              },
              icon: SvgPicture.asset(
                "assets/images/Icon (2).svg",
                height: 24,
                width: 24,
              ),
            ),
          ),
        ),
        title: const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 12),
          child: Text(
            "General Details",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              fontStyle: FontStyle.normal,
              color: Color.fromRGBO(57, 55, 56, 1),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 24,
            ),
            child: IconButton(
              padding: const EdgeInsets.all(0.0),
              color: const Color.fromRGBO(57, 55, 56, 1),
              onPressed: () {},
              icon: Image.asset(
                "assets/images/Filters (1).png",
                scale: 1.0,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, bottom: 20),
        child: Container(
          height: 60,
          width: 364,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          child: FilledButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                const Color.fromRGBO(98, 98, 98, 1),
              ),
            ),
            onPressed: () async {
              // Check if form is valid
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();

                // Show the loading dialog
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // Prevent dismissing the dialog manually
                  builder: (context) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            CircularProgressIndicator(color: Colors.black),
                            SizedBox(height: 15),
                            Text("Uploading data..."),
                          ],
                        ),
                      ),
                    );
                  },
                );

                try {
                  // Simulate a short delay to ensure the loading dialog is visible
                  await Future.delayed(const Duration(milliseconds: 500));
                  SupabaseServices().uploadImagesToSupabase(context, imagePaths);

                  // Upload General Details to Firestore
                  await FireStoreServices().addGeneralDetails(
                    currentId!,
                    GeneralDetailsModel(
                      property: selectedProperty ?? "",
                      refNo: _refNoController.text.trim(),
                      myRef: _myRefController.text.trim(),
                      region: selectedRegion ?? "",
                      houseName: _houseNameController.text.trim(),
                      houseNo: _houseNoController.text.trim(),
                      street: _streetController.text.trim(),
                      locality: _localiityController.text.trim(),
                      country: _countryController.text.trim(),
                      town: _townController.text.trim(),
                      postCode: _postCodeController.text.trim(),
                      date: _assessmentDateController.text.trim(),
                    ),
                  );

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("General Details added!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error adding data: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                } finally {
                  // Close the loading dialog
                  Navigator.pop(context);
                }

                // Update the button state to reflect the success
                setState(() {
                  isAdded = true;
                });
              } else {
                // If form has errors, keep the "Add" button unchanged
                setState(() {
                  isAdded = false;
                });
              }
            },
            child: const Text(
              "Submit",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 1),
              color: const Color.fromRGBO(204, 204, 204, 1),
              child: Container(
                height: 1800,
                width: double.infinity,
                color: const Color.fromRGBO(253, 253, 253, 1),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    right: 32,
                    top: 20,
                  ),
                  child: SizedBox(
                    width: 364,
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text(
                                      "Reference",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Color.fromRGBO(98, 98, 98, 1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                // height: 62,
                                width: 364,
                                child: Center(
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Reference Number';
                                      }
                                      return null;
                                    },
                                    controller: _refNoController,
                                    onChanged: (String value) {
                                      // Track the input value
                                      setState(() {
                                        elementName = value;
                                      });
                                    },
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(57, 55, 56, 1),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Enter Reference Number",
                                      hintStyle: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w300,
                                        color: Color.fromRGBO(57, 55, 56, 0.5),
                                      ),
                                      suffixIcon: IconButton(
                                        style: const ButtonStyle(
                                            splashFactory:
                                                NoSplash.splashFactory),
                                        onPressed: _showImageSourceSelection,
                                        icon: SvgPicture.asset(
                                          "assets/images/camera (1).svg",
                                          color: const Color.fromRGBO(
                                              57, 55, 56, 0.5),
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
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          16,
                                        ),
                                        borderSide: const BorderSide(
                                          color: Color(0X19626262),
                                          width: 2,
                                        ),
                                      ),
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Wrap(
                                      alignment: WrapAlignment.start,
                                      runAlignment: WrapAlignment.start,
                                      spacing: 5,
                                      runSpacing: 5,
                                      children: List.generate(imagePaths.length,
                                          (index) {
                                        return SizedBox(
                                          height: 36,
                                          width: 36,
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Container(
                                                height: 36,
                                                width: 36,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.2),
                                                  image: DecorationImage(
                                                    image: FileImage(File(
                                                        imagePaths[index])),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    imagePaths.removeAt(index);
                                                  });
                                                },
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.65),
                                                      child: SvgPicture.asset(
                                                        "assets/images/Ellipse 270.svg",
                                                        height: 10,
                                                        width: 10,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.39),
                                                      child: SvgPicture.asset(
                                                        "assets/images/Group 1353 (1).svg",
                                                        height: 6.25,
                                                        width: 6.25,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text("My Reference",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(98, 98, 98, 1),
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                // height: 62,
                                width: 364,
                                child: TextFormField(
                                  controller: _myRefController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    // Validator for form field
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Reference Number'; // Return error message
                                    }
                                    return null; // Return null if input is valid
                                  },
                                  onChanged: (String value) {
                                    // Track the input value
                                    setState(() {
                                      elementName = value;
                                    });
                                  },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration: myDecoration(
                                      'Enter the Reference Number'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text("Regs Region",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(98, 98, 98, 1),
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 364,
                                child: DropdownButtonFormField<String>(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    // Validator for form field
                                    if (value == null || value.isEmpty) {
                                      return 'Please select the Option'; // Return error message
                                    }
                                    return null; // Return null if input is valid
                                  },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
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
                                        left: 15,
                                        right: 16,
                                        top: 18,
                                        bottom: 18),
                                  ),
                                  isExpanded: true,
                                  isDense: true,

                                  value: selectedRegion,
                                  hint: Text(
                                      "Select a region"), // Placeholder text
                                  items: region
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e, // Set value for each item
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRegion =
                                          value; // Update the selected value
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 364,
                            height: 36,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      _houseNameController.clear();
                                      _houseNoController.clear();
                                      _streetController.clear();
                                      _localiityController.clear();
                                      _townController.clear();
                                      _countryController.clear();
                                      _postCodeController.clear();
                                      _assessmentDateController.clear();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 1,
                                          color: const Color.fromRGBO(
                                              255, 59, 48, 0.2),
                                        ),
                                        color: const Color.fromRGBO(
                                            255, 59, 48, 0.1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/Clear.svg",
                                              height: 24,
                                              width: 24,
                                              color: const Color.fromRGBO(
                                                255,
                                                59,
                                                48,
                                                1,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            const Text(
                                              "Clear Address",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Mundial',
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w300,
                                                color: Color.fromRGBO(
                                                    255, 59, 48, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 1,
                                          color: const Color.fromRGBO(
                                              52, 199, 89, 0.2),
                                        ),
                                        color: const Color.fromRGBO(
                                            52, 199, 89, 0.1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              "assets/images/search.svg",
                                              height: 24,
                                              width: 24,
                                              color: const Color.fromRGBO(
                                                52,
                                                199,
                                                89,
                                                1,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            const Text(
                                              "Find Address",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Mundial',
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w300,
                                                color: Color.fromRGBO(
                                                    52, 199, 89, 1),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text(
                                        "Is the property of traditional construction?",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(98, 98, 98, 1),
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 364,
                                child: Center(
                                  child: DropdownButtonFormField2(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (String? value) {
                                      // Validator for form field
                                      if (value == null || value.isEmpty) {
                                        return 'Please select the Option'; // Return error message
                                      }
                                      return null; // Return null if input is valid
                                    },
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(57, 55, 56, 1),
                                    ),
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
                                          left: 0,
                                          right: 16,
                                          top: 18,
                                          bottom: 18),
                                    ),
                                    isExpanded: true,
                                    isDense: true,
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    value: selectedProperty,
                                    hint: const Text(
                                      "Select the Property construction",
                                      textAlign: TextAlign.center,
                                    ),
                                    iconStyleData: IconStyleData(
                                      icon: SvgPicture.asset(
                                        "assets/images/IconV.svg",
                                        height: 24,
                                        width: 24,
                                        color: const Color.fromRGBO(
                                            57, 55, 56, 0.5),
                                      ),
                                    ),
                                    items: items.map((item) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerLeft,
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedProperty = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text("House Name",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(98, 98, 98, 1),
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 364,
                                child: TextFormField(
                                  controller: _houseNameController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    // Validator for form field
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter House Name'; // Return error message
                                    }
                                    return null; // Return null if input is valid
                                  },
                                  onChanged: (String value) {
                                    // Track the input value
                                    setState(() {
                                      elementName = value;
                                    });
                                  },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration:
                                      myDecoration('Enter the House Name'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text("House Number",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(98, 98, 98, 1),
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 364,
                                child: TextFormField(
                                  controller: _houseNoController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    // Validator for form field
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter House Name'; // Return error message
                                    }
                                    return null; // Return null if input is valid
                                  },
                                  onChanged: (String value) {
                                    // Track the input value
                                    setState(() {
                                      elementName = value;
                                    });
                                  },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration:
                                      myDecoration('Enter the House Number'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text("Street",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(98, 98, 98, 1),
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 364,
                                child: TextFormField(
                                  controller: _streetController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    // Validator for form field
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Street'; // Return error message
                                    }
                                    return null; // Return null if input is valid
                                  },
                                  onChanged: (String value) {
                                    // Track the input value
                                    setState(() {
                                      elementName = value;
                                    });
                                  },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration: myDecoration('Enter the Street'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text("Locality",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(98, 98, 98, 1),
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 364,
                                child: TextFormField(
                                  controller: _localiityController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    // Validator for form field
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the Locality'; // Return error message
                                    }
                                    return null; // Return null if input is valid
                                  },
                                  onChanged: (String value) {
                                    // Track the input value
                                    setState(() {
                                      elementName = value;
                                    });
                                  },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration:
                                      myDecoration("Enter the Locality"),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text("Town",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(98, 98, 98, 1),
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 364,
                                child: TextFormField(
                                  controller: _townController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    // Validator for form field
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Town'; // Return error message
                                    }
                                    return null; // Return null if input is valid
                                  },
                                  onChanged: (String value) {
                                    // Track the input value
                                    setState(() {
                                      elementName = value;
                                    });
                                  },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration: myDecoration("Enter the Town"),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text("Country",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(98, 98, 98, 1),
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 364,
                                child: TextFormField(
                                  controller: _countryController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    // Validator for form field
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your Country'; // Return error message
                                    }
                                    return null; // Return null if input is valid
                                  },
                                  onChanged: (String value) {
                                    // Track the input value
                                    setState(() {
                                      elementName = value;
                                    });
                                  },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration: myDecoration("Enter the Country"),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text("Postcode",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(98, 98, 98, 1),
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 364,
                                child: TextFormField(
                                  controller: _postCodeController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    // Validator for form field
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your PostCode'; // Return error message
                                    }
                                    return null; // Return null if input is valid
                                  },
                                  onChanged: (String value) {
                                    // Track the input value
                                    setState(() {
                                      elementName = value;
                                    });
                                  },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration:
                                      myDecoration("Enter the Postcode"),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text("Risk Assessment path",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(98, 98, 98, 1),
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 364,
                                child: Center(
                                  child: DropdownButtonFormField2(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (String? value) {
                                      // Validator for form field
                                      if (value == null || value.isEmpty) {
                                        return 'Please select the Option'; // Return error message
                                      }
                                      return null; // Return null if input is valid
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
                                          left: 0,
                                          right: 16,
                                          top: 18,
                                          bottom: 18),
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
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    value: button2,
                                    hint: const Text(
                                      "Select the Assessment Path",
                                      textAlign: TextAlign.center,
                                    ),
                                    iconStyleData: IconStyleData(
                                      icon: SvgPicture.asset(
                                        "assets/images/IconV.svg",
                                        height: 24,
                                        width: 24,
                                        color: const Color.fromRGBO(
                                            57, 55, 56, 0.5),
                                      ),
                                    ),
                                    items: items2.map((item) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerLeft,
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        button2 = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.50,
                                    child: Text("Assessment Date",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(98, 98, 98, 1),
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 364,
                                child: Center(
                                  child: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select the Date';
                                      }
                                      return null;
                                    },
                                    controller:
                                        _assessmentDateController, // Correct controller
                                    onTap: () {
                                      selectdate();
                                    },
                                    readOnly: true,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(57, 55, 56, 1),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Select the Assessment Date",
                                      hintStyle: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w300,
                                        color: Color.fromRGBO(57, 55, 56, 0.5),
                                      ),
                                      suffixIcon: IconButton(
                                        style: const ButtonStyle(
                                          splashFactory: NoSplash.splashFactory,
                                        ),
                                        onPressed: () {
                                          // Optional action for suffix icon
                                        },
                                        icon: SvgPicture.asset(
                                          "assets/images/IconD.svg",
                                          color: const Color.fromRGBO(
                                              57, 55, 56, 0.5),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0X19626262),
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0X19626262),
                                          width: 2,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Color(0X19626262),
                                          width: 2,
                                        ),
                                      ),
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectdate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        // Update the correct controller
        _assessmentDateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  InputDecoration myDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        color: Color.fromRGBO(57, 55, 56, 0.5),
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
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          16,
        ),
        borderSide: const BorderSide(
          color: Color(0X19626262),
          width: 2,
        ),
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
    );
  }

  void _showImageSourceSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('Pick from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }
}
