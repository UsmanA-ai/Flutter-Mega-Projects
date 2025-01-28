import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condition_report/Screens/condition_report.dart';
import 'package:condition_report/provider/assessment_provider.dart';
import 'package:condition_report/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssesmentsScreen extends StatefulWidget {
  const AssesmentsScreen({super.key});

  @override
  State<AssesmentsScreen> createState() => _AssesmentsScreenState();
}

class _AssesmentsScreenState extends State<AssesmentsScreen> {
  String selectedFilter = "All"; // Track the selected filter
  String searchQuery = ""; // Track the search query

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        title: Text("Assessments",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              fontStyle: FontStyle.normal,
              color: Color.fromRGBO(57, 55, 56, 1),
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton<String>(
              elevation: 5,
              color: Colors.white,
              menuPadding: EdgeInsets.all(10),
              onSelected: (value) {
                setState(() {
                  selectedFilter = value;
                });
              },
              icon: SvgPicture.asset(
                "assets/images/Filters.svg",
                height: 24,
                width: 24,
                fit: BoxFit.fill,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: "All",
                  child: Text("All"),
                ),
                PopupMenuItem(
                  value: "Completed",
                  child: Text("Completed"),
                ),
                PopupMenuItem(
                  value: "Incomplete",
                  child: Text("Incomplete"),
                ),
              ],
            ),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Scrolls the entire body
        child: Column(
          children: [
            Container(
              color: const Color.fromRGBO(204, 204, 204, 1),
              padding: const EdgeInsets.only(top: 1),
              child: Container(
                color: const Color.fromRGBO(253, 253, 253, 1),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    right: 32,
                    top: 20,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 56,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value.toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search Assessments',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(37, 144, 240, 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color.fromRGBO(37, 144, 240, 1)),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.2),
                              ),
                            ),
                          ),
                          onPressed: () {
                            
                            FireStoreServices().createAssessment();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ConditionReport(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Add New Assessment",
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
                                  color: const Color.fromRGBO(255, 255, 255, 1),
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
                                    color:
                                        const Color.fromRGBO(37, 144, 240, 1),
                                    height: 6.55,
                                    width: 6.55,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Now we can allow ListView to take the remaining space
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FireStoreServices().fetchAllAssessments(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            final assessments = snapshot.data!.docs;

                            // Filter assessments based on selectedFilter and search query
                            final filteredAssessments =
                                assessments.where((doc) {
                              final assessment = doc.data();
                              final isAddedGD = assessment['generalDetails']
                                      ['isAdded'] ??
                                  false;
                              final isAddedPD = assessment['propertyDetails']
                                      ['isAdded'] ??
                                  false;
                              final isAddedO =
                                  assessment['occupancy']['isAdded'] ?? false;
                              final status =
                                  (isAddedGD && isAddedPD && isAddedO)
                                      ? 'Completed'
                                      : 'Incomplete';
                              final address =
                                  '${assessment['generalDetails']['houseName'] ?? ''} ${assessment['generalDetails']['houseNo'] ?? ''} ${assessment['generalDetails']['street'] ?? ''} ${assessment['generalDetails']['town'] ?? ''} ${assessment['generalDetails']['postCode'] ?? ''} ${assessment['generalDetails']['region'] ?? ''}'
                                      .toLowerCase();
                              final refNo =
                                  (assessment['generalDetails']['refNo'] ?? '')
                                      .toLowerCase();
                              return (selectedFilter == "All" ||
                                      status == selectedFilter) &&
                                  (address.contains(searchQuery) ||
                                      refNo.contains(searchQuery));
                            }).toList();

                            return ListView.builder(
                              shrinkWrap:
                                  true, // Makes the ListView behave correctly within Column
                              physics:
                                  NeverScrollableScrollPhysics(), // Prevent scroll conflict with parent SingleChildScrollView
                              itemCount: filteredAssessments.length,
                              itemBuilder: (BuildContext context, int index) {
                                final assessment =
                                    filteredAssessments[index].data();

                                // Extract address components
                                final houseName = assessment['generalDetails']
                                        ['houseName'] ??
                                    '';
                                final houseNo = assessment['generalDetails']
                                        ['houseNo'] ??
                                    '';
                                final street = assessment['generalDetails']
                                        ['street'] ??
                                    '';
                                final town =
                                    assessment['generalDetails']['town'] ?? '';
                                final postCode = assessment['generalDetails']
                                        ['postCode'] ??
                                    '';
                                final region = assessment['generalDetails']
                                        ['region'] ??
                                    '';

                                // Create the full address string
                                final address =
                                    '$houseName $houseNo $street $town $postCode $region'
                                        .trim();

                                // Check statuses
                              final bool  isAddedGD = assessment['generalDetails']
                                        ['isAdded'] ??
                                    false;
                              final bool  isAddedPD = assessment['propertyDetails']
                                        ['isAdded'] ??
                                    false;
                              final bool  isAddedO =
                                    assessment['occupancy']['isAdded'] ?? false;

                                // Determine assessment status
                                final status =
                                    (isAddedGD && isAddedPD && isAddedO)
                                        ? 'Complete'
                                        : 'Incomplete';

                                return GestureDetector(
                                  onTap: () {
                                    currentId = snapshot.data!.docs[index].id;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ConditionReport(
                                          assessmentId:
                                              snapshot.data!.docs[index].id,

                                        // isAddedGD: isAddedGD,
                                        // isAddedO: isAddedO,
                                        // isAddedPD: isAddedPD,
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: Colors.white,
                                        title: Text(
                                            "Are you sure you want to delete"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              FireStoreServices()
                                                  .deleteAssessment(snapshot
                                                      .data!.docs[index].id);
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Ok",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12.0),
                                    margin: EdgeInsets.symmetric(vertical: 8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 0.5),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          address.isNotEmpty
                                              ? address
                                              : 'No Address Provided',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          "[${assessment["generalDetails"]["refNo"] ?? "Reference_Number"}]",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Status: $status',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: status == 'Complete'
                                                ? Colors.green
                                                : Colors.red,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return SizedBox(); // Return an empty box if no data
                        },
                      )
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
