class PropertyDetailsModel {
  String propertyConstraint;
  String propertyConstruction;
  String propertyDetachment;
  String buildingOrientation;
  String exposureZone;

  PropertyDetailsModel({
    required this.propertyConstraint,
    required this.propertyConstruction,
    required this.propertyDetachment,
    required this.buildingOrientation,
    required this.exposureZone,
  });

  // Convert PropertyDetailsModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'propertyConstraint': propertyConstraint,
      'propertyConstruction': propertyConstruction,
      'propertyDetachment': propertyDetachment,
      'buildingOrientation': buildingOrientation,
      'exposureZone': exposureZone,
    };
  }

  // Create PropertyDetailsModel from a Map
  factory PropertyDetailsModel.fromMap(Map<String, dynamic> map) {
    return PropertyDetailsModel(
      propertyConstraint: map['propertyConstraint'] ?? '',
      propertyConstruction: map['propertyConstruction'] ?? '',
      propertyDetachment: map['propertyDetachment'] ?? '',
      buildingOrientation: map['buildingOrientation'] ?? '',
      exposureZone: map['exposureZone'] ?? '',
    );
  }
}
