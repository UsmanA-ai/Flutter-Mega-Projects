import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:condition_report/models/general_details_model.dart';
import 'package:condition_report/models/occupancy_model.dart';
import 'package:condition_report/models/property_details_model.dart';
import 'package:condition_report/provider/assessment_provider.dart';

class FireStoreServices {
  final _firebaseFirestore =
      FirebaseFirestore.instance.collection("assessment");
  final List<String> ids = [];

  // Create a new assessment and return its ID
  Future<String> createAssessment() async {
    try {
      final docRef = _firebaseFirestore.doc(); // Generate a random document ID
      ids.add(docRef.id);
      currentId = docRef.id;
      await docRef.set({
        "generalDetails": {}, // Initialize empty maps for the fields
        "propertyDetails": {},
        "occupancy": {}
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
      await _firebaseFirestore.doc(assessmentId).update({
        "generalDetails": data.toMap(), // Update the `generalDetails` field
      });
      log('General details added successfully');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Add Property Details to the assessment
  Future<void> addPropertyDetails(
      String assessmentId, PropertyDetailsModel data) async {
    try {
      await _firebaseFirestore.doc(assessmentId).update({
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
      await _firebaseFirestore.doc(assessmentId).update({
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
      final docSnapshot = await _firebaseFirestore.doc(assessmentId).get();
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
      return _firebaseFirestore.snapshots();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
    // Delete an assessment by its ID
  Future<void> deleteAssessment(String assessmentId) async {
    try {
      await _firebaseFirestore.doc(assessmentId).delete();
      log('Assessment deleted successfully');
    } catch (e) {
      throw Exception("Error deleting assessment: ${e.toString()}");
    }
  }
}
