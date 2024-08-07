import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;

class Student {
  int id;
  String name;
  String phone;
  Student(this.id, this.name, this.phone);

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'phone': phone};
  }

  static Student fromJson(Map<String, dynamic> json) {
    return Student(json['id'], json['name'], json['phone']);
  }

  @override
  String toString() {
    return 'ID: $id, Name: $name, Phone: $phone';
  }
}

Future<void> addStudent(String filePath, List<Student> students) async {
  int id = students.isEmpty ? 1 : students.last.id + 1;

  stdout.write('Enter student name: ');

  String? name = stdin.readLineSync();

  if (name == null || name.isEmpty) {
    print('Invalid name');
    return;
  }

  stdout.write('Enter student phone: ');

  String? phone = stdin.readLineSync();

  if (phone == null || phone.isEmpty) {
    print('Invalid phone');
    return;
  }

  /* Tao doi tuong Json */
  Student student = Student(id, name, phone);

  /* Them sinh vien vao List */
  students.add(student);

  /* Them List vao Json file */
  await saveStudents(filePath, students);
}

void displayStudent(List<Student> students) {
  if (students.isEmpty) {
    print('Student is empty');
  }
  for (var student in students) {
    print(student);
  }
}

Future<void> saveStudents(String filePath, List<Student> students) async {
  String jsonContent =
      jsonEncode(students.map((student) => student.toJson()).toList());

  /* Ghi vao file */
  await File(filePath).writeAsString(jsonContent);
}

void main() async {
  const String fileName = 'student.json';
  final String directoryPath = p.join(Directory.current.path, 'data');
  
  /* Thu muc se luu file */
  final Directory directory = Directory(directoryPath);

  if (!await directory.exists()) {
    await directory.create(recursive: true);
  }

  final String filePath = p.join(directoryPath, fileName);
  List<Student> students = await getAllStudents(filePath);

  while (true) {
    stdout.write('''Menu: 
    1. Add Student
    2. Get All Students
    3. Delete Student
    4. Update Student
    5. Exit
    Enter number: ''');

    String? choice = stdin.readLineSync();
    switch (choice) {
      case '1':
        await addStudent(filePath, students);
        break;
      case '2':
        displayStudent(students);
        break;
      case '5':
        exit(0);
      default:
        print('Invalid number');
    }
  }
}

Future<List<Student>> getAllStudents(String filePath) async {
  if (!File(filePath).existsSync()) {
    await File(filePath).create();
    await File(filePath).writeAsString(jsonEncode([]));
    return [];
  }
  String content = await File(filePath).readAsString();
  List<dynamic> jsonData = jsonDecode(content);

  var students = jsonData.map((json) => Student.fromJson(json)).toList();
  return students;
}
