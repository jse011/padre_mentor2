// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UsuarioSerial _$UsuarioSerialFromJson(Map<String, dynamic> json) {
  return UsuarioSerial(
    usuarioId: json['usuarioId'] as int,
    personaId: json['personaId'] as int,
    usuario: json['usuario'] as String,
    password: json['password'] as String,
    estado: json['estado'] as bool,
    habilitarAcceso: json['habilitarAcceso'] as bool,
  );
}

Map<String, dynamic> _$UsuarioSerialToJson(UsuarioSerial instance) =>
    <String, dynamic>{
      'usuarioId': instance.usuarioId,
      'personaId': instance.personaId,
      'usuario': instance.usuario,
      'password': instance.password,
      'estado': instance.estado,
      'habilitarAcceso': instance.habilitarAcceso,
    };

PersonaSerial _$PersonaSerialFromJson(Map<String, dynamic> json) {
  return PersonaSerial(
    personaId: json['personaId'] as int,
    nombres: json['nombres'] as String,
    apellidoPaterno: json['apellidoPaterno'] as String,
    apellidoMaterno: json['apellidoMaterno'] as String,
    celular: json['celular'] as String,
    telefono: json['telefono'] as String,
    foto: json['foto'] as String,
    fechaNac: json['fechaNac'] as String,
    genero: json['genero'] as String,
    estadoCivil: json['estadoCivil'] as String,
    numDoc: json['numDoc'] as String,
    ocupacion: json['ocupacion'] as String,
    estadoId: json['estadoId'] as int,
    correo: json['correo'] as String,
    direccion: json['direccion'] as String,
    path: json['path'] as String,
    image64: json['image64'] as String,
  );
}

Map<String, dynamic> _$PersonaSerialToJson(PersonaSerial instance) =>
    <String, dynamic>{
      'personaId': instance.personaId,
      'nombres': instance.nombres,
      'apellidoPaterno': instance.apellidoPaterno,
      'apellidoMaterno': instance.apellidoMaterno,
      'celular': instance.celular,
      'telefono': instance.telefono,
      'foto': instance.foto,
      'fechaNac': instance.fechaNac,
      'genero': instance.genero,
      'estadoCivil': instance.estadoCivil,
      'numDoc': instance.numDoc,
      'ocupacion': instance.ocupacion,
      'estadoId': instance.estadoId,
      'correo': instance.correo,
      'direccion': instance.direccion,
      'path': instance.path,
      'image64': instance.image64,
    };

RelacionesSerial _$RelacionesSerialFromJson(Map<String, dynamic> json) {
  return RelacionesSerial(
    idRelacion: json['idRelacion'] as int,
    personaPrincipalId: json['personaPrincipalId'] as int,
    personaVinculadaId: json['personaVinculadaId'] as int,
    tipoId: json['tipoId'] as int,
    activo: json['activo'] as bool,
  );
}

Map<String, dynamic> _$RelacionesSerialToJson(RelacionesSerial instance) =>
    <String, dynamic>{
      'idRelacion': instance.idRelacion,
      'personaPrincipalId': instance.personaPrincipalId,
      'personaVinculadaId': instance.personaVinculadaId,
      'tipoId': instance.tipoId,
      'activo': instance.activo,
    };

AnioAcademicoAlumnoSerial _$AnioAcademicoAlumnoSerialFromJson(
    Map<String, dynamic> json) {
  return AnioAcademicoAlumnoSerial(
    idAnioAcademico: json['idAnioAcademico'] as int,
    nombre: json['nombre'] as String,
    fechaInicio: json['fechaInicio'] as String,
    fechaFin: json['fechaFin'] as String,
    denominacion: json['denominacion'] as String,
    georeferenciaId: json['georeferenciaId'] as int,
    organigramaId: json['organigramaId'] as int,
    estadoId: json['estadoId'] as int,
    tipoId: json['tipoId'] as int,
    personaId: json['personaId'] as int,
  );
}

Map<String, dynamic> _$AnioAcademicoAlumnoSerialToJson(
        AnioAcademicoAlumnoSerial instance) =>
    <String, dynamic>{
      'idAnioAcademico': instance.idAnioAcademico,
      'nombre': instance.nombre,
      'fechaInicio': instance.fechaInicio,
      'fechaFin': instance.fechaFin,
      'denominacion': instance.denominacion,
      'georeferenciaId': instance.georeferenciaId,
      'organigramaId': instance.organigramaId,
      'estadoId': instance.estadoId,
      'tipoId': instance.tipoId,
      'personaId': instance.personaId,
    };

CargaCursosSerial _$CargaCursosSerialFromJson(Map<String, dynamic> json) {
  return CargaCursosSerial(
    cargaCursoId: json['cargaCursoId'] as int,
    planCursoId: json['planCursoId'] as int,
    empleadoId: json['empleadoId'] as int,
    cargaAcademicaId: json['cargaAcademicaId'] as int,
    complejo: json['complejo'] as int,
    evaluable: json['evaluable'] as int,
    idempleado: json['idempleado'] as int,
    idTipoHora: json['idTipoHora'] as int,
    descripcion: json['descripcion'] as String,
    fechaInicio: json['fechaInicio'] as int,
    fechafin: json['fechafin'] as int,
    modo: json['modo'] as String,
    estado: json['estado'] as int,
    anioAcademicoId: json['anioAcademicoId'] as int,
    aulaId: json['aulaId'] as int,
    grupoId: json['grupoId'] as int,
    idPlanEstudio: json['idPlanEstudio'] as int,
    idPlanEstudioVersion: json['idPlanEstudioVersion'] as int,
    CapacidadVacanteP: json['CapacidadVacanteP'] as int,
    CapacidadVacanteD: json['CapacidadVacanteD'] as int,
  )
    ..nombreDocente = json['nombreDocente'] as String
    ..personaIdDocente = json['personaIdDocente'] as int
    ..fotoDocente = json['fotoDocente'] as String;
}

Map<String, dynamic> _$CargaCursosSerialToJson(CargaCursosSerial instance) =>
    <String, dynamic>{
      'cargaCursoId': instance.cargaCursoId,
      'planCursoId': instance.planCursoId,
      'empleadoId': instance.empleadoId,
      'cargaAcademicaId': instance.cargaAcademicaId,
      'complejo': instance.complejo,
      'evaluable': instance.evaluable,
      'idempleado': instance.idempleado,
      'idTipoHora': instance.idTipoHora,
      'descripcion': instance.descripcion,
      'fechaInicio': instance.fechaInicio,
      'fechafin': instance.fechafin,
      'modo': instance.modo,
      'estado': instance.estado,
      'anioAcademicoId': instance.anioAcademicoId,
      'aulaId': instance.aulaId,
      'grupoId': instance.grupoId,
      'idPlanEstudio': instance.idPlanEstudio,
      'idPlanEstudioVersion': instance.idPlanEstudioVersion,
      'CapacidadVacanteP': instance.CapacidadVacanteP,
      'CapacidadVacanteD': instance.CapacidadVacanteD,
      'nombreDocente': instance.nombreDocente,
      'personaIdDocente': instance.personaIdDocente,
      'fotoDocente': instance.fotoDocente,
    };

ContratoSerial _$ContratoSerialFromJson(Map<String, dynamic> json) {
  return ContratoSerial(
    idContrato: json['idContrato'] as int,
    personaId: json['personaId'] as int,
    idAnioAcademico: json['idAnioAcademico'] as int,
    nroHno: json['nroHno'] as int,
    nivelAcaId: json['nivelAcaId'] as int,
    seccionId: json['seccionId'] as int,
    periodoId: json['periodoId'] as int,
    vigente: json['vigente'] as int,
    estadoId: json['estadoId'] as int,
    apoderadoId: json['apoderadoId'] as int,
  );
}

