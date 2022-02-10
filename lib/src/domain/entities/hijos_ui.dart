import 'dart:io';

class HijosUi {
  int? usuarioId;
  int? personaId;
  String? nombre;
  String? foto;
  String? documento;
  String? celular;
  String? correo;
  String? fechaNacimiento;
  String? fechaNacimiento2;
  bool? change;
  File? fotoFile;
  String? image64;

  HijosUi({this.usuarioId, this.personaId, this.nombre, this.foto, this.documento, this.celular, this.correo, this.fechaNacimiento, this.fechaNacimiento2});
}