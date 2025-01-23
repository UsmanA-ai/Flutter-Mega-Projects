import 'package:flutter/material.dart';

class AssessmentProvider extends ChangeNotifier {
  final List<String> assessmentIds = [];

  void add(String id) {
    assessmentIds.add(id);
    notifyListeners();
  }
}

String? currentId;
bool isAddedGD = false;
bool isAddedPD = false;
bool isAddedO = false;
