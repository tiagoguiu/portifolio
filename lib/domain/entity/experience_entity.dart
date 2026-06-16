/// A professional work experience entity.
class ExperienceEntity {
  const ExperienceEntity({
    required this.company,
    required this.role,
    required this.period,
    required this.highlights,
    this.location,
    this.isCurrent = false,
  });

  final String company;
  final String role;
  final String period;
  final String? location;
  final List<String> highlights;
  final bool isCurrent;
}
