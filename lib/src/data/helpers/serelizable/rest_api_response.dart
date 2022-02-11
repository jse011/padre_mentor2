import 'package:json_annotation/json_annotation.dart';

part 'rest_api_response.g.dart';
/*
Mac OS important
export PATH="$PATH:/Users/edwinrubenpuente/SDKFlutter/flutter/bin"
export PATH="$PATH:/Users/jose/SDKFlutter/flutter 2/bin"
export PATH="$PATH:/Users/jose/flutter 2/bin"

flutter 2

* One-time code generation
By running flutter pub run build_runner build in the project root, you generate JSON serialization code for your models whenever they are needed. This triggers a one-time build that goes through the source files, picks the relevant ones, and generates the necessary serialization code for them.

While this is convenient, it would be nice if you did not have to run the build manually every time you make changes in your model classes.

Generating code continuously
A watcher makes our source code generation process more convenient. It watches changes in our project files and automatically builds the necessary files when needed. Start the watcher by running flutter pub run build_runner watch in the project root.

It is safe to start the watcher once and leave it running in the background.
* */
@JsonSerializable()
class UsuarioSerial{
  int? usuarioId;
  int? personaId;
  String? usuario;
  String? password;
  bool?  estado;
  bool?  habilitarAcceso;

  UsuarioSerial({this.usuarioId, this.personaId, this.usuario, this.password,
    this.estado, this.habilitarAcceso});

  factory UsuarioSerial.fromJson(Map<String, dynamic> json) => _$UsuarioSerialFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioSerialToJson(this);

}

@JsonSerializable()
class PersonaSerial{
  int? personaId;
  String? nombres;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? celular;
  String? telefono;
  String? foto;
  String? fechaNac;
  String? genero;
  String? estadoCivil;
  String? numDoc;
  String? ocupacion;
  int? estadoId;
  String? correo;
  String? direccion;
  String? path;
  String? image64; //Solo sirve para guardar un imagen

  PersonaSerial(
      {this.personaId,
        this.nombres,
        this.apellidoPaterno,
        this.apellidoMaterno,
        this.celular,
        this.telefono,
        this.foto,
        this.fechaNac,
        this.genero,
        this.estadoCivil,
        this.numDoc,
        this.ocupacion,
        this.estadoId = 0,
        this.correo,
        this.direccion,
        this.path,
        this.image64});

  factory PersonaSerial.fromJson(Map<String, dynamic> json) => _$PersonaSerialFromJson(json);

  Map<String, dynamic> toJson() => _$PersonaSerialToJson(this);
}

@JsonSerializable()
class RelacionesSerial{
  int? idRelacion;
  int? personaPrincipalId;
  int? personaVinculadaId;
  int? tipoId;
  bool?  activo;

  RelacionesSerial({this.idRelacion, this.personaPrincipalId, this.personaVinculadaId,
    this.tipoId, this.activo});

  factory RelacionesSerial.fromJson(Map<String, dynamic> json) => _$RelacionesSerialFromJson(json);

  Map<String, dynamic> toJson() => _$RelacionesSerialToJson(this);
}

@JsonSerializable()
class AnioAcademicoAlumnoSerial{

  int? idAnioAcademico;
  String? nombre;
  String? fechaInicio;
  String? fechaFin;
  String? denominacion;
  int? georeferenciaId;
  int? organigramaId;
  int? estadoId;
  int? tipoId;
  int? personaId;

  AnioAcademicoAlumnoSerial(
      {this.idAnioAcademico,
        this.nombre,
        this.fechaInicio,
        this.fechaFin,
        this.denominacion,
        this.georeferenciaId,
        this.organigramaId,
        this.estadoId,
        this.tipoId,
        this.personaId});

  factory AnioAcademicoAlumnoSerial.fromJson(Map<String, dynamic> json) => _$AnioAcademicoAlumnoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$AnioAcademicoAlumnoSerialToJson(this);
}

@JsonSerializable()
class CargaCursosSerial{

  int? cargaCursoId;
  int? planCursoId;
  int? empleadoId;
  int? cargaAcademicaId;
  int? complejo;
  int? evaluable;
  int? idempleado;
  int? idTipoHora;
  String? descripcion;
  int? fechaInicio;//Long
  int? fechafin;//Long
  String? modo;
  int? estado;
  int? anioAcademicoId;
  int? aulaId;
  int? grupoId;
  int? idPlanEstudio;
  int? idPlanEstudioVersion;
  int? CapacidadVacanteP;
  int? CapacidadVacanteD;
  String? nombreDocente;
  int? personaIdDocente;
  String? fotoDocente;

