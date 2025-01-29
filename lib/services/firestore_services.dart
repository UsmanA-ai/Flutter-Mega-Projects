import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condition_report/models/general_details_model.dart';
import 'package:condition_report/models/image_detail.dart';
import 'package:condition_report/models/new_element_model.dart';
import 'package:condition_report/models/occupancy_model.dart';
import 'package:condition_report/models/property_details_model.dart';
import 'package:condition_report/provider/assessment_provider.dart';

class FireStoreServices {
  final _firebaseAssessment =
      FirebaseFirestore.instance.collection("assessment");
  final List<String> ids = [];

  // Create a new assessment and return its ID
  Future<String> createAssessment() async {
    try {
      final docRef = _firebaseAssessment.doc(); // Generate a random document ID
      ids.add(docRef.id);
      currentId = docRef.id;
      await docRef.set({
        'createdAt': FieldValue.serverTimestamp(),
        "generalDetails": {}, // Initialize empty maps for the fields
        "propertyDetails": {},
        "occupancy": {},
        "images": []
      });
      return docRef.id; // Return the generated document ID
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> createNewElement(
      String elementName, NewElementModel data) async {
    try {
      final docRef =
          _firebaseAssessment.doc(currentId); // Generate a random document ID
      // ids.add(docRef.id);
      await docRef.update({
        elementName: data.toMap(),
      });
      return docRef.id; // Return the generated document ID
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Add General Details to the assessment
  Future<void> addGeneralDetails(
      String assessmentId, GeneralDetailsModel data) async {
    try {
      log(currentId!);
      await _firebaseAssessment.doc(assessmentId).update({
        "generalDetails": data.toMap(), // Update the `generalDetails` field
      });
      log('General details added successfully');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addImage(String assessmentId, ImageDetail imageDetail) async {
    try {
      await _firebaseAssessment.doc(assessmentId).update({
        "images":
            FieldValue.arrayUnion([imageDetail.toMap()]), // Add to the list
      });
      log("Image detail added successfully to Firestore.");
    } catch (e) {
      log("Error adding image detail to Firestore: $e");
      throw Exception(e.toString());
    }
  }

  // Add Property Details to the assessment
  Future<void> addPropertyDetails(
      String assessmentId, PropertyDetailsModel data) async {
    try {
      await _firebaseAssessment.doc(assessmentId).update({
        "propertyDetails": data.toMap(), // Update the `propertyDetails` field
      });
      log('Property details added successfully');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Add Occupancy Details to the assessment
  Future<void> addOccupancyDetails(
      String assessmentId, OccupancyModel data) async {
    try {
      await _firebaseAssessment.doc(assessmentId).update({
        "occupancy": data.toMap(), // Update the `occupancy` field
      });
      log('Occupancy details added successfully');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Fetch an assessment by its ID
  Future<Map<String, dynamic>> fetchAssessment(String assessmentId) async {
    try {
      final docSnapshot = await _firebaseAssessment.doc(assessmentId).get();
      if (docSnapshot.exists) {
        return docSnapshot.data()!;
      } else {
        throw Exception("Assessment not found");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Fetch all assessments ordered by 'createdAt'
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllAssessments() {
    try {
      // Fetch the assessments and order them by 'createdAt' in descending order
      return _firebaseAssessment
          .orderBy('createdAt', descending: true) // Order by createdAt field
          .snapshots(); // Listen for real-time updates
    } catch (e) {
      throw Exception("Error fetching assessments: ${e.toString()}");
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchNewElements() {
    try {
      // log(_firebaseAssessment.snapshots().toString());
      return _firebaseAssessment.doc(currentId).snapshots();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteAssessment(String assessmentId) async {
    try {
      await _firebaseAssessment.doc(assessmentId).delete();
      log('Assessment deleted successfully');
    } catch (e) {
      throw Exception("Error deleting assessment: ${e.toString()}");
    }
  }

  Stream<List<Map<String, dynamic>>> fetchPhotoStreamImages() {
    try {
      return _firebaseAssessment
          .doc(currentId)
          .snapshots()
          .map((documentSnapshot) {
        if (documentSnapshot.exists) {
          Map<String, dynamic>? data = documentSnapshot.data();
          List<dynamic>? imagesList = data?["images"] as List<dynamic>?;
          // log("ImageList : $imagesList");
          if (imagesList != null) {
            List<Map<String, dynamic>> filteredImages = imagesList
                .where((image) =>
                    image is Map<String, dynamic> && image["id"] == "ps")
                .map((image) => image as Map<String, dynamic>)
                .toList();

            // log("Filter Data : $filteredImages");
            return filteredImages;
          }
        }
        return [];
      });
    } catch (e) {
      log("Error fetching images: $e");
      return Stream.value([]);
    }
  }

  Future<List<Map<String, dynamic>>> fetchGDImages() async {
    try {
      var documentSnapshot = await _firebaseAssessment.doc(currentId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data();
        List<dynamic>? imagesList = data?["images"] as List<dynamic>?;

        if (imagesList != null) {
          List<Map<String, dynamic>> filteredImages = imagesList
              .where((image) =>
                  image is Map<String, dynamic> && image["id"] == "gd")
              .map((image) => image as Map<String, dynamic>)
              .toList();

          return filteredImages;
        }
      }
      return [];
    } catch (e) {
      log("Error fetching images: $e");
      return [];
    }
  }

  Stream<List<String>> fetchAllImages() {
    try {
      return _firebaseAssessment
          .doc(currentId)
          .snapshots()
          .map((documentSnapshot) {
        List<String> allImages = [];

        Map<String, dynamic>? data = documentSnapshot.data();
        List<dynamic>? imagesList = data?["images"] as List<dynamic>?;

        if (imagesList != null) {
          for (var image in imagesList) {
            if (image is Map<String, dynamic> && image.containsKey("path")) {
              allImages.add(image["path"]);
            }
          }
        }
        return allImages;
      });
    } catch (e) {
      log("Error fetching images: $e");
      return Stream.value([]);
    }
  }
}
