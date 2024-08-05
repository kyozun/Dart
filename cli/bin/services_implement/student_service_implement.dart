import '../data/db_context.dart';
import 'dart:io';
import '../models/student.dart';
import 'package:cli_table/cli_table.dart';
import '../utils/types/query.dart';
import '../services/student_service.dart';

class StudentServiceImplement implements StudentService {
  @override
  Future<void> addStudent() async {
    DbContext dbContext = DbContext();

    stdout.write('Enter student ID: ');
    int? id = int.tryParse(stdin.readLineSync() ?? '');
    if (id == null) {
      print('Invalid ID');
      return;
    }

    stdout.write('Enter name: ');
    String? name = stdin.readLineSync();
    if (name == null || !isAlphabet(name)) {
      print('Name không hợp lệ');
      return;
    }

    stdout.write('Enter phone: ');
    String? phone = stdin.readLineSync();

    if (phone == null) {
      print('Invalid phone');
      return;
    }

    var student = Student(id: id, name: name, phone: phone);
    await dbContext.createStudent(student);
  }

  @override
  Future<void> getAllStudents() async {
    DbContext dbContext = DbContext();
    List<Student> students = await dbContext.getAllStudents();
    final table = Table(
      header: ['ID', 'Name', "Phone Number"], // Set headers
      columnWidths: [10, 30, 30], // Optionally set column widhts,
    );

    for (var student in students) {
      table.add([student.id, student.name, student.phone]);
    }
    print(table.toString());
  }

  @override
  Future<void> getStudent(Query query) async {
    switch (query) {
      case Query.name:
        DbContext dbContext = DbContext();
        stdout.write('Enter name: ');
        String? name = stdin.readLineSync();
        if (!isAlphabet(name!)) {
          print('Invalid Name');
          return;
        }

        List<Student> students = await dbContext.getStudent(name: name);
        if (students.isEmpty) {
          print('Student not found');
          return;
        } else {
          final table = Table(
            header: ['ID', 'Name', "Phone Number"], // Set headers
            columnWidths: [10, 30, 30], // Optionally set column widhts,
          );

          for (var student in students) {
            table.add([student.id, student.name, student.phone]);
          }
          print(table.toString());
          return;
        }
      case Query.phone:
        break;
      default:
        DbContext dbContext = DbContext();
        stdout.write('Enter Student ID: ');
        int? id = int.tryParse(stdin.readLineSync() ?? '');
        if (id == null) {
          print('Invalid ID');
          return;
        }

        List<Student> students = await dbContext.getStudent(id: id);
        if (students == []) {
          print('Student not found');
          return;
        }

        final table = Table(
          header: ['ID', 'Name', "Phone Number"], // Set headers
          columnWidths: [10, 30, 30], // Optionally set column widhts,
        );

        for (var student in students) {
          table.add([student.id, student.name, student.phone]);
        }
        print(table.toString());
        break;
    }
  }

  @override
  Future<void> deleteStudent() async {
    DbContext dbContext = DbContext();

    stdout.write('Nhập ID sinh viên: ');
    int? id = int.tryParse(stdin.readLineSync() ?? '');
    if (id == null) {
      print('Invalid ID');
      return;
    }

    var isDelete = await dbContext.deleteStudent(id);
    if (isDelete) {
      print('Delete Student successfully');
      return;
    }
    print('Student not found');
  }

  @override
  bool isAlphabet(String str) {
    RegExp alphabet = RegExp(r'^[A-Za-z]+$');
    return alphabet.hasMatch(str);
  }
}
