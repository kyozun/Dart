import 'dart:io';
import 'services/student_service.dart';
import 'services_implement/student_service_implement.dart';
import 'utils/types/query.dart';

void main() async {
  while (true) {
    stdout.write('''
    Menu:
    1. Add Student
    2. Get All Students
    3. Find Student
    4. Delete Student
    5. Update Student
    6. Exit
    Enter number: ''');

    String? choice = stdin.readLineSync();
    StudentService studentService = StudentServiceImplement();

    switch (choice) {
      case '1':
        await studentService.addStudent();
        break;
      case '2':
        await studentService.getAllStudents();
        break;
      case '3':
        stdout.write('''
        Find Student By:
        1. ID
        2. Name
        3. Phone
        Enter number: ''');

        String? choice = stdin.readLineSync();
        switch (choice) {
          case '1':
            await studentService.getStudent(Query.id);
            break;
          case '2':
            await studentService.getStudent(Query.name);
            break;
          case '3':
            await studentService.getStudent(Query.phone);
            break;
          default:
            print('Invalid number');
            break;
        }

        break;
      case '4':
        await studentService.deleteStudent();
        break;
      case '5':
        await studentService.getAllStudents();
        break;
      case '6':
        print('Bye');
        exit(0);
      default:
        print('Invalid number');
    }
  }
}
