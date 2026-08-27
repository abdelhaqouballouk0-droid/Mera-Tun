enum AppLanguage { ar, en }

class AppStrings {
  AppStrings._();

  static AppLanguage _currentLanguage = AppLanguage.ar;
  static AppLanguage get currentLanguage => _currentLanguage;
  static void setLanguage(AppLanguage language) => _currentLanguage = language;
  static bool get _ar => _currentLanguage == AppLanguage.ar;

  static String get appName => 'Mera Tune';
  static String get home => _ar ? 'الرئيسية' : 'Home';
  static String get journeys => _ar ? 'مساراتي' : 'My Paths';
  static String get coach => _ar ? 'المدرّب' : 'Coach';
  static String get insights => _ar ? 'تقدّمي' : 'Progress';
  static String get settings => _ar ? 'الإعدادات' : 'Settings';
  static String get appTagline =>
      _ar ? 'تعلّمها بأن تجرّبها' : 'Learn it by doing it';
  static String get homeIntro => _ar
      ? 'حوّل أي مهارة إلى خطوات قصيرة: جرّب، فكّر، ثم تقدّم.'
      : 'Turn any skill into short steps: try, reflect, then progress.';
  static String get startJourney => _ar ? 'ابدأ مساراً جديداً' : 'Start a new path';
  static String get continueLearning => _ar ? 'تابع التعلّم' : 'Continue learning';
  static String get activeJourneys => _ar ? 'مسارات نشطة' : 'Active paths';
  static String get completedSteps =>
      _ar ? 'تحديات مكتملة' : 'Completed challenges';
  static String get overallProgress => _ar ? 'التقدّم الكلي' : 'Overall progress';
  static String get noJourneysTitle => _ar ? 'ابدأ بأول تجربة' : 'Start your first try';
  static String get noJourneysBody => _ar
      ? 'اختر شيئاً يهمّك، وسنحوّله إلى تحديات عملية صغيرة.'
      : "Pick something you care about, and we'll turn it into small practical challenges.";
  static String get newJourney => _ar ? 'مسار تعلّم جديد' : 'New learning path';
  static String get topicLabel => _ar ? 'ماذا تريد أن تتعلّم؟' : 'What do you want to learn?';
  static String get topicHint =>
      _ar ? 'مثال: أساسيات التصوير بالهاتف' : 'Example: phone photography basics';
  static String get goalLabel => _ar ? 'لماذا تريد تعلّمه؟' : 'Why do you want to learn it?';
  static String get goalHint => _ar
      ? 'مثال: لألتقط صوراً أفضل في السفر'
      : 'Example: to take better photos while traveling';
  static String get create => _ar ? 'أنشئ المسار' : 'Create path';
  static String get save => _ar ? 'حفظ' : 'Save';
  static String get cancel => _ar ? 'إلغاء' : 'Cancel';
  static String get requiredField => _ar ? 'هذا الحقل مطلوب' : 'This field is required';
  static String get topicTooShort => _ar
      ? 'اكتب موضوعاً أوضح من 3 أحرف على الأقل'
      : 'Write a clearer topic of at least 3 characters';
  static String get journeyCreated =>
      _ar ? 'مسارك جاهز. ابدأ بأول تحدٍ!' : 'Your path is ready. Start your first challenge!';
  static String get editJourney => _ar ? 'تعديل المسار' : 'Edit path';
  static String get deleteJourney => _ar ? 'حذف المسار' : 'Delete path';
  static String get deleteConfirmation =>
      _ar ? 'هل تريد حذف هذا المسار وكل تقدّمه؟' : 'Delete this path and all its progress?';
  static String get delete => _ar ? 'حذف' : 'Delete';
  static String get progress => _ar ? 'التقدّم' : 'Progress';
  static String get currentChallenge => _ar ? 'تحدّيك الآن' : 'Your current challenge';
  static String get upcomingChallenges => _ar ? 'الخطوات التالية' : 'Upcoming steps';
  static String get done => _ar ? 'أتممت التحدّي' : 'Mark as done';
  static String get completed => _ar ? 'مكتمل' : 'Completed';
  static String get allDone => _ar ? 'أكملت المسار!' : 'Path complete!';
  static String get allDoneBody => _ar
      ? 'رائع. جرّب شرح ما تعلّمته لشخص آخر لتثبيت المهارة.'
      : 'Great work. Try explaining what you learned to someone else to lock it in.';
  static String get challengeOneTitle => _ar ? 'ارسم نقطة البداية' : 'Map your starting point';
  static String challengeOneBody(String topic) => _ar
      ? 'اكتب ثلاث جمل قصيرة عمّا تعرفه الآن عن $topic، ثم حدّد سؤالاً واحداً تريد إجابته.'
      : 'Write three short sentences about what you currently know about $topic, then pick one question you want answered.';
  static String get challengeTwoTitle => _ar ? 'نفّذ تجربة مصغّرة' : 'Run a mini experiment';
  static String challengeTwoBody(String topic) => _ar
      ? 'طبّق أبسط جزء ممكن من $topic لمدة عشر دقائق. سجّل ما نجح وما أربكك.'
      : 'Practice the simplest possible part of $topic for ten minutes. Note what worked and what confused you.';
  static String get challengeThreeTitle => _ar ? 'اشرحها بطريقتك' : 'Explain it your way';
  static String challengeThreeBody(String topic) => _ar
      ? 'اشرح فكرة واحدة من $topic بكلماتك كأنك تحكيها لصديق لا يعرفها.'
      : 'Explain one idea from $topic in your own words, as if telling a friend who knows nothing about it.';
  static String get challengeFourTitle => _ar ? 'ارفع مستوى الصعوبة' : 'Raise the difficulty';
  static String challengeFourBody(String topic) => _ar
      ? 'كرّر تجربتك في $topic مع قيد جديد: وقت أقل، أدوات أقل، أو نتيجة أدق.'
      : 'Repeat your $topic exercise with a new constraint: less time, fewer tools, or a more precise result.';
  static String get coachTitle => _ar ? 'مدرّبك العملي' : 'Your hands-on coach';
  static String get coachIntro => _ar
      ? 'اطلب تحدّياً، شاركني محاولتك، أو اطلب تلميحاً صغيراً.'
      : 'Ask for a challenge, share your attempt, or ask for a small hint.';
  static String get consentTitle => _ar ? 'قبل أن تبدأ المحادثة' : 'Before you start chatting';
  static String get consentBody => _ar
      ? 'عند المتابعة، سيُرسل نص رسائلك إلى Groq عبر خادم جرّبها لتوليد ردود تساعدك على التعلّم. لا ترسل معلومات شخصية أو حساسة. يمكنك مسح المحادثة أو سحب موافقتك في أي وقت من الإعدادات.'
      : "By continuing, your message text will be sent to Groq via the app's server to generate replies that help you learn. Don't send personal or sensitive information. You can clear the chat or withdraw consent anytime from Settings.";
  static String get consentAccept => _ar ? 'أوافق وأبدأ' : 'Agree and start';
  static String get consentDecline => _ar ? 'ليس الآن' : 'Not now';
  static String get consentDeclinedNotice => _ar
      ? 'لن تُرسل أي رسائل. يمكنك الموافقة لاحقاً عندما تكون مستعداً.'
      : "No messages will be sent. You can agree later whenever you're ready.";
  static String get consentPrivacy => _ar ? 'كيف تُستخدم رسائلي؟' : 'How is my data used?';
  static String get messageHint => _ar ? 'اكتب ما تريد أن تتعلّمه…' : 'Write what you want to learn…';
  static String get send => _ar ? 'إرسال' : 'Send';
  static String get clearChat => _ar ? 'مسح المحادثة' : 'Clear chat';
  static String get clearChatConfirmation =>
      _ar ? 'هل تريد مسح كل رسائل هذه المحادثة؟' : 'Clear all messages in this chat?';
  static String get retry => _ar ? 'إعادة المحاولة' : 'Retry';
  static String get starterOne =>
      _ar ? 'أعطني تحدياً بسيطاً لتعلّم الرسم' : 'Give me a simple challenge to learn drawing';
  static String get starterTwo =>
      _ar ? 'اختبر فهمي لمفهوم أختاره' : 'Test my understanding of a concept I choose';
  static String get starterThree =>
      _ar ? 'ساعدني بتلميح، لا تعطِني الحل' : "Help me with a hint, don't give me the answer";
  static String get aiOffline =>
      _ar ? 'تعذّر الاتصال. تحقق من الشبكة ثم حاول مجدداً.' : 'Connection failed. Check your network and try again.';
  static String get aiRateLimit =>
      _ar ? 'المدرّب مشغول الآن. انتظر قليلاً ثم حاول.' : 'The coach is busy right now. Wait a bit and try again.';
  static String get aiTimeout =>
      _ar ? 'استغرق الرد وقتاً طويلاً. حاول مرة أخرى.' : 'The reply took too long. Try again.';
  static String get aiMalformed =>
      _ar ? 'وصل رد غير متوقع. حاول مرة أخرى.' : 'Received an unexpected reply. Try again.';
  static String get aiGenericError =>
      _ar ? 'تعذّر إكمال الطلب الآن. حاول لاحقاً.' : "Couldn't complete the request. Try again later.";
  static String get todayEffort => _ar ? 'حصيلتك' : 'Your stats';
  static String get stepsDone => _ar ? 'خطوات أنجزتها' : 'Steps completed';
  static String get pathsCompleted => _ar ? 'مسارات أكملتها' : 'Paths completed';
  static String get nextMilestone => _ar ? 'المحطة التالية' : 'Next milestone';
  static String get milestoneBody =>
      _ar ? 'أكمل 3 تحديات لفتح جلسة مراجعة ذاتية.' : 'Complete 3 challenges to unlock a self-review session.';
  static String get emptyInsights => _ar
      ? 'سيظهر تقدّمك هنا بعد أن تبدأ أول مسار وتكمل تحدّياً.'
      : 'Your progress will show here once you start a path and complete a challenge.';
  static String get general => _ar ? 'عام' : 'General';
  static String get language => _ar ? 'لغة العرض' : 'Display language';
  static String get arabic => _ar ? 'العربية' : 'Arabic';
  static String get english => _ar ? 'الإنجليزية' : 'English';
  static String get privacy => _ar ? 'سياسة الخصوصية' : 'Privacy policy';
  static String get support => _ar ? 'الدعم والمساعدة' : 'Support & help';
  static String get terms => _ar ? 'شروط الاستخدام' : 'Terms of use';
  static String get about => _ar ? 'عن التطبيق' : 'About the app';
  static String get version => _ar ? 'الإصدار' : 'Version';
  static String get aiPrivacy => _ar ? 'الذكاء الاصطناعي والخصوصية' : 'AI & privacy';
  static String get aiConsentGranted => _ar ? 'الموافقة مفعّلة' : 'Consent granted';
  static String get aiConsentNotGranted => _ar ? 'لم تمنح الموافقة' : 'Consent not granted';
  static String get revokeConsent =>
      _ar ? 'سحب الموافقة ومسح المحادثة' : 'Withdraw consent & clear chat';
  static String get revokeConfirmation => _ar
      ? 'سيتم سحب الموافقة ومسح رسائل المدرّب المحفوظة على هذا الجهاز.'
      : 'This will withdraw consent and clear the coach messages stored on this device.';
  static String get openLinkError =>
      _ar ? 'تعذّر فتح الرابط. حاول لاحقاً.' : "Couldn't open the link. Try again later.";
  static String get aboutBody => _ar
      ? 'جرّبها يساعدك على بناء المهارات بخطوات عملية قصيرة. المحتوى الذكي للتعلّم العام وليس بديلاً عن المختصين.'
      : 'Kado helps you build skills through short practical steps. AI content is for general learning and is not a substitute for experts.';
  static String get close => _ar ? 'إغلاق' : 'Close';
  static String get loading => _ar ? 'جارٍ التحميل…' : 'Loading…';
  static String get you => _ar ? 'أنت' : 'You';
  static String get ai => _ar ? 'المدرّب' : 'Coach';
  static String get percentSign => _ar ? '٪' : '%';
}
