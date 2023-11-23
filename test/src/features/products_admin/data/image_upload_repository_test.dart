import 'package:ecommerce_app/src/features/products_admin/data/image_upload_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

//Created to learn how to work with firebase_storage_mocks package
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late FirebaseStorage storage;

  late ImageUploadRepository imageUploadRepository;

  setUp(() {
    storage = MockFirebaseStorage();

    imageUploadRepository = ImageUploadRepository(storage);
  });

  test(
    'uploadProductImageFromAsset',
    () async {
      var image = await storage.ref('products/bruschetta-plate.jpg').getData();
      expect(image != null, false);

      await imageUploadRepository.uploadProductImageFromAsset('assets/products/bruschetta-plate.jpg');

      image = await storage.ref('products/bruschetta-plate.jpg').getData();
      expect(image != null, true);
    },
  );

  test(
    'deleteProductImage',
    () async {
      await imageUploadRepository.uploadProductImageFromAsset('assets/products/bruschetta-plate.jpg');
      var image = await storage.ref('products/bruschetta-plate.jpg').getData();
      expect(image != null, true);

      await imageUploadRepository
          .deleteProductImage('gs://ecommerce-app-a8e8b.appspot.com/products/bruschetta-plate.jpg');
      image = await storage.ref('products/bruschetta-plate.jpg').getData();
      expect(image != null, false);
    },
  );
}
