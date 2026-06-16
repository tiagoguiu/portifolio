/// A portfolio project entity.
class ProjectEntity {
  const ProjectEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.technologies,
    this.statusTag,
    this.imageAsset,
    this.playStoreUrl,
    this.appStoreUrl,
    this.githubUrl,
    this.websiteUrl,
    this.isFeatured = false,
  });

  final String id;
  final String title;
  final String description;
  final List<String> technologies;
  final String? statusTag;
  final String? imageAsset;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? githubUrl;
  final String? websiteUrl;
  final bool isFeatured;
}
