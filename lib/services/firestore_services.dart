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
  Future<String> createAssessment() async {
    try {
      final docRef = _firebaseFirestore.doc(); // Generate a random document ID
      ids.add(docRef.id);
      currentId = docRef.id;
      return docRef.id; // Return the generated document ID
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  fetchAssessment() async {
    // final data = await _firebaseFirestore
    //     .doc("Rd9sf7kCx44W9EqIFuYy")
    //     .collection("generalProperty")
    //     .doc("EwySl30ivmNzl3cNmhmo")
    //     .get();

    // log(data.data().toString());
    // return _firebaseFirestore
    //     .doc("Rd9sf7kCx44W9EqIFuYy")
    //     .collection("generalProperty")
    //     .doc("EwySl30ivmNzl3cNmhmo")
    //     .get();
    final id = FirebaseFirestore.instance.collection("demo").snapshots().map((event) => event.docs);
    log(id.toString());
  }

  Future<void> addPropertyDetails(PropertyDetailsModel data) async {
    try {
      await _firebaseFirestore
          .doc(currentId)
          .collection("propertyDetails")
          .add(data.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addGeneralDetails(GeneralDetailsModel data) async {
    try {
      await _firebaseFirestore
          .doc(currentId)
          .collection("generalDetails")
          .add(data.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addOccupancy(String assessmentId, OccupancyModel data) async {
    try {
      await _firebaseFirestore
          .doc(assessmentId)
          .collection("occupancy")
          .add(data.toMap());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<PropertyDetailsModel>> fetchPropertyDetails(
      String assessmentId) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .doc(assessmentId)
          .collection("propertyDetails")
          .get();

      return querySnapshot.docs
          .map((doc) => PropertyDetailsModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<GeneralDetailsModel>> fetchGeneralDetails(
      String assessmentId) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .doc(assessmentId)
          .collection("generalDetails")
          .get();

      return querySnapshot.docs
          .map((doc) => GeneralDetailsModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<OccupancyModel>> fetchOccupancy(String assessmentId) async {
    try {
      final querySnapshot = await _firebaseFirestore
          .doc(assessmentId)
          .collection("occupancy")
          .get();

      return querySnapshot.docs
          .map((doc) => OccupancyModel.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
