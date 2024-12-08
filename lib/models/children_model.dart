class ChildrenModel {
  final String id;
  final String name;
  final String age;
  final String gender;
  final String weight;
  final String height;
  final String dateBirthday;

  ChildrenModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.weight,
    required this.height,
    required this.dateBirthday,
  });

  factory ChildrenModel.fromJson(Map<String, dynamic> json) {
    return ChildrenModel(
      id: json['id'].toString(), // Ensure id is a string
      name: json['name'],
      age: json['age'].toString(), // Ensure age is a string
      weight: json['weight'].toString(), // Ensure weight is a string
      height: json['height'].toString(), // Ensure height is a string
      gender: json['gender'],
      dateBirthday: json['dateBirthday'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'gender': gender,
      'weight': weight,
      'height': height,
      'dateBirthday': dateBirthday,
      'age': age,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'weight': weight,
      'height': height,
      'dateBirthday': dateBirthday,
    };
  }
}
