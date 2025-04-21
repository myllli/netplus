class NaverAccountResult {
  final String id;
  final String email;
  final String name;
  final String nickname;
  final String gender;
  final String age;
  final String birthday;
  final String profileImage;
  final String birthyear;
  final String mobile;

  NaverAccountResult({
    required this.id,
    required this.email,
    required this.name,
    required this.nickname,
    required this.gender,
    required this.age,
    required this.birthday,
    required this.profileImage,
    required this.birthyear,
    required this.mobile,
  });

  factory NaverAccountResult.fromJson(Map<String, dynamic> json) {
    return NaverAccountResult(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      nickname: json['nickname'] ?? '',
      gender: json['gender'] ?? '',
      age: json['age'] ?? '',
      birthday: json['birthday'] ?? '',
      profileImage: json['profile_image'] ?? '',
      birthyear: json['birthyear'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }
}
