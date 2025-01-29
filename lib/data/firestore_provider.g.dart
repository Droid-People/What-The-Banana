// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$firebaseFirestoreHash() => r'eca974fdc891fcd3f9586742678f47582b20adec';

/// See also [firebaseFirestore].
@ProviderFor(firebaseFirestore)
final firebaseFirestoreProvider =
    AutoDisposeProvider<FirebaseFirestore>.internal(
  firebaseFirestore,
  name: r'firebaseFirestoreProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$firebaseFirestoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FirebaseFirestoreRef = AutoDisposeProviderRef<FirebaseFirestore>;
String _$feedbackCollectionHash() =>
    r'5a6e4337c5217bca5ee53b355e916280a8c20bd1';

/// See also [feedbackCollection].
@ProviderFor(feedbackCollection)
final feedbackCollectionProvider =
    AutoDisposeProvider<CollectionReference<Map<String, dynamic>>>.internal(
  feedbackCollection,
  name: r'feedbackCollectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$feedbackCollectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeedbackCollectionRef
    = AutoDisposeProviderRef<CollectionReference<Map<String, dynamic>>>;
String _$addFeedbackHash() => r'6b5c4fd2598bc9e181acf4fe1081173d5b5d6cea';

/// See also [AddFeedback].
@ProviderFor(AddFeedback)
final addFeedbackProvider =
    AutoDisposeAsyncNotifierProvider<AddFeedback, void>.internal(
  AddFeedback.new,
  name: r'addFeedbackProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$addFeedbackHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AddFeedback = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
