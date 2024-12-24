import 'dart:async';
import 'dart:io';

import 'package:condition_report/Screens/condition_report.dart';
import 'package:condition_report/Screens/outstanding_photos..dart';
import 'package:condition_report/Screens/photo_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:condition_report/Screens/globals.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class Bedroom1 extends StatefulWidget {
  const Bedroom1({super.key});

  @override
  State<Bedroom1> createState() => _Bedroom1State();
}

class _Bedroom1State extends State<Bedroom1> {
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  String barTitle = "New Element";
  @override
  void initState() {
    super.initState();
    _textController.addListener(() => setState(() => barTitle =
        _textController.text.isEmpty ? "New Element" : _textController.text));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String? selectedImagePath;
  DateTime _imageDateTime = DateTime.now();

  List<String> camera1Images = [];
  List<String> camera2Images = [];
  List<String> camera3Images = [];

  List<DateTime> camera1ImageDates = [];
  List<DateTime> camera2ImageDates = [];
  List<DateTime> camera3ImageDates = [];

  Future<void> _requestPermissions() async {
    await Permission.storage.request();
    await Permission.camera.request();
    await Permission.photos.request();
  }

  Future<void> _pickImage(ImageSource source, int cameraIndex) async {
    try {
      final PermissionStatus storageStatus = await Permission.storage.status;
      final PermissionStatus cameraStatus = await Permission.camera.status;
      final PermissionStatus photosStatus = await Permission.photos.status;

      if (storageStatus.isDenied ||
          cameraStatus.isDenied ||
          photosStatus.isDenied) {
        await _requestPermissions();
      }
      final XFile? photo = await _picker.pickImage(source: source);
      if (photo == null) return; // User canceled image picking

      // Capture the current date and time when the image is picked
      DateTime imageDateTime = DateTime.now();

      setState(() {
        if (cameraIndex == 1) {
          camera1Images.add(photo.path);
          camera1ImageDates.add(imageDateTime);
        } else if (cameraIndex == 2) {
          camera2Images.add(photo.path);
          camera2ImageDates.add(imageDateTime);
        } else if (cameraIndex == 3) {
          camera3Images.add(photo.path);
          camera3ImageDates.add(imageDateTime);
        }
      });

      // Upload the image to Firebase Storage
      final FirebaseStorage _storage = FirebaseStorage.instance;
      final Reference ref = _storage
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putFile(File(photo.path));

      // Get the download URL of the uploaded image
      final String downloadUrl = await ref.getDownloadURL();

      // Add the image path to the list
      setState(() {
        if (cameraIndex == 1) {
          camera1Images[camera1Images.length - 1] = downloadUrl;
        } else if (cameraIndex == 2) {
          camera2Images[camera2Images.length - 1] = downloadUrl;
        } else if (cameraIndex == 3) {
          camera3Images[camera3Images.length - 1] = downloadUrl;
        }
      });
      // Navigate to Outstanding Photos and PhotoStream screens
      List<String> imagePaths;
      List<DateTime> imageDates;
      if (cameraIndex == 1) {
        imagePaths = camera1Images;
        imageDates = camera1ImageDates;
      } else if (cameraIndex == 2) {
        imagePaths = camera2Images;
        imageDates = camera2ImageDates;
      } else {
        imagePaths = camera3Images;
        imageDates = camera3ImageDates;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OutstandingPhotos(imagePaths: imagePaths),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoStreamScreen(
            imagePaths: imagePaths,
            imageDates: imageDates,
          ),
        ),
      );
      setState(() {});
    } catch (e) {
      if (e is FirebaseException) {
        print('Firebase error: ${e.code}');
      } else {
        print('Error picking or processing image: $e');
      }
    }
  }

