class ImageDetail {
  String location;
  String subSelection;

  // Constructor
  ImageDetail({required this.location, required this.subSelection});

  // Convert to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['location'] = location;
    data['subSelection'] = subSelection;
    return data;
  }

  ImageDetail.fromJson(Map<String, dynamic> json)
      : location = json['location'],
        subSelection = json['subSelection'];
}
