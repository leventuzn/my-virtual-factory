import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_programlama_hw3_1306160014_1306160046/models/users.dart';

class UserService {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

  Future<void> add(User user) {
    return usersRef
        .doc(user.id)
        .set({
          'id': user.id,
          'name': user.name,
          'password': user.password,
        })
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add User: $error"));
  }

  Future<void> update(User user) {
    return usersRef
        .doc(user.id)
        .update({
          'name': user.name,
          'password': user.password,
        })
        .then((value) => print("User updated"))
        .catchError((error) => print("Failed to update User: $error"));
  }

  Future<void> delete(String id) {
    return usersRef
        .doc(id)
        .delete()
        .then((value) => print("User deleted"))
        .catchError((error) => print("Failed to delete User: $error"));
  }

  Stream<QuerySnapshot> getUsers() {
    return usersRef.snapshots();
  }
}
