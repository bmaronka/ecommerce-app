import 'package:ecommerce_app/src/features/products/data/products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/products_admin/data/image_upload_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_upload_service.g.dart';

class ImageUploadService {
  const ImageUploadService({
    required this.imageUploadRepository,
    required this.productsRepository,
  });

  final ImageUploadRepository imageUploadRepository;
  final ProductsRepository productsRepository;

  Future<void> uploadProduct(Product product) async {
    final downloadUrl = await imageUploadRepository.uploadProductImageFromAsset(product.imageUrl);
    await productsRepository.createProduct(product.id, downloadUrl);
  }
}

@riverpod
ImageUploadService imageUploadService(ImageUploadServiceRef ref) => ImageUploadService(
      imageUploadRepository: ref.watch(imageUploadRepositoryProvider),
      productsRepository: ref.watch(productsRepositoryProvider),
    );
