// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_products_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$templateProductsRepositoryHash() =>
    r'c79409a10730193014442e19df424f39d5fe5d85';

/// See also [templateProductsRepository].
@ProviderFor(templateProductsRepository)
final templateProductsRepositoryProvider =
    AutoDisposeProvider<ProductsRepository>.internal(
  templateProductsRepository,
  name: r'templateProductsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$templateProductsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TemplateProductsRepositoryRef
    = AutoDisposeProviderRef<ProductsRepository>;
String _$templateProductsListHash() =>
    r'ea88cb28e7ad2d5fc21de289358949825a7215f9';

/// See also [templateProductsList].
@ProviderFor(templateProductsList)
final templateProductsListProvider =
    AutoDisposeStreamProvider<List<Product>>.internal(
  templateProductsList,
  name: r'templateProductsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$templateProductsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TemplateProductsListRef = AutoDisposeStreamProviderRef<List<Product>>;
String _$templateProductHash() => r'a2f12ef8243158fff61e5cb94983afe7cbb23ec6';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [templateProduct].
@ProviderFor(templateProduct)
const templateProductProvider = TemplateProductFamily();

/// See also [templateProduct].
class TemplateProductFamily extends Family<AsyncValue<Product?>> {
  /// See also [templateProduct].
  const TemplateProductFamily();

  /// See also [templateProduct].
  TemplateProductProvider call(
    String id,
  ) {
    return TemplateProductProvider(
      id,
    );
  }

  @override
  TemplateProductProvider getProviderOverride(
    covariant TemplateProductProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'templateProductProvider';
}

/// See also [templateProduct].
class TemplateProductProvider extends AutoDisposeStreamProvider<Product?> {
  /// See also [templateProduct].
  TemplateProductProvider(
    String id,
  ) : this._internal(
          (ref) => templateProduct(
            ref as TemplateProductRef,
            id,
          ),
          from: templateProductProvider,
          name: r'templateProductProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$templateProductHash,
          dependencies: TemplateProductFamily._dependencies,
          allTransitiveDependencies:
              TemplateProductFamily._allTransitiveDependencies,
          id: id,
        );

  TemplateProductProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    Stream<Product?> Function(TemplateProductRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TemplateProductProvider._internal(
        (ref) => create(ref as TemplateProductRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Product?> createElement() {
    return _TemplateProductProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TemplateProductProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TemplateProductRef on AutoDisposeStreamProviderRef<Product?> {
  /// The parameter `id` of this provider.
  String get id;
}

class _TemplateProductProviderElement
    extends AutoDisposeStreamProviderElement<Product?> with TemplateProductRef {
  _TemplateProductProviderElement(super.provider);

  @override
  String get id => (origin as TemplateProductProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
