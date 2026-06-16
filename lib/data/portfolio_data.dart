import '../domain/entity/education_entity.dart';
import '../domain/entity/experience_entity.dart';
import '../domain/entity/project_entity.dart';
import '../domain/entity/skill_group_entity.dart';

/// Static portfolio data for Tiago Rezende.
abstract final class PortfolioData {
  static const String name = 'Tiago Rezende';
  static const String title = 'Senior Flutter & Mobile Engineer';
  static const String tagline = 'Flutter & Mobile Engineer';
  static const String headline =
      'Senior Flutter/Mobile Engineer with 5+ years of experience building '
      'production-grade Android and iOS applications with over 2 million users. '
      'Specialized in clean architecture, offline-first flows, real-time '
      'tracking, and identity verification systems.';
  static const String about =
      "Hi, I'm Tiago Rezende — a Senior Flutter/Mobile Engineer focused on "
      'building production-grade Android and iOS applications across B2B '
      'commerce, identity verification, onboarding, offline-first flows, '
      'real-time order tracking, and connected-device experiences. Strong '
      'background in architecting Flutter apps from scratch, integrating '
      'native platform capabilities (MLKit, BLE, NFC), and improving '
      'reliability through pragmatic engineering decisions. Currently '
      'pursuing a postgraduate specialization in Mobile Engineering.';
  static const String email = 'tiago.rezende.vb@outlook.com';
  static const String githubUrl = 'https://github.com/tiagoguiu';
  static const String linkedinUrl = 'https://www.linkedin.com/in/tiago-rezendevb/';
  static const String playStoreDevUrl = 'https://play.google.com/store/apps/developer?id=Onebox+Tecnologia';

  static const List<ExperienceEntity> experiences = [
    ExperienceEntity(
      company: 'Onebox',
      role: 'Mobile Developer',
      period: '2024 — Present',
      isCurrent: true,
      highlights: [
        'Spearheaded architecture and development for "Fácil Alagoas" and '
            '"DNE" products, serving over 2 million users, with Clean '
            'Architecture, Riverpod, GoRouter, and Dio.',
        'Designed a custom offline request queue intercepting and caching HTTP '
            'operations during network loss with seamless automatic '
            'synchronization upon reconnection.',
        'Shipped a secure onboarding system with facial recognition and a '
            'native document scanner (ML Kit on Android, custom YesWeScan on '
            'Swift for iOS), reducing document errors by 10%.',
        'Expanded the ecosystem to Flutter Web via a modular multi-repository '
            'architecture; maintained CI/CD pipelines (CodeMagic) with '
            'Shorebird Code Push.',
        'Shaved 20% off total application size by overhauling the Gradle '
            'build plugin and compressing unused assets. Integrated New Relic, '
            'Microsoft Clarity, and Firebase Crashlytics.',
        'Engineered a POS Clover terminal integration with public transit '
            'ticketing systems using Android/Kotlin with NFC communication.',
        'Actively contributed to Node.js backend: creating REST endpoints, '
            'maintaining API docs on Insomnia, and managing Oracle database '
            'operations.',
      ],
    ),
    ExperienceEntity(
      company: 'LevObra',
      role: 'Mobile Developer',
      period: '2025 — 2026',
      highlights: [
        'Led end-to-end delivery of LevObra\'s B2B marketplace mobile '
            'infrastructure, structuring a robust MVVM foundation with GetIt '
            'dependency injection for buyer and driver applications.',
        'Engineered real-time WebSockets to bypass legacy polling protocols, '
            'achieving instantaneous PIX payment confirmations and live dispatch '
            'driver updates.',
        'Designed a freight quotation security mechanism using SHA-256 cart '
            'crypto hashes with 5-minute timers to safely invalidate outdated '
            'checkout transactions.',
        'Orchestrated Google Maps API and Geolocator integrations for precise '
            'address selection, live driver tracking, and accurate ETAs.',
        'Orchestrated driver onboarding workflows with selfie capture, ML Kit '
            'face detection validations, document analysis, and multimedia '
            'compression.',
      ],
    ),
    ExperienceEntity(
      company: 'Vizo',
      role: 'Junior Mobile Developer',
      period: '2023 — 2024',
      highlights: [
        'Supercharged a TikTok-style endless media feed by shifting aggressive '
            'data parsing into background Isolates, fully eliminating UI thread '
            'bottlenecks and locking smooth scrolling.',
        'Worked on the ZIRA app during my time at Vizo, contributing to '
            'mobile feature delivery and release quality for production users.',
        'Developed an Israel-oriented geolocation mapping platform for '
            'critical incident reporting with GPS coordinate plots, restricted '
            'user roles, likes, and comment models.',
        'Enhanced an aquatic hardware companion app using Bluetooth Low Energy '
            '(BLE) with synchronization layers and a local SQLite database '
            'following MVP/Repository patterns.',
      ],
    ),
    ExperienceEntity(
      company: 'Usemobile',
      role: 'Mobile Development Intern',
      period: '2021 — 2022',
      highlights: [
        'Played a key role in Kumon MOL and Imedy (telemedicine) commercial '
            'products, refining UI features based on SOLID and Clean '
            'Architecture (MVVM).',
        'Engineered real-time Agora IO video-call solutions with WebSocket '
            'logic triggers and introduced full i18n internationalizations.',
      ],
    ),
    ExperienceEntity(
      company: 'CNPq',
      role: 'Scientific Initiation Researcher',
      period: '2020 — 2021',
      highlights: [
        'Architected from scratch a full-stack solution for internet service '
            'providers, logging connection parameters with a Flutter mobile app.',
        'Engineered the backend with Node.js connected to MongoDB, delivering '
            'endpoints via Heroku.',
      ],
    ),
  ];

