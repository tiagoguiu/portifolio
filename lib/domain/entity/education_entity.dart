/// A formal education record entity.
class EducationEntity {
  const EducationEntity({
    required this.institution,
    required this.degree,
    required this.period,
    required this.description,
    this.institutionUrl,
    this.isInProgress = false,
  });

  final String institution;
  final String degree;
  final String period;
  final String description;
  final String? institutionUrl;
  final bool isInProgress;
}
