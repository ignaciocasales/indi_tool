// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$requestListHash() => r'89544782d724dbaf97d88d72f0ba6721a344700c';

/// See also [requestList].
@ProviderFor(requestList)
final requestListProvider = AutoDisposeProvider<List<HttpRequest>>.internal(
  requestList,
  name: r'requestListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$requestListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RequestListRef = AutoDisposeProviderRef<List<HttpRequest>>;
String _$selectedRequestHash() => r'ababf9b481167bb41e5b486a1744b7342f8a5df2';

/// See also [SelectedRequest].
@ProviderFor(SelectedRequest)
final selectedRequestProvider =
    AutoDisposeNotifierProvider<SelectedRequest, HttpRequest?>.internal(
  SelectedRequest.new,
  name: r'selectedRequestProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedRequestHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedRequest = AutoDisposeNotifier<HttpRequest?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
