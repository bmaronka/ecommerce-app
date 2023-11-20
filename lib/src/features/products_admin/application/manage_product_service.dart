import 'package:ecommerce_app/src/features/products/data/products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/products_admin/data/image_upload_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'manage_product_service.g.dart';

class ManageProductService {
  const ManageProductService({
    required this.imageUploadRepository,
    required this.productsRepository,
  });

  final ImageUploadRepository imageUploadRepository;
  final ProductsRepository productsRepository;

  Future<void> uploadProduct(Product product) async {
    final downloadUrl = await imageUploadRepository.uploadProductImageFromAsset(product.imageUrl);
    await productsRepository.createProduct(product.id, downloadUrl);
  }

  Future<void> deleteProduct(Product product) async {
    await imageUploadRepository.deleteProductImage(product.imageUrl);
    await productsRepository.deleteProduct(product.id);
  }
}

@riverpod
ManageProductService manageProductService(ManageProductServiceRef ref) => ManageProductService(
      imageUploadRepository: ref.watch(imageUploadRepositoryProvider),
      productsRepository: ref.watch(productsRepositoryProvider),
    );
