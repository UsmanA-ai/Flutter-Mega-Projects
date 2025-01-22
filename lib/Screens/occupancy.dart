import 'package:condition_report/Screens/condition_report.dart';
import 'package:condition_report/models/occupancy_model.dart';
import 'package:condition_report/provider/assessment_provider.dart';
import 'package:condition_report/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Occupancy extends StatefulWidget {
  const Occupancy({super.key});

  @override
  State<Occupancy> createState() => _OccupancyState();
}

class _OccupancyState extends State<Occupancy> {
  final TextEditingController _totalOccupantsController = TextEditingController();
  final TextEditingController _childrenUnder18Controller = TextEditingController();
  final TextEditingController _pensionableMemberController = TextEditingController();
  final TextEditingController _specialConsiderationController = TextEditingController();
  final TextEditingController _disableMemberController = TextEditingController();
  // String? elementN1;
  // String? elementN2;
  // String? elementN3;
  // String? elementN4;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
            "Occupancy",
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

                  // Upload General Details to Firestore
                  await FireStoreServices().addOccupancyDetails(currentId!,
                    OccupancyModel(
                      childrenUnder18: _childrenUnder18Controller.text.trim(),
                      disabledMembers: _specialConsiderationController.text.trim(),
                      pensionableMembers: _pensionableMemberController.text.trim(),
                      totalOccupants: _totalOccupantsController.text.trim(),
                      specialConsideration: _specialConsiderationController.text.trim(),
                     
                    ),
                  );

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Occupancy added!"),
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

               
            
              } else {
                
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
                                  child: Text("Total Number of Occupants?",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Color.fromRGBO(98, 98, 98, 1),
                                      )),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                // height: 62,
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
                                  controller: _totalOccupantsController,
                                  // onChanged: (String value) {
                                  //   // Track the input value
                                  //   setState(() {
                                  //     elementN1 = value;
                                  //   });
                                  // },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    hintText: "Enter the Total Occupants",
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
                                  child: Text(
                                      "How many children are under the age of 18?",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Color.fromRGBO(98, 98, 98, 1),
                                      )),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                // height: 62,
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
                                  controller: _childrenUnder18Controller,
                                  // onChanged: (String value) {
                                  //   // Track the input value
                                  //   setState(() {
                                  //     elementN2 = value;
                                  //   });
                                  // },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    hintText:
                                        "Enter the Total Children under 18",
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
                                  child: Text("How many of a pensionable age?",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Color.fromRGBO(98, 98, 98, 1),
                                      )),
                                ),
                              ),
                              const SizedBox(height: 5),
                              SizedBox(
                                // height: 62,
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
                                  controller: _pensionableMemberController,
                                  // onChanged: (String value) {
                                  //   // Track the input value
                                  //   setState(() {
                                  //     elementN3 = value;
                                  //   });
                                  // },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    hintText:
                                        "Enter the Total Pensionable Members",
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
                                  child: Text("How many with disabilities?",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Color.fromRGBO(98, 98, 98, 1),
                                      )),
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
                                  controller: _disableMemberController,
                                  // onChanged: (String value) {
                                  //   // Track the input value
                                  //   setState(() {
                                  //     elementN4 = value;
                                  //   });
                                  // },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    hintText:
                                        "Enter the Total Disabled Members",
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
                                  child: Text("Special Considerations (Optional)",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        color: Color.fromRGBO(98, 98, 98, 1),
                                      )),
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                maxLines: 3,
                                
                                  controller: _specialConsiderationController,
                                  // onChanged: (String value) {
                                  //   // Track the input value
                                  //   setState(() {
                                  //     elementN4 = value;
                                  //   });
                                  // },
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w300,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    hintText:
                                        "If any",
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
                              // Container(
                              //   constraints: const BoxConstraints(
                              //     minHeight:
                              //         100, // Default height of the container
                              //   ),
                              //   width: 364,
                              //   decoration: BoxDecoration(
                              //     border: Border.all(
                              //       width: 2,
                              //       color:
                              //           const Color.fromRGBO(98, 98, 98, 0.1),
                              //     ),
                              //     borderRadius: BorderRadius.circular(16),
                              //   ),
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(
                              //         left: 17, right: 17, top: 10, bottom: 19),
                              //     child: CupertinoTextFormFieldRow(
                              //       textAlign: TextAlign.start,
                              //       maxLines: null, // Allows for multiple lines
                              //       keyboardType: TextInputType
                              //           .multiline, // Keyboard suited for multiline
                              //       placeholder: "If any! (optional)",
                              //       placeholderStyle: const TextStyle(
                              //         fontSize: 16,
                              //         fontStyle: FontStyle.normal,
                              //         fontWeight: FontWeight.w300,
                              //         color: Color.fromRGBO(57, 55, 56, 0.5),
                              //       ),
                              //       padding: EdgeInsets.zero,
                              //       style: const TextStyle(
                              //         fontSize: 16,
                              //         fontStyle: FontStyle.normal,
                              //         fontWeight: FontWeight.w300,
                              //         color: Color.fromRGBO(57, 55, 56, 1),
                              //       ),
                              //     ),
                              //   ),
                              // ),
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
