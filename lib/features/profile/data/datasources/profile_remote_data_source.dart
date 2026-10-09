import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../movies/domain/entities/movie_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<UserEntity> getUserProfile();
  Future<List<MovieEntity>> getWishlist();
  Future<List<MovieEntity>> getHistory();
  Stream<List<MovieEntity>> streamWishlist(String userId);
  Stream<List<MovieEntity>> streamHistory(String userId);
  Future<void> updateUserData({
    required String name,
    required String phone,
    required int avatarId,
  });
  Future<void> deleteAccount();
  Future<void> signOut();
  Future<void> resetPassword({required String email});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  ProfileRemoteDataSourceImpl({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  User _requireCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'USER_NOT_FOUND',
        message: 'No logged in user found.',
      );
    }
    return user;
  }

  MovieEntity _mapDocToMovieEntity(String docId, Map<String, dynamic> data) {
    final image =
        (data['medium_cover_image'] ?? data['mediumCoverImage']) as String? ??
            '';
    final largeImage =
        (data['large_cover_image'] ?? data['largeCoverImage'] ?? image)
                as String? ??
            '';
    return MovieEntity(
      id: (data['id'] as num?)?.toInt() ?? int.tryParse(docId) ?? 0,
      title: data['title'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      genres: (data['genres'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      summary: data['summary'] as String? ?? '',
      mediumCoverImage: image,
      largeCoverImage: largeImage,
      backgroundImage:
          (data['background_image'] ?? data['backgroundImage']) as String? ??
              '',
      year: (data['year'] as num?)?.toInt() ?? 0,
      runtime: (data['runtime'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Future<UserEntity> getUserProfile() async {
    final currentUser = _requireCurrentUser();
    try {
      final doc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return UserEntity(
          id: currentUser.uid,
          name: data['name'] as String? ?? currentUser.displayName ?? 'User',
          email: data['email'] as String? ?? currentUser.email ?? '',
          phone: data['phone'] as String? ?? currentUser.phoneNumber ?? '',
          avatarId: data['avatarId']?.toString() ?? 'avatar_1',
        );
      }
    } catch (_) {
      // Fallback to FirebaseAuth user data if Firestore read fails
    }

    return UserEntity(
      id: currentUser.uid,
      name: currentUser.displayName ?? 'User',
      email: currentUser.email ?? '',
      phone: currentUser.phoneNumber ?? '',
      avatarId: 'avatar_1',
    );
  }

  @override
  Future<List<MovieEntity>> getWishlist() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('favorites')
          .get();

      final docs = snapshot.docs.toList();
      docs.sort((a, b) {
        final aTime =
            (a.data()['added_at'] ?? a.data()['addedAt']) as Timestamp?;
        final bTime =
            (b.data()['added_at'] ?? b.data()['addedAt']) as Timestamp?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      return docs
          .map((doc) => _mapDocToMovieEntity(doc.id, doc.data()))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Stream<List<MovieEntity>> streamWishlist(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) {
      final docs = snapshot.docs.toList();
      docs.sort((a, b) {
        final aTime =
            (a.data()['added_at'] ?? a.data()['addedAt']) as Timestamp?;
        final bTime =
            (b.data()['added_at'] ?? b.data()['addedAt']) as Timestamp?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });
      return docs
          .map((doc) => _mapDocToMovieEntity(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Future<List<MovieEntity>> getHistory() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('history')
          .get();

      final docs = snapshot.docs.toList();
      docs.sort((a, b) {
        final aTime =
            (a.data()['watched_at'] ?? a.data()['watchedAt']) as Timestamp?;
        final bTime =
            (b.data()['watched_at'] ?? b.data()['watchedAt']) as Timestamp?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });

      return docs
          .map((doc) => _mapDocToMovieEntity(doc.id, doc.data()))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Stream<List<MovieEntity>> streamHistory(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .snapshots()
        .map((snapshot) {
      final docs = snapshot.docs.toList();
      docs.sort((a, b) {
        final aTime =
            (a.data()['watched_at'] ?? a.data()['watchedAt']) as Timestamp?;
        final bTime =
            (b.data()['watched_at'] ?? b.data()['watchedAt']) as Timestamp?;
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return bTime.compareTo(aTime);
      });
      return docs
          .map((doc) => _mapDocToMovieEntity(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  Future<void> updateUserData({
    required String name,
    required String phone,
    required int avatarId,
  }) async {
    final currentUser = _requireCurrentUser();

    await _firestore.collection('users').doc(currentUser.uid).set({
      'uid': currentUser.uid,
      'name': name.trim(),
      'phone': phone.trim(),
      'avatarId': 'avatar_$avatarId',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    try {
      await currentUser.updateDisplayName(name.trim());
    } catch (_) {}
  }

  @override
  Future<void> deleteAccount() async {
    final currentUser = _requireCurrentUser();

    try {
      await _firestore.collection('users').doc(currentUser.uid).delete();
    } catch (_) {}

    await currentUser.delete();
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }
}
