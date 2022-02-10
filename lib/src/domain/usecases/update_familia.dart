import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:padre_mentor/src/domain/entities/familia_ui.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';
import 'package:padre_mentor/src/domain/repositories/check_conex_repository.dart';
import 'package:padre_mentor/src/domain/repositories/compress_image_repository.dart';
import 'package:padre_mentor/src/domain/repositories/http_datos_repository.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';

class UpdateFamilia extends UseCase<UpdateFamiliaCaseResponse, UpdateFamiliaCaseParams>{
  HttpDatosRepository httpRepository;
  UsuarioAndConfiguracionRepository repository;
  CheckConexRepository checkConexRepository;
  CompressImageRepository compressImageRepository;

  UpdateFamilia(this.httpRepository, this.repository, this.checkConexRepository, this.compressImageRepository);

  @override
  Future<Stream<UpdateFamiliaCaseResponse>> buildUseCaseStream(UpdateFamiliaCaseParams? params) async {
    final controller = StreamController<UpdateFamiliaCaseResponse>();

    try {
      bool hayconexion = await checkConexRepository.hayConexcion();
      if(hayconexion){
        int usuarioId = await repository.getSessionUsuarioId();
        String urlServidorLocal = await repository.getSessionUsuarioUrlServidor();

        if(params?.usuarioUi.fotoFile!=null){
          Uint8List? uint8list = await compressImageRepository.compressImage(params?.usuarioUi.fotoFile);
          String base64  = base64Encode(uint8list!);
          params?.usuarioUi.image64 =  base64;
        }

        for(HijosUi hijosUi in params?.hijosUiList??[]){
          if(hijosUi.fotoFile!=null){
            Uint8List? uint8list = await compressImageRepository.compressImage(hijosUi.fotoFile);
            String base64  = base64Encode(uint8list!);
            hijosUi.image64 = base64;
          }
        }

        for(FamiliaUi familiarUi in params?.familiaUiList??[]){
          if(familiarUi.fotoFile!=null){
            Uint8List? uint8list = await compressImageRepository.compressImage(familiarUi.fotoFile);
            String base64  = base64Encode(uint8list!);
            familiarUi.image64 = base64;
          }
        }

        List<dynamic> jsonPersonas =  repository.getJsonUpdatePersonas(params?.usuarioUi, params?.hijosUiList, params?.familiaUiList);
        if(jsonPersonas!=null&&jsonPersonas.isNotEmpty){
          List<dynamic>? jsonPersonasUpdate = await httpRepository.updateFamilia(urlServidorLocal, usuarioId, jsonPersonas);
          await repository.updatePersona(jsonPersonasUpdate);
        }

        logger.finest('UpdateFamilia successful.');
      }
      controller.add(UpdateFamiliaCaseResponse(hayconexion));
      controller.close();
    } catch (e) {
      logger.severe('UpdateFamilia unsuccessful: ' + e.toString());
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }

}

class UpdateFamiliaCaseResponse {
    bool hayconexion;

    UpdateFamiliaCaseResponse(this.hayconexion);
}

class UpdateFamiliaCaseParams {
  UsuarioUi usuarioUi;
  List<HijosUi> hijosUiList;
  List<FamiliaUi> familiaUiList;

  UpdateFamiliaCaseParams(this.usuarioUi, this.hijosUiList, this.familiaUiList);


}