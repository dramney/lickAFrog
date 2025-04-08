import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:frog/domain/entities/user.dart';
import 'package:frog/domain/entities/frog.dart';
import 'package:frog/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._firebaseAuth, this._firestore);

  @override
  Future<bool> isAuthenticated() async {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<User> login(String nickname, String password) async {
    try {
      // First, find the user document by nickname
      final querySnapshot = await _firestore
          .collection('users')
          .where('nickname', isEqualTo: nickname)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('User not found');
      }

      // Get user document
      final userDoc = querySnapshot.docs.first;
      final userAuthUid = userDoc['authUid'] as String;

      final storedHashedPassword = userDoc['passwordHash'] as String;
      final enteredHashedPassword = _hashPassword(password);

      if (enteredHashedPassword != storedHashedPassword) {
        throw Exception('Incorrect password');
      }

      // Use Firebase to authenticate the user (sign in anonymously for now)
      final userCredential = await _firebaseAuth.signInAnonymously();

      // Store the connection between auth user and the nickname
      await _firestore.collection('auth_users').doc(userCredential.user!.uid).set({
        'firestoreUserId': userDoc.id,
        'nickname': nickname,
      });

      // Fetch the frogRef to get the FrogData
      final frogRef = userDoc['frogRef'] as DocumentReference;
      final frogDoc = await frogRef.get();

      if (!frogDoc.exists) {
        throw Exception('Frog data not found');
      }

      final frogData = FrogData(
        frogName: frogDoc['frogName'] as String? ?? 'Frog',
        dayLicks: frogDoc['dayLicks'] as int? ?? 0,
        allLicks: frogDoc['allLicks'] as int? ?? 0,
      );

      return User(
        id: userDoc.id,
        nickname: nickname,
        frogRef: frogRef.id, // Store the frog's document ID as a reference
      );
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<User> register(String nickname, String password) async {
    try {
      // Check if the nickname is already taken
      final querySnapshot = await _firestore
          .collection('users')
          .where('nickname', isEqualTo: nickname)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('Nickname already taken');
      }

      // Create anonymous auth account
      final userCredential = await _firebaseAuth.signInAnonymously();

      // Define default values for the new user
      final frogRef = await _createFrogData();

      // Create user document in Firestore
      final userDocRef = _firestore.collection('users').doc();
      await userDocRef.set({
        'nickname': nickname,
        'passwordHash': _hashPassword(password),
        'authUid': userCredential.user!.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'frogRef': frogRef,  // Store the reference to frog data
      });

      // Store the connection between auth user and the nickname
      await _firestore.collection('auth_users').doc(userCredential.user!.uid).set({
        'firestoreUserId': userDocRef.id,
        'nickname': nickname,
      });

      return User(
        id: userDocRef.id,
        nickname: nickname,
        frogRef: frogRef.id,  // Store the frog document ID as a reference
      );
    } catch (e, stackTrace) {
      print('Registration failed: $e');
      print(stackTrace);
      rethrow;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser == null) {
      throw Exception('No authenticated user');
    }

    // Get user data from auth_users collection
    final authUserDoc = await _firestore
        .collection('auth_users')
        .doc(firebaseUser.uid)
        .get();

    if (!authUserDoc.exists) {
      throw Exception('User data not found');
    }

    final firestoreUserId = authUserDoc['firestoreUserId'] as String;

    // Fetch complete user data from the users collection
    final userDoc = await _firestore
        .collection('users')
        .doc(firestoreUserId)
        .get();

    if (!userDoc.exists) {
      throw Exception('User document not found');
    }

    // Extract user data
    final nickname = userDoc['nickname'] as String;
    final frogRef = userDoc['frogRef'] as DocumentReference;

    // Fetch the frog data from the frog collection
    final frogDoc = await frogRef.get();
    if (!frogDoc.exists) {
      throw Exception('Frog data not found');
    }

    final frogData = FrogData(
      frogName: frogDoc['frogName'] as String? ?? 'Frog',
      dayLicks: frogDoc['dayLicks'] as int? ?? 0,
      allLicks: frogDoc['allLicks'] as int? ?? 0,
    );

    return User(
      id: firestoreUserId,
      nickname: nickname,
      frogRef: frogRef.id, // Store the frog document ID
    );
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Simple password hashing function (not for production use)
  String _hashPassword(String password) {
    // In a real app, use a proper password hashing library
    // This is just for demonstration purposes
    return '${password.split('').reversed.join('')}_hashed';
  }

  // Helper function to create new frog data
  Future<DocumentReference> _createFrogData() async {
    final frogDocRef = _firestore.collection('frogs').doc();
    await frogDocRef.set({
      'frogName': 'Frog',
      'dayLicks': 0,
      'allLicks': 0,
    });
    return frogDocRef;
  }
}