  CargaCursosSerial(
      {this.cargaCursoId,
        this.planCursoId,
        this.empleadoId,
        this.cargaAcademicaId,
        this.complejo,
        this.evaluable,
        this.idempleado,
        this.idTipoHora,
        this.descripcion,
        this.fechaInicio,
        this.fechafin,
        this.modo,
        this.estado,
        this.anioAcademicoId,
        this.aulaId,
        this.grupoId,
        this.idPlanEstudio,
        this.idPlanEstudioVersion,
        this.CapacidadVacanteP,
        this.CapacidadVacanteD});

  factory CargaCursosSerial.fromJson(Map<String, dynamic> json) => _$CargaCursosSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CargaCursosSerialToJson(this);
}

@JsonSerializable()
class ContratoSerial{

  int? idContrato;
  int? personaId;//Alum_Id
  int? idAnioAcademico;
  int? nroHno;
  int? nivelAcaId;
  int? seccionId;
  int? periodoId;
  int? vigente;
  int? estadoId;
  int? apoderadoId;


  ContratoSerial(
      {  this.idContrato,
        this.personaId,
        this.idAnioAcademico,
        this.nroHno,
        this.nivelAcaId,
        this.seccionId,
        this.periodoId,
        this.vigente,
        this.estadoId,
        this.apoderadoId});

  factory ContratoSerial.fromJson(Map<String, dynamic> json) => _$ContratoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$ContratoSerialToJson(this);
}

@JsonSerializable()
class DetalleContratoAcadSerial{

  int? idContratoDetAcad;
  int? idContrato;
  int? cargaCursoId;
  int? cargaAcademicaId;
  String? notaPromedio;
  String? escala;
  int? anioAcademicoId;
  int? idNivelAcademico;
  int? cursoId;
  int? grupoId;
  int? aulaId;

  DetalleContratoAcadSerial(
      {this.idContratoDetAcad,
        this.idContrato,
        this.cargaCursoId,
        this.cargaAcademicaId,
        this.notaPromedio,
        this.escala,
        this.anioAcademicoId,
        this.idNivelAcademico,
        this.cursoId,
        this.grupoId,
        this.aulaId});

  factory DetalleContratoAcadSerial.fromJson(Map<String, dynamic> json) => _$DetalleContratoAcadSerialFromJson(json);

  Map<String, dynamic> toJson() => _$DetalleContratoAcadSerialToJson(this);

}

@JsonSerializable()
class PlanCursosSerial {

  int? planCursoId;
  int? cursoId;
  int? periodoId;
  int? planEstudiosId;

  PlanCursosSerial(
      {this.planCursoId, this.cursoId, this.periodoId, this.planEstudiosId});

  factory PlanCursosSerial.fromJson(Map<String, dynamic> json) => _$PlanCursosSerialFromJson(json);

  Map<String, dynamic> toJson() => _$PlanCursosSerialToJson(this);
}

@JsonSerializable()
class ProgramasEducativoSerial {

  int? programaEduId;
  String? nombre;
  String? nroCiclos;
  int? nivelAcadId;
  int? tipoEvaluacionId;
  int? estadoId;
  int? entidadId;
  int? tipoInformeSiagieId;
  int? tipoProgramaId;
  int? tipoMatriculaId;

  ProgramasEducativoSerial(
      {this.programaEduId,
        this.nombre,
        this.nroCiclos,
        this.nivelAcadId,
        this.tipoEvaluacionId,
        this.estadoId,
        this.entidadId,
        this.tipoInformeSiagieId,
        this.tipoProgramaId,
        this.tipoMatriculaId});

  factory ProgramasEducativoSerial.fromJson(Map<String, dynamic> json) => _$ProgramasEducativoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramasEducativoSerialToJson(this);
}

@JsonSerializable()
class PlanEstudiosSerial {

  int? planEstudiosId;
  int? programaEduId;
  String? nombrePlan;
  String? alias;
  int? estadoId;
  String? nroResolucion;
  String? fechaResolucion;

  PlanEstudiosSerial({this.planEstudiosId, this.programaEduId, this.nombrePlan,
    this.alias, this.estadoId, this.nroResolucion, this.fechaResolucion});

  factory PlanEstudiosSerial.fromJson(Map<String, dynamic> json) => _$PlanEstudiosSerialFromJson(json);

  Map<String, dynamic> toJson() => _$PlanEstudiosSerialToJson(this);
}

@JsonSerializable()
class CalendarioPeriodoSerial {

  int? calendarioPeriodoId;
  int? fechaInicio;//long
  int? fechaFin;//long
  int? calendarioAcademicoId;
  int? tipoId;
  int? estadoId;
  int? diazPlazo;

  CalendarioPeriodoSerial(
      {this.calendarioPeriodoId,
        this.fechaInicio,
        this.fechaFin,
        this.calendarioAcademicoId,
        this.tipoId,
        this.estadoId,
        this.diazPlazo});

  factory CalendarioPeriodoSerial.fromJson(Map<String, dynamic> json) => _$CalendarioPeriodoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarioPeriodoSerialToJson(this);
}

