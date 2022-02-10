import 'dart:io';

import 'package:padre_mentor/src/domain/entities/contacto_ui.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/entities/programa_educativo_ui.dart';

import 'familia_ui.dart';

class UsuarioUi {
  int? personaId;
  String? nombre;
  String? nombreSimple;
  String? foto;
  List<HijosUi>? hijos;
  List<ProgramaEducativoUi>? programaEducativoUiList;
  HijosUi? hijoSelected;
  ProgramaEducativoUi? programaEducativoUiSelected;
  String? celular;
  String? correo;
  String? fechaNacimiento;
  String? fechaNacimiento2;
  List<FamiliaUi>? familiaUiList = [];
  bool? change;
  File? fotoFile;
  String? image64;

  UsuarioUi({this.personaId, this.nombre, this.foto, this.hijos, this.programaEducativoUiList, this.celular, this.correo, this.fechaNacimiento, this.familiaUiList, this.nombreSimple, this.fechaNacimiento2});
}