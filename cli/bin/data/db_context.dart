import 'package:mysql1/mysql1.dart';
import '../models/student.dart';

class DbContext {
  var settings = ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'root',
      password: 'pizza',
      db: 'student',
      timeout: Duration(seconds: 30));

  Future<MySqlConnection> getConnection() async {
    try {
      return await MySqlConnection.connect(settings);
    } catch (e) {
      print('Can\'t not connect to Database');
      rethrow;
    }
  }

  // Create
  Future<void> createStudent(Student student) async {
    MySqlConnection? connection;
    connection = await getConnection();
    print(connection);

    try {
      await connection.query('insert into student(name, phone) values(?,?)',
          [student.name, student.phone]);
      print('Đã thêm sinh viên');
    } catch (e) {
      print('Bad requesst');
    } finally {
      connection.close();
    }
  }

  // Get
  Future<List<Student>> getStudent({int? id, String? name}) async {
    MySqlConnection? connection;
    connection = await getConnection();
    List<Student> students = [];
    if (id != null) {
      var results =
          await connection.query('select * from student where id = ?', [id]);
      if (results.isEmpty) {
        return [];
      }
      for (var row in results) {
        students.add(Student(id: row[0], name: row[1], phone: row[2]));
      }
    } else if (name != null) {
      var results = await connection
          .query('select * from student where name like ? ', ['%$name%']);
      if (results.isEmpty) {
        return [];
      }
      for (var row in results) {
        students.add(Student(id: row[0], name: row[1], phone: row[2]));
      }
    }

    return students;
  }

  // Get
  Future<List<Student>> getAllStudents() async {
    MySqlConnection? connection;
    connection = await getConnection();
    var results = await connection.query('select * from student');
    List<Student> students = [];
    for (var row in results) {
      students.add(Student(id: row[0], name: row[1], phone: row[2]));
    }
    return students;
  }

  // Delete
  Future<bool> deleteStudent(int id) async {
    MySqlConnection? connection;
    connection = await getConnection();

    var result =
        await connection.query('delete from student where id = ?', [id]);
    return result.affectedRows! > 0 ? true : false;
  }

  // Update
  Future<void> updateStudent(Student student) async {
    MySqlConnection? connection;
    connection = await getConnection();
    await connection.query(
        'update Student set name = ? , phone = ? where id = ?',
        [student.name, student.phone, student.id]);
  }
}