@JsonSerializable()
class CalendarioAcademicoSerial{

  int? calendarioAcademicoId;
  int? programaEduId;
  int? idAnioAcademico;
  int? estadoId;

  CalendarioAcademicoSerial({this.calendarioAcademicoId, this.programaEduId,
    this.idAnioAcademico, this.estadoId});
  factory CalendarioAcademicoSerial.fromJson(Map<String, dynamic> json) => _$CalendarioAcademicoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarioAcademicoSerialToJson(this);
}

@JsonSerializable()
class TiposSerial {

  int? tipoId;
  String? objeto;
  String? concepto;
  String? nombre;
  String? codigo;
  int? parentId;

  TiposSerial({this.tipoId, this.objeto, this.concepto, this.nombre, this.codigo,
    this.parentId});

  factory TiposSerial.fromJson(Map<String, dynamic> json) => _$TiposSerialFromJson(json);

  Map<String, dynamic> toJson() => _$TiposSerialToJson(this);
}

@JsonSerializable()
class AreasBoletaSerial{

  int? rubroEvalResultadoId;
  String? nombre;
  int? tipoConceptoId;
  int? totalHt;
  int? silaboEventoId;
  String? competencia;
  int? tipoId;//TipoNotaId
  int? tipoFormulaId;
  int? competenciaId;
  int? tipoCompetenciaId;
  int? calendarioPeriodoId;
  int? anioAcademicoId;
  int? programaEducativoId;
  int? periodoId;
  int? seccionId;

  AreasBoletaSerial(
      {this.rubroEvalResultadoId,
        this.nombre,
        this.tipoConceptoId,
        this.totalHt,
        this.silaboEventoId,
        this.competencia,
        this.tipoId,
        this.tipoFormulaId,
        this.competenciaId,
        this.tipoCompetenciaId,
        this.calendarioPeriodoId,
        this.anioAcademicoId,
        this.programaEducativoId,
        this.periodoId,
        this.seccionId});

  factory AreasBoletaSerial.fromJson(Map<String, dynamic> json) => _$AreasBoletaSerialFromJson(json);

  Map<String, dynamic> toJson() => _$AreasBoletaSerialToJson(this);
}

@JsonSerializable()
class NotasCalendarioBoletaSerial{

  int? evaluacionResultadoId;
  int? rubroEvalResultadoId;
  int? alumnoId;
  int? silaboEventoId;
  String? nota;
  double? peso;
  String? valorTipoNotaId;
  String? tituloNota;
  int? tipoNotaId;
  int? calendarioPeriodoId;
  String? color;

  NotasCalendarioBoletaSerial(
      {this.evaluacionResultadoId,
        this.rubroEvalResultadoId,
        this.alumnoId,
        this.silaboEventoId,
        this.nota,
        this.peso,
        this.valorTipoNotaId,
        this.tituloNota,
        this.tipoNotaId,
        this.calendarioPeriodoId,
        this.color});
  factory NotasCalendarioBoletaSerial.fromJson(Map<String, dynamic> json) => _$NotasCalendarioBoletaSerialFromJson(json);

  Map<String, dynamic> toJson() => _$NotasCalendarioBoletaSerialToJson(this);

}
@JsonSerializable()
class ParametrosDisenioSerial{

  int? parametroDisenioId;
  String? objeto;
  String? concepto;
  String? nombre;
  String? path;
  String? color1;
  String? color2;
  String? color3;
  bool?  estado;

  ParametrosDisenioSerial(
      {this.parametroDisenioId,
        this.objeto,
        this.concepto,
        this.nombre,
        this.path,
        this.color1,
        this.color2,
        this.color3,
        this.estado});

  factory ParametrosDisenioSerial.fromJson(Map<String, dynamic> json) => _$ParametrosDisenioSerialFromJson(json);

  Map<String, dynamic> toJson() => _$ParametrosDisenioSerialToJson(this);
}

@JsonSerializable()
class SilaboEventoSerial {

  int? silaboEventoId;
  String? titulo;
  String? descripcionGeneral;
  int? planCursoId;
  int? entidadId;
  int? docenteId;
  int? seccionId;
  String? fechaInicio;
  String? fechaFin;
  int? estadoId;
  int? anioAcademicoId;
  int? georeferenciaId;
  int? silaboBaseId;
  int? cargaCursoId;
  int? parametroDisenioId;

  SilaboEventoSerial(
      {this.silaboEventoId,
        this.titulo,
        this.descripcionGeneral,
        this.planCursoId,
        this.entidadId,
        this.docenteId,
        this.seccionId,
        this.fechaInicio,
        this.fechaFin,
        this.estadoId,
        this.anioAcademicoId,
        this.georeferenciaId,
        this.silaboBaseId,
        this.cargaCursoId,
        this.parametroDisenioId});

  factory SilaboEventoSerial.fromJson(Map<String, dynamic> json) => _$SilaboEventoSerialFromJson(json);

  Map<String, dynamic> toJson() => _$SilaboEventoSerialToJson(this);
}

@JsonSerializable()
class RubroEvalDesempeniosSerial{
  String? nombreCurso;
  int? fechaEvaluacion;//long
  String? tituloEvaluacion;
  String? formaEvaluacion;
  int? tipoRubroEvalId;
  int? cargaCursoId;
  int? silaboEventoId;
  int? anioAcademicoId;
  int? programaAcadId;
  String? rubroEvalProcesoId;
  int? alumnoId;
  int? gradoId;
  String? grado;
  int? seccionId;
  String? seccion;
  int? calendarioPeriodoId;
  int? parametroDesenioId;
  String? iconoNivelLogro;
  String? tituloNivelLogro;
  String? descripcionNivelLogro;
  int? tipoIdNivelLogro;
  double? notaEvalaucion;
  String? desempenioEvalaucion;
  int? desempenioIcdTipoId;
  String? evaluacionProcesoId;


  RubroEvalDesempeniosSerial(
      this.nombreCurso,
      this.fechaEvaluacion,
      this.tituloEvaluacion,
      this.formaEvaluacion,
      this.tipoRubroEvalId,
      this.cargaCursoId,
      this.silaboEventoId,
      this.anioAcademicoId,
      this.programaAcadId,
      this.rubroEvalProcesoId,
      this.alumnoId,
      this.gradoId,
      this.grado,
      this.seccionId,
      this.seccion,
      this.calendarioPeriodoId,
      this.parametroDesenioId,
      this.iconoNivelLogro,
      this.tituloNivelLogro,
      this.descripcionNivelLogro,
      this.tipoIdNivelLogro,
      this.notaEvalaucion,
      this.desempenioEvalaucion,
      this.desempenioIcdTipoId,
      this.evaluacionProcesoId);

  factory RubroEvalDesempeniosSerial.fromJson(Map<String, dynamic> json) => _$RubroEvalDesempeniosSerialFromJson(json);

  Map<String, dynamic> toJson() => _$RubroEvalDesempeniosSerialToJson(this);
}


@JsonSerializable()
class WebConfigsSerial {
  String? nombre;
  String? content;

  WebConfigsSerial(this.nombre, this.content);

  factory WebConfigsSerial.fromJson(Map<String, dynamic> json) => _$WebConfigsSerialFromJson(json);

  Map<String, dynamic> toJson() => _$WebConfigsSerialToJson(this);
}

@JsonSerializable()
class TareaCursoSerializable{
  String? tareaId;
  String? tareaTitulo;
  String? tareaInstrucciones;
  int? tareafechaCreacion;
  String? tareaEstadoId;
  int? unidadAprendizajeId;
  int? sesionAprendizajeId;
  String? tareaFechaEntrega;
  String? tareaHoraEntrega;
  int? gradoId;
  String? grado;
  int? seccionId;
  String? seccion;
  int? fechaEvaluacion; //long
  String? tituloEvaluacion;
  String? formaEvaluacion;
  int? tipoRubroEvalId;
  int? cargaCursoId;
  int? silaboEventoId;
  int? anioAcademicoId;
  int? programaAcadId;
  String? rubroEvalProcesoId;
  int? alumnoId;
  int? calendarioPeriodoId;
  int? parametroDesenioId;
  String? iconoNivelLogro;
  String? tituloNivelLogro;
  String? descripcionNivelLogro;
  int? tipoIdNivelLogro;
  double? notaEvalaucion;
  String? evaluacionProcesoId;
  String? nombreCurso;

  String? docenteApellMat;
  String? docenteApellPat;
  String? docenteNombre;

  TareaCursoSerializable(
      {this.tareaId,
        this.tareaTitulo,
        this.tareaInstrucciones,
        this.tareafechaCreacion,
        this.tareaEstadoId,
        this.unidadAprendizajeId,
        this.sesionAprendizajeId,
        this.tareaFechaEntrega,
        this.tareaHoraEntrega,
        this.gradoId,
        this.grado,
        this.seccionId,
        this.seccion,
        this.fechaEvaluacion,
        this.tituloEvaluacion,
        this.formaEvaluacion,
        this.tipoRubroEvalId,
        this.cargaCursoId,
        this.silaboEventoId,
        this.anioAcademicoId,
        this.programaAcadId,
        this.rubroEvalProcesoId,
        this.alumnoId,
        this.calendarioPeriodoId,
        this.parametroDesenioId,
        this.iconoNivelLogro,
        this.tituloNivelLogro,
        this.descripcionNivelLogro,
        this.tipoIdNivelLogro,
        this.notaEvalaucion,
        this.evaluacionProcesoId,
        this.nombreCurso,
        this.docenteApellMat,
        this.docenteApellPat,
        this.docenteNombre});

  factory TareaCursoSerializable.fromJson(Map<String, dynamic> json) => _$TareaCursoSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$TareaCursoSerializableToJson(this);
}

@JsonSerializable()
class EventoSerializable {
  String? eventoId;
  String? titulo;
  String? descripcion;
  String? calendarioId;
  int? tipoEventoId;
  int? estadoId;
  bool?  estadoPublicacion;
  int? entidadId;
  int? georeferenciaId;
  String? fechaEvento_;
  String? horaEvento;
  String? pathImagen;
  bool?  envioPersonalizado;
  String? tipoEventoNombre;
  int? usuarioReceptorId;
  int? eventoHijoId;
  String? nombreEntidad;
  String? fotoEntidad;
  String? nombreEntidadSiglas;
  EventoSerializable(
      {this.eventoId,
        this.titulo,
        this.descripcion,
        this.calendarioId,
        this.tipoEventoId,
        this.estadoId,
        this.estadoPublicacion,
        this.entidadId,
        this.georeferenciaId,
        this.fechaEvento_,
        this.horaEvento,
        this.pathImagen,
        this.envioPersonalizado,
        this.tipoEventoNombre,
        this.usuarioReceptorId,
        this.eventoHijoId,
        this.nombreEntidad,
        this.fotoEntidad,
        this.nombreEntidadSiglas});

  factory EventoSerializable.fromJson(Map<String, dynamic> json) => _$EventoSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$EventoSerializableToJson(this);

}

@JsonSerializable()
class CalendarioSerializable{
  String? calendarioId;
  String? nombre;
  String? descripcion;
  int? estado;
// int? usuarioId;
  int? entidadId;
  int? georeferenciaId;
//String? fechaAccion;
//String? fechaCrecion;
  String? nUsuario;
  String? cargo;
  int? usuarioId;

  int? cargaAcademicaId;
  int? cargaCursoId;
  int? estadoPublicacion;
  int? rolId;
  int? fechaCreacion;
  int? usuarioAccionId;
  int? fechaAccion;

  CalendarioSerializable(
      {this.calendarioId,
        this.nombre,
        this.descripcion,
        this.estado,
        this.entidadId,
        this.georeferenciaId,
        this.nUsuario,
        this.cargo,
        this.usuarioId,
        this.cargaAcademicaId,
        this.cargaCursoId,
        this.estadoPublicacion,
        this.rolId,
        this.fechaCreacion,
        this.usuarioAccionId,
        this.fechaAccion});

  factory CalendarioSerializable.fromJson(Map<String, dynamic> json) => _$CalendarioSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarioSerializableToJson(this);
}

@JsonSerializable()
class ContactoSerializable {
  int? personaId;
  String? nombres;
  String? apellidoPaterno;
  String? apellidoMaterno;
  String? ocupacion;
  int? estadoId;
  String? telefono;
  String? celular;
  String? fechaNac;
  String? correo;
  String? genero;
  String? estadoCivil;
  String? numDoc;
  String? foto;
  String? nombreTipo;
  int? tipo;
  int? companieroId;
  int? hijoRelacionId;
  String? relacion;
  int? cargaCursoId;

  ContactoSerializable(
      {this.personaId,
        this.nombres,
        this.apellidoPaterno,
        this.apellidoMaterno,
        this.ocupacion,
        this.estadoId,
        this.telefono,
        this.celular,
        this.fechaNac,
        this.correo,
        this.genero,
        this.estadoCivil,
        this.numDoc,
        this.foto,
        this.nombreTipo,
        this.tipo,
        this.companieroId,
        this.hijoRelacionId,
        this.relacion,
        this.cargaCursoId});

  factory ContactoSerializable.fromJson(Map<String, dynamic> json) => _$ContactoSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$ContactoSerializableToJson(this);
}

@JsonSerializable()
class AdminServiceSerializable {
  int? UsuarioId;
  bool?  Estado;
  int? EntidadId;
  int? UsuarioExternoId;
  int? UsuarioCreadorId;
  int? UsuarioAccionId;
  int? Opcion;
  int? Cantidad;
  String? UrlServiceMovil;

  AdminServiceSerializable(
      {this.UsuarioId,
        this.Estado,
        this.EntidadId,
        this.UsuarioExternoId,
        this.UsuarioCreadorId,
        this.UsuarioAccionId,
        this.Opcion,
        this.Cantidad,
        this.UrlServiceMovil});

  factory AdminServiceSerializable.fromJson(Map<String, dynamic> json) => _$AdminServiceSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$AdminServiceSerializableToJson(this);
}

@JsonSerializable()
class EntidadSerializable {

  int? entidadId;
  int? tipoId;
  int? parentId;
  String? nombre;
  String? ruc;
  String? site;
  String? telefono;
  String? correo;
  String? foto;
  int? estadoId;

  EntidadSerializable(
      {this.entidadId,
        this.tipoId,
        this.parentId,
        this.nombre,
        this.ruc,
        this.site,
        this.telefono,
        this.correo,
        this.foto,
        this.estadoId});

  factory EntidadSerializable.fromJson(Map<String, dynamic> json) => _$EntidadSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$EntidadSerializableToJson(this);
}
@JsonSerializable()
class GeoreferenciaSerializable {

  int? georeferenciaId ;
  String? nombre ;
  int? entidadId ;
  String? alias;
  int? estadoId;

  GeoreferenciaSerializable({this.georeferenciaId, this.nombre, this.entidadId, this.alias,
    this.estadoId});

  factory GeoreferenciaSerializable.fromJson(Map<String, dynamic> json) => _$GeoreferenciaSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$GeoreferenciaSerializableToJson(this);
}

@JsonSerializable()
class RolSerializable{
  int? rolId;
  String? nombre;
  int? parentId;
  bool?  estado;

  RolSerializable({this.rolId, this.nombre, this.parentId, this.estado});


  factory RolSerializable.fromJson(Map<String, dynamic> json) => _$RolSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$RolSerializableToJson(this);
}

@JsonSerializable()
class UsuarioRolGeoreferenciaSerializable{
  int? usuarioRolGeoreferenciaId;
  int? usuarioId;
  int? rolId;
  int? geoReferenciaId;
  int? entidadId;


  UsuarioRolGeoreferenciaSerializable({this.usuarioRolGeoreferenciaId,
    this.usuarioId, this.rolId, this.geoReferenciaId, this.entidadId});

  factory UsuarioRolGeoreferenciaSerializable.fromJson(Map<String, dynamic> json) => _$UsuarioRolGeoreferenciaSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioRolGeoreferenciaSerializableToJson(this);
}

@JsonSerializable()
class CursosSerializable {

  int? cursoId;
  String? nombre;
  int? estadoId;
  String? descripcion;
  String? alias;
  int? entidadId;
  int? nivelAcadId;
  int? tipoCursoId;
  int? tipoConceptoId;
  String? color;
  String? creditos;
  String? totalHP;
  String? totalHT;
  String? notaAprobatoria;
  String? sumilla;
  int? superId;
  int? idServicioLaboratorio;
  int? horasLaboratorio;
  bool?  tipoSubcurso;
  String? foto;
  String? codigo;

  CursosSerializable(
      {this.cursoId,
        this.nombre,
        this.estadoId,
        this.descripcion,
        this.alias,
        this.entidadId,
        this.nivelAcadId,
        this.tipoCursoId,
        this.tipoConceptoId,
        this.color,
        this.creditos,
        this.totalHP,
        this.totalHT,
        this.notaAprobatoria,
        this.sumilla,
        this.superId,
        this.idServicioLaboratorio,
        this.horasLaboratorio,
        this.tipoSubcurso,
        this.foto,
        this.codigo});

  factory CursosSerializable.fromJson(Map<String, dynamic> json) => _$CursosSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$CursosSerializableToJson(this);
}

@JsonSerializable()
class SeccionSeraializable {
  int? seccionId;
  String? nombre;
  String? descripcion;
  bool?  estado;
  int? georeferenciaId;

  SeccionSeraializable(this.seccionId, this.nombre, this.descripcion,
      this.estado, this.georeferenciaId);

  factory SeccionSeraializable.fromJson(Map<String, dynamic> json) => _$SeccionSeraializableFromJson(json);

  Map<String, dynamic> toJson() => _$SeccionSeraializableToJson(this);
}

@JsonSerializable()
class AulaSeraializable {
  int? aulaId;
  String? descripcion;
  String? numero;
  String? capacidad;
  int? estado;

  AulaSeraializable(
      this.aulaId, this.descripcion, this.numero, this.capacidad, this.estado);

  factory AulaSeraializable.fromJson(Map<String, dynamic> json) => _$AulaSeraializableFromJson(json);

  Map<String, dynamic> toJson() => _$AulaSeraializableToJson(this);
}

@JsonSerializable()
class PeriodosSeraializable {

  int? periodoId;
  String? nombre;
  int? estadoId;
  String? alias;
  String? fecComienzo;
  String? fecTermino;
  int? tipoId;
  int? superId;
  int? geoReferenciaId;
  int? organigramaId;
  int? entidadId;
  bool?  activo;
  int? cicloId;
  int? docenteId;
  String? gruponombre;
  int? grupoId;
  String? nivelAcademico;
  int? nivelAcademicoId;
  int? tutorId;

