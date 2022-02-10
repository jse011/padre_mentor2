import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:padre_mentor/src/domain/repositories/compress_image_repository.dart';

class DeviceCompressImageRepository extends CompressImageRepository{
  @override
  Future<Uint8List?> compressImage(File? file)async {
    var result = await FlutterImageCompress.compressWithFile(
      file?.absolute.path??"",
      minWidth: 750,
      minHeight: 750,
      quality: 80,
      format: CompressFormat.jpeg
      //rotate: 90,
    );
    return result;
  }

}