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
      print("Image detail added successfully to Firestore.");
    } catch (e) {
      print("Error adding image detail to Firestore: $e");
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

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllAssessments() {
    try {
      // log(_firebaseAssessment.snapshots().toString());
      return _firebaseAssessment.snapshots();
    } catch (e) {
      throw Exception(e.toString());
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

  // Delete an assessment by its ID
  Future<void> deleteAssessment(String assessmentId) async {
    try {
      await _firebaseAssessment.doc(assessmentId).delete();
      log('Assessment deleted successfully');
    } catch (e) {
      throw Exception("Error deleting assessment: ${e.toString()}");
    }
  }
}