  String? button1;
  String? button2;
  final Map<String, List<String>> items = {
    'Internal': [
      'Add own element',
      'Bathroom',
      'Bedroom 1',
      'Bedroom 2',
      'Bedroom 3',
      'Bedroom 4',
      'Bedroom 5',
      'Cloakroom',
      'Conservatory',
      'Dining room',
      'Dressing room',
      'Ensuite',
      'Hall',
      'Kitchen',
      'Kitchen dinner',
      'Landing',
      'Living room',
      'Lounge',
      'Lounge dinner',
      'Playroom',
      'Sitting room',
      'Study',
      'Utility room',
    ],
    'External': [
      'Add own element',
      'Basement',
      'External Elevation',
      'Integerated Garage',
      'Loft'
    ],
  };
  String? button3;
  final List<String> items3 = ['Yes', 'No'];
  String? button4;
  final List<String> items4 = ['Yes', 'No'];
  String? button5;
  final List<String> items5 = ['Yes', 'No'];
  String? button6;
  final List<String> items6 = ['Yes', 'No'];
  String? button7;
  final List<String> items7 = ['Yes', 'No'];
  String? button8;
  final List<String> items8 = ['Yes', 'No'];
  String? button9;
  final List<String> items9 = ['Yes', 'No'];
  String? button10;
  final List<String> items10 = ['Yes', 'No'];

