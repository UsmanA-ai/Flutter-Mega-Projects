import 'package:condition_report/Screens/condition_report.dart';
import 'package:condition_report/models/property_details_model.dart';
import 'package:condition_report/services/firestore_services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PropertyDetails extends StatefulWidget {
  const PropertyDetails({super.key});

  @override
  State<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
  String? elementName1;
  final TextEditingController _propertyContstraintController =
      TextEditingController();
  String? elementName2;
  final TextEditingController _buildingOrientationController =
      TextEditingController();
  bool isAdded = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? selectedPropertyDetachment;
  final List<String> items = ['Semi-Detachment', 'Detachment', 'Item 3'];
  String? selectedExposureZone;
  final List<String> items2 = ['Item 1', 'Item 2', 'Item 3'];

  int selectedTag = -1;
  List<String> options = [
    "Conventional",
    "Traditional",
    "System-build",
    "High rise - cavity wall",
    "High rise - solid wall",
    "Protected - cavity wall",
    "Protected - solid wall"
  ];
  bool showErrorMessages = false; // Flag to control validation message display

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
            "Property Details",
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
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.only(left: 32, right: 32, bottom: 20),
      //   child: Container(
      //     height: 60,
      //     width: 364,
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(100),
      //     ),
      //     child: FilledButton(
      //       style: ButtonStyle(
      //         backgroundColor: WidgetStateProperty.all<Color>(
      //           const Color.fromRGBO(98, 98, 98, 1),
      //         ),
      //       ),
      //       onPressed: () {
      //         if (formKey.currentState!.validate()) {
      //           formKey.currentState!.save();
      //           setState(() {
      //       isAdded = true; // Indicate that the item has been added
      //     });
      //         }
      //       },
      //       child: const Text(
      //         "Submit",
      //         textAlign: TextAlign.center,
      //         style: TextStyle(
      //           fontSize: 16,
      //           fontStyle: FontStyle.normal,
      //           fontWeight: FontWeight.w600,
      //           color: Color.fromRGBO(255, 255, 255, 1),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
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
            // onPressed: () {
            //   if (formKey.currentState!.validate()) {
            //     formKey.currentState!.save();
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(
            //         content: Center(
            //           child: Text(
            //             "Element has been added!",
            //             style: TextStyle(color: Colors.black),
            //           ),
            //         ),
            //         backgroundColor: Colors.white,
            //         duration: Duration(seconds: 1),
            //       ),
            //     );

            //     // Update the state locally
            //     setState(() {
            //       isAdded = true; // Update the button state to "Added"
            //     });
            //   }
            //   setState(() {
            //     showErrorMessages =
            //         true; // Show validation messages when submitting
            //   });
            // },
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
                            CircularProgressIndicator(
                              color: Colors.black,
                            ),
                            SizedBox(height: 15),
                            Text("Uploading Property details..."),
                          ],
                        ),
                      ),
                    );
                  },
                );

                try {
                  // Simulate a short delay to ensure the loading dialog is visible
                  await Future.delayed(const Duration(milliseconds: 500));

                  // Create a new assessment and get its ID
                  // Upload property details to Firebase
                  await FireStoreServices().addPropertyDetails(
                    PropertyDetailsModel(
                      buildingOrientation:
                          _buildingOrientationController.text.trim(),
                      exposureZone: selectedExposureZone ?? "",
                      propertyConstraint:
                          _propertyContstraintController.text.trim(),
                      propertyConstruction: options[selectedTag],
                      propertyDetachment: selectedPropertyDetachment ?? "",
                    ),
                  );

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Property details added successfully!",
                        style: TextStyle(color: Colors.black),
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  // Show error message if something goes wrong
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Error adding property details: $e",
                        style: const TextStyle(color: Colors.black),
                      ),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } finally {
                  // Close the loading dialog
                  Navigator.pop(context);
                }

                // Update the button state to reflect success
                setState(() {
                  isAdded = true;
                });
                setState(() {
                  showErrorMessages =
                      true; // Show validation messages when submitting
                });
              } else {
                // If form has errors, keep the "Add" button unchanged
                setState(() {
                  isAdded = false;
                });
              }

              // Show validation error messages if needed
              setState(() {
                showErrorMessages = true;
              });
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
              color: const Color.fromRGBO(204, 204, 204, 0.5),
              child: Container(
                height: 926,
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
                                    child: Text("Property Constraints",
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    // Validator for form field
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Reference Number'; // Return error message
                                    }
                                    return null; // Return null if input is valid
                                  },
                                  controller: _propertyContstraintController,
                                  onChanged: (String value) {
                                    // Track the input value
                                    setState(() {
                                      elementName1 = value;
                                    });
                                  },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    hintText: "Enter the Property Constraints",
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
                                    child: Text("Property Construction",
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onTap: () {},
                                  readOnly: true,
                                  textAlign: TextAlign.start,
                                  validator: (String? value) {
                                    if (selectedTag == -1) {
                                      return 'Please select an option';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: selectedTag == -1
                                        ? "No option selected"
                                        : options[selectedTag],
                                    hintStyle: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(57, 55, 56, 1),
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
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Wrap(
                                spacing: 6,
                                children: List<Widget>.generate(
                                  options.length,
                                  (int index) {
                                    return ChoiceChip(
                                      label: Text(options[index]),
                                      showCheckmark: false,
                                      // labelPadding: const EdgeInsets.symmetric(
                                      //     vertical: 6.0, horizontal: 12),
                                      selected: selectedTag ==
                                          index, // Only one chip can be selected
                                      onSelected: (bool value) {
                                        setState(() {
                                          selectedTag = value
                                              ? index
                                              : -1; // Select the clicked chip, or deselect it if clicked again
                                          // formKey.currentState!
                                          //     .validate(); // Validate on chip selection
                                        });
                                      },
                                      backgroundColor: const Color.fromRGBO(
                                          98, 98, 98, 0.05),
                                      selectedColor: const Color.fromRGBO(
                                          37, 144, 240, 0.1),
                                      labelStyle: TextStyle(
                                        color: selectedTag == index
                                            ? const Color.fromRGBO(
                                                37, 144, 240, 1)
                                            : const Color.fromRGBO(
                                                57, 55, 56, 0.5),
                                        fontFamily: 'Mundial',
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        side: BorderSide(
                                          color: selectedTag == index
                                              ? const Color.fromRGBO(
                                                  37, 144, 240, 1)
                                              : const Color.fromRGBO(
                                                  57, 55, 56, 0.1),
                                        ),
                                      ),
                                    );
                                  },
                                ).toList(),
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
                                    child: Text("Property Detachment",
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
                                      if (value == null) {
                                        return 'Please select the Option';
                                      }
                                      return null;
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
                                    value: selectedPropertyDetachment,
                                    hint: const Text(
                                      "Select the Property Detachment",
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
                                        selectedPropertyDetachment = value;
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
                                    child: Text("Building Orientation",
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (String? value) {
                                    // Validator for form field
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Building Orientation'; // Return error message
                                    }
                                    return null; // Return null if input is valid
                                  },
                                  controller: _buildingOrientationController,
                                  onChanged: (String value) {
                                    // Track the input value
                                    setState(() {
                                      elementName2 = value;
                                    });
                                  },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    hintText: "Enter the Building Orientation",
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
                                    child: Text("Exposure Zone",
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
                                      if (value == null) {
                                        return 'Please select the Option';
                                      }
                                      return null;
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
                                    hint: const Text(
                                      "Select the Exposure Zone",
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
                                    value: selectedExposureZone,
                                    items: items2.map((item) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerLeft,
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedExposureZone = value;
                                      });
                                    },
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
}
