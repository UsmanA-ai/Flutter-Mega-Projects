import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  File? imageFile;
  // pick image
  pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image != null) {
      imageFile = File(image.path);
    }
  }

  Future uploadImagesToSupabase(
      BuildContext context, List<String> images) async {
    if (imageFile == null) return;
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = "uploads/$fileName";
    // await Supabase.instance.client.storage.from("Imagegs").upload(path, imageFile!).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Uploaded Successfully"))),);
    images.map((image) => Supabase.instance.client.storage
        .from('Images')
        .upload(path, File(image)));
  }

  Future uploadImageToSupabase(
      BuildContext context, String image) async {
    if (imageFile == null) return;
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = "uploads/$fileName";
    await Supabase.instance.client.storage.from("Imagegs").upload(path, File(image)).then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image Uploaded Successfully"))),);
    // images.map((image) => Supabase.instance.client.storage
    //     .from('Images')
    //     .upload(path, File(image)));
  }
}
