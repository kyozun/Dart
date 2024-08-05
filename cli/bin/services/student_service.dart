import '../utils/types/query.dart';


abstract class StudentService {
  Future<void> addStudent();

  Future<void> getStudent(Query query);

  Future<void> getAllStudents();

  Future<void> deleteStudent();

  bool isAlphabet(String str) {
    RegExp alphabet = RegExp(r'^[A-Za-z]+$');
    return alphabet.hasMatch(str);
  }
}
