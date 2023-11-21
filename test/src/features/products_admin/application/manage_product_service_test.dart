import 'package:ecommerce_app/src/features/products/data/products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/products_admin/application/manage_product_service.dart';
import 'package:ecommerce_app/src/features/products_admin/data/image_upload_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  late ImageUploadRepository imageUploadRepository;
  late ProductsRepository productsRepository;

  late ManageProductService manageProductService;

  const testDownloadUrl = 'test_download_url.com';
  final testProduct = Product(
    id: '1',
    imageUrl: 'assets/products/bruschetta-plate.jpg',
    title: 'Bruschetta plate',
    description: 'Lorem ipsum',
    price: 15,
    availableQuantity: 5,
  );

  setUp(() {
    imageUploadRepository = MockImageUploadRepository();
    productsRepository = MockFakeProductsRepository();

    manageProductService = ManageProductService(
      imageUploadRepository: imageUploadRepository,
      productsRepository: productsRepository,
    );
  });

  test(
    'uploads image and creates product',
    () async {
      when(imageUploadRepository.uploadProductImageFromAsset(testProduct.imageUrl))
          .thenAnswer((_) => Future.value(testDownloadUrl));
      when(productsRepository.createProduct(testProduct.id, testDownloadUrl)).thenAnswer((_) => Future.value());

      await manageProductService.uploadProduct(testProduct);

      verify(imageUploadRepository.uploadProductImageFromAsset(testProduct.imageUrl)).called(1);
      verify(productsRepository.createProduct(testProduct.id, testDownloadUrl)).called(1);
    },
  );

  test(
    'deletes image and product',
    () async {
      when(imageUploadRepository.deleteProductImage(testProduct.imageUrl))
          .thenAnswer((_) => Future.value(testDownloadUrl));
      when(productsRepository.deleteProduct(testProduct.id)).thenAnswer((_) => Future.value());

      await manageProductService.deleteProduct(testProduct);

      verify(imageUploadRepository.deleteProductImage(testProduct.imageUrl)).called(1);
      verify(productsRepository.deleteProduct(testProduct.id)).called(1);
    },
  );
}
