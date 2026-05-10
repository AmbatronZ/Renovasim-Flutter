class ProjectModel {
  final String title;
  final String? location;
  final String budget;
  final String? status;
  final String imagePath;
  final bool isInProgress;
  final String? draftInfo;
  final String? updatedInfo;

  const ProjectModel({
    required this.title,
    required this.location,
    required this.budget,
    required this.status,
    required this.imagePath,
    required this.isInProgress,
    this.draftInfo,
    this.updatedInfo,
  });
}