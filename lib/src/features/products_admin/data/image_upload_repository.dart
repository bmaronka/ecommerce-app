import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_upload_repository.g.dart';

class ImageUploadRepository {
  const ImageUploadRepository(this._storage);

  final FirebaseStorage _storage;

  Future<String> uploadProductImageFromAsset(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final assetPathComponents = assetPath.split('/');
    final filename = assetPathComponents.last;

    final result = await _uploadAsset(byteData, filename);

    return result.ref.getDownloadURL();
  }

  UploadTask _uploadAsset(ByteData byteData, String filename) {
    final bytes = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
    final ref = _storage.ref('products/$filename');
    return ref.putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );
  }
}

@riverpod
ImageUploadRepository imageUploadRepository(ImageUploadRepositoryRef ref) =>
    ImageUploadRepository(FirebaseStorage.instance);
