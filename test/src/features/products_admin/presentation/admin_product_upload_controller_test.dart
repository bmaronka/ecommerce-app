import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/products_admin/application/image_upload_service.dart';
import 'package:ecommerce_app/src/features/products_admin/presentation/admin_product_upload_controller.dart';
import 'package:ecommerce_app/src/router/router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.dart';
import '../../../mocks.mocks.dart';

void main() {
  late MockImageUploadService imageUploadService;
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

  setUp(() {
    imageUploadService = MockImageUploadService();
    goRouter = MockGoRouter();
  });

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        imageUploadServiceProvider.overrideWithValue(imageUploadService),
        goRouterProvider.overrideWithValue(goRouter),
      ],
    );
    addTearDown(container.dispose);

    return container;
  }

  group(
    'upload',
    () {
      test(
        'success',
        () async {
          when(imageUploadService.uploadProduct(testProduct)).thenAnswer((_) => Future.value(null));

          final container = makeProviderContainer();
          final controller = container.read(adminProductUploadControllerProvider.notifier);
          final listener = Listener();

          container.listen(
            adminProductUploadControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          await controller.upload(testProduct);

          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
          ]);
          verifyNoMoreInteractions(listener);
          verify(imageUploadService.uploadProduct(testProduct)).called(1);
          verify(
            goRouter.goNamed(
              AppRoute.adminEditProduct.name,
              pathParameters: {
                'id': testProduct.id,
              },
            ),
          ).called(1);
        },
      );

      test(
        'failure',
        () async {
          when(imageUploadService.uploadProduct(testProduct)).thenThrow(exception);

          final container = makeProviderContainer();
          final controller = container.read(adminProductUploadControllerProvider.notifier);
          final listener = Listener();

          container.listen(
            adminProductUploadControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          await controller.upload(testProduct);

          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), argThat(isA<AsyncError>())),
          ]);
          verifyNoMoreInteractions(listener);
          verify(imageUploadService.uploadProduct(testProduct)).called(1);
          verifyNever(
            goRouter.goNamed(
              AppRoute.adminEditProduct.name,
              pathParameters: {
                'id': testProduct.id,
              },
            ),
          );
        },
      );
    },
  );
}
