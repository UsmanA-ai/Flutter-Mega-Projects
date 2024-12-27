import 'package:condition_report/Screens/condition_report.dart';
import 'package:condition_report/Screens/select_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PhotoStreamScreen extends StatefulWidget {
  final List<String> imagePaths; // Change to List<String> for multiple paths
  final List<DateTime> imageDates;

  const PhotoStreamScreen({
    Key? key,
    required this.imagePaths, // Update to List<String>
    required this.imageDates,
  }) : super(key: key);

  @override
  State<PhotoStreamScreen> createState() => _PhotoStreamScreenState();
}

class _PhotoStreamScreenState extends State<PhotoStreamScreen> {
  List<String> imagePathList = [];
  List<DateTime> imageDateList = [];

  @override
  void initState() {
    super.initState();
    // Add the list of images passed from the previous screen
    imagePathList.addAll(widget.imagePaths);
    imageDateList.addAll(widget.imageDates);
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
            "Photo Stream",
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
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromRGBO(204, 204, 204, 1),
          child: Container(
            height: MediaQuery.of(context).size.height - 160, // Adjusted height
            color: const Color.fromRGBO(253, 253, 253, 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Column(
                children: imagePathList.isNotEmpty
                    ? imagePathList.asMap().entries.map<Widget>((entry) {
                        int index = entry.key;
                        String imagePath = entry.value;
                        DateTime imageDate = imageDateList[index];

                        // Format the date and time
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(imageDate);
                        String formattedTime =
                            DateFormat('HH:mm').format(imageDate);

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectSelctionScreen(),
                              ),
                            );
                          },
                          child: CupertinoFormRow(
                            padding: EdgeInsets.zero,
                            prefix: Row(
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2.75),
                                      // image: DecorationImage(
                                      //   image: FadeInImage(
                                      //     placeholder: AssetImage(
                                      //         "assets/images/placeholder.png"),
                                      //     image: NetworkImage(imagePath),
                                      //     fit: BoxFit.cover,
                                      //   ).image,
                                      //   fit: BoxFit.cover,
                                      // ),
                                      image: DecorationImage(
                                        image: NetworkImage(imagePath),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "General Image",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color.fromRGBO(57, 55, 56, 1),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "$formattedDate ; $formattedTime",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color.fromRGBO(57, 55, 56, 0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              "assets/images/RightArrow.svg",
                              height: 16,
                              width: 16,
                            ),
                          ),
                        );
                      }).toList()
                    : const [Center(child: Text("No images available"))],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
