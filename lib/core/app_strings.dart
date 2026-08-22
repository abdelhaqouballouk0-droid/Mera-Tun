class AppStrings {
  const AppStrings._();

  static const home = 'الرئيسية';
  static const journeys = 'مساراتي';
  static const coach = 'المدرّب';
  static const insights = 'تقدّمي';
  static const settings = 'الإعدادات';
  static const appTagline = 'تعلّمها بأن تجرّبها';
  static const homeIntro =
      'حوّل أي مهارة إلى خطوات قصيرة: جرّب، فكّر، ثم تقدّم.';
  static const startJourney = 'ابدأ مساراً جديداً';
  static const continueLearning = 'تابع التعلّم';
  static const activeJourneys = 'مسارات نشطة';
  static const completedSteps = 'تحديات مكتملة';
  static const overallProgress = 'التقدّم الكلي';
  static const noJourneysTitle = 'ابدأ بأول تجربة';
  static const noJourneysBody =
      'اختر شيئاً يهمّك، وسنحوّله إلى تحديات عملية صغيرة.';
  static const newJourney = 'مسار تعلّم جديد';
  static const topicLabel = 'ماذا تريد أن تتعلّم؟';
  static const topicHint = 'مثال: أساسيات التصوير بالهاتف';
  static const goalLabel = 'لماذا تريد تعلّمه؟';
  static const goalHint = 'مثال: لألتقط صوراً أفضل في السفر';
  static const create = 'أنشئ المسار';
  static const save = 'حفظ';
  static const cancel = 'إلغاء';
  static const requiredField = 'هذا الحقل مطلوب';
  static const topicTooShort = 'اكتب موضوعاً أوضح من 3 أحرف على الأقل';
  static const journeyCreated = 'مسارك جاهز. ابدأ بأول تحدٍ!';
  static const editJourney = 'تعديل المسار';
  static const deleteJourney = 'حذف المسار';
  static const deleteConfirmation = 'هل تريد حذف هذا المسار وكل تقدّمه؟';
  static const delete = 'حذف';
  static const progress = 'التقدّم';
  static const currentChallenge = 'تحدّيك الآن';
  static const upcomingChallenges = 'الخطوات التالية';
  static const done = 'أتممت التحدّي';
  static const completed = 'مكتمل';
  static const allDone = 'أكملت المسار!';
  static const allDoneBody =
      'رائع. جرّب شرح ما تعلّمته لشخص آخر لتثبيت المهارة.';
  static const challengeOneTitle = 'ارسم نقطة البداية';
  static String challengeOneBody(String topic) =>
      'اكتب ثلاث جمل قصيرة عمّا تعرفه الآن عن $topic، ثم حدّد سؤالاً واحداً تريد إجابته.';
  static const challengeTwoTitle = 'نفّذ تجربة مصغّرة';
  static String challengeTwoBody(String topic) =>
      'طبّق أبسط جزء ممكن من $topic لمدة عشر دقائق. سجّل ما نجح وما أربكك.';
  static const challengeThreeTitle = 'اشرحها بطريقتك';
  static String challengeThreeBody(String topic) =>
      'اشرح فكرة واحدة من $topic بكلماتك كأنك تحكيها لصديق لا يعرفها.';
  static const challengeFourTitle = 'ارفع مستوى الصعوبة';
  static String challengeFourBody(String topic) =>
      'كرّر تجربتك في $topic مع قيد جديد: وقت أقل، أدوات أقل، أو نتيجة أدق.';
  static const coachTitle = 'مدرّبك العملي';
  static const coachIntro =
      'اطلب تحدّياً، شاركني محاولتك، أو اطلب تلميحاً صغيراً.';
  static const consentTitle = 'قبل أن تبدأ المحادثة';
  static const consentBody =
      'عند المتابعة، سيُرسل نص رسائلك إلى Groq عبر خادم جرّبها لتوليد ردود تساعدك على التعلّم. لا ترسل معلومات شخصية أو حساسة. يمكنك مسح المحادثة أو سحب موافقتك في أي وقت من الإعدادات.';
  static const consentAccept = 'أوافق وأبدأ';
  static const consentDecline = 'ليس الآن';
  static const consentDeclinedNotice =
      'لن تُرسل أي رسائل. يمكنك الموافقة لاحقاً عندما تكون مستعداً.';
  static const consentPrivacy = 'كيف تُستخدم رسائلي؟';
  static const messageHint = 'اكتب ما تريد أن تتعلّمه…';
  static const send = 'إرسال';
  static const clearChat = 'مسح المحادثة';
  static const clearChatConfirmation = 'هل تريد مسح كل رسائل هذه المحادثة؟';
  static const retry = 'إعادة المحاولة';
  static const starterOne = 'أعطني تحدياً بسيطاً لتعلّم الرسم';
  static const starterTwo = 'اختبر فهمي لمفهوم أختاره';
  static const starterThree = 'ساعدني بتلميح، لا تعطِني الحل';
  static const aiOffline = 'تعذّر الاتصال. تحقق من الشبكة ثم حاول مجدداً.';
  static const aiRateLimit = 'المدرّب مشغول الآن. انتظر قليلاً ثم حاول.';
  static const aiTimeout = 'استغرق الرد وقتاً طويلاً. حاول مرة أخرى.';
  static const aiMalformed = 'وصل رد غير متوقع. حاول مرة أخرى.';
  static const aiGenericError = 'تعذّر إكمال الطلب الآن. حاول لاحقاً.';
  static const todayEffort = 'حصيلتك';
  static const stepsDone = 'خطوات أنجزتها';
  static const pathsCompleted = 'مسارات أكملتها';
  static const nextMilestone = 'المحطة التالية';
  static const milestoneBody = 'أكمل 3 تحديات لفتح جلسة مراجعة ذاتية.';
  static const emptyInsights =
      'سيظهر تقدّمك هنا بعد أن تبدأ أول مسار وتكمل تحدّياً.';
  static const general = 'عام';
  static const language = 'لغة العرض';
  static const arabic = 'العربية';
  static const privacy = 'سياسة الخصوصية';
  static const support = 'الدعم والمساعدة';
  static const terms = 'شروط الاستخدام';
  static const about = 'عن التطبيق';
  static const version = 'الإصدار';
  static const aiPrivacy = 'الذكاء الاصطناعي والخصوصية';
  static const aiConsentGranted = 'الموافقة مفعّلة';
  static const aiConsentNotGranted = 'لم تمنح الموافقة';
  static const revokeConsent = 'سحب الموافقة ومسح المحادثة';
  static const revokeConfirmation =
      'سيتم سحب الموافقة ومسح رسائل المدرّب المحفوظة على هذا الجهاز.';
  static const openLinkError = 'تعذّر فتح الرابط. حاول لاحقاً.';
  static const aboutBody =
      'جرّبها يساعدك على بناء المهارات بخطوات عملية قصيرة. المحتوى الذكي للتعلّم العام وليس بديلاً عن المختصين.';
  static const close = 'إغلاق';
  static const loading = 'جارٍ التحميل…';
  static const you = 'أنت';
  static const ai = 'المدرّب';
}
