import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  File? imageFile;
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  ValueNotifier<double> uploadProgress = ValueNotifier<double>(0.0);

  // Initialize Supabase
  SupabaseServices() {
    Supabase.initialize(
      url: 'YOUR_SUPABASE_URL', // Replace with your Supabase URL
      anonKey: 'YOUR_SUPABASE_ANON_KEY', // Replace with your Supabase anon key
    );
  }

  // Pick an image using ImagePicker
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image != null) {
      imageFile = File(image.path);
    }
  }

  Future<String?> uploadImageToSupabase(
      BuildContext context, String imagePath) async {
    try {
      final file = File(imagePath);

      // Validate the file existence and size
      if (!await file.exists()) {
        log('File not found at path: $imagePath');
        throw Exception('File not found');
      }

      final fileSize = await file.length();
      if (fileSize == 0) {
        log('File is empty at path: $imagePath');
        throw Exception('File is empty');
      }
      log('File size: $fileSize bytes');

      // Read file bytes
      log('Reading file...');
      final fileBytes = await file.readAsBytes();
      log('File read successfully');

      // Generate unique file path
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final path = 'images/$fileName.jpg';

      // Upload file to Supabase
      log('Uploading file to Supabase...');
      await _supabaseClient.storage.from('Images').uploadBinary(
            path,
            fileBytes,
            fileOptions: const FileOptions(upsert: false),
          );
      log('File uploaded successfully to: $path');

      // Get public URL for the uploaded file
      final publicUrl =
          _supabaseClient.storage.from('Images').getPublicUrl(path);
      log('Generated public URL: $publicUrl');

      return publicUrl;
    } catch (e, stackTrace) {
      log('Error uploading image: $e');
      log('StackTrace: $stackTrace');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image: $e")),
      );
      return null;
    }
  }

  // Upload multiple images to Supabase with progress tracking
  Future<void> uploadListImagesToSupabase(
      BuildContext context, List<String> images) async {
    if (images.isEmpty) return;

    try {
      uploadProgress.value = 0.0;

      // Upload all images in parallel
      final totalImages = images.length;
      final results = await Future.wait(
        images.map((imagePath) async {
          // await uploadImageToSupabase(context, imagePath);
          uploadProgress.value += 1 / totalImages; // Update progress
        }),
      );

      // Check if all uploads were successful
      if (results.every((result) => result == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("All images uploaded successfully!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload some images: $e")),
      );
    }
  }
}
