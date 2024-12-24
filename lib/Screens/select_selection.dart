import 'package:condition_report/Screens/photo_stream.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

// ignore_for_file: must_be_immutable
class SelectSelctionScreen extends StatefulWidget {
  SelectSelctionScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<SelectSelctionScreen> createState() => _SelectSelctionScreenState();
}

class _SelectSelctionScreenState extends State<SelectSelctionScreen> {
  List<String> imagePaths = [];
  List<DateTime> imageDates = [];
  String? button;
  List<String> dropdownItemList = ["One", "Two", "Three"];
  String? button1;
  List<String> dropdownItemList1 = ["Item One", "Item Two", "Item Three"];

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
                // Navigate to PhotoStreamScreen with dynamic imagePath and dateTime
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoStreamScreen(
                      imagePaths: imagePaths,
                      imageDates: imageDates,
                    ),
                  ),
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
            "Select Selection",
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
            onPressed: () {},
            child: const Text(
              "Save",
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
                width: double.infinity,
                height: 926,
                color: const Color.fromRGBO(253, 253, 253, 1),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 32,
                    right: 32,
                    top: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: SizedBox(
                              height: 24,
                              width: 318,
                              child: Text(
                                "Select the location for the picture",
                                style: TextStyle(
                                  color: Color(0X7F626262),
                                  fontSize: 16,
                                  fontFamily: 'Mundial',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 62,
                            width: 364,
                            child: Center(
                              child: DropdownButtonFormField2(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                      right: 16, top: 18, bottom: 18),
                                ),
                                // isExpanded: true,
                                isDense: true,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w300,
                                  color: Color.fromRGBO(57, 55, 56, 1),
                                ),
                                value: button,
                                hint: const Text(
                                  "Select the Option",
                                  textAlign: TextAlign.center,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                iconStyleData: IconStyleData(
                                  icon: SvgPicture.asset(
                                    "assets/images/IconV.svg",
                                    height: 24,
                                    width: 24,
                                    color:
                                        const Color.fromRGBO(57, 55, 56, 0.5),
                                  ),
                                ),
                                items: dropdownItemList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    alignment: Alignment.centerLeft,
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    button = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select element';
                                  }
                                  return null;
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
                              width: 318,
                              child: Text(
                                "Select the sub-selection",
                                style: TextStyle(
                                  color: Color(0X7F626262),
                                  fontSize: 16,
                                  fontFamily: 'Mundial',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 62,
                            width: 364,
                            child: Center(
                              child: DropdownButtonFormField2(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                      right: 16, top: 18, bottom: 18),
                                ),
                                // isExpanded: true,
                                isDense: true,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.w300,
                                  color: Color.fromRGBO(57, 55, 56, 1),
                                ),
                                hint: const Text(
                                  "Trickle events",
                                  textAlign: TextAlign.center,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(255, 255, 255, 1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                iconStyleData: IconStyleData(
                                  icon: SvgPicture.asset(
                                    "assets/images/IconV.svg",
                                    height: 24,
                                    width: 24,
                                    color:
                                        const Color.fromRGBO(57, 55, 56, 0.5),
                                  ),
                                ),
                                value: button1,
                                items: dropdownItemList1.map((String value) {
                                  return DropdownMenuItem<String>(
                                    alignment: Alignment.centerLeft,
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    button1 = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please select element';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
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