  static const List<ProjectEntity> projects = [
    ProjectEntity(
      id: 'facilalagoas',
      title: 'Fácil Alagoas',
      description:
          'Public transit card management app serving Alagoas, Brazil. '
          'Joined the project from inception, co-architecting the entire '
          'mobile foundation: offline request queue with retry logic, '
          'Firebase Remote Config for real-time feature flags, and a '
          'connectivity-aware overlay. Users can buy tickets, recharge '
          'cards, and track balance in real time.',
      technologies: ['Flutter', 'Riverpod', 'Clean Architecture', 'Dio', 'Firebase', 'GoRouter'],
      playStoreUrl: 'https://play.google.com/store/apps/details?id=br.com.simohuapp&pcampaignid=web_share',
      isFeatured: true,
    ),
    ProjectEntity(
      id: 'soulup',
      title: 'Soul Up',
      description:
          'Soul Up is a blockchain-powered super app designed to put '
          'communities back at the center of digital interaction. It unifies '
          'finance, privacy, decentralized identity, and measurable '
          'socio-environmental impact in a single platform. The product '
          'emphasizes user autonomy, allowing people to personalize their '
          'experience and control how, when, and whether their data is '
          'shared. During my time at Vizo, I contributed with Flutter and '
          'Bloc/Cubit to deliver a scalable, community-first social '
          'experience.',
      technologies: ['Flutter', 'Bloc/Cubit', 'Blockchain', 'Clean Architecture'],
      playStoreUrl: 'https://play.google.com/store/apps/details?id=com.soulprime.app',
      isFeatured: true,
    ),
    ProjectEntity(
      id: 'dne',
      title: 'DNE — National Student Document',
      description:
          'Official student identification app for Brazilian students '
          'serving over 2 million users. Led the intelligence layer with '
          'ML Kit (Face Recognition, Document Scanner) and a custom '
          'YesWeScan integration for iOS. Expanded to Flutter Web via '
          'modular multi-repo architecture.',
      technologies: ['Flutter', 'ML Kit', 'Firebase', 'Swift', 'Clean Architecture', 'Shorebird', 'CodeMagic'],
      playStoreUrl: 'https://play.google.com/store/apps/details?id=br.com.dnedigital',
      isFeatured: true,
    ),
    ProjectEntity(
      id: 'levobra',
      title: 'LevObra',
      description:
          'B2B e-commerce marketplace for construction materials built '
          'from scratch. Real-time WebSocket dispatch, SHA-256 secure '
          'checkout, Google Maps live driver tracking, and PIX payment '
          'flow with ML Kit driver onboarding.',
      technologies: ['Flutter', 'MVVM', 'WebSocket', 'Google Maps', 'GoRouter', 'GetIt', 'New Relic'],
      statusTag: 'Não lançado',
      isFeatured: true,
    ),
    ProjectEntity(
      id: 'chuzz',
      title: 'Chuzz',
      description:
          'Gastronomic social network app with video sharing, geolocation, '
          'and Firebase integration, built with Clean Architecture and '
          'Bloc state management.',
      technologies: ['Flutter', 'Firebase', 'Bloc/Cubit', 'Geolocation', 'Clean Architecture'],
      playStoreUrl: 'https://play.google.com/store/apps/details?id=dev.vizo.chuzz.chuzz',
      isFeatured: true,
    ),
    ProjectEntity(
      id: 'zira',
      title: 'ZIRA',
      description:
          'ZIRA is an advanced safety and community-intelligence app built '
          'for Israeli users. It provides real-time news, location-based '
          'security alerts, and interactive incident mapping, while enabling '
          'crowdsourced reports to improve situational awareness and response '
          'times. The platform also relays official Home Front Command '
          'alerts during critical events and uses strong privacy safeguards '
          'with location anonymization. I worked on high-reliability mobile '
          'features focused on usability, push notifications, and '
          'real-time communication.',
      technologies: ['Flutter', 'Clean Architecture', 'BLoC/Cubit', 'Firebase'],
      playStoreUrl: 'https://play.google.com/store/apps/details?id=dev.vizo.zira',
      isFeatured: true,
    ),
    ProjectEntity(
      id: 'imedy',
      title: 'Imedy Telemedicine',
      description:
          'Telemedicine app with HD video calls using Agora IO and modular '
          'architecture based on MVVM and Clean Architecture principles.',
      technologies: ['Flutter', 'Agora IO', 'Firebase', 'MVVM', 'GetX'],
      playStoreUrl: 'https://play.google.com/store/apps/details?id=br.com.imedy.paciente',
      isFeatured: true,
    ),
    ProjectEntity(
      id: 'kumonmol',
      title: 'Kumon MOL',
      description:
          'Educational platform for Kumon students and instructors. '
          'Collaborated as a mobile development intern applying SOLID '
          'principles, Clean Architecture (MVVM), and real-time '
          'features using WebSockets.',
      technologies: ['Flutter', 'MVVM', 'Clean Architecture', 'SOLID', 'WebSocket', 'Crashlytics'],
      playStoreUrl: 'https://play.google.com/store/apps/details?id=br.com.kumon_mol.kumon_mol',
      isFeatured: true,
    ),
    ProjectEntity(
      id: 'simohuapp',
      title: 'Simohuapp',
      description:
          'Implemented an in-memory API request queue with retry logic '
          'and connectivity-aware offline overlay to preserve user actions '
          'during network loss. Added Firebase Remote Config real-time '
          'updates for payment and ticket availability.',
      technologies: ['Flutter', 'Riverpod', 'Dio', 'Connectivity Plus', 'Firebase Remote Config', 'Flutter Map'],
      isFeatured: false,
    ),
    ProjectEntity(
      id: 'cunningscanner',
      title: 'Cunning Document Scanner',
      description:
          'Open-source reusable Flutter document-scanning package with '
          'automatic cropping and Android/iOS native support, covering '
          'camera permissions and scan-output handling.',
      technologies: ['Flutter', 'Dart', 'Android native', 'iOS native', 'Document Scanning'],
      githubUrl: 'https://github.com/tiagoguiu',
      isFeatured: false,
    ),
  ];

