// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$requestListHash() => r'c3636d83b6fc00bc8e5dccd87d8c804b98a2ed51';

/// See also [requestList].
@ProviderFor(requestList)
final requestListProvider = AutoDisposeProvider<List<IndiHttpRequest>>.internal(
  requestList,
  name: r'requestListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$requestListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RequestListRef = AutoDisposeProviderRef<List<IndiHttpRequest>>;
String _$selectedRequestHash() => r'5f6c04355e663e217baea4a81841b2ca101355c8';

/// See also [SelectedRequest].
@ProviderFor(SelectedRequest)
final selectedRequestProvider =
    AutoDisposeNotifierProvider<SelectedRequest, IndiHttpRequest?>.internal(
  SelectedRequest.new,
  name: r'selectedRequestProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedRequestHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedRequest = AutoDisposeNotifier<IndiHttpRequest?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