  final _formKey = GlobalKey<FormState>();

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
                Navigator.push(
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
        title: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 12),
          child: Text(
            // "Bedroom 1",
            barTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(
                      child: Text(
                        "Element has been added!",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    duration: Duration(seconds: 1),
                  ),
                );
                Timer(const Duration(seconds: 2), () {
                  globalButtons.add(
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Bedroom1()),
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
                                          "assets/images/attachment.svg",
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
                                        color: const Color.fromRGBO(
                                            37, 144, 240, 1),
                                        // color: Colors.red,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    barTitle,
                                    style: const TextStyle(
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
                                  borderRadius: BorderRadius.circular(6.2),
                                  color: const Color.fromRGBO(37, 144, 240, 1),
                                ),
                                child: CupertinoButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () {},
                                  child: const SizedBox(
                                    height: 17,
                                    child: Text(
                                      "Added",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color.fromRGBO(255, 255, 255, 1),
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ConditionReport()),
                  );
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
              color: const Color.fromRGBO(204, 204, 204, 0.5),
              child: Container(
                height: 1900,
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
                      key: _formKey,
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
                                    opacity: 0.5,
                                    child: Text(
                                        "Is this element internal or external?",
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
                                    isDense: true,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(57, 55, 56, 1),
                                    ),
                                    value: button1,
                                    hint: const Text(
                                      "Select the Element",
                                      textAlign: TextAlign.center,
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
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
                                    items: items.keys.map((String key) {
                                      return DropdownMenuItem(
                                        alignment: Alignment.centerLeft,
                                        value: key,
                                        child: Text(key),
                                      );
                                    }).toList(),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select element';
                                      }
                                      return null;
                                    },
                                    onChanged: (String? value) {
                                      setState(() {
                                        button1 = value;
                                        button2 = null;
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
                                    opacity: 0.5,
                                    child: Text("Please select your element",
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
                                // height: 82,f
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
                                    isExpanded: true,
                                    isDense: true,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(57, 55, 56, 1),
                                    ),
                                    value: button2,
                                    hint: const Text(
                                      "Select the Element",
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
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            255, 255, 255, 1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    items: items[button1]?.map((item) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerLeft,
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select the element';
                                      }
                                      return null;
                                    },
                                    onChanged: (String? value) {
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
                                    opacity: 0.5,
                                    child: Text("Element Name",
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
                                    controller: _textController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (String? value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Element Name';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(57, 55, 56, 1),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Enter the Element Name",
                                      hintStyle: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: FontWeight.w300,
                                        color: Color.fromRGBO(57, 55, 56, 0.5),
                                      ),
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
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Text("Condition Summary",
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
                                        return 'Please enter Condition Summary';
                                      }
                                      return null;
                                    },
                                    onTap: () {},
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(57, 55, 56, 1),
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Enter Condition Summary",
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
                                        onPressed: () =>
                                            _showImageSourceSelection(1),
                                        icon: SvgPicture.asset(
                                          "assets/images/camera (1).svg",
                                          color: const Color.fromRGBO(
                                              57, 55, 56, 0.5),
                                        ),
                                      ),
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 18),
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
                                      children: List.generate(
                                          camera1Images.length, (index) {
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
                                                    image: camera1Images[index]
                                                            .startsWith('http')
                                                        ? NetworkImage(
                                                            camera1Images[
                                                                index])
                                                        : FileImage(File(
                                                            camera1Images[
                                                                index])),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    camera1Images
                                                        .removeAt(index);
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
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: SizedBox(
                                  height: 28,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Text("Ventilation",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w300,
                                          color: Color.fromRGBO(28, 28, 28, 1),
                                        )),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: SizedBox(
                                  height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Text(
                                        "Does the room have any windows?",
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
                                    value: button3,
                                    hint: const Text(
                                      "Select the Option",
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
                                    items: items3.map((options1) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerLeft,
                                        value: options1,
                                        child: Text(options1),
                                      );
                                    }).toList(),
                                    validator: (String? value) {
                                      if (value == null) {
                                        return 'Please select the option';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        button3 = value;
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
                                  // height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Text(
                                        "Are the undercuts on all the internal doors?",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                                // height: 82,
                                width: 364,
                                child: Center(
                                  child: DropdownButtonFormField2(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      // helperText: "",
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
                                    value: button4,
                                    hint: const Text(
                                      "Select the Option",
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
                                    items: items4.map((option2) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerLeft,
                                        value: option2,
                                        child: Text(option2),
                                      );
                                    }).toList(),
                                    validator: (String? value) {
                                      if (value == null) {
                                        return 'Please select the option';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        button4 = value;
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
                                    opacity: 0.5,
                                    child: Text("Do they have trickle vents",
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
                                // height: 82,
                                width: 364,
                                child: Center(
                                  child: DropdownButtonFormField2(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      // helperText: "",
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
                                    value: button5,
                                    hint: const Text(
                                      "Enter Condition Summary",
                                      textAlign: TextAlign.center,
                                    ),
                                    iconStyleData: IconStyleData(
                                      icon: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/IconV.svg",
                                            height: 24,
                                            width: 24,
                                            color: const Color.fromRGBO(
                                                57, 55, 56, 0.5),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () =>
                                                _showImageSourceSelection(2),
                                            child: SvgPicture.asset(
                                              "assets/images/camera (1).svg",
                                              color: const Color.fromRGBO(
                                                  57, 55, 56, 0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    items: items5.map((option3) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerLeft,
                                        value: option3,
                                        child: Text(option3),
                                      );
                                    }).toList(),
                                    validator: (String? value) {
                                      if (value == null) {
                                        return 'Please enter Condition Summary';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        button5 = value;
                                      });
                                    },
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
                                      children: List.generate(
                                          camera2Images.length, (index) {
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
                                                    // image: FileImage(File(
                                                    //     camera2Images[index])),
                                                    image: NetworkImage(
                                                        camera1Images[index]),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    camera2Images
                                                        .removeAt(index);
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
                                  // height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Text(
                                        "Is there any open-flued heating appliance within this room?",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                                // height: 82,
                                width: 364,
                                child: Center(
                                  child: DropdownButtonFormField2(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      // helperText: "",
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
                                    value: button6,
                                    hint: const Text(
                                      "Select the Option",
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
                                    items: items6.map((option4) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerLeft,
                                        value: option4,
                                        child: Text(option4),
                                      );
                                    }).toList(),
                                    validator: (String? value) {
                                      if (value == null) {
                                        return 'Please select the option';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        button6 = value;
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
                                  // height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Text(
                                        "Are the undercuts on all the internal doors (7.6mm gap on a one meter door)?",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                                // height: 82,
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
                                    value: button7,
                                    hint: const Text(
                                      "Enter Condition Summary",
                                      textAlign: TextAlign.center,
                                    ),
                                    iconStyleData: IconStyleData(
                                      icon: Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/images/IconV.svg",
                                            height: 24,
                                            width: 24,
                                            color: const Color.fromRGBO(
                                                57, 55, 56, 0.5),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () =>
                                                _showImageSourceSelection(3),
                                            child: SvgPicture.asset(
                                              "assets/images/camera (1).svg",
                                              color: const Color.fromRGBO(
                                                  57, 55, 56, 0.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    items: items7.map((options5) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerLeft,
                                        value: options5,
                                        child: Text(options5),
                                      );
                                    }).toList(),
                                    validator: (String? value) {
                                      if (value == null) {
                                        return 'Please enter Condition Summary';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        button7 = value;
                                      });
                                    },
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
                                      children: List.generate(
                                          camera3Images.length, (index) {
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
                                                    // image: FileImage(File(
                                                    //     camera3Images[index])),
                                                    image: NetworkImage(
                                                        camera1Images[index]),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    camera3Images
                                                        .removeAt(index);
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
                                  // height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Text(
                                        "Does the room have intermittent extract fans fitted?",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                                // height: 82,
                                width: 364,
                                child: Center(
                                  child: DropdownButtonFormField2(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      // helperText: "",
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
                                    value: button8,
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
                                    items: items8.map((options6) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerLeft,
                                        value: options6,
                                        child: Text(options6),
                                      );
                                    }).toList(),
                                    validator: (String? value) {
                                      if (value == null) {
                                        return 'Please select the option';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        button8 = value;
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
                                  // height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Text(
                                        "Are there any other existing ventilation systems present in this room?",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                                // height: 82,
                                width: 364,
                                child: Center(
                                  child: DropdownButtonFormField2(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      // helperText: "",
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
                                    value: button9,
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
                                    items: items9.map((options7) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerLeft,
                                        value: options7,
                                        child: Text(options7),
                                      );
                                    }).toList(),
                                    validator: (String? value) {
                                      if (value == null) {
                                        return 'Please select the option';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        button9 = value;
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
                                  // height: 24,
                                  width: 330,
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Text(
                                        "Is there any evidence of condensation, damp or mould growth in this room?",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
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
                                // height: 82,
                                width: 364,
                                child: Center(
                                  child: DropdownButtonFormField2(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                      // helperText: "",
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
                                    value: button10,
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
                                    items: items10.map((options8) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerLeft,
                                        value: options8,
                                        child: Text(options8),
                                      );
                                    }).toList(),
                                    validator: (String? value) {
                                      if (value == null) {
                                        return 'Please select the option';
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        button10 = value;
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
                                    opacity: 0.5,
                                    child: Text("Additional notes",
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
                              Container(
                                constraints: const BoxConstraints(
                                  minHeight:
                                      100, // Default height of the container
                                ),
                                width: 364,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color:
                                        const Color.fromRGBO(98, 98, 98, 0.1),
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 17, right: 17, top: 10, bottom: 19),
                                  child: CupertinoTextFormFieldRow(
                                    textAlign: TextAlign.start,
                                    maxLines: null, // Allows for multiple lines
                                    keyboardType: TextInputType
                                        .multiline, // Keyboard suited for multiline
                                    placeholder: "If any! (optional)",
                                    placeholderStyle: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(57, 55, 56, 0.5),
                                    ),
                                    padding: EdgeInsets.zero,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w300,
                                      color: Color.fromRGBO(57, 55, 56, 1),
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

  void _showImageSourceSelection(int cameraIndex) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, cameraIndex);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_album),
              title: const Text('Pick from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, cameraIndex);
              },
            ),
          ],
        );
      },
    );
  }
}
