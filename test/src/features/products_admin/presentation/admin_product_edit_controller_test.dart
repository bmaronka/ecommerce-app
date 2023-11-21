import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/data/products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/products_admin/application/manage_product_service.dart';
import 'package:ecommerce_app/src/features/products_admin/presentation/admin_product_edit_controller.dart';
import 'package:ecommerce_app/src/router/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.dart';
import '../../../mocks.mocks.dart';

void main() {
  late MockManageProductService manageProductService;
  late FakeProductsRepository fakeProductsRepository;
  late GoRouter goRouter;

  final exception = Exception('Connection failure');
  final testProduct = Product(
    id: '1',
    imageUrl: 'assets/products/bruschetta-plate.jpg',
    title: 'Bruschetta plate',
    description: 'Lorem ipsum',
    price: 15,
    availableQuantity: 5,
  );
  final updatedTestProduct = Product(
    id: '1',
    imageUrl: 'assets/products/bruschetta-plate.jpg',
    title: 'Bruschetta plate 1',
    description: 'Lorem ipsum 1',
    price: 20,
    availableQuantity: 10,
  );

  setUp(() {
    manageProductService = MockManageProductService();
    fakeProductsRepository = MockFakeProductsRepository();
    goRouter = MockGoRouter();
  });

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        manageProductServiceProvider.overrideWithValue(manageProductService),
        productsRepositoryProvider.overrideWithValue(fakeProductsRepository),
        goRouterProvider.overrideWithValue(goRouter),
      ],
    );
    addTearDown(container.dispose);

    return container;
  }

  group(
    'update',
    () {
      test(
        'success',
        () async {
          when(fakeProductsRepository.updateProduct(updatedTestProduct)).thenAnswer((_) => Future.value(null));

          final container = makeProviderContainer();
          final controller = container.read(adminProductEditControllerProvider.notifier);
          final listener = Listener();

          container.listen(
            adminProductEditControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          await controller.updateProduct(
            product: testProduct,
            title: 'Bruschetta plate 1',
            description: 'Lorem ipsum 1',
            price: '20',
            availableQuantity: '10',
          );

          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), data),
          ]);
          verifyNoMoreInteractions(listener);
          verify(fakeProductsRepository.updateProduct(updatedTestProduct)).called(1);
          verify(goRouter.pop()).called(1);
        },
      );

      test(
        'failure',
        () async {
          when(fakeProductsRepository.updateProduct(updatedTestProduct)).thenThrow(exception);

          final container = makeProviderContainer();
          final controller = container.read(adminProductEditControllerProvider.notifier);
          final listener = Listener();

          container.listen(
            adminProductEditControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          await controller.updateProduct(
            product: testProduct,
            title: 'Bruschetta plate 1',
            description: 'Lorem ipsum 1',
            price: '20',
            availableQuantity: '10',
          );

          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), argThat(isA<AsyncError>())),
          ]);
          verifyNoMoreInteractions(listener);
          verify(fakeProductsRepository.updateProduct(updatedTestProduct)).called(1);
          verifyNever(goRouter.pop());
        },
      );
    },
  );

  group(
    'delete',
    () {
      test(
        'success',
        () async {
          when(manageProductService.deleteProduct(testProduct)).thenAnswer((_) => Future.value(null));

          final container = makeProviderContainer();
          final controller = container.read(adminProductEditControllerProvider.notifier);
          final listener = Listener();

          container.listen(
            adminProductEditControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          await controller.deleteProduct(testProduct);

          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), data),
          ]);
          verifyNoMoreInteractions(listener);
          verify(manageProductService.deleteProduct(testProduct)).called(1);
          verify(goRouter.pop()).called(1);
        },
      );

      test(
        'failure',
        () async {
          when(manageProductService.deleteProduct(testProduct)).thenThrow(exception);

          final container = makeProviderContainer();
          final controller = container.read(adminProductEditControllerProvider.notifier);
          final listener = Listener();

          container.listen(
            adminProductEditControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          await controller.deleteProduct(testProduct);

          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), argThat(isA<AsyncError>())),
          ]);
          verifyNoMoreInteractions(listener);
          verify(manageProductService.deleteProduct(testProduct)).called(1);
          verifyNever(goRouter.pop());
        },
      );
    },
  );
}
