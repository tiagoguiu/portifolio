/// A technical skill entity grouped by category.
class SkillGroupEntity {
  const SkillGroupEntity({required this.category, required this.skills});

  final String category;
  final List<String> skills;
}
