import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OutstandingPhotos extends StatefulWidget {
  final List<String> imagePaths;
  const OutstandingPhotos({super.key, required this.imagePaths});

  @override
  State<OutstandingPhotos> createState() => _OutstandingPhotosState();
}

class _OutstandingPhotosState extends State<OutstandingPhotos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarOpacity: 0.32,
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        title: const Center(
          child: Text(
            "Outstanding Photos",
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
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 20,
                      children: widget.imagePaths.map((imagePath) {
                        return SizedBox(
                          height: 108,
                          width: 108,
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                height: 108,
                                width: 108,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.2),
                                  image: DecorationImage(
                                    image: FileImage(File(imagePath)),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: SvgPicture.asset(
                                        "assets/images/Ellipse 270.svg",
                                        height: 15,
                                        width: 15,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.39),
                                      child: SvgPicture.asset(
                                        "assets/images/Group 1353 (1).svg",
                                        height: 15,
                                        width: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(), // Don't forget to call toList() to convert the map to a list
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}








// class OutstandingPhotos extends StatefulWidget {
//   final List<String> imagePaths; // List<String> for multiple image paths

//   const OutstandingPhotos({Key? key, required this.imagePaths}) : super(key: key);

//   @override
//   State<OutstandingPhotos> createState() => _OutstandingPhotosState();
// }

// class _OutstandingPhotosState extends State<OutstandingPhotos> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarOpacity: 0.32,
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 24),
//           child: IconButton(
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ConditionReport()),
//               );
//             },
//             icon: SvgPicture.asset(
//               "assets/images/Icon (2).svg",
//               height: 24,
//               width: 24,
//               fit: BoxFit.fill,
//             ),
//           ),
//         ),
//         title: const Center(
//           child: Text(
//             "Outstanding Photos",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 24,
//               fontStyle: FontStyle.normal,
//               color: Color.fromRGBO(57, 55, 56, 1),
//             ),
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 24),
//             child: IconButton(
//               onPressed: () {},
//               icon: Image.asset(
//                 "assets/images/Filters (1).png",
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.only(left: 32, right: 32, bottom: 20),
//         child: Container(
//           height: 60,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(100),
//           ),
//           child: FilledButton(
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all<Color>(
//                 const Color.fromRGBO(98, 98, 98, 1),
//               ),
//             ),
//             onPressed: () {},
//             child: const Text(
//               "Submit",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: widget.imagePaths.isNotEmpty
//           ? Padding(
//               padding: const EdgeInsets.all(20),
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3, // Number of items in each row
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: widget.imagePaths.length,
//                 itemBuilder: (context, index) {
//                   return Stack(
//                     alignment: Alignment.topRight,
//                     children: [
//                       Container(
//                         height: 108,
//                         width: 108,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(6.2),
//                           image: DecorationImage(
//                             image: FileImage(File(widget.imagePaths[index])),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           // Handle delete or other actions
//                         },
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(5),
//                               child: SvgPicture.asset(
//                                 "assets/images/Ellipse 270.svg",
//                                 height: 15,
//                                 width: 15,
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(1.39),
//                               child: SvgPicture.asset(
//                                 "assets/images/Group 1353 (1).svg",
//                                 height: 15,
//                                 width: 15,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             )
//           : const Center(
//               child: Text('No images available'),
//             ),
//     );
//   }
// }

                        // SizedBox(
                        //   height: 108,
                        //   width: 108,
                        //   child: Stack(
                        //     alignment: Alignment.topRight,
                        //     children: [
                        //       Container(
                        //         height: 108,
                        //         width: 108,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(6.2),
                        //           image: const DecorationImage(
                        //             image: AssetImage(
                        //               "assets/images/b9f21842550e3bcb9325c083dba2e8ec.png",
                        //             ),
                        //             fit: BoxFit.fill,
                        //           ),
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {},
                        //         child: Stack(
                        //           alignment: Alignment.center,
                        //           children: [
                        //             Padding(
                        //               padding: const EdgeInsets.all(5),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Ellipse 270.svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.all(1.39),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Group 1353 (1).svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 108,
                        //   width: 108,
                        //   child: Stack(
                        //     alignment: Alignment.topRight,
                        //     children: [
                        //       Container(
                        //         height: 108,
                        //         width: 108,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(6.2),
                        //           image: const DecorationImage(
                        //             image: AssetImage(
                        //               "assets/images/b9f21842550e3bcb9325c083dba2e8ec.png",
                        //             ),
                        //             fit: BoxFit.fill,
                        //           ),
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {},
                        //         child: Stack(
                        //           alignment: Alignment.center,
                        //           children: [
                        //             Padding(
                        //               padding: const EdgeInsets.all(5),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Ellipse 270.svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.all(1.39),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Group 1353 (1).svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 108,
                        //   width: 108,
                        //   child: Stack(
                        //     alignment: Alignment.topRight,
                        //     children: [
                        //       Container(
                        //         height: 108,
                        //         width: 108,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(6.2),
                        //           image: const DecorationImage(
                        //             image: AssetImage(
                        //               "assets/images/b9f21842550e3bcb9325c083dba2e8ec.png",
                        //             ),
                        //             fit: BoxFit.fill,
                        //           ),
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {},
                        //         child: Stack(
                        //           alignment: Alignment.center,
                        //           children: [
                        //             Padding(
                        //               padding: const EdgeInsets.all(5),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Ellipse 270.svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.all(1.39),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Group 1353 (1).svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 108,
                        //   width: 108,
                        //   child: Stack(
                        //     alignment: Alignment.topRight,
                        //     children: [
                        //       Container(
                        //         height: 108,
                        //         width: 108,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(6.2),
                        //           image: const DecorationImage(
                        //             image: AssetImage(
                        //               "assets/images/b9f21842550e3bcb9325c083dba2e8ec.png",
                        //             ),
                        //             fit: BoxFit.fill,
                        //           ),
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {},
                        //         child: Stack(
                        //           alignment: Alignment.center,
                        //           children: [
                        //             Padding(
                        //               padding: const EdgeInsets.all(5),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Ellipse 270.svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.all(1.39),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Group 1353 (1).svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 108,
                        //   width: 108,
                        //   child: Stack(
                        //     alignment: Alignment.topRight,
                        //     children: [
                        //       Container(
                        //         height: 108,
                        //         width: 108,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(6.2),
                        //           image: const DecorationImage(
                        //             image: AssetImage(
                        //               "assets/images/b9f21842550e3bcb9325c083dba2e8ec.png",
                        //             ),
                        //             fit: BoxFit.fill,
                        //           ),
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {},
                        //         child: Stack(
                        //           alignment: Alignment.center,
                        //           children: [
                        //             Padding(
                        //               padding: const EdgeInsets.all(5),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Ellipse 270.svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.all(1.39),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Group 1353 (1).svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 108,
                        //   width: 108,
                        //   child: Stack(
                        //     alignment: Alignment.topRight,
                        //     children: [
                        //       Container(
                        //         height: 108,
                        //         width: 108,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(6.2),
                        //           image: const DecorationImage(
                        //             image: AssetImage(
                        //               "assets/images/b9f21842550e3bcb9325c083dba2e8ec.png",
                        //             ),
                        //             fit: BoxFit.fill,
                        //           ),
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {},
                        //         child: Stack(
                        //           alignment: Alignment.center,
                        //           children: [
                        //             Padding(
                        //               padding: const EdgeInsets.all(5),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Ellipse 270.svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.all(1.39),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Group 1353 (1).svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 108,
                        //   width: 108,
                        //   child: Stack(
                        //     alignment: Alignment.topRight,
                        //     children: [
                        //       Container(
                        //         height: 108,
                        //         width: 108,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(6.2),
                        //           image: const DecorationImage(
                        //             image: AssetImage(
                        //               "assets/images/b9f21842550e3bcb9325c083dba2e8ec.png",
                        //             ),
                        //             fit: BoxFit.fill,
                        //           ),
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {},
                        //         child: Stack(
                        //           alignment: Alignment.center,
                        //           children: [
                        //             Padding(
                        //               padding: const EdgeInsets.all(5),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Ellipse 270.svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.all(1.39),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Group 1353 (1).svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 108,
                        //   width: 108,
                        //   child: Stack(
                        //     alignment: Alignment.topRight,
                        //     children: [
                        //       Container(
                        //         height: 108,
                        //         width: 108,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(6.2),
                        //           image: const DecorationImage(
                        //             image: AssetImage(
                        //               "assets/images/b9f21842550e3bcb9325c083dba2e8ec.png",
                        //             ),
                        //             fit: BoxFit.fill,
                        //           ),
                        //         ),
                        //       ),
                        //       GestureDetector(
                        //         onTap: () {},
                        //         child: Stack(
                        //           alignment: Alignment.center,
                        //           children: [
                        //             Padding(
                        //               padding: const EdgeInsets.all(5),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Ellipse 270.svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //             Padding(
                        //               padding: const EdgeInsets.all(1.39),
                        //               child: SvgPicture.asset(
                        //                 "assets/images/Group 1353 (1).svg",
                        //                 height: 15,
                        //                 width: 15,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),











// import 'dart:io';
// import 'package:flutter/material.dart';

// class GridViewScreen extends StatefulWidget {
//   final List<String> imagePaths;

//   GridViewScreen({required this.imagePaths});

//   @override
//   _GridViewScreenState createState() => _GridViewScreenState();
// }

// class _GridViewScreenState extends State<GridViewScreen> {
//   List<String> _imagePaths = [];

//   @override
//   void initState() {
//     super.initState();
//     _imagePaths = widget.imagePaths; // Initialize the imagePaths
//   }

//   void _removeImage(int index) {
//     setState(() {
//       _imagePaths.removeAt(index);
//     });
//   }

//   void _openImageFullScreen(String imagePath) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FullScreenImage(imagePath: imagePath),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Grid View'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(10),
//         child: GridView.builder(
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 3,
//             crossAxisSpacing: 8,
//             mainAxisSpacing: 8,
//           ),
//           itemCount: _imagePaths.length,
//           itemBuilder: (context, index) {
//             return Stack(
//               alignment: Alignment.topLeft,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     _openImageFullScreen(_imagePaths[index]);
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(6.2),
//                       image: DecorationImage(
//                         image: FileImage(File(_imagePaths[index])),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     _removeImage(index);
//                   },
//                   child: Icon(Icons.cancel, color: Colors.red),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// class FullScreenImage extends StatelessWidget {
//   final String imagePath;

//   FullScreenImage({required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Full-Screen Image'),
//       ),
//       body: Center(
//         child: Image.file(
//           File(imagePath),
//           fit: BoxFit
//               .contain, // Adjust this to change how the image fits the screen
//         ),
//       ),
//     );
//   }
// }








// class OutstandingPhotos extends StatefulWidget {
//   final List<String> imagePaths;

//   const OutstandingPhotos({Key? key, required this.imagePaths})
//       : super(key: key);

//   @override
//   State<OutstandingPhotos> createState() => _OutstandingPhotosState();
// }

// class _OutstandingPhotosState extends State<OutstandingPhotos> {
//   List<String> _imagePaths = [];

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the local _imagePaths with the incoming list from widget
//     _imagePaths = List.from(widget.imagePaths);
//   }

//   void _deleteImage(int index) {
//     // Show confirmation dialog before deleting
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Delete Image'),
//           content: const Text('Are you sure you want to delete this image?'),
//           actions: [
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//             TextButton(
//               child: const Text('Delete'),
//               onPressed: () {
//                 setState(() {
//                   _imagePaths.removeAt(index); // Remove image
//                 });
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarOpacity: 0.32,
//         centerTitle: true,
//         elevation: 0,
//         backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 24),
//           child: IconButton(
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => const ConditionReport()),
//               );
//             },
//             icon: SvgPicture.asset(
//               "assets/images/Icon (2).svg",
//               height: 24,
//               width: 24,
//               fit: BoxFit.fill,
//             ),
//           ),
//         ),
//         title: const Center(
//           child: Text(
//             "Outstanding Photos",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 24,
//               fontStyle: FontStyle.normal,
//               color: Color.fromRGBO(57, 55, 56, 1),
//             ),
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 24),
//             child: IconButton(
//               onPressed: () {},
//               icon: Image.asset(
//                 "assets/images/Filters (1).png",
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.only(left: 32, right: 32, bottom: 20),
//         child: Container(
//           height: 60,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(100),
//           ),
//           child: FilledButton(
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all<Color>(
//                 const Color.fromRGBO(98, 98, 98, 1),
//               ),
//             ),
//             onPressed: () {
//               // Handle submission or other actions
//             },
//             child: const Text(
//               "Submit",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: _imagePaths.isNotEmpty
//           ? Padding(
//               padding: const EdgeInsets.all(20),
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3, // Number of items in each row
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                 ),
//                 itemCount: _imagePaths.length,
//                 itemBuilder: (context, index) {
//                   return Stack(
//                     alignment: Alignment.topRight,
//                     children: [
//                       Container(
//                         height: 108,
//                         width: 108,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(6.2),
//                           image: DecorationImage(
//                             image: FileImage(File(_imagePaths[index])),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           _deleteImage(index); // Trigger image deletion
//                         },
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(5),
//                               child: SvgPicture.asset(
//                                 "assets/images/Ellipse 270.svg",
//                                 height: 15,
//                                 width: 15,
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(1.39),
//                               child: SvgPicture.asset(
//                                 "assets/images/Group 1353 (1).svg",
//                                 height: 15,
//                                 width: 15,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             )
//           : const Center(
//               child: Text('No images available'),
//             ),
//     );
//   }
// }
