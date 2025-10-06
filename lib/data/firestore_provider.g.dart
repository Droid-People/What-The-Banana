// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseFirestore)
const firebaseFirestoreProvider = FirebaseFirestoreProvider._();

final class FirebaseFirestoreProvider extends $FunctionalProvider<
    FirebaseFirestore,
    FirebaseFirestore,
    FirebaseFirestore> with $Provider<FirebaseFirestore> {
  const FirebaseFirestoreProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'firebaseFirestoreProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$firebaseFirestoreHash();

  @$internal
  @override
  $ProviderElement<FirebaseFirestore> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseFirestore create(Ref ref) {
    return firebaseFirestore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseFirestore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseFirestore>(value),
    );
  }
}

String _$firebaseFirestoreHash() => r'eca974fdc891fcd3f9586742678f47582b20adec';

@ProviderFor(feedbackCollection)
const feedbackCollectionProvider = FeedbackCollectionProvider._();

final class FeedbackCollectionProvider extends $FunctionalProvider<
        CollectionReference<Map<String, dynamic>>,
        CollectionReference<Map<String, dynamic>>,
        CollectionReference<Map<String, dynamic>>>
    with $Provider<CollectionReference<Map<String, dynamic>>> {
  const FeedbackCollectionProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'feedbackCollectionProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$feedbackCollectionHash();

  @$internal
  @override
  $ProviderElement<CollectionReference<Map<String, dynamic>>> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CollectionReference<Map<String, dynamic>> create(Ref ref) {
    return feedbackCollection(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CollectionReference<Map<String, dynamic>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<CollectionReference<Map<String, dynamic>>>(value),
    );
  }
}

String _$feedbackCollectionHash() =>
    r'6d07760e72c1f6e203d9a01264c3dc83d2a8dbfc';

@ProviderFor(AddFeedback)
const addFeedbackProvider = AddFeedbackProvider._();

final class AddFeedbackProvider
    extends $AsyncNotifierProvider<AddFeedback, void> {
  const AddFeedbackProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'addFeedbackProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$addFeedbackHash();

  @$internal
  @override
  AddFeedback create() => AddFeedback();
}

String _$addFeedbackHash() => r'8cf2bd6abdbc1fa270bf3d1d3b9ffb25c48053f0';

abstract class _$AddFeedback extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<void>, void>,
        AsyncValue<void>,
        Object?,
        Object?>;
    element.handleValue(ref, null);
  }
}