Map<String, dynamic> _$ContratoSerialToJson(ContratoSerial instance) =>
    <String, dynamic>{
      'idContrato': instance.idContrato,
      'personaId': instance.personaId,
      'idAnioAcademico': instance.idAnioAcademico,
      'nroHno': instance.nroHno,
      'nivelAcaId': instance.nivelAcaId,
      'seccionId': instance.seccionId,
      'periodoId': instance.periodoId,
      'vigente': instance.vigente,
      'estadoId': instance.estadoId,
      'apoderadoId': instance.apoderadoId,
    };

DetalleContratoAcadSerial _$DetalleContratoAcadSerialFromJson(
    Map<String, dynamic> json) {
  return DetalleContratoAcadSerial(
    idContratoDetAcad: json['idContratoDetAcad'] as int,
    idContrato: json['idContrato'] as int,
    cargaCursoId: json['cargaCursoId'] as int,
    cargaAcademicaId: json['cargaAcademicaId'] as int,
    notaPromedio: json['notaPromedio'] as String,
    escala: json['escala'] as String,
    anioAcademicoId: json['anioAcademicoId'] as int,
    idNivelAcademico: json['idNivelAcademico'] as int,
    cursoId: json['cursoId'] as int,
    grupoId: json['grupoId'] as int,
    aulaId: json['aulaId'] as int,
  );
}

Map<String, dynamic> _$DetalleContratoAcadSerialToJson(
        DetalleContratoAcadSerial instance) =>
    <String, dynamic>{
      'idContratoDetAcad': instance.idContratoDetAcad,
      'idContrato': instance.idContrato,
      'cargaCursoId': instance.cargaCursoId,
      'cargaAcademicaId': instance.cargaAcademicaId,
      'notaPromedio': instance.notaPromedio,
      'escala': instance.escala,
      'anioAcademicoId': instance.anioAcademicoId,
      'idNivelAcademico': instance.idNivelAcademico,
      'cursoId': instance.cursoId,
      'grupoId': instance.grupoId,
      'aulaId': instance.aulaId,
    };

PlanCursosSerial _$PlanCursosSerialFromJson(Map<String, dynamic> json) {
  return PlanCursosSerial(
    planCursoId: json['planCursoId'] as int,
    cursoId: json['cursoId'] as int,
    periodoId: json['periodoId'] as int,
    planEstudiosId: json['planEstudiosId'] as int,
  );
}

Map<String, dynamic> _$PlanCursosSerialToJson(PlanCursosSerial instance) =>
    <String, dynamic>{
      'planCursoId': instance.planCursoId,
      'cursoId': instance.cursoId,
      'periodoId': instance.periodoId,
      'planEstudiosId': instance.planEstudiosId,
    };

ProgramasEducativoSerial _$ProgramasEducativoSerialFromJson(
    Map<String, dynamic> json) {
  return ProgramasEducativoSerial(
    programaEduId: json['programaEduId'] as int,
    nombre: json['nombre'] as String,
    nroCiclos: json['nroCiclos'] as String,
    nivelAcadId: json['nivelAcadId'] as int,
    tipoEvaluacionId: json['tipoEvaluacionId'] as int,
    estadoId: json['estadoId'] as int,
    entidadId: json['entidadId'] as int,
    tipoInformeSiagieId: json['tipoInformeSiagieId'] as int,
    tipoProgramaId: json['tipoProgramaId'] as int,
    tipoMatriculaId: json['tipoMatriculaId'] as int,
  );
}

Map<String, dynamic> _$ProgramasEducativoSerialToJson(
        ProgramasEducativoSerial instance) =>
    <String, dynamic>{
      'programaEduId': instance.programaEduId,
      'nombre': instance.nombre,
      'nroCiclos': instance.nroCiclos,
      'nivelAcadId': instance.nivelAcadId,
      'tipoEvaluacionId': instance.tipoEvaluacionId,
      'estadoId': instance.estadoId,
      'entidadId': instance.entidadId,
      'tipoInformeSiagieId': instance.tipoInformeSiagieId,
      'tipoProgramaId': instance.tipoProgramaId,
      'tipoMatriculaId': instance.tipoMatriculaId,
    };

PlanEstudiosSerial _$PlanEstudiosSerialFromJson(Map<String, dynamic> json) {
  return PlanEstudiosSerial(
    planEstudiosId: json['planEstudiosId'] as int,
    programaEduId: json['programaEduId'] as int,
    nombrePlan: json['nombrePlan'] as String,
    alias: json['alias'] as String,
    estadoId: json['estadoId'] as int,
    nroResolucion: json['nroResolucion'] as String,
    fechaResolucion: json['fechaResolucion'] as String,
  );
}

Map<String, dynamic> _$PlanEstudiosSerialToJson(PlanEstudiosSerial instance) =>
    <String, dynamic>{
      'planEstudiosId': instance.planEstudiosId,
      'programaEduId': instance.programaEduId,
      'nombrePlan': instance.nombrePlan,
      'alias': instance.alias,
      'estadoId': instance.estadoId,
      'nroResolucion': instance.nroResolucion,
      'fechaResolucion': instance.fechaResolucion,
    };

CalendarioPeriodoSerial _$CalendarioPeriodoSerialFromJson(
    Map<String, dynamic> json) {
  return CalendarioPeriodoSerial(
    calendarioPeriodoId: json['calendarioPeriodoId'] as int,
    fechaInicio: json['fechaInicio'] as int,
    fechaFin: json['fechaFin'] as int,
    calendarioAcademicoId: json['calendarioAcademicoId'] as int,
    tipoId: json['tipoId'] as int,
    estadoId: json['estadoId'] as int,
    diazPlazo: json['diazPlazo'] as int,
  );
}

Map<String, dynamic> _$CalendarioPeriodoSerialToJson(
        CalendarioPeriodoSerial instance) =>
    <String, dynamic>{
      'calendarioPeriodoId': instance.calendarioPeriodoId,
      'fechaInicio': instance.fechaInicio,
      'fechaFin': instance.fechaFin,
      'calendarioAcademicoId': instance.calendarioAcademicoId,
      'tipoId': instance.tipoId,
      'estadoId': instance.estadoId,
      'diazPlazo': instance.diazPlazo,
    };

CalendarioAcademicoSerial _$CalendarioAcademicoSerialFromJson(
    Map<String, dynamic> json) {
  return CalendarioAcademicoSerial(
    calendarioAcademicoId: json['calendarioAcademicoId'] as int,
    programaEduId: json['programaEduId'] as int,
    idAnioAcademico: json['idAnioAcademico'] as int,
    estadoId: json['estadoId'] as int,
  );
}

Map<String, dynamic> _$CalendarioAcademicoSerialToJson(
        CalendarioAcademicoSerial instance) =>
    <String, dynamic>{
      'calendarioAcademicoId': instance.calendarioAcademicoId,
      'programaEduId': instance.programaEduId,
      'idAnioAcademico': instance.idAnioAcademico,
      'estadoId': instance.estadoId,
    };

TiposSerial _$TiposSerialFromJson(Map<String, dynamic> json) {
  return TiposSerial(
    tipoId: json['tipoId'] as int,
    objeto: json['objeto'] as String,
    concepto: json['concepto'] as String,
    nombre: json['nombre'] as String,
    codigo: json['codigo'] as String,
    parentId: json['parentId'] as int,
  );
}

Map<String, dynamic> _$TiposSerialToJson(TiposSerial instance) =>
    <String, dynamic>{
      'tipoId': instance.tipoId,
      'objeto': instance.objeto,
      'concepto': instance.concepto,
      'nombre': instance.nombre,
      'codigo': instance.codigo,
      'parentId': instance.parentId,
    };

AreasBoletaSerial _$AreasBoletaSerialFromJson(Map<String, dynamic> json) {
  return AreasBoletaSerial(
    rubroEvalResultadoId: json['rubroEvalResultadoId'] as int,
    nombre: json['nombre'] as String,
    tipoConceptoId: json['tipoConceptoId'] as int,
    totalHt: json['totalHt'] as int,
    silaboEventoId: json['silaboEventoId'] as int,
    competencia: json['competencia'] as String,
    tipoId: json['tipoId'] as int,
    tipoFormulaId: json['tipoFormulaId'] as int,
    competenciaId: json['competenciaId'] as int,
    tipoCompetenciaId: json['tipoCompetenciaId'] as int,
    calendarioPeriodoId: json['calendarioPeriodoId'] as int,
    anioAcademicoId: json['anioAcademicoId'] as int,
    programaEducativoId: json['programaEducativoId'] as int,
    periodoId: json['periodoId'] as int,
    seccionId: json['seccionId'] as int,
  );
}

Map<String, dynamic> _$AreasBoletaSerialToJson(AreasBoletaSerial instance) =>
    <String, dynamic>{
      'rubroEvalResultadoId': instance.rubroEvalResultadoId,
      'nombre': instance.nombre,
      'tipoConceptoId': instance.tipoConceptoId,
      'totalHt': instance.totalHt,
      'silaboEventoId': instance.silaboEventoId,
      'competencia': instance.competencia,
      'tipoId': instance.tipoId,
      'tipoFormulaId': instance.tipoFormulaId,
      'competenciaId': instance.competenciaId,
      'tipoCompetenciaId': instance.tipoCompetenciaId,
      'calendarioPeriodoId': instance.calendarioPeriodoId,
      'anioAcademicoId': instance.anioAcademicoId,
      'programaEducativoId': instance.programaEducativoId,
      'periodoId': instance.periodoId,
      'seccionId': instance.seccionId,
    };

NotasCalendarioBoletaSerial _$NotasCalendarioBoletaSerialFromJson(
    Map<String, dynamic> json) {
  return NotasCalendarioBoletaSerial(
    evaluacionResultadoId: json['evaluacionResultadoId'] as int,
    rubroEvalResultadoId: json['rubroEvalResultadoId'] as int,
    alumnoId: json['alumnoId'] as int,
    silaboEventoId: json['silaboEventoId'] as int,
    nota: json['nota'] as String,
    peso: (json['peso'] as num)?.toDouble(),
    valorTipoNotaId: json['valorTipoNotaId'] as String,
    tituloNota: json['tituloNota'] as String,
    tipoNotaId: json['tipoNotaId'] as int,
    calendarioPeriodoId: json['calendarioPeriodoId'] as int,
    color: json['color'] as String,
  );
}

Map<String, dynamic> _$NotasCalendarioBoletaSerialToJson(
        NotasCalendarioBoletaSerial instance) =>
    <String, dynamic>{
      'evaluacionResultadoId': instance.evaluacionResultadoId,
      'rubroEvalResultadoId': instance.rubroEvalResultadoId,
      'alumnoId': instance.alumnoId,
      'silaboEventoId': instance.silaboEventoId,
      'nota': instance.nota,
      'peso': instance.peso,
      'valorTipoNotaId': instance.valorTipoNotaId,
      'tituloNota': instance.tituloNota,
      'tipoNotaId': instance.tipoNotaId,
      'calendarioPeriodoId': instance.calendarioPeriodoId,
      'color': instance.color,
    };

ParametrosDisenioSerial _$ParametrosDisenioSerialFromJson(
    Map<String, dynamic> json) {
  return ParametrosDisenioSerial(
    parametroDisenioId: json['parametroDisenioId'] as int,
    objeto: json['objeto'] as String,
    concepto: json['concepto'] as String,
    nombre: json['nombre'] as String,
    path: json['path'] as String,
    color1: json['color1'] as String,
    color2: json['color2'] as String,
    color3: json['color3'] as String,
    estado: json['estado'] as bool,
  );
}

Map<String, dynamic> _$ParametrosDisenioSerialToJson(
        ParametrosDisenioSerial instance) =>
    <String, dynamic>{
      'parametroDisenioId': instance.parametroDisenioId,
      'objeto': instance.objeto,
      'concepto': instance.concepto,
      'nombre': instance.nombre,
      'path': instance.path,
      'color1': instance.color1,
      'color2': instance.color2,
      'color3': instance.color3,
      'estado': instance.estado,
    };

SilaboEventoSerial _$SilaboEventoSerialFromJson(Map<String, dynamic> json) {
  return SilaboEventoSerial(
    silaboEventoId: json['silaboEventoId'] as int,
    titulo: json['titulo'] as String,
    descripcionGeneral: json['descripcionGeneral'] as String,
    planCursoId: json['planCursoId'] as int,
    entidadId: json['entidadId'] as int,
    docenteId: json['docenteId'] as int,
    seccionId: json['seccionId'] as int,
    fechaInicio: json['fechaInicio'] as String,
    fechaFin: json['fechaFin'] as String,
    estadoId: json['estadoId'] as int,
    anioAcademicoId: json['anioAcademicoId'] as int,
    georeferenciaId: json['georeferenciaId'] as int,
    silaboBaseId: json['silaboBaseId'] as int,
    cargaCursoId: json['cargaCursoId'] as int,
    parametroDisenioId: json['parametroDisenioId'] as int,
  );
}

Map<String, dynamic> _$SilaboEventoSerialToJson(SilaboEventoSerial instance) =>
    <String, dynamic>{
      'silaboEventoId': instance.silaboEventoId,
      'titulo': instance.titulo,
      'descripcionGeneral': instance.descripcionGeneral,
      'planCursoId': instance.planCursoId,
      'entidadId': instance.entidadId,
      'docenteId': instance.docenteId,
      'seccionId': instance.seccionId,
      'fechaInicio': instance.fechaInicio,
      'fechaFin': instance.fechaFin,
      'estadoId': instance.estadoId,
      'anioAcademicoId': instance.anioAcademicoId,
      'georeferenciaId': instance.georeferenciaId,
      'silaboBaseId': instance.silaboBaseId,
      'cargaCursoId': instance.cargaCursoId,
      'parametroDisenioId': instance.parametroDisenioId,
    };

RubroEvalDesempeniosSerial _$RubroEvalDesempeniosSerialFromJson(
    Map<String, dynamic> json) {
  return RubroEvalDesempeniosSerial(
    json['nombreCurso'] as String,
    json['fechaEvaluacion'] as int,
    json['tituloEvaluacion'] as String,
    json['formaEvaluacion'] as String,
    json['tipoRubroEvalId'] as int,
    json['cargaCursoId'] as int,
    json['silaboEventoId'] as int,
    json['anioAcademicoId'] as int,
    json['programaAcadId'] as int,
    json['rubroEvalProcesoId'] as String,
    json['alumnoId'] as int,
    json['gradoId'] as int,
    json['grado'] as String,
    json['seccionId'] as int,
    json['seccion'] as String,
    json['calendarioPeriodoId'] as int,
    json['parametroDesenioId'] as int,
    json['iconoNivelLogro'] as String,
    json['tituloNivelLogro'] as String,
    json['descripcionNivelLogro'] as String,
    json['tipoIdNivelLogro'] as int,
    (json['notaEvalaucion'] as num)?.toDouble(),
    json['desempenioEvalaucion'] as String,
    json['desempenioIcdTipoId'] as int,
    json['evaluacionProcesoId'] as String,
  );
}

Map<String, dynamic> _$RubroEvalDesempeniosSerialToJson(
        RubroEvalDesempeniosSerial instance) =>
    <String, dynamic>{
      'nombreCurso': instance.nombreCurso,
      'fechaEvaluacion': instance.fechaEvaluacion,
      'tituloEvaluacion': instance.tituloEvaluacion,
      'formaEvaluacion': instance.formaEvaluacion,
      'tipoRubroEvalId': instance.tipoRubroEvalId,
      'cargaCursoId': instance.cargaCursoId,
      'silaboEventoId': instance.silaboEventoId,
      'anioAcademicoId': instance.anioAcademicoId,
      'programaAcadId': instance.programaAcadId,
      'rubroEvalProcesoId': instance.rubroEvalProcesoId,
      'alumnoId': instance.alumnoId,
      'gradoId': instance.gradoId,
      'grado': instance.grado,
      'seccionId': instance.seccionId,
      'seccion': instance.seccion,
      'calendarioPeriodoId': instance.calendarioPeriodoId,
      'parametroDesenioId': instance.parametroDesenioId,
      'iconoNivelLogro': instance.iconoNivelLogro,
      'tituloNivelLogro': instance.tituloNivelLogro,
      'descripcionNivelLogro': instance.descripcionNivelLogro,
      'tipoIdNivelLogro': instance.tipoIdNivelLogro,
      'notaEvalaucion': instance.notaEvalaucion,
      'desempenioEvalaucion': instance.desempenioEvalaucion,
      'desempenioIcdTipoId': instance.desempenioIcdTipoId,
      'evaluacionProcesoId': instance.evaluacionProcesoId,
    };

WebConfigsSerial _$WebConfigsSerialFromJson(Map<String, dynamic> json) {
  return WebConfigsSerial(
    json['nombre'] as String,
    json['content'] as String,
  );
}

Map<String, dynamic> _$WebConfigsSerialToJson(WebConfigsSerial instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'content': instance.content,
    };

TareaCursoSerializable _$TareaCursoSerializableFromJson(
    Map<String, dynamic> json) {
  return TareaCursoSerializable(
    tareaId: json['tareaId'] as String,
    tareaTitulo: json['tareaTitulo'] as String,
    tareaInstrucciones: json['tareaInstrucciones'] as String,
    tareafechaCreacion: json['tareafechaCreacion'] as int,
    tareaEstadoId: json['tareaEstadoId'] as String,
    unidadAprendizajeId: json['unidadAprendizajeId'] as int,
    sesionAprendizajeId: json['sesionAprendizajeId'] as int,
    tareaFechaEntrega: json['tareaFechaEntrega'] as String,
    tareaHoraEntrega: json['tareaHoraEntrega'] as String,
    gradoId: json['gradoId'] as int,
    grado: json['grado'] as String,
    seccionId: json['seccionId'] as int,
    seccion: json['seccion'] as String,
    fechaEvaluacion: json['fechaEvaluacion'] as int,
    tituloEvaluacion: json['tituloEvaluacion'] as String,
    formaEvaluacion: json['formaEvaluacion'] as String,
    tipoRubroEvalId: json['tipoRubroEvalId'] as int,
    cargaCursoId: json['cargaCursoId'] as int,
    silaboEventoId: json['silaboEventoId'] as int,
    anioAcademicoId: json['anioAcademicoId'] as int,
    programaAcadId: json['programaAcadId'] as int,
    rubroEvalProcesoId: json['rubroEvalProcesoId'] as String,
    alumnoId: json['alumnoId'] as int,
    calendarioPeriodoId: json['calendarioPeriodoId'] as int,
    parametroDesenioId: json['parametroDesenioId'] as int,
    iconoNivelLogro: json['iconoNivelLogro'] as String,
    tituloNivelLogro: json['tituloNivelLogro'] as String,
    descripcionNivelLogro: json['descripcionNivelLogro'] as String,
    tipoIdNivelLogro: json['tipoIdNivelLogro'] as int,
    notaEvalaucion: (json['notaEvalaucion'] as num)?.toDouble(),
    evaluacionProcesoId: json['evaluacionProcesoId'] as String,
    nombreCurso: json['nombreCurso'] as String,
    docenteApellMat: json['docenteApellMat'] as String,
    docenteApellPat: json['docenteApellPat'] as String,
    docenteNombre: json['docenteNombre'] as String,
  );
}

Map<String, dynamic> _$TareaCursoSerializableToJson(
        TareaCursoSerializable instance) =>
    <String, dynamic>{
      'tareaId': instance.tareaId,
      'tareaTitulo': instance.tareaTitulo,
      'tareaInstrucciones': instance.tareaInstrucciones,
      'tareafechaCreacion': instance.tareafechaCreacion,
      'tareaEstadoId': instance.tareaEstadoId,
      'unidadAprendizajeId': instance.unidadAprendizajeId,
      'sesionAprendizajeId': instance.sesionAprendizajeId,
      'tareaFechaEntrega': instance.tareaFechaEntrega,
      'tareaHoraEntrega': instance.tareaHoraEntrega,
      'gradoId': instance.gradoId,
      'grado': instance.grado,
      'seccionId': instance.seccionId,
      'seccion': instance.seccion,
      'fechaEvaluacion': instance.fechaEvaluacion,
      'tituloEvaluacion': instance.tituloEvaluacion,
      'formaEvaluacion': instance.formaEvaluacion,
      'tipoRubroEvalId': instance.tipoRubroEvalId,
      'cargaCursoId': instance.cargaCursoId,
      'silaboEventoId': instance.silaboEventoId,
      'anioAcademicoId': instance.anioAcademicoId,
      'programaAcadId': instance.programaAcadId,
      'rubroEvalProcesoId': instance.rubroEvalProcesoId,
      'alumnoId': instance.alumnoId,
      'calendarioPeriodoId': instance.calendarioPeriodoId,
      'parametroDesenioId': instance.parametroDesenioId,
      'iconoNivelLogro': instance.iconoNivelLogro,
      'tituloNivelLogro': instance.tituloNivelLogro,
      'descripcionNivelLogro': instance.descripcionNivelLogro,
      'tipoIdNivelLogro': instance.tipoIdNivelLogro,
      'notaEvalaucion': instance.notaEvalaucion,
      'evaluacionProcesoId': instance.evaluacionProcesoId,
      'nombreCurso': instance.nombreCurso,
      'docenteApellMat': instance.docenteApellMat,
      'docenteApellPat': instance.docenteApellPat,
      'docenteNombre': instance.docenteNombre,
    };

EventoSerializable _$EventoSerializableFromJson(Map<String, dynamic> json) {
  return EventoSerializable(
    eventoId: json['eventoId'] as String,
    titulo: json['titulo'] as String,
    descripcion: json['descripcion'] as String,
    calendarioId: json['calendarioId'] as String,
    tipoEventoId: json['tipoEventoId'] as int,
    estadoId: json['estadoId'] as int,
    estadoPublicacion: json['estadoPublicacion'] as bool,
    entidadId: json['entidadId'] as int,
    georeferenciaId: json['georeferenciaId'] as int,
    fechaEvento_: json['fechaEvento_'] as String,
    horaEvento: json['horaEvento'] as String,
    pathImagen: json['pathImagen'] as String,
    envioPersonalizado: json['envioPersonalizado'] as bool,
    tipoEventoNombre: json['tipoEventoNombre'] as String,
    usuarioReceptorId: json['usuarioReceptorId'] as int,
    eventoHijoId: json['eventoHijoId'] as int,
    nombreEntidad: json['nombreEntidad'] as String,
    fotoEntidad: json['fotoEntidad'] as String,
    nombreEntidadSiglas: json['nombreEntidadSiglas'] as String,
  );
}

Map<String, dynamic> _$EventoSerializableToJson(EventoSerializable instance) =>
    <String, dynamic>{
      'eventoId': instance.eventoId,
      'titulo': instance.titulo,
      'descripcion': instance.descripcion,
      'calendarioId': instance.calendarioId,
      'tipoEventoId': instance.tipoEventoId,
      'estadoId': instance.estadoId,
      'estadoPublicacion': instance.estadoPublicacion,
      'entidadId': instance.entidadId,
      'georeferenciaId': instance.georeferenciaId,
      'fechaEvento_': instance.fechaEvento_,
      'horaEvento': instance.horaEvento,
      'pathImagen': instance.pathImagen,
      'envioPersonalizado': instance.envioPersonalizado,
      'tipoEventoNombre': instance.tipoEventoNombre,
      'usuarioReceptorId': instance.usuarioReceptorId,
      'eventoHijoId': instance.eventoHijoId,
      'nombreEntidad': instance.nombreEntidad,
      'fotoEntidad': instance.fotoEntidad,
      'nombreEntidadSiglas': instance.nombreEntidadSiglas,
    };

CalendarioSerializable _$CalendarioSerializableFromJson(
    Map<String, dynamic> json) {
  return CalendarioSerializable(
    calendarioId: json['calendarioId'] as String,
    nombre: json['nombre'] as String,
    descripcion: json['descripcion'] as String,
    estado: json['estado'] as int,
    entidadId: json['entidadId'] as int,
    georeferenciaId: json['georeferenciaId'] as int,
    nUsuario: json['nUsuario'] as String,
    cargo: json['cargo'] as String,
    usuarioId: json['usuarioId'] as int,
    cargaAcademicaId: json['cargaAcademicaId'] as int,
    cargaCursoId: json['cargaCursoId'] as int,
    estadoPublicacion: json['estadoPublicacion'] as int,
    rolId: json['rolId'] as int,
    fechaCreacion: json['fechaCreacion'] as int,
    usuarioAccionId: json['usuarioAccionId'] as int,
    fechaAccion: json['fechaAccion'] as int,
  );
}

Map<String, dynamic> _$CalendarioSerializableToJson(
        CalendarioSerializable instance) =>
    <String, dynamic>{
      'calendarioId': instance.calendarioId,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'estado': instance.estado,
      'entidadId': instance.entidadId,
      'georeferenciaId': instance.georeferenciaId,
      'nUsuario': instance.nUsuario,
      'cargo': instance.cargo,
      'usuarioId': instance.usuarioId,
      'cargaAcademicaId': instance.cargaAcademicaId,
      'cargaCursoId': instance.cargaCursoId,
      'estadoPublicacion': instance.estadoPublicacion,
      'rolId': instance.rolId,
      'fechaCreacion': instance.fechaCreacion,
      'usuarioAccionId': instance.usuarioAccionId,
      'fechaAccion': instance.fechaAccion,
    };

ContactoSerializable _$ContactoSerializableFromJson(Map<String, dynamic> json) {
  return ContactoSerializable(
    personaId: json['personaId'] as int,
    nombres: json['nombres'] as String,
    apellidoPaterno: json['apellidoPaterno'] as String,
    apellidoMaterno: json['apellidoMaterno'] as String,
    ocupacion: json['ocupacion'] as String,
    estadoId: json['estadoId'] as int,
    telefono: json['telefono'] as String,
    celular: json['celular'] as String,
    fechaNac: json['fechaNac'] as String,
    correo: json['correo'] as String,
    genero: json['genero'] as String,
    estadoCivil: json['estadoCivil'] as String,
    numDoc: json['numDoc'] as String,
    foto: json['foto'] as String,
    nombreTipo: json['nombreTipo'] as String,
    tipo: json['tipo'] as int,
    companieroId: json['companieroId'] as int,
    hijoRelacionId: json['hijoRelacionId'] as int,
    relacion: json['relacion'] as String,
    cargaCursoId: json['cargaCursoId'] as int,
  );
}

Map<String, dynamic> _$ContactoSerializableToJson(
        ContactoSerializable instance) =>
    <String, dynamic>{
      'personaId': instance.personaId,
      'nombres': instance.nombres,
      'apellidoPaterno': instance.apellidoPaterno,
      'apellidoMaterno': instance.apellidoMaterno,
      'ocupacion': instance.ocupacion,
      'estadoId': instance.estadoId,
      'telefono': instance.telefono,
      'celular': instance.celular,
      'fechaNac': instance.fechaNac,
      'correo': instance.correo,
      'genero': instance.genero,
      'estadoCivil': instance.estadoCivil,
      'numDoc': instance.numDoc,
      'foto': instance.foto,
      'nombreTipo': instance.nombreTipo,
      'tipo': instance.tipo,
      'companieroId': instance.companieroId,
      'hijoRelacionId': instance.hijoRelacionId,
      'relacion': instance.relacion,
      'cargaCursoId': instance.cargaCursoId,
    };

AdminServiceSerializable _$AdminServiceSerializableFromJson(
    Map<String, dynamic> json) {
  return AdminServiceSerializable(
    UsuarioId: json['UsuarioId'] as int,
    Estado: json['Estado'] as bool,
    EntidadId: json['EntidadId'] as int,
    UsuarioExternoId: json['UsuarioExternoId'] as int,
    UsuarioCreadorId: json['UsuarioCreadorId'] as int,
    UsuarioAccionId: json['UsuarioAccionId'] as int,
    Opcion: json['Opcion'] as int,
    Cantidad: json['Cantidad'] as int,
    UrlServiceMovil: json['UrlServiceMovil'] as String,
  );
}

Map<String, dynamic> _$AdminServiceSerializableToJson(
        AdminServiceSerializable instance) =>
    <String, dynamic>{
      'UsuarioId': instance.UsuarioId,
      'Estado': instance.Estado,
      'EntidadId': instance.EntidadId,
      'UsuarioExternoId': instance.UsuarioExternoId,
      'UsuarioCreadorId': instance.UsuarioCreadorId,
      'UsuarioAccionId': instance.UsuarioAccionId,
      'Opcion': instance.Opcion,
      'Cantidad': instance.Cantidad,
      'UrlServiceMovil': instance.UrlServiceMovil,
    };

EntidadSerializable _$EntidadSerializableFromJson(Map<String, dynamic> json) {
  return EntidadSerializable(
    entidadId: json['entidadId'] as int,
    tipoId: json['tipoId'] as int,
    parentId: json['parentId'] as int,
    nombre: json['nombre'] as String,
    ruc: json['ruc'] as String,
    site: json['site'] as String,
    telefono: json['telefono'] as String,
    correo: json['correo'] as String,
    foto: json['foto'] as String,
    estadoId: json['estadoId'] as int,
  );
}

Map<String, dynamic> _$EntidadSerializableToJson(
        EntidadSerializable instance) =>
    <String, dynamic>{
      'entidadId': instance.entidadId,
      'tipoId': instance.tipoId,
      'parentId': instance.parentId,
      'nombre': instance.nombre,
      'ruc': instance.ruc,
      'site': instance.site,
      'telefono': instance.telefono,
      'correo': instance.correo,
      'foto': instance.foto,
      'estadoId': instance.estadoId,
    };

GeoreferenciaSerializable _$GeoreferenciaSerializableFromJson(
    Map<String, dynamic> json) {
  return GeoreferenciaSerializable(
    georeferenciaId: json['georeferenciaId'] as int,
    nombre: json['nombre'] as String,
    entidadId: json['entidadId'] as int,
    alias: json['alias'] as String,
    estadoId: json['estadoId'] as int,
  );
}

Map<String, dynamic> _$GeoreferenciaSerializableToJson(
        GeoreferenciaSerializable instance) =>
    <String, dynamic>{
      'georeferenciaId': instance.georeferenciaId,
      'nombre': instance.nombre,
      'entidadId': instance.entidadId,
      'alias': instance.alias,
      'estadoId': instance.estadoId,
    };

RolSerializable _$RolSerializableFromJson(Map<String, dynamic> json) {
  return RolSerializable(
    rolId: json['rolId'] as int,
    nombre: json['nombre'] as String,
    parentId: json['parentId'] as int,
    estado: json['estado'] as bool,
  );
}

Map<String, dynamic> _$RolSerializableToJson(RolSerializable instance) =>
    <String, dynamic>{
      'rolId': instance.rolId,
      'nombre': instance.nombre,
      'parentId': instance.parentId,
      'estado': instance.estado,
    };

UsuarioRolGeoreferenciaSerializable
    _$UsuarioRolGeoreferenciaSerializableFromJson(Map<String, dynamic> json) {
  return UsuarioRolGeoreferenciaSerializable(
    usuarioRolGeoreferenciaId: json['usuarioRolGeoreferenciaId'] as int,
    usuarioId: json['usuarioId'] as int,
    rolId: json['rolId'] as int,
    geoReferenciaId: json['geoReferenciaId'] as int,
    entidadId: json['entidadId'] as int,
  );
}

Map<String, dynamic> _$UsuarioRolGeoreferenciaSerializableToJson(
        UsuarioRolGeoreferenciaSerializable instance) =>
    <String, dynamic>{
      'usuarioRolGeoreferenciaId': instance.usuarioRolGeoreferenciaId,
      'usuarioId': instance.usuarioId,
      'rolId': instance.rolId,
      'geoReferenciaId': instance.geoReferenciaId,
      'entidadId': instance.entidadId,
    };

CursosSerializable _$CursosSerializableFromJson(Map<String, dynamic> json) {
  return CursosSerializable(
    cursoId: json['cursoId'] as int,
    nombre: json['nombre'] as String,
    estadoId: json['estadoId'] as int,
    descripcion: json['descripcion'] as String,
    alias: json['alias'] as String,
    entidadId: json['entidadId'] as int,
    nivelAcadId: json['nivelAcadId'] as int,
    tipoCursoId: json['tipoCursoId'] as int,
    tipoConceptoId: json['tipoConceptoId'] as int,
    color: json['color'] as String,
    creditos: json['creditos'] as String,
    totalHP: json['totalHP'] as String,
    totalHT: json['totalHT'] as String,
    notaAprobatoria: json['notaAprobatoria'] as String,
    sumilla: json['sumilla'] as String,
    superId: json['superId'] as int,
    idServicioLaboratorio: json['idServicioLaboratorio'] as int,
    horasLaboratorio: json['horasLaboratorio'] as int,
    tipoSubcurso: json['tipoSubcurso'] as bool,
    foto: json['foto'] as String,
    codigo: json['codigo'] as String,
  );
}

Map<String, dynamic> _$CursosSerializableToJson(CursosSerializable instance) =>
    <String, dynamic>{
      'cursoId': instance.cursoId,
      'nombre': instance.nombre,
      'estadoId': instance.estadoId,
      'descripcion': instance.descripcion,
      'alias': instance.alias,
      'entidadId': instance.entidadId,
      'nivelAcadId': instance.nivelAcadId,
      'tipoCursoId': instance.tipoCursoId,
      'tipoConceptoId': instance.tipoConceptoId,
      'color': instance.color,
      'creditos': instance.creditos,
      'totalHP': instance.totalHP,
      'totalHT': instance.totalHT,
      'notaAprobatoria': instance.notaAprobatoria,
      'sumilla': instance.sumilla,
      'superId': instance.superId,
      'idServicioLaboratorio': instance.idServicioLaboratorio,
      'horasLaboratorio': instance.horasLaboratorio,
      'tipoSubcurso': instance.tipoSubcurso,
      'foto': instance.foto,
      'codigo': instance.codigo,
    };

SeccionSeraializable _$SeccionSeraializableFromJson(Map<String, dynamic> json) {
  return SeccionSeraializable(
    json['seccionId'] as int,
    json['nombre'] as String,
    json['descripcion'] as String,
    json['estado'] as bool,
    json['georeferenciaId'] as int,
  );
}

Map<String, dynamic> _$SeccionSeraializableToJson(
        SeccionSeraializable instance) =>
    <String, dynamic>{
      'seccionId': instance.seccionId,
      'nombre': instance.nombre,
      'descripcion': instance.descripcion,
      'estado': instance.estado,
      'georeferenciaId': instance.georeferenciaId,
    };

AulaSeraializable _$AulaSeraializableFromJson(Map<String, dynamic> json) {
  return AulaSeraializable(
    json['aulaId'] as int,
    json['descripcion'] as String,
    json['numero'] as String,
    json['capacidad'] as String,
    json['estado'] as int,
  );
}

Map<String, dynamic> _$AulaSeraializableToJson(AulaSeraializable instance) =>
    <String, dynamic>{
      'aulaId': instance.aulaId,
      'descripcion': instance.descripcion,
      'numero': instance.numero,
      'capacidad': instance.capacidad,
      'estado': instance.estado,
    };

PeriodosSeraializable _$PeriodosSeraializableFromJson(
    Map<String, dynamic> json) {
  return PeriodosSeraializable(
    periodoId: json['periodoId'] as int,
    nombre: json['nombre'] as String,
    estadoId: json['estadoId'] as int,
    alias: json['alias'] as String,
    fecComienzo: json['fecComienzo'] as String,
    fecTermino: json['fecTermino'] as String,
    tipoId: json['tipoId'] as int,
    superId: json['superId'] as int,
    geoReferenciaId: json['geoReferenciaId'] as int,
    organigramaId: json['organigramaId'] as int,
    entidadId: json['entidadId'] as int,
    activo: json['activo'] as bool,
    cicloId: json['cicloId'] as int,
    docenteId: json['docenteId'] as int,
    gruponombre: json['gruponombre'] as String,
    grupoId: json['grupoId'] as int,
    nivelAcademico: json['nivelAcademico'] as String,
    nivelAcademicoId: json['nivelAcademicoId'] as int,
    tutorId: json['tutorId'] as int,
  );
}

Map<String, dynamic> _$PeriodosSeraializableToJson(
        PeriodosSeraializable instance) =>
    <String, dynamic>{
      'periodoId': instance.periodoId,
      'nombre': instance.nombre,
      'estadoId': instance.estadoId,
      'alias': instance.alias,
      'fecComienzo': instance.fecComienzo,
      'fecTermino': instance.fecTermino,
      'tipoId': instance.tipoId,
      'superId': instance.superId,
      'geoReferenciaId': instance.geoReferenciaId,
      'organigramaId': instance.organigramaId,
      'entidadId': instance.entidadId,
      'activo': instance.activo,
      'cicloId': instance.cicloId,
      'docenteId': instance.docenteId,
      'gruponombre': instance.gruponombre,
      'grupoId': instance.grupoId,
      'nivelAcademico': instance.nivelAcademico,
      'nivelAcademicoId': instance.nivelAcademicoId,
      'tutorId': instance.tutorId,
    };

CargaAcademicaSeraializable _$CargaAcademicaSeraializableFromJson(
    Map<String, dynamic> json) {
  return CargaAcademicaSeraializable(
    cargaAcademicaId: json['cargaAcademicaId'] as int,
    estadoId: json['estadoId'] as int,
    idAnioAcademico: json['idAnioAcademico'] as int,
    idPeriodoAcad: json['idPeriodoAcad'] as int,
    aulaId: json['aulaId'] as int,
    idGrupo: json['idGrupo'] as int,
    idPlanEstudio: json['idPlanEstudio'] as int,
    idPlanEstudioVersion: json['idPlanEstudioVersion'] as int,
    capacidadVacante: json['capacidadVacante'] as int,
    capacidadVacanteD: json['capacidadVacanteD'] as int,
    idEmpleadoTutor: json['idEmpleadoTutor'] as int,
    seccionId: json['seccionId'] as int,
    periodoId: json['periodoId'] as int,
  );
}

Map<String, dynamic> _$CargaAcademicaSeraializableToJson(
        CargaAcademicaSeraializable instance) =>
    <String, dynamic>{
      'cargaAcademicaId': instance.cargaAcademicaId,
      'estadoId': instance.estadoId,
      'idAnioAcademico': instance.idAnioAcademico,
      'idPeriodoAcad': instance.idPeriodoAcad,
      'aulaId': instance.aulaId,
      'idGrupo': instance.idGrupo,
      'idPlanEstudio': instance.idPlanEstudio,
      'idPlanEstudioVersion': instance.idPlanEstudioVersion,
      'capacidadVacante': instance.capacidadVacante,
      'capacidadVacanteD': instance.capacidadVacanteD,
      'idEmpleadoTutor': instance.idEmpleadoTutor,
      'seccionId': instance.seccionId,
      'periodoId': instance.periodoId,
    };

NivelAcademicoSeraializable _$NivelAcademicoSeraializableFromJson(
    Map<String, dynamic> json) {
  return NivelAcademicoSeraializable(
    nivelAcadId: json['nivelAcadId'] as int,
    nombre: json['nombre'] as String,
    activo: json['activo'] as bool,
    entidadId: json['entidadId'] as int,
  );
}

Map<String, dynamic> _$NivelAcademicoSeraializableToJson(
        NivelAcademicoSeraializable instance) =>
    <String, dynamic>{
      'nivelAcadId': instance.nivelAcadId,
      'nombre': instance.nombre,
      'activo': instance.activo,
      'entidadId': instance.entidadId,
    };

AsistenciaAlumnosSerializable _$AsistenciaAlumnosSerializableFromJson(
    Map<String, dynamic> json) {
  return AsistenciaAlumnosSerializable(
    asistenciaSesionId: json['asistenciaSesionId'] as String,
    fechaAsistenciaN: json['fechaAsistenciaN'] as String,
    hora: json['hora'] as String,
    georeferenciaId: json['georeferenciaId'] as int,
    alumnoId: json['alumnoId'] as int,
    sesionAprendizajeId: json['sesionAprendizajeId'] as int,
    calendarioPeriodoId: json['calendarioPeriodoId'] as int,
    cargaCursoId: json['cargaCursoId'] as int,
    valorTipoNotaId: json['valorTipoNotaId'] as String,
    asistenciaSesionIdAndroid: json['asistenciaSesionIdAndroid'] as int,
    periodoId: json['periodoId'] as int,
    docenteId: json['docenteId'] as int,
    grupoId: json['grupoId'] as int,
    fechaAsistenciaS: json['fechaAsistenciaS'] as String,
    nombreCurso: json['nombreCurso'] as String,
    gradoId: json['gradoId'] as int,
    grado: json['grado'] as String,
    seccionId: json['seccionId'] as int,
    seccion: json['seccion'] as String,
    silaboEventoId: json['silaboEventoId'] as int,
    parametroDesenioId: json['parametroDesenioId'] as int,
    correoDocente: json['correoDocente'] as String,
    celularDocente: json['celularDocente'] as String,
    telefonoDocente: json['telefonoDocente'] as String,
    fotoDocente: json['fotoDocente'] as String,
    nombreDocente: json['nombreDocente'] as String,
    personaIdDocente: json['personaIdDocente'] as int,
    anioAcademicoId: json['anioAcademicoId'] as int,
    programaAcadId: json['programaAcadId'] as int,
  );
}

Map<String, dynamic> _$AsistenciaAlumnosSerializableToJson(
        AsistenciaAlumnosSerializable instance) =>
    <String, dynamic>{
      'asistenciaSesionId': instance.asistenciaSesionId,
      'fechaAsistenciaN': instance.fechaAsistenciaN,
      'hora': instance.hora,
      'georeferenciaId': instance.georeferenciaId,
      'alumnoId': instance.alumnoId,
      'sesionAprendizajeId': instance.sesionAprendizajeId,
      'calendarioPeriodoId': instance.calendarioPeriodoId,
      'cargaCursoId': instance.cargaCursoId,
      'valorTipoNotaId': instance.valorTipoNotaId,
      'asistenciaSesionIdAndroid': instance.asistenciaSesionIdAndroid,
      'periodoId': instance.periodoId,
      'docenteId': instance.docenteId,
      'grupoId': instance.grupoId,
      'fechaAsistenciaS': instance.fechaAsistenciaS,
      'nombreCurso': instance.nombreCurso,
      'gradoId': instance.gradoId,
      'grado': instance.grado,
      'seccionId': instance.seccionId,
      'seccion': instance.seccion,
      'silaboEventoId': instance.silaboEventoId,
      'parametroDesenioId': instance.parametroDesenioId,
      'correoDocente': instance.correoDocente,
      'celularDocente': instance.celularDocente,
      'telefonoDocente': instance.telefonoDocente,
      'fotoDocente': instance.fotoDocente,
      'nombreDocente': instance.nombreDocente,
      'personaIdDocente': instance.personaIdDocente,
      'anioAcademicoId': instance.anioAcademicoId,
      'programaAcadId': instance.programaAcadId,
    };

AsistenciaJustificacionSerializable
    _$AsistenciaJustificacionSerializableFromJson(Map<String, dynamic> json) {
  return AsistenciaJustificacionSerializable(
    justificacionId: json['justificacionId'] as String,
    asistenciaId: json['asistenciaId'] as String,
    descripcion: json['descripcion'] as String,
    tipoJustificacionId: json['tipoJustificacionId'] as int,
    tipoIngresoId: json['tipoIngresoId'] as int,
    asistenciaSesionId: json['asistenciaSesionId'] as String,
    asistenciaDocenteId: json['asistenciaDocenteId'] as String,
  );
}