  PeriodosSeraializable(
      {this.periodoId,
        this.nombre,
        this.estadoId,
        this.alias,
        this.fecComienzo,
        this.fecTermino,
        this.tipoId,
        this.superId,
        this.geoReferenciaId,
        this.organigramaId,
        this.entidadId,
        this.activo,
        this.cicloId,
        this.docenteId,
        this.gruponombre,
        this.grupoId,
        this.nivelAcademico,
        this.nivelAcademicoId,
        this.tutorId});

  factory PeriodosSeraializable.fromJson(Map<String, dynamic> json) => _$PeriodosSeraializableFromJson(json);

  Map<String, dynamic> toJson() => _$PeriodosSeraializableToJson(this);
}

@JsonSerializable()
class CargaAcademicaSeraializable {
  int? cargaAcademicaId;
  int? estadoId;
  int? idAnioAcademico;
  int? idPeriodoAcad;
  int? aulaId;
  int? idGrupo;
  int? idPlanEstudio;
  int? idPlanEstudioVersion;
  int? capacidadVacante;
  int? capacidadVacanteD;
  int? idEmpleadoTutor;
  int? seccionId;
  int? periodoId;

  CargaAcademicaSeraializable(
      {this.cargaAcademicaId,
        this.estadoId,
        this.idAnioAcademico,
        this.idPeriodoAcad,
        this.aulaId,
        this.idGrupo,
        this.idPlanEstudio,
        this.idPlanEstudioVersion,
        this.capacidadVacante,
        this.capacidadVacanteD,
        this.idEmpleadoTutor,
        this.seccionId,
        this.periodoId});

  factory CargaAcademicaSeraializable.fromJson(Map<String, dynamic> json) => _$CargaAcademicaSeraializableFromJson(json);

  Map<String, dynamic> toJson() => _$CargaAcademicaSeraializableToJson(this);
}
@JsonSerializable()
class NivelAcademicoSeraializable{
  int? nivelAcadId;
  String? nombre;
  bool?  activo;
  int? entidadId;

  NivelAcademicoSeraializable(
      {this.nivelAcadId, this.nombre, this.activo, this.entidadId});

  factory NivelAcademicoSeraializable.fromJson(Map<String, dynamic> json) => _$NivelAcademicoSeraializableFromJson(json);

  Map<String, dynamic> toJson() => _$NivelAcademicoSeraializableToJson(this);
}
@JsonSerializable()
class AsistenciaAlumnosSerializable{
  String? asistenciaSesionId;
  String? fechaAsistenciaN;
  String? hora;
  int? georeferenciaId;
  int? alumnoId;
  int? sesionAprendizajeId;
  int? calendarioPeriodoId;
  int? cargaCursoId;
  String? valorTipoNotaId;
  int? asistenciaSesionIdAndroid;
  int? periodoId;
  int? docenteId;
  int? grupoId;
  String? fechaAsistenciaS;
  String? nombreCurso;
  int? gradoId;
  String? grado;
  int? seccionId;
  String? seccion;
  int? silaboEventoId;
  int? parametroDesenioId;
  String? correoDocente;
  String? celularDocente;
  String? telefonoDocente;
  String? fotoDocente;
  String? nombreDocente;
  int? personaIdDocente;
  int? anioAcademicoId;
  int? programaAcadId;
  AsistenciaAlumnosSerializable(
      {this.asistenciaSesionId,
        this.fechaAsistenciaN,
        this.hora,
        this.georeferenciaId,
        this.alumnoId,
        this.sesionAprendizajeId,
        this.calendarioPeriodoId,
        this.cargaCursoId,
        this.valorTipoNotaId,
        this.asistenciaSesionIdAndroid,
        this.periodoId,
        this.docenteId,
        this.grupoId,
        this.fechaAsistenciaS,
        this.nombreCurso,
        this.gradoId,
        this.grado,
        this.seccionId,
        this.seccion,
        this.silaboEventoId,
        this.parametroDesenioId,
        this.correoDocente,
        this.celularDocente,
        this.telefonoDocente,
        this.fotoDocente,
        this.nombreDocente,
        this.personaIdDocente,
        this.anioAcademicoId,
        this.programaAcadId});

  factory AsistenciaAlumnosSerializable.fromJson(Map<String, dynamic> json) => _$AsistenciaAlumnosSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$AsistenciaAlumnosSerializableToJson(this);
}
@JsonSerializable()
class AsistenciaJustificacionSerializable{
  String? justificacionId;
  String? asistenciaId;
  String? descripcion;
  int? tipoJustificacionId;
  int? tipoIngresoId;
  String? asistenciaSesionId;
  String? asistenciaDocenteId;


  AsistenciaJustificacionSerializable(
      {this.justificacionId,
        this.asistenciaId,
        this.descripcion,
        this.tipoJustificacionId,
        this.tipoIngresoId,
        this.asistenciaSesionId,
        this.asistenciaDocenteId});

