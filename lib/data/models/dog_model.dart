class Dog {
  final int? id; // Permite ser null
  final String name;
  final int age;

  Dog({this.id, required this.name, required this.age});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }
}
