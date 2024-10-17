import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

 
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    return user;
  } on FirebaseAuthException catch (e) {
    throw e;
  }
}

 
  Future<void> signOut() async {
    await _auth.signOut();
  }

  
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