  factory AsistenciaJustificacionSerializable.fromJson(Map<String, dynamic> json) => _$AsistenciaJustificacionSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$AsistenciaJustificacionSerializableToJson(this);
}
@JsonSerializable()
class AsistecniaArchivoSerializable{
  String? archivoAsistenciaId;
  String? path;
  String? nombre;
  int? tipoId;
  String? justificacionId;
  String? pathLectura;


  AsistecniaArchivoSerializable({this.archivoAsistenciaId, this.path,
    this.nombre, this.tipoId, this.justificacionId, this.pathLectura});

  factory AsistecniaArchivoSerializable.fromJson(Map<String, dynamic> json) => _$AsistecniaArchivoSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$AsistecniaArchivoSerializableToJson(this);
}
@JsonSerializable()
class AsistenciaTipoNotaSerializable{
  String? tipoNotaId;
  String? nombre;
  int? tipoId;
  String? valorDefecto;
  int? valorMaximo;
  int? valorMinino;
  double? longitudPaso;
  bool?  intervalo;
  bool?  estatico;
  int? entidadId;
  int? georeferenciaId;
  int? organigramaId;
  int? estadoId;
  int? tipoFuenteId;
  int? escalaEvaluacionId;


  AsistenciaTipoNotaSerializable(
      {this.tipoNotaId,
        this.nombre,
        this.tipoId,
        this.valorDefecto,
        this.valorMaximo,
        this.valorMinino,
        this.longitudPaso,
        this.intervalo,
        this.estatico,
        this.entidadId,
        this.georeferenciaId,
        this.organigramaId,
        this.estadoId,
        this.tipoFuenteId,
        this.escalaEvaluacionId});

  factory AsistenciaTipoNotaSerializable.fromJson(Map<String, dynamic> json) => _$AsistenciaTipoNotaSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$AsistenciaTipoNotaSerializableToJson(this);
}

@JsonSerializable()
class AsistenciaValorTipoNotaSerializable{
  String? valorTipoNotaId;
  String? tipoNotaId;
  String? titulo;
  String? alias;
  double? limiteInferior;
  double? limiteSuperior;
  double? valorNumerico;
  String? icono;
  int? estadoId;
  bool?  incluidoLInferior;
  bool?  incluidoLSuperior;
  int? tipoId;


  AsistenciaValorTipoNotaSerializable(
      {this.valorTipoNotaId,
        this.tipoNotaId,
        this.titulo,
        this.alias,
        this.limiteInferior,
        this.limiteSuperior,
        this.valorNumerico,
        this.icono,
        this.estadoId,
        this.incluidoLInferior,
        this.incluidoLSuperior,
        this.tipoId});

  factory AsistenciaValorTipoNotaSerializable.fromJson(Map<String, dynamic> json) => _$AsistenciaValorTipoNotaSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$AsistenciaValorTipoNotaSerializableToJson(this);
}

@JsonSerializable()
class AsistenciaRelProgramaTipoNotaSerializable{
  int? programaEducativoId;
  String? tipoNotaId;
  bool?  estado;


  AsistenciaRelProgramaTipoNotaSerializable(
      {this.programaEducativoId, this.tipoNotaId, this.estado});

  factory AsistenciaRelProgramaTipoNotaSerializable.fromJson(Map<String, dynamic> json) => _$AsistenciaRelProgramaTipoNotaSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$AsistenciaRelProgramaTipoNotaSerializableToJson(this);
}

@JsonSerializable()
class AsistenciaGeneralSerializable{
 
  int? controlAsistenciaId;
  int? alumnoId;
  int? calendarioPeriodoId;
  int? grupoId;
  int? periodoId;
  int? programaEducativoId;
  int? docenteId ;
  int? georeferenciaId;
  String? fechaAsistencia;
  String? horaIngreso;
  String? horaSalida;
  int? estadoIngresoId;
  String? estadosIngresoNombre;
  int? estadoSalidaId;
  String? estadosSalidaNombre;
  String? observaciones;

  AsistenciaGeneralSerializable(
      this.controlAsistenciaId,
      this.alumnoId,
      this.calendarioPeriodoId,
      this.grupoId,
      this.periodoId,
      this.programaEducativoId,
      this.docenteId,
      this.georeferenciaId,
      this.fechaAsistencia,
      this.horaIngreso,
      this.horaSalida,
      this.estadoIngresoId,
      this.estadosIngresoNombre,
      this.estadoSalidaId,
      this.estadosSalidaNombre,
      this.observaciones);

  factory AsistenciaGeneralSerializable.fromJson(Map<String, dynamic> json) => _$AsistenciaGeneralSerializableFromJson(json);

  Map<String, dynamic> toJson() => _$AsistenciaGeneralSerializableToJson(this);
}