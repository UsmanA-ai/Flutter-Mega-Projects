import 'dart:developer';
import 'package:condition_report/Screens/add_new_element.dart';
import 'package:condition_report/Screens/general_details.dart';
import 'package:condition_report/Screens/occupancy.dart';
import 'package:condition_report/Screens/outstanding_photos..dart';
import 'package:condition_report/Screens/photo_stream.dart';
import 'package:condition_report/Screens/property_details.dart';
import 'package:condition_report/common_widgets/submit_button.dart';
import 'package:condition_report/provider/assessment_provider.dart';
import 'package:condition_report/services/firestore_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:condition_report/Screens/globals.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConditionReport extends StatefulWidget {
  final String? assessmentId;
  const ConditionReport({super.key, this.assessmentId});

  @override
  State<ConditionReport> createState() => _ConditionReportState();
}

class _ConditionReportState extends State<ConditionReport> {
  // List<String> imageLength = [];
  // List<DateTime> imageDates = [];
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final List<String> _imageUrls = [];
// Added loading state

  @override
  void initState() {
    super.initState();
    _fetchImages();
    // setState(() {});
    // log("initstate");
  }

  Future<void> _fetchImages() async {
    setState(() {
// Show loading indicator
    });

    try {
      final response =
          await _supabaseClient.storage.from('Images').list(path: 'images');

      if (response.isEmpty) {
        log("No images found in Supabase storage.");
        setState(() {
// Hide loading indicator
        });
        return;
      }

      final List<String> urls = [];
      for (var file in response) {
        log("Found file: ${file.name}");
        final url = _supabaseClient.storage
            .from('Images')
            .getPublicUrl('images/${file.name}');
        log("Generated URL: $url");
        urls.add(url);
      }

      setState(() {
        _imageUrls.clear();
        _imageUrls.addAll(urls);
// Hide loading indicator
      });
    } catch (e) {
      log("Error fetching images: $e");
      setState(() {
// Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        title: const Padding(
          padding: EdgeInsets.only(top: 20, bottom: 12),
          child: Text(
            "Condition Report",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              fontStyle: FontStyle.normal,
              color: Color.fromRGBO(57, 55, 56, 1),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SubmitButton(
        text: "Submit",
        onPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 1),
              color: const Color.fromRGBO(204, 204, 204, 1),
              child: Container(
                height: 926,
                // width: double.infinity,
                color: const Color.fromRGBO(253, 253, 253, 1),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    right: 32,
                    top: 20,
                  ),
                  child: Column(
                    children: [
                      Container(
                        // width: 364,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 0,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                            bottom: BorderSide(
                              width: 0,
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),
                        ),
                        child: CupertinoButton(
                          borderRadius: BorderRadius.circular(6.2),
                          color: const Color.fromRGBO(37, 144, 240, 1),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddNewElement()),
                            );
                          },
                          child: SizedBox(
                            // width: 364,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 16, bottom: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Add New Element",
                                    selectionColor:
                                        Color.fromRGBO(255, 255, 255, 1),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(255, 255, 255, 1),
                                    ),
                                  ),
                                  Container(
                                    height: 24,
                                    width: 22.90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.18,
                                        bottom: 8.18,
                                        left: 8.73,
                                        right: 8.73,
                                      ),
                                      child: SvgPicture.asset(
                                        "assets/images/Vector.svg",
                                        color: const Color.fromRGBO(
                                            37, 144, 240, 1),
                                        height: 6.55,
                                        width: 6.55,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to PhotoStreamScreen with dynamic imagePath and dateTime
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoStreamScreen(
                                  // imagePaths: imagePaths,
                                  // imageDates: imageDates,
                                  ),
                            ),
                          );
                        },
                        child: Container(
                          width: 364,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Color.fromRGBO(253, 253, 253, 1),
                              ),
                              bottom: BorderSide.none,
                            ),
                          ),
                          child: CupertinoFormRow(
                            padding: EdgeInsets.zero,
                            prefix: Row(
                              children: [
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(13.5),
                                      child: SvgPicture.asset(
                                        "assets/images/camera.svg",
                                        height: 24,
                                        width: 24,
                                        color: const Color.fromRGBO(
                                            37, 144, 240, 1),
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      "assets/images/Group 1259.svg",
                                      height: 50.5,
                                      width: 50,
                                      color:
                                          const Color.fromRGBO(37, 144, 240, 1),
                                      // color: Colors.red,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Row(
                                  children: [
                                    Text(
                                      "Photo Stream ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          color: Color.fromRGBO(57, 55, 56, 1)),
                                    ),
                                    Text(
                                      "(${_imageUrls.length})",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w400,
                                          color:
                                              Color.fromRGBO(57, 55, 56, 0.5)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            child: Container(
                              width: 56,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromRGBO(37, 144, 240, 1),
                                ),
                                borderRadius: BorderRadius.circular(6.2),
                                color: _imageUrls.isEmpty
                                    ? Color.fromRGBO(37, 144, 240, 0.1)
                                    : Color.fromRGBO(37, 144, 240, 1),
                              ),
                              child: CupertinoButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_imageUrls.isEmpty)
                                      SvgPicture.asset(
                                        "assets/images/Group 1353.svg",
                                        height: 10,
                                        width: 10,
                                        color: const Color.fromRGBO(
                                            37, 144, 240, 1),
                                      ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      height: 17,
                                      child: Text(
                                        _imageUrls.isEmpty ? "Add" : "Added",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: _imageUrls.isEmpty
                                              ? Color.fromRGBO(37, 144, 240, 1)
                                              : Colors.white,
                                          fontSize: 14,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OutstandingPhotos(
                                imagePaths: [], // Pass the correct parameter name 'imagePaths'
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 364,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                width: 0,
                                color: Color.fromRGBO(253, 253, 253, 1),
                              ),
                              bottom: BorderSide(
                                width: 0,
                                color: Color.fromRGBO(253, 253, 253, 1),
                              ),
                            ),
                          ),
                          child: CupertinoFormRow(
                            padding: EdgeInsets.zero,
                            prefix: Row(
                              children: [
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(13.5),
                                      child: SvgPicture.asset(
                                        "assets/images/Photo.svg",
                                        height: 24,
                                        width: 24,
                                        color: const Color.fromRGBO(
                                            37, 144, 240, 1),
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      "assets/images/Group 1259.svg",
                                      height: 50.5,
                                      width: 50,
                                      color:
                                          const Color.fromRGBO(37, 144, 240, 1),
                                      // color: Colors.red,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  "Outstanding Photos",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(57, 55, 56, 1)),
                                ),
                              ],
                            ),
                            child: Container(
                              width: 56,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromRGBO(37, 144, 240, 1),
                                ),
                                borderRadius: BorderRadius.circular(6.2),
                                color: const Color.fromRGBO(37, 144, 240, 0.1),
                              ),
                              child: CupertinoButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/Group 1353.svg",
                                      height: 10,
                                      width: 10,
                                      color:
                                          const Color.fromRGBO(37, 144, 240, 1),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const SizedBox(
                                      height: 17,
                                      child: Text(
                                        "Add",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(37, 144, 240, 1),
                                          fontSize: 14,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            Map<String, dynamic>? assessmentData;

                            if (widget.assessmentId != null) {
                              try {
                                // Fetch data only if assessmentId is not null
                                assessmentData = await FireStoreServices()
                                    .fetchAssessment(widget.assessmentId!);
                                log('Fetched assessment data: $assessmentData');
                              } catch (e) {
                                log('Error fetching assessment data: $e');
                                // Handle fetching errors if necessary
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error fetching data: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                            } else {
                              log('Creating new assessment: No initial data available');
                            }

                            // Navigate to the Occupancy screen with existing data or empty values
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GeneralDetails(
                                  initialData:
                                      assessmentData?['generalDetails'] ??
                                          {}, // Pass empty map if null
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error loading data: $e")),
                            );
                          }
                        },
                        child: Container(
                          width: 364,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                width: 0,
                                color: Color.fromRGBO(253, 253, 253, 1),
                              ),
                              bottom: BorderSide(
                                width: 0,
                                color: Color.fromRGBO(253, 253, 253, 1),
                              ),
                            ),
                          ),
                          child: CupertinoFormRow(
                            padding: EdgeInsets.zero,
                            prefix: Row(
                              children: [
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(13.5),
                                      child: SvgPicture.asset(
                                        "assets/images/doc-detail.svg",
                                        height: 24,
                                        width: 24,
                                        color: const Color.fromRGBO(
                                            37, 144, 240, 1),
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      "assets/images/Group 1259.svg",
                                      height: 50.5,
                                      width: 50,
                                      color:
                                          const Color.fromRGBO(37, 144, 240, 1),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  "General Details",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(57, 55, 56, 1),
                                  ),
                                ),
                              ],
                            ),
                            child: isAddedGD
                                ? Container(
                                    width: 56,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color.fromRGBO(37, 144, 240,
                                            1), // "Added" state color
                                      ),
                                      borderRadius: BorderRadius.circular(6.2),
                                      color: Color.fromRGBO(37, 144, 240,
                                          1), // "Added" state color
                                    ),
                                    child: Text(
                                      "Added",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 56,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            37, 144, 240, 1), // Blue border
                                      ),
                                      borderRadius: BorderRadius.circular(6.2),
                                      color: const Color.fromRGBO(
                                          37, 144, 240, 0.1), // Blue background
                                    ),
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/Group 1353.svg", // Replace with your add icon
                                            height: 10,
                                            width: 10,
                                            color: const Color.fromRGBO(
                                                37, 144, 240, 1), // Blue color
                                          ),
                                          const SizedBox(width: 5),
                                          const SizedBox(
                                            height: 17,
                                            child: Text(
                                              "Add",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color.fromRGBO(37, 144,
                                                    240, 1), // Blue text
                                                fontSize: 14,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            Map<String, dynamic>? assessmentData;

                            if (widget.assessmentId != null) {
                              try {
                                // Fetch data only if assessmentId is not null
                                assessmentData = await FireStoreServices()
                                    .fetchAssessment(widget.assessmentId!);
                                log('Fetched assessment data: $assessmentData');
                              } catch (e) {
                                log('Error fetching assessment data: $e');
                                // Handle fetching errors if necessary
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error fetching data: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                            } else {
                              log('Creating new assessment: No initial data available');
                            }

                            // Navigate to the Occupancy screen with existing data or empty values
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PropertyDetails(
                                  initialData:
                                      assessmentData?['propertyDetails'] ??
                                          {}, // Pass empty map if null
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error loading data: $e")),
                            );
                          }
                        },
                        child: Container(
                          width: 364,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                width: 0,
                                color: Color.fromRGBO(253, 253, 253, 1),
                              ),
                              bottom: BorderSide(
                                width: 0,
                                color: Color.fromRGBO(253, 253, 253, 1),
                              ),
                            ),
                          ),
                          child: CupertinoFormRow(
                            padding: EdgeInsets.zero,
                            prefix: Row(
                              children: [
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(13.5),
                                      child: SvgPicture.asset(
                                        "assets/images/doc-detail.svg",
                                        height: 24,
                                        width: 24,
                                        color: const Color.fromRGBO(
                                            37, 144, 240, 1),
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      "assets/images/Group 1259.svg",
                                      height: 50.5,
                                      width: 50,
                                      color:
                                          const Color.fromRGBO(37, 144, 240, 1),
                                      // color: Colors.red,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  "Property Details",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(57, 55, 56, 1)),
                                ),
                              ],
                            ),
                            // child: Container(
                            //   width: 56,
                            //   height: 24,
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //       color: const Color.fromRGBO(37, 144, 240, 1),
                            //     ),
                            //     borderRadius: BorderRadius.circular(6.2),
                            //     color: isAdded
                            //         ? const Color.fromRGBO(
                            //             37, 144, 240, 1) // "Added" state color
                            //         : const Color.fromRGBO(37, 144, 240,
                            //             0.1), // Initial state color
                            //   ),
                            //   child: CupertinoButton(
                            //     padding: const EdgeInsets.all(0),
                            //     onPressed: () async {
                            //       // Navigate to the PropertyDetails screen and wait for the result
                            //       final result = await Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => const PropertyDetails(),
                            //         ),
                            //       );

                            //       // Check if the result is true (form was successfully submitted)
                            //       if (result == true) {
                            //         setState(() {
                            //           isAdded = true; // Update the button state
                            //         });
                            //       }
                            //     },
                            //     child: isAdded
                            //         ? const SizedBox(
                            //             height: 17,
                            //             child: Text(
                            //               "Added",
                            //               textAlign: TextAlign.center,
                            //               style: TextStyle(
                            //                 color: Color.fromRGBO(
                            //                     255, 255, 255, 1),
                            //                 fontSize: 14,
                            //                 fontStyle: FontStyle.normal,
                            //                 fontWeight: FontWeight.w300,
                            //               ),
                            //             ),
                            //           )
                            //         : Row(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.center,
                            //             children: [
                            //               SvgPicture.asset(
                            //                 "assets/images/Group 1353.svg",
                            //                 height: 10,
                            //                 width: 10,
                            //                 color: const Color.fromRGBO(
                            //                     37, 144, 240, 1),
                            //               ),
                            //               const SizedBox(
                            //                 width: 5,
                            //               ),
                            //               const SizedBox(
                            //                 height: 17,
                            //                 child: Text(
                            //                   "Add",
                            //                   textAlign: TextAlign.center,
                            //                   style: TextStyle(
                            //                     color: Color.fromRGBO(
                            //                         37, 144, 240, 1),
                            //                     fontSize: 14,
                            //                     fontStyle: FontStyle.normal,
                            //                     fontWeight: FontWeight.w300,
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //   ),
                            // ),
                            child: Container(
                              width: 56,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromRGBO(37, 144, 240, 1),
                                ),
                                borderRadius: BorderRadius.circular(6.2),
                                color: isAddedPD
                                    ? const Color.fromRGBO(
                                        37, 144, 240, 1) // "Added" state color
                                    : const Color.fromRGBO(37, 144, 240,
                                        0.1), // Initial state color
                              ),
                              child: CupertinoButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {},
                                // async {
                                //   // Navigate to PropertyDetails and wait for the result
                                //   final result = await Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) =>
                                //           PropertyDetails(), // Navigate to PropertyDetails screen
                                //     ),
                                //   );

                                //   // Check if the result is 'true' (indicating successful save)
                                //   if (result == true) {
                                //     setState(() {
                                //       isAdded =
                                //           true; // Change the button to "Added"
                                //       print(
                                //           "Item added successfully, button state updated.");
                                //     });
                                //   } else {
                                //     print("No item added.");
                                //   }
                                // },
                                child: isAddedPD
                                    ? const SizedBox(
                                        height: 17,
                                        child: Text(
                                          "Added",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 1),
                                            fontSize: 14,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/Group 1353.svg",
                                            height: 10,
                                            width: 10,
                                            color: const Color.fromRGBO(
                                                37, 144, 240, 1),
                                          ),
                                          const SizedBox(width: 5),
                                          const SizedBox(
                                            height: 17,
                                            child: Text(
                                              "Add",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color.fromRGBO(
                                                    37, 144, 240, 1),
                                                fontSize: 14,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            Map<String, dynamic>? assessmentData;

                            if (widget.assessmentId != null) {
                              try {
                                // Fetch data only if assessmentId is not null
                                assessmentData = await FireStoreServices()
                                    .fetchAssessment(widget.assessmentId!);
                                log('Fetched assessment data: $assessmentData');
                              } catch (e) {
                                log('Error fetching assessment data: $e');
                                // Handle fetching errors if necessary
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error fetching data: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                            } else {
                              log('Creating new assessment: No initial data available');
                            }

                            // Navigate to the Occupancy screen with existing data or empty values
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Occupancy(
                                  initialData: assessmentData?['occupancy'] ??
                                      {}, // Pass empty map if null
                                ),
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error loading data: $e")),
                            );
                          }
                        },
                        child: Container(
                          width: 364,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                width: 0,
                                color: Color.fromRGBO(253, 253, 253, 1),
                              ),
                              bottom: BorderSide(
                                width: 0,
                                color: Color.fromRGBO(253, 253, 253, 1),
                              ),
                            ),
                          ),
                          child: CupertinoFormRow(
                            padding: EdgeInsets.zero,
                            prefix: Row(
                              children: [
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(13.5),
                                      child: SvgPicture.asset(
                                        "assets/images/doc-detail.svg",
                                        height: 24,
                                        width: 24,
                                        color: const Color.fromRGBO(
                                            37, 144, 240, 1),
                                      ),
                                    ),
                                    SvgPicture.asset(
                                      "assets/images/Group 1259.svg",
                                      height: 50.5,
                                      width: 50,
                                      color:
                                          const Color.fromRGBO(37, 144, 240, 1),
                                      // color: Colors.red,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  "Occupancy",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                      color: Color.fromRGBO(57, 55, 56, 1)),
                                ),
                              ],
                            ),
                            child: isAddedO
                                ? Container(
                                    width: 56,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color.fromRGBO(37, 144, 240,
                                            1), // "Added" state color
                                      ),
                                      borderRadius: BorderRadius.circular(6.2),
                                      color: Color.fromRGBO(37, 144, 240,
                                          1), // "Added" state color
                                    ),
                                    child: Text(
                                      "Added",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 56,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            37, 144, 240, 1), // Blue border
                                      ),
                                      borderRadius: BorderRadius.circular(6.2),
                                      color: const Color.fromRGBO(
                                          37, 144, 240, 0.1), // Blue background
                                    ),
                                    child: CupertinoButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/Group 1353.svg", // Replace with your add icon
                                            height: 10,
                                            width: 10,
                                            color: const Color.fromRGBO(
                                                37, 144, 240, 1), // Blue color
                                          ),
                                          const SizedBox(width: 5),
                                          const SizedBox(
                                            height: 17,
                                            child: Text(
                                              "Add",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color.fromRGBO(37, 144,
                                                    240, 1), // Blue text
                                                fontSize: 14,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: globalButtons,
                      ),
                    ],
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
