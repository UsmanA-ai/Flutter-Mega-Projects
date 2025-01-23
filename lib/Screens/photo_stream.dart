import 'dart:developer';
import 'dart:io';

import 'package:condition_report/Screens/condition_report.dart';
import 'package:condition_report/Screens/select_selection.dart';
import 'package:condition_report/common_widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhotoStreamScreen extends StatefulWidget {
  // final List<String> imagePaths;
  // final List<DateTime> imageDates;

  const PhotoStreamScreen({
    super.key,
    // required this.imagePaths,
    // required this.imageDates,
  });

  @override
  State<PhotoStreamScreen> createState() => _PhotoStreamScreenState();
}

class _PhotoStreamScreenState extends State<PhotoStreamScreen> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final List<String> _imageUrls = [];
  bool _isLoading = false; // Added loading state

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      final response =
          await _supabaseClient.storage.from('Images').list(path: 'images');

      if (response.isEmpty) {
        log("No images found in Supabase storage.");
        setState(() {
          _isLoading = false; // Hide loading indicator
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
        _isLoading = false; // Hide loading indicator
      });
    } catch (e) {
      log("Error fetching images: $e");
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  void _showImageSourceSelection() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take a Photo'),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.camera);

                if (image != null) {
                  await _uploadImageToSupabase(image);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('Pick from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);

                if (image != null) {
                  await _uploadImageToSupabase(image);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImageToSupabase(XFile image) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final path = 'images/$fileName.jpg';

      final fileBytes = await File(image.path).readAsBytes();
      await _supabaseClient.storage.from('Images').uploadBinary(path, fileBytes,
          fileOptions: const FileOptions(upsert: false));

      final publicUrl =
          _supabaseClient.storage.from('Images').getPublicUrl(path);

      setState(() {
        _imageUrls.add(publicUrl);
      });

      log('Image uploaded and public URL added: $publicUrl');
    } catch (e) {
      log('Error uploading image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
        leading: Padding(
          padding: const EdgeInsets.only(left: 24, top: 20, bottom: 12),
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
              icon: SvgPicture.asset("assets/images/Icon (2).svg",
                  height: 24, width: 24),
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
                color: Color.fromRGBO(57, 55, 56, 1)),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: IconButton(
              padding: const EdgeInsets.all(0.0),
              color: const Color.fromRGBO(57, 55, 56, 1),
              onPressed: () {},
              icon: Image.asset("assets/images/Filters (1).png", scale: 1.0),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
          : _imageUrls.isNotEmpty
              ? ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _imageUrls.length,
                  itemBuilder: (context, index) {
                    final imageDate = DateTime.now();
                    final formattedDate =
                        DateFormat('dd/MM/yyyy').format(imageDate);

                    return ListTile(
                      leading: Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _imageUrls[index].isEmpty
                            ? Icon(
                                Icons.image, // Default icon while loading
                                size: 48,
                                color: Colors.grey,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _imageUrls[index],
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child; // Display the image when loaded
                                    }
                                    return Center(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    (loadingProgress
                                                            .expectedTotalBytes ??
                                                        1)
                                                : null,
                                            color: Colors
                                                .black, // You can customize the color
                                          ),
                                          Text(
                                            loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? '${((loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)) * 100).toStringAsFixed(0)}%' // Calculate percentage
                                                : '0%', // Fallback
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons
                                          .error, // Show error icon if loading fails
                                      size: 48,
                                      color: Colors.red,
                                    );
                                  },
                                ),
                              ),
                      ),
                      title: const Text('Image'),
                      subtitle: Text(formattedDate),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectSelctionScreen()),
                        );
                      },
                    );
                  },
                )
              : const Center(child: Text("No images available")),
      bottomNavigationBar: SubmitButton(
        onPressed: _showImageSourceSelection,
        text: "Upload a Picture",
      ),
    );
  }
}
