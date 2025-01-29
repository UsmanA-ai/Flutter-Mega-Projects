import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condition_report/Screens/select_selection.dart';
import 'package:condition_report/common_widgets/submit_button.dart';
import 'package:condition_report/models/image_detail.dart';
import 'package:condition_report/provider/assessment_provider.dart';
import 'package:condition_report/services/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhotoStreamScreen extends StatefulWidget {
  const PhotoStreamScreen({super.key});

  @override
  State<PhotoStreamScreen> createState() => _PhotoStreamScreenState();
}

class _PhotoStreamScreenState extends State<PhotoStreamScreen> {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final List<String> _imageUrls = [];
  final bool _isLoading = false;

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

      FireStoreServices().addImage(
        currentId!,
        ImageDetail(
            path: publicUrl,
            id: 'ps',
            location: 'photoStream',
            subSelection: 'subSelection'),
      );

      // return publicUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image: $e")),
      );
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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FireStoreServices().fetchPhotoStreamImages(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No images available"));
          }

          List<Map<String, dynamic>> imageList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: imageList.length,
            itemBuilder: (context, index) {
              final imageData = imageList[index];
              final String imageUrl = imageData["path"] ?? "";
              final String formattedDate =
                  DateFormat('dd/MM/yyyy').format(DateTime.now());

              return ListTile(
                leading: Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: imageUrl.isEmpty
                      ? const Icon(
                          Icons.image,
                          size: 48,
                          color: Colors.grey,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;

                              return Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      loadingProgress.expectedTotalBytes != null
                                          ? '${((loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)) * 100).toStringAsFixed(0)}%'
                                          : '0%',
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
                              return const Icon(
                                Icons.error,
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
                      builder: (context) => SelectSelctionScreen(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: SubmitButton(
        onPressed: _showImageSourceSelection,
        text: "Upload a Picture",
      ),
    );
  }
}
