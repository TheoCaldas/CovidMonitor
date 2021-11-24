import 'dart:convert';

UserData userDataFromJson(String str) {
  final jsonData = json.decode(str);
  return UserData.fromMap(jsonData);
}

String userDataToJson(UserData data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class UserData {
  static final int id = 1;

  String? profileImagePath;
  String? vacPassImagePath;
  String? vacDate;
  int? isVaccinated;
  String? name;
  int? age;

  UserData({
    this.profileImagePath,
    this.vacPassImagePath,
    this.vacDate,
    this.isVaccinated,
    this.name,
    this.age,
  });

  factory UserData.fromMap(Map<String, dynamic> json) => new UserData(
        profileImagePath: json["profileImagePath"],
        vacPassImagePath: json["vacPassImagePath"],
        vacDate: json["vacDate"],
        isVaccinated: json["isVaccinated"],
        name: json["name"],
        age: json["age"],
      );

  Map<String, dynamic> toMap() => {
        "profileImagePath": profileImagePath ?? "",
        "vacPassImagePath": vacPassImagePath ?? "",
        "vacDate": vacDate ?? "",
        "isVaccinated": isVaccinated ?? 0,
        "name": name ?? "",
        "age": age ?? 0,
      };
}