  static const List<SkillGroupEntity> skillGroups = [
    SkillGroupEntity(
      category: 'Mobile & Cross-platform',
      skills: ['Flutter', 'Dart', 'Android', 'iOS', 'Kotlin', 'Swift'],
    ),
    SkillGroupEntity(
      category: 'Architecture & Patterns',
      skills: ['Clean Architecture', 'MVVM', 'MVP', 'SOLID', 'BLoC/Cubit', 'Riverpod'],
    ),
    SkillGroupEntity(
      category: 'Networking & Real-time',
      skills: ['Dio', 'REST APIs', 'WebSocket', 'GoRouter', 'Offline Queue'],
    ),
    SkillGroupEntity(
      category: 'Firebase & Observability',
      skills: ['Firebase Crashlytics', 'Firebase Messaging', 'Remote Config', 'New Relic', 'Microsoft Clarity'],
    ),
    SkillGroupEntity(
      category: 'DevOps & Tooling',
      skills: ['CI/CD (CodeMagic)', 'GitHub Actions', 'Shorebird Code Push', 'GitFlow', 'Node.js', 'Oracle'],
    ),
    SkillGroupEntity(
      category: 'Device & Integrations',
      skills: ['Google ML Kit', 'Google Maps API', 'Bluetooth BLE', 'NFC', 'Agora IO', 'Isolates'],
    ),
  ];

  static const List<EducationEntity> education = [
    EducationEntity(
      institution: 'PUC Minas',
      degree: 'Postgraduate Studies in Mobile Engineering',
      period: 'In Progress',
      isInProgress: true,
      institutionUrl: 'https://www.pucminas.br/',
      description:
          'Coursework includes software quality and testing, Mobile DevOps '
          'culture, mobile marketing and analytics, mobile security, '
          'responsive design for smart devices, native Android and Apple iOS '
          'platforms, hybrid platforms (React Native, PWA, and Flutter), IoT '
          'application development, mobile databases, conversational '
          'interfaces, APIs and web services, agile project management, and '
          'user experience design.',
    ),
    EducationEntity(
      institution: 'UFSJ — Federal University of São João del-Rei',
      degree: 'B.S. in Telecommunications Engineering',
      period: '2023',
      institutionUrl: 'https://www.ufsj.edu.br/',
      description:
          'Founded a Flutter study group at UFSJ to share mobile-development '
          'knowledge with peers. Conducted government-funded research related '
          'to mobile development (CNPq Scientific Initiation Program).',
    ),
  ];
}
