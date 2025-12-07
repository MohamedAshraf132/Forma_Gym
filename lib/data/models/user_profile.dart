class UserProfile {
  String gender; // 'Male' or 'Female'
  DateTime? birthday; // تاريخ الميلاد
  double weight; // بالكيلوجرام
  double height; // بالسنتيمتر
  bool useAppleHealth; // خيار ربط الصحة (كما في الصورة)

  UserProfile({
    this.gender = 'Male', // قيمة افتراضية
    this.birthday,
    this.weight = 75.0,
    this.height = 175.0,
    this.useAppleHealth = false,
  });
}
