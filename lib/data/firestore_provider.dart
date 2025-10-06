import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:what_the_banana/common/logger.dart';

part 'firestore_provider.g.dart';

// Firestore 인스턴스를 제공하는 Provider
@riverpod
FirebaseFirestore firebaseFirestore(Ref ref) => FirebaseFirestore.instance;

@riverpod
CollectionReference<Map<String, dynamic>> feedbackCollection(Ref ref) {
  return ref.watch(firebaseFirestoreProvider).collection('feedback');
}

// Firestore에 사용자 추가하는 함수
@riverpod
class AddFeedback extends _$AddFeedback {
  @override
  FutureOr<void> build() {}

  Future<bool> addFeedback(String feedback) async {
    try {
      final feedbackCollection = ref.read(feedbackCollectionProvider);
      await feedbackCollection.add({
        'feedback': feedback,
        'timestamp': FieldValue.serverTimestamp(),
      });
      return true;
    } on Exception catch (e) {
      Log.e('Failed to add feedback: $e');
      return false;
    }
  }
}