Map<String, dynamic> _$AsistenciaJustificacionSerializableToJson(
        AsistenciaJustificacionSerializable instance) =>
    <String, dynamic>{
      'justificacionId': instance.justificacionId,
      'asistenciaId': instance.asistenciaId,
      'descripcion': instance.descripcion,
      'tipoJustificacionId': instance.tipoJustificacionId,
      'tipoIngresoId': instance.tipoIngresoId,
      'asistenciaSesionId': instance.asistenciaSesionId,
      'asistenciaDocenteId': instance.asistenciaDocenteId,
    };

AsistecniaArchivoSerializable _$AsistecniaArchivoSerializableFromJson(
    Map<String, dynamic> json) {
  return AsistecniaArchivoSerializable(
    archivoAsistenciaId: json['archivoAsistenciaId'] as String,
    path: json['path'] as String,
    nombre: json['nombre'] as String,
    tipoId: json['tipoId'] as int,
    justificacionId: json['justificacionId'] as String,
    pathLectura: json['pathLectura'] as String,
  );
}

Map<String, dynamic> _$AsistecniaArchivoSerializableToJson(
        AsistecniaArchivoSerializable instance) =>
    <String, dynamic>{
      'archivoAsistenciaId': instance.archivoAsistenciaId,
      'path': instance.path,
      'nombre': instance.nombre,
      'tipoId': instance.tipoId,
      'justificacionId': instance.justificacionId,
      'pathLectura': instance.pathLectura,
    };

AsistenciaTipoNotaSerializable _$AsistenciaTipoNotaSerializableFromJson(
    Map<String, dynamic> json) {
  return AsistenciaTipoNotaSerializable(
    tipoNotaId: json['tipoNotaId'] as String,
    nombre: json['nombre'] as String,
    tipoId: json['tipoId'] as int,
    valorDefecto: json['valorDefecto'] as String,
    valorMaximo: json['valorMaximo'] as int,
    valorMinino: json['valorMinino'] as int,
    longitudPaso: (json['longitudPaso'] as num)?.toDouble(),
    intervalo: json['intervalo'] as bool,
    estatico: json['estatico'] as bool,
    entidadId: json['entidadId'] as int,
    georeferenciaId: json['georeferenciaId'] as int,
    organigramaId: json['organigramaId'] as int,
    estadoId: json['estadoId'] as int,
    tipoFuenteId: json['tipoFuenteId'] as int,
    escalaEvaluacionId: json['escalaEvaluacionId'] as int,
  );
}

Map<String, dynamic> _$AsistenciaTipoNotaSerializableToJson(
        AsistenciaTipoNotaSerializable instance) =>
    <String, dynamic>{
      'tipoNotaId': instance.tipoNotaId,
      'nombre': instance.nombre,
      'tipoId': instance.tipoId,
      'valorDefecto': instance.valorDefecto,
      'valorMaximo': instance.valorMaximo,
      'valorMinino': instance.valorMinino,
      'longitudPaso': instance.longitudPaso,
      'intervalo': instance.intervalo,
      'estatico': instance.estatico,
      'entidadId': instance.entidadId,
      'georeferenciaId': instance.georeferenciaId,
      'organigramaId': instance.organigramaId,
      'estadoId': instance.estadoId,
      'tipoFuenteId': instance.tipoFuenteId,
      'escalaEvaluacionId': instance.escalaEvaluacionId,
    };

AsistenciaValorTipoNotaSerializable
    _$AsistenciaValorTipoNotaSerializableFromJson(Map<String, dynamic> json) {
  return AsistenciaValorTipoNotaSerializable(
    valorTipoNotaId: json['valorTipoNotaId'] as String,
    tipoNotaId: json['tipoNotaId'] as String,
    titulo: json['titulo'] as String,
    alias: json['alias'] as String,
    limiteInferior: (json['limiteInferior'] as num)?.toDouble(),
    limiteSuperior: (json['limiteSuperior'] as num)?.toDouble(),
    valorNumerico: (json['valorNumerico'] as num)?.toDouble(),
    icono: json['icono'] as String,
    estadoId: json['estadoId'] as int,
    incluidoLInferior: json['incluidoLInferior'] as bool,
    incluidoLSuperior: json['incluidoLSuperior'] as bool,
    tipoId: json['tipoId'] as int,
  );
}

Map<String, dynamic> _$AsistenciaValorTipoNotaSerializableToJson(
        AsistenciaValorTipoNotaSerializable instance) =>
    <String, dynamic>{
      'valorTipoNotaId': instance.valorTipoNotaId,
      'tipoNotaId': instance.tipoNotaId,
      'titulo': instance.titulo,
      'alias': instance.alias,
      'limiteInferior': instance.limiteInferior,
      'limiteSuperior': instance.limiteSuperior,
      'valorNumerico': instance.valorNumerico,
      'icono': instance.icono,
      'estadoId': instance.estadoId,
      'incluidoLInferior': instance.incluidoLInferior,
      'incluidoLSuperior': instance.incluidoLSuperior,
      'tipoId': instance.tipoId,
    };

AsistenciaRelProgramaTipoNotaSerializable
    _$AsistenciaRelProgramaTipoNotaSerializableFromJson(
        Map<String, dynamic> json) {
  return AsistenciaRelProgramaTipoNotaSerializable(
    programaEducativoId: json['programaEducativoId'] as int,
    tipoNotaId: json['tipoNotaId'] as String,
    estado: json['estado'] as bool,
  );
}

Map<String, dynamic> _$AsistenciaRelProgramaTipoNotaSerializableToJson(
        AsistenciaRelProgramaTipoNotaSerializable instance) =>
    <String, dynamic>{
      'programaEducativoId': instance.programaEducativoId,
      'tipoNotaId': instance.tipoNotaId,
      'estado': instance.estado,
    };

AsistenciaGeneralSerializable _$AsistenciaGeneralSerializableFromJson(
    Map<String, dynamic> json) {
  return AsistenciaGeneralSerializable(
    json['controlAsistenciaId'] as int,
    json['alumnoId'] as int,
    json['calendarioPeriodoId'] as int,
    json['grupoId'] as int,
    json['periodoId'] as int,
    json['programaEducativoId'] as int,
    json['docenteId'] as int,
    json['georeferenciaId'] as int,
    json['fechaAsistencia'] as String,
    json['horaIngreso'] as String,
    json['horaSalida'] as String,
    json['estadoIngresoId'] as int,
    json['estadosIngresoNombre'] as String,
    json['estadoSalidaId'] as int,
    json['estadosSalidaNombre'] as String,
    json['observaciones'] as String,
  );
}

Map<String, dynamic> _$AsistenciaGeneralSerializableToJson(
        AsistenciaGeneralSerializable instance) =>
    <String, dynamic>{
      'controlAsistenciaId': instance.controlAsistenciaId,
      'alumnoId': instance.alumnoId,
      'calendarioPeriodoId': instance.calendarioPeriodoId,
      'grupoId': instance.grupoId,
      'periodoId': instance.periodoId,
      'programaEducativoId': instance.programaEducativoId,
      'docenteId': instance.docenteId,
      'georeferenciaId': instance.georeferenciaId,
      'fechaAsistencia': instance.fechaAsistencia,
      'horaIngreso': instance.horaIngreso,
      'horaSalida': instance.horaSalida,
      'estadoIngresoId': instance.estadoIngresoId,
      'estadosIngresoNombre': instance.estadosIngresoNombre,
      'estadoSalidaId': instance.estadoSalidaId,
      'estadosSalidaNombre': instance.estadosSalidaNombre,
      'observaciones': instance.observaciones,
    };
