import 'package:pluto_grid/pluto_grid.dart';

class User {
  final String id;
  final String name;
  final int age;
  final String role;
  final String joined;
  final String workingTime;
  final double salary;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.role,
    required this.joined,
    required this.workingTime,
    required this.salary,
  });

  // Factory method to convert a PlutoCell map into a User instance
  factory User.fromPlutoCells(Map<String, PlutoCell> cells) {
    return User(
      id: cells['id']?.value ?? '',
      name: cells['name']?.value ?? '',
      age: cells['age']?.value ?? 0,
      role: cells['role']?.value ?? '',
      joined: cells['joined']?.value ?? '',
      workingTime: cells['working_time']?.value ?? '',
      salary: (cells['salary']?.value ?? 0).toDouble(),
    );
  }

  // Convert a User instance to a PlutoCell map
  Map<String, PlutoCell> toPlutoCells() {
    return {
      'id': PlutoCell(value: id),
      'name': PlutoCell(value: name),
      'age': PlutoCell(value: age),
      'role': PlutoCell(value: role),
      'joined': PlutoCell(value: joined),
      'working_time': PlutoCell(value: workingTime),
      'salary': PlutoCell(value: salary),
    };
  }

  String toJson() =>
      '{"id": "$id", "name": "$name", "age": $age, "role": "$role", "joined": "$joined", "working_time": "$workingTime", "salary": $salary}';
}
