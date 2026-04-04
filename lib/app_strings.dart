class AppStrings {
  // هذه هي "اللمبة" اللي تطفي وتشغل اللغة في كل التطبيق
  static bool isArabic = true; 

  // نصوص صفحة تفاصيل الحجز (Parking Detail)
  static String get parkingDetailTitle => isArabic ? "تفاصيل الحجز" : "Parking Detail";
  static String get vehicleTypeLabel => isArabic ? "نوع المركبة" : "VEHICLE TYPE";
  static String get parkingLotLabel => isArabic ? "موقع الموقف" : "PARKING LOT";
  static String get slotLabel => isArabic ? "الموقف" : "SLOT";
  static String get scheduleLabel => isArabic ? "الجدولة" : "SCHEDULE";
  static String get timeDurationLabel => isArabic ? "مدة الوقوف" : "Time Duration";
  static String get confirmPayBtn => isArabic ? "تأكيد والدفع" : "Confirm & Pay";

  // نصوص صفحة التذكرة (Ticket)
  static String get ticketTitle => isArabic ? "تذكرة الموقف" : "Your Parking Ticket";
  static String get downloadBtn => isArabic ? "تحميل" : "Download";
  static String get goToTimerBtn => isArabic ? "الذهاب للمؤقت" : "Go to Timer";
  static String get scanMsg => isArabic 
      ? "الرجاء مسح الرمز عند وصولك للموقف" 
      : "Please scan the code on the parking when you arrived";

  // نصوص صفحة التايمر (Timer)
  static String get timerTitle => isArabic ? "مؤقت الموقف" : "Parking Timer";
  static String get hours => isArabic ? "ساعات" : "Hours";
  static String get minutes => isArabic ? "دقائق" : "Minutes";
  static String get seconds => isArabic ? "ثواني" : "Seconds";
  static String get extendBtn => isArabic ? "تمديد الوقت" : "Extend the Time";
}