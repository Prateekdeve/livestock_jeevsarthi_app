class AppStrings {
  final String appSubtitle;
  final String chooseLanguage;
  final String continueAs;
  final String farmerRole;
  final String farmerDescription;
  final String vetRole;
  final String vetDescription;
  final String adminRole;
  final String adminDescription;
  final String speciesSummary;
  final String disclaimer;
  final String farmerGreeting;

  const AppStrings({
    required this.appSubtitle,
    required this.chooseLanguage,
    required this.continueAs,
    required this.farmerRole,
    required this.farmerDescription,
    required this.vetRole,
    required this.vetDescription,
    required this.adminRole,
    required this.adminDescription,
    required this.speciesSummary,
    required this.disclaimer,
    required this.farmerGreeting,
  });

  static const AppStrings marathi = AppStrings(
    appSubtitle: 'पशुधन आरोग्य पूर्वसूचना प्रणाली',
    chooseLanguage: 'भाषा निवडा',
    continueAs: 'पुढे जा (डेमो प्रवेश)',
    farmerRole: 'शेतकरी (Farmer)',
    farmerDescription: 'Check sick animals, vaccination & withdrawal alerts',
    vetRole: 'पशुवैद्यक (Veterinarian)',
    vetDescription: 'Review triage queue, lab referrals & prescriptions',
    adminRole: 'शासकीय अधिकारी (Govt Admin)',
    adminDescription: 'Maharashtra district disease surveillance & outbreaks',
    speciesSummary: '4 Species  •  8 Priority Diseases  •  3+11 Triage',
    disclaimer:
        'Prototype. Screening results are not diagnoses. Demo records are mock data based on Maharashtra Animal Husbandry guidelines.',
    farmerGreeting: 'नमस्कार 🙏',
  );

  static const AppStrings hindi = AppStrings(
    appSubtitle: 'पशु स्वास्थ्य पूर्व चेतावनी प्रणाली',
    chooseLanguage: 'भाषा चुनें',
    continueAs: 'आगे बढ़ें (डेमो एक्सेस)',
    farmerRole: 'किसान (Farmer)',
    farmerDescription: 'Check sick animals, vaccination & withdrawal alerts',
    vetRole: 'पशु चिकित्सक (Veterinarian)',
    vetDescription: 'Review triage queue, lab referrals & prescriptions',
    adminRole: 'सरकारी अधिकारी (Govt Admin)',
    adminDescription: 'Maharashtra district disease surveillance & outbreaks',
    speciesSummary: '4 Species  •  8 Priority Diseases  •  3+11 Triage',
    disclaimer:
        'Prototype. Screening results are not diagnoses. Demo records are mock data based on Maharashtra Animal Husbandry guidelines.',
    farmerGreeting: 'नमस्ते 🙏',
  );

  static const AppStrings english = AppStrings(
    appSubtitle: 'Livestock health early warning',
    chooseLanguage: 'Choose language',
    continueAs: 'Continue as (demo access)',
    farmerRole: 'Farmer',
    farmerDescription: 'Check sick animals, vaccination & withdrawal alerts',
    vetRole: 'Veterinarian',
    vetDescription: 'Review triage queue, lab referrals & prescriptions',
    adminRole: 'Government admin',
    adminDescription: 'Maharashtra district disease surveillance & outbreaks',
    speciesSummary: '4 Species  •  8 Priority Diseases  •  3+11 Triage',
    disclaimer:
        'Prototype. Screening results are not diagnoses. Demo records are mock data based on Maharashtra Animal Husbandry guidelines.',
    farmerGreeting: 'Namaskar 🙏',
  );

  static AppStrings of(String language) {
    switch (language) {
      case 'मराठी':
        return marathi;
      case 'हिन्दी':
        return hindi;
      default:
        return english;
    }
  }
}

