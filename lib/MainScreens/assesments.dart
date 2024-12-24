import 'package:condition_report/Screens/condition_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssesmentsScreen extends StatefulWidget {
  const AssesmentsScreen({super.key});

  @override
  State<AssesmentsScreen> createState() => _AssesmentsScreenState();
}

class _AssesmentsScreenState extends State<AssesmentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 0.32,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 24,
            // top: 20,
            // bottom: 12,
          ),
          child: SizedBox(
            height: 24,
            width: 24,
            child: IconButton(
              padding: const EdgeInsets.all(0.0),
              onPressed: () {},
              icon: const Icon(
                Icons.arrow_back_sharp,
                size: 24,
                color: Color.fromRGBO(57, 55, 56, 1),
              ),
            ),
          ),
        ),
        title: const Center(
          child: Text("Assessments",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
                fontStyle: FontStyle.normal,
                color: Color.fromRGBO(57, 55, 56, 1),
              )),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 24,
              // bottom: 12,
            ),
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                "assets/images/Filters.svg",
                height: 24,
                width: 24,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 1),
              color: const Color.fromRGBO(204, 204, 204, 1),
              child: Container(
                height: 926,
                // width: 428,
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
                      const SizedBox(
                        height: 56,
                        // width: 364,
                        child: TextField(
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
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 54,
                        // width: 400,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromRGBO(37, 144, 240, 1),
                            ),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.2),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ConditionReport()),
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
