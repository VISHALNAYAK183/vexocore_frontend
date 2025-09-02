class SignUpModel {
  final String name;
  final String email;
  final String password;
  final int age;
  final String dob;
  final String gender;

  SignUpModel({
    required this.name,
    required this.email,
    required this.password,
    required this.age,
    required this.dob,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "age": age,
      "dob": dob,
      "gender": gender,
    };
  }
}
