class courseModel {
  int? courseId;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedA;

  courseModel({
    this.courseId,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedA,
  });

  courseModel.fromjson(Map<String, dynamic> json) {
    courseId=json['courseId'];
    title = json['title'];
    description = json['description'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    createdAt = json['createdAt'];
    updatedA = json['updatedA'];
  }
}
