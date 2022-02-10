import 'dart:io';

class FamiliaUi {
  int? personaId;
  String? nombre;
  String? foto;
  String? documento;
  String? celular;
  String? correo;
  String? fechaNacimiento;
  String? fechaNacimiento2;
  String? relacion;
  bool? change;
  File? fotoFile;
  String? image64;

  FamiliaUi({this.personaId, this.nombre, this.foto, this.documento, this.celular, this.correo, this.fechaNacimiento, this.relacion, this.fechaNacimiento2});
}