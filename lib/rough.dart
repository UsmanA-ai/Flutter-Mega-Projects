// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;
// import 'package:path_provider/path_provider.dart';

// class ImagePickerExample extends StatefulWidget {
//   @override
//   _ImagePickerExampleState createState() => _ImagePickerExampleState();
// }

// class _ImagePickerExampleState extends State<ImagePickerExample> {
//   final ImagePicker _picker = ImagePicker();
//   String? imagePathOriginal;
//   String? imagePathResized1;
//   String? imagePathResized2;

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? photo = await _picker.pickImage(source: source);
//       if (photo == null) return;

//       // Load the image
//       final image = img.decodeImage(File(photo.path).readAsBytesSync())!;

//       // Resize images
//       final img1 = img.copyResize(image, width: 800); // Resize to 800px width
//       final img2 = img.copyResize(image, width: 400); // Resize to 400px width

//       // Get the temporary directory
//       final directory = await getTemporaryDirectory();

//       // Define file paths
//       imagePathOriginal = photo.path;
//       imagePathResized1 = '${directory.path}/resized_image_800.jpg';
//       imagePathResized2 = '${directory.path}/resized_image_400.jpg';

//       // Save images to different locations
//       File(imagePathResized1!).writeAsBytesSync(img.encodeJpg(img1)!);
//       File(imagePathResized2!).writeAsBytesSync(img.encodeJpg(img2)!);

//       print('Original image saved to: $imagePathOriginal');
//       print('Resized image 800px width saved to: $imagePathResized1');
//       print('Resized image 400px width saved to: $imagePathResized2');
//     } catch (e) {
//       print('Error picking or processing image: $e');
//     }
//   }

//   void _showImageSourceSelection() {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Icon(Icons.camera_alt),
//               title: Text('Take a Photo'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.camera);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_album),
//               title: Text('Pick from Gallery'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _pickImage(ImageSource.gallery);
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
//       appBar: AppBar(title: Text('Image Picker Example')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _showImageSourceSelection,
//               child: Text('Pick or Take Image'),
//             ),
//             if (imagePathOriginal != null) ...[
//               Image.file(File(imagePathOriginal!)),
//               Text('Original Image'),
//             ],
//             if (imagePathResized1 != null) ...[
//               Image.file(File(imagePathResized1!)),
//               Text('Resized Image 800px'),
//             ],
//             if (imagePathResized2 != null) ...[
//               Image.file(File(imagePathResized2!)),
//               Text('Resized Image 400px'),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// // void main() {
// //   runApp(MaterialApp(
// //     home: ImagePickerExample(),
// //   ));
// // }

import 'package:condition_report/StartupScreens/signIn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore_for_file: must_be_immutable
class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<SignupScreen> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFDFDFD),
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 41.5,
                  ),
                  child: SizedBox(
                    width: 130,
                    height: 74.2,
                    child: SvgPicture.asset(
                      "assets/images/logo-svg.svg",
                      color: const Color.fromRGBO(92, 148, 155, 1),
                    ),
                  ),
                ),
                const SizedBox(height: 38.28),
                const SizedBox(
                  width: 216,
                  child: Text(
                    "Create your\naccount",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0XFF393738),
                      fontSize: 40,
                      fontFamily: 'Mundial',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(height: 14),
                const SizedBox(
                  width: 353,
                  // height: 50,
                  child: Text(
                    "Personalize your construction report with condition report.",
                    maxLines: 2,
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Color(0X7F20242B),
                      fontSize: 18,
                      fontFamily: 'Mundial',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.20,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 364,
                  child: TextFormField(
                    // focusNode: FocusNode(),
                    autofocus: true,
                    controller: emailController,
                    style: const TextStyle(
                      color: Color(0X3F393738),
                      fontSize: 16,
                      fontFamily: 'Mundial',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: const TextStyle(
                        color: Color(0X3F393738),
                        fontSize: 16,
                        fontFamily: 'Mundial',
                        fontWeight: FontWeight.w400,
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
                const SizedBox(height: 17.5),
                SizedBox(
                  width: 364,
                  child: TextFormField(
                    focusNode: FocusNode(),
                    obscureText: _isObscured,
                    autofocus: true,
                    controller: passwordController,
                    style: const TextStyle(
                      color: Color(0X3F393738),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textInputAction: TextInputAction.done,
                    // obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: const TextStyle(
                        color: Color(0X3F393738),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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
                      suffixIcon: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                          child: SvgPicture.asset(
                            "assets/images/eyeIcon.svg",
                            height: 24,
                            width: 24,
                            color: const Color.fromRGBO(57, 55, 56, 0.5),
                          ),
                        ),
                      ),
                      suffixIconConstraints: const BoxConstraints(
                        maxHeight: 60,
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.maxFinite,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0XFF626262),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          30,
                        ),
                      ),
                      visualDensity: const VisualDensity(
                        vertical: -4,
                        horizontal: -4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 18,
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        color: Color(0XFFFFFFFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 72),
                _buildRowWithLines(context),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {},
                      padding: const EdgeInsets.all(0),
                      icon: Container(
                        width: 85,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                          border: Border.all(
                            color: const Color(0XFFEBF0F0),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 18),
                        child: SvgPicture.asset(
                          "assets/images/Frame.svg",
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {},
                      padding: const EdgeInsets.all(0),
                      icon: Container(
                        width: 85,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                          border: Border.all(
                            color: const Color(0XFFEBF0F0),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 18),
                        child: SvgPicture.asset(
                          "assets/images/Frame (1).svg",
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {},
                      padding: const EdgeInsets.all(0),
                      icon: Container(
                        width: 85,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                          border: Border.all(
                            color: const Color(0XFFEBF0F0),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 18),
                        child: SvgPicture.asset(
                          "assets/images/Frame (2).svg",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 52),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Color(0XFF393738),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()),
                          );
                        },
                        child: const Text(
                          "Log in",
                          style: TextStyle(
                            color: Color(0XFF2590F0),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 4)
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildRowWithLines(BuildContext context) {
    return const SizedBox(
      width: double.maxFinite,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Color(0XFFEBF0F0),
              ),
            ),
          ),
          SizedBox(width: 26),
          Align(
            alignment: Alignment.center,
            child: Text(
              "or continue with",
              style: TextStyle(
                color: Color(0X9920242B),
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(width: 26),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Color(0XFFEBF0F0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
