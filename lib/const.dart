import 'package:table/model/user.dart';

final List<User> listOfUsers = List.generate(
  130,
  (index) => User(
    id: (index + 1).toString(),
    name: "name_${index + 1}",
    age: 20 + (index % 10),
    role: "role_${index % 5}",
    joined: "202${(index % 5) + 1}-01-01",
    workingTime: "09:00",
    salary: 400 + (index % 10) * 10,
  ),
);
