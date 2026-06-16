import 'package:flutter/material.dart';

import '../widgets/about_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/education_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/footer_widget.dart';
import '../widgets/hero_section.dart';
import '../widgets/nav_bar.dart';
import '../widgets/projects_section.dart';

/// Single-page portfolio home screen.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  final _aboutKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _educationKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String section) {
    final key = switch (section) {
      'about' => _aboutKey,
      'experience' => _experienceKey,
      'projects' => _projectsKey,
      'education' => _educationKey,
      'contact' => _contactKey,
      _ => null,
    };

    if (key?.currentContext case final ctx?) {
      Scrollable.ensureVisible(ctx, duration: const Duration(milliseconds: 700), curve: Curves.easeInOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          NavBar(onScrollToSection: _scrollToSection),
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: HeroSection(
                    onGetInTouch: () => _scrollToSection('contact'),
                    onViewProjects: () => _scrollToSection('projects'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: KeyedSubtree(key: _aboutKey, child: const AboutSection()),
                ),
                SliverToBoxAdapter(
                  child: KeyedSubtree(key: _experienceKey, child: const ExperienceSection()),
                ),
                SliverToBoxAdapter(
                  child: KeyedSubtree(key: _projectsKey, child: const ProjectsSection()),
                ),
                SliverToBoxAdapter(
                  child: KeyedSubtree(key: _educationKey, child: const EducationSection()),
                ),
                SliverToBoxAdapter(
                  child: KeyedSubtree(key: _contactKey, child: const ContactSection()),
                ),
                const SliverToBoxAdapter(child: FooterWidget()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
