import 'dart:io';
import 'dart:typed_data';

abstract class CompressImageRepository {

  Future<Uint8List?> compressImage(File? file);

}