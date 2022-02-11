import 'package:moor_flutter/moor_flutter.dart';
import 'package:padre_mentor/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:padre_mentor/src/data/repositories/moor/database/app_database.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/areas_boleta.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/calendario_acalendario.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/cursos.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/nivel_academico.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/plan_estudios.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/silabo_evento.dart';
import 'package:padre_mentor/src/domain/tools/app_tools.dart';


class SerializableConvert{

  static UsuarioData converSerializeUsuario(Map<String,dynamic> model){
    UsuarioSerial usuarioSerial = UsuarioSerial.fromJson(model);
    return UsuarioData(usuarioId: usuarioSerial.usuarioId??0, personaId: usuarioSerial.personaId, usuario: usuarioSerial.usuario, password: usuarioSerial.password, estado: usuarioSerial.estado, habilitarAcceso: usuarioSerial.habilitarAcceso);
  }

  static List<UsuarioData> converListSerializeUsuario(dynamic model){
    List<UsuarioData> usuarios = [];
    Iterable l = model;
    for(var item in l){
      usuarios.add(converSerializeUsuario(item));
    }
    return usuarios;
  }

  static PersonaData converSerializePersona(Map<String,dynamic> model){
    PersonaSerial personaSerial = PersonaSerial.fromJson(model);
    return PersonaData(
        personaId: personaSerial.personaId??0,
        nombres: personaSerial.nombres,
        apellidoPaterno: personaSerial.apellidoPaterno,
        apellidoMaterno: personaSerial.apellidoMaterno,
        celular: personaSerial.celular,
        telefono: personaSerial.telefono,
        foto: personaSerial.foto,
        fechaNac: personaSerial.fechaNac,
        genero: personaSerial.genero,
        estadoCivil: personaSerial.estadoCivil,
        numDoc: personaSerial.numDoc,
        ocupacion: personaSerial.ocupacion,
        estadoId: personaSerial.estadoId,
        correo: personaSerial.correo,
        direccion: personaSerial.direccion,
        path: personaSerial.path);
    //insert.personaId = Values(1);
  }

  static List<PersonaData> converListSerializePersona(dynamic model){
    List<PersonaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializePersona(item));
    }
    return items;
  }

  static Relacione converSerializeRelaciones(Map<String,dynamic> model){
    RelacionesSerial personaSerial = RelacionesSerial.fromJson(model);

    return Relacione(idRelacion: personaSerial.idRelacion??0, personaPrincipalId: personaSerial.personaPrincipalId, personaVinculadaId: personaSerial.personaVinculadaId,
        tipoId: personaSerial.tipoId, activo: personaSerial.activo);
  }

  static List<Relacione> converListSerializeRelaciones(dynamic model){
    List<Relacione> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeRelaciones(item));
    }
    return items;
  }

  static AnioAcademicoAlumnoData converSerializeAnioAcademicoAlumno(Map<String,dynamic> model){
    AnioAcademicoAlumnoSerial academicoAlumnoSerial = AnioAcademicoAlumnoSerial.fromJson(model);

    return AnioAcademicoAlumnoData(idAnioAcademico: academicoAlumnoSerial.idAnioAcademico??0,
      nombre: academicoAlumnoSerial.nombre,
      fechaInicio: academicoAlumnoSerial.fechaFin,
      fechaFin: academicoAlumnoSerial.fechaFin,
      denominacion: academicoAlumnoSerial.denominacion,
      georeferenciaId: academicoAlumnoSerial.georeferenciaId,
      organigramaId: academicoAlumnoSerial.organigramaId,
      estadoId: academicoAlumnoSerial.estadoId,
      tipoId: academicoAlumnoSerial.tipoId,
      personaId: academicoAlumnoSerial.personaId,
      /*toogle: academicoAlumnoSerial.toogle*/);
  }

  static List<AnioAcademicoAlumnoData> converListSerializeAnioAcademicoAlumno(dynamic model){
    List<AnioAcademicoAlumnoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeAnioAcademicoAlumno(item));
    }
    return items;
  }

  static CargaCursoData converSerializeCargaCurso(Map<String,dynamic> model){
    CargaCursosSerial serial = CargaCursosSerial.fromJson(model);

    return CargaCursoData(cargaCursoId: serial.cargaCursoId??0,
        planCursoId: serial.planCursoId,
        empleadoId: serial.empleadoId,
        cargaAcademicaId: serial.cargaAcademicaId,
        complejo: serial.complejo,
        evaluable: serial.evaluable,
        idempleado: serial.idempleado,
        idTipoHora: serial.idTipoHora,
        descripcion: serial.descripcion,
        fechaInicio: DateTime.fromMillisecondsSinceEpoch(serial.fechaInicio??0),
        fechafin: DateTime.fromMillisecondsSinceEpoch(serial.fechafin??0),
        modo: serial.modo,
        estado: serial.estado,
        anioAcademicoId: serial.anioAcademicoId,
        aulaId: serial.aulaId,
        grupoId: serial.grupoId,
        idPlanEstudio: serial.idPlanEstudio,
        idPlanEstudioVersion: serial.idPlanEstudioVersion,
        CapacidadVacanteP: serial.CapacidadVacanteP,
        CapacidadVacanteD: serial.CapacidadVacanteD,
        nombreDocente: serial.nombreDocente,
        personaIdDocente: serial.personaIdDocente,
        fotoDocente: serial.fotoDocente
    );
  }
  static EventoAdjuntoData converSerializeEventoAdjunto(Map<String,dynamic> model){
    EventoAdjuntoSerial serial = EventoAdjuntoSerial.fromJson(model);
    return EventoAdjuntoData(
        eventoAdjuntoId: serial.eventoAdjuntoId??"",
        driveId: serial.driveId,
        titulo: serial.titulo,
        eventoId: serial.eventoId,
        tipoId: serial.tipoId
    );
  }

  static List<EventoAdjuntoData> converListSerializeEventoAjunto(dynamic model){
    List<EventoAdjuntoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeEventoAdjunto(item));
    }
    return items;
  }
  static List<CargaCursoData> converListSerializeCargaCurso(dynamic model){
    List<CargaCursoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCargaCurso(item));
    }
    return items;
  }

  static ContratoData converSerializeContrato(Map<String,dynamic> model){
    ContratoSerial serial = ContratoSerial.fromJson(model);

    return ContratoData(idContrato: serial.idContrato??0,
        personaId: serial.personaId,
        idAnioAcademico: serial.idAnioAcademico,
        nroHno: serial.nroHno,
        nivelAcaId: serial.nivelAcaId,
        seccionId: serial.seccionId,
        periodoId: serial.periodoId,
        vigente: serial.vigente,
        estadoId: serial.estadoId,
        apoderadoId: serial.apoderadoId);
  }

  static List<ContratoData> converListSerializeContrato(dynamic model){
    List<ContratoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeContrato(item));
    }
    return items;
  }

  static DetalleContratoAcadData converSerializeDetalleContratoAcad(Map<String,dynamic> model){
    DetalleContratoAcadSerial serial = DetalleContratoAcadSerial.fromJson(model);

    return DetalleContratoAcadData(idContratoDetAcad: serial.idContratoDetAcad??0,
        idContrato: serial.idContrato,
        cargaCursoId: serial.cargaCursoId,
        cargaAcademicaId: serial.cargaAcademicaId,
        notaPromedio: serial.notaPromedio,
        escala: serial.escala,
        anioAcademicoId: serial.anioAcademicoId,
        idNivelAcademico: serial.idNivelAcademico,
        cursoId: serial.cursoId,
        grupoId: serial.grupoId,
        aulaId: serial.aulaId);
  }

  static List<DetalleContratoAcadData> converListSerializeDetalleContratoAcad(dynamic model){
    List<DetalleContratoAcadData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeDetalleContratoAcad(item));
    }
    return items;
  }

  static PlanCurso converSerializePlanCurso(Map<String,dynamic> model){
    PlanCursosSerial serial = PlanCursosSerial.fromJson(model);

    return PlanCurso(planCursoId: serial.planCursoId??0,
        cursoId: serial.cursoId,
        periodoId: serial.periodoId,
        planEstudiosId: serial.planEstudiosId);
  }

  static List<PlanCurso> converListSerializePlanCurso(dynamic model){
    List<PlanCurso> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializePlanCurso(item));
    }
    return items;
  }

  static PlanEstudioData converSerializePlanEstudio(Map<String,dynamic> model){
    PlanEstudiosSerial serial = PlanEstudiosSerial.fromJson(model);

    return PlanEstudioData( planEstudiosId: serial.planEstudiosId??0,
        programaEduId: serial.programaEduId,
        nombrePlan: serial.nombrePlan,
        aliasPlan: serial.alias,
        estadoId: serial.estadoId,
        nroResolucion: serial.nroResolucion,
        fechaResolucion: serial.fechaResolucion);
  }

  static List<PlanEstudioData> converListSerializePlanEstudio(dynamic model){
    List<PlanEstudioData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializePlanEstudio(item));
    }
    return items;
  }

  static ProgramasEducativoData converSerializeProgramasEducativo(Map<String,dynamic> model){
    ProgramasEducativoSerial serial = ProgramasEducativoSerial.fromJson(model);

    return ProgramasEducativoData( programaEduId: serial.programaEduId??0,
        nombre: serial.nombre,
        nroCiclos: serial.nroCiclos,
        nivelAcadId: serial.nivelAcadId,
        tipoEvaluacionId: serial.tipoEvaluacionId,
        estadoId: serial.estadoId,
        entidadId: serial.entidadId,
        tipoInformeSiagieId: serial.tipoInformeSiagieId,
        /*toogle: serial.,*/
        tipoProgramaId: serial.tipoProgramaId,
        tipoMatriculaId: serial.tipoMatriculaId);
  }

  static List<ProgramasEducativoData> converListSerializeProgramasEducativo(dynamic model){
    List<ProgramasEducativoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeProgramasEducativo(item));
    }
    return items;
  }

  static CalendarioAcademicoData converSerializeCalendarioAcademico(Map<String,dynamic> model){
    CalendarioAcademicoSerial serial = CalendarioAcademicoSerial.fromJson(model);

    return CalendarioAcademicoData(
        calendarioAcademicoId: serial.calendarioAcademicoId??0,
        programaEduId: serial.programaEduId,
        idAnioAcademico: serial.idAnioAcademico,
        estadoId: serial.estadoId);
  }

  static List<CalendarioAcademicoData> converListSerializeCalendarioAcademico(dynamic model){
    List<CalendarioAcademicoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCalendarioAcademico(item));
    }
    return items;
  }

  static CalendarioPeriodoData converSerializeCalendarioPeriodo(Map<String,dynamic> model){
    CalendarioPeriodoSerial serial = CalendarioPeriodoSerial.fromJson(model);

    return CalendarioPeriodoData(
        calendarioPeriodoId: serial.calendarioPeriodoId??0,
        fechaInicio:  DateTime.fromMillisecondsSinceEpoch(serial.fechaInicio??0),
        fechaFin:  DateTime.fromMillisecondsSinceEpoch(serial.fechaFin??0),
        calendarioAcademicoId: serial.calendarioAcademicoId,
        tipoId: serial.tipoId,
        estadoId: serial.estadoId,
        diazPlazo: serial.diazPlazo);
  }

  static List<CalendarioPeriodoData> converListSerializeCalendarioPeriodo(dynamic model){
    List<CalendarioPeriodoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCalendarioPeriodo(item));
    }
    return items;
  }

  static Tipo converSerializeTipos(Map<String,dynamic> model){
    TiposSerial serial = TiposSerial.fromJson(model);

    return Tipo(
        tipoId: serial.tipoId??0,
        objeto: serial.objeto,
        concepto: serial.concepto,
        nombre: serial.nombre,
        codigo: serial.codigo,
        parentId: serial.parentId);
  }

  static List<Tipo> converListSerializeTipos(dynamic model){
    List<Tipo> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeTipos(item));
    }
    return items;
  }

  static AreasBoletaData converSerializeAreasBoleta(Map<String,dynamic> model, int anioAcademicoId, int seccionId, int periodoId, int programaEducativoId){
    AreasBoletaSerial serial = AreasBoletaSerial.fromJson(model);

    return AreasBoletaData(
        rubroEvalResultadoId: serial.rubroEvalResultadoId??0,
        nombre: serial.nombre,
        tipoConceptoId: serial.tipoConceptoId,
        totalHt: serial.totalHt,
        silaboEventoId: serial.silaboEventoId,
        competencia: serial.competencia,
        tipoNotaId: serial.tipoId,
        tipoFormulaId: serial.competenciaId,
        competenciaId: serial.competenciaId,
        tipoCompetenciaId: serial.tipoCompetenciaId,
        calendarioPeriodoId: serial.calendarioPeriodoId,
        //anioAcademicoId: serial.anioAcademicoId,
        anioAcademicoId: anioAcademicoId,
        //programaEducativoId: serial.programaEducativoId,
        programaEducativoId: programaEducativoId,
        //periodoId: serial.periodoId,
        periodoId: periodoId,
        //seccionId: serial.seccionId
        seccionId: seccionId
    );
  }

  static List<AreasBoletaData> converListSerializeAreasBoleta(dynamic model, int anioAcademicoId, int seccionId, int periodoId, int programaEducativoId){
    List<AreasBoletaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeAreasBoleta(item, anioAcademicoId, seccionId, periodoId, programaEducativoId));
    }
    return items;
  }

  static NotasCalendarioBoletaData converSerializeNotasCalendarioBoleta(Map<String,dynamic> model){
    NotasCalendarioBoletaSerial serial = NotasCalendarioBoletaSerial.fromJson(model);

    return NotasCalendarioBoletaData(
        evaluacionResultadoId: serial.evaluacionResultadoId??0,
        rubroEvalResultadoId: serial.rubroEvalResultadoId,
        alumnoId: serial.alumnoId,
        silaboEventoId: serial.silaboEventoId,
        nota: serial.nota,
        peso: serial.peso,
        valorTipoNotaId: serial.valorTipoNotaId,
        tituloNota: serial.tituloNota,
        tipoNotaId: serial.tipoNotaId,
        calendarioPeriodoId: serial.calendarioPeriodoId,
        color: serial.color
    );
  }

  static List<NotasCalendarioBoletaData> converListSerializeNotasCalendarioBoleta(dynamic model){
    List<NotasCalendarioBoletaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeNotasCalendarioBoleta(item));
    }
    return items;
  }

  static ParametrosDisenioData converSerializeParametrosDisenio(Map<String,dynamic> model){
    ParametrosDisenioSerial serial = ParametrosDisenioSerial.fromJson(model);
    return ParametrosDisenioData(
        parametroDisenioId: serial.parametroDisenioId??0,
        objeto: serial.objeto,
        concepto: serial.concepto,
        nombre: serial.nombre,
        path: serial.path,
        color1: serial.color1,
        color2: serial.color2,
        color3: serial.color3,
        estado: serial.estado
    );
  }

  static List<ParametrosDisenioData> converListSerializeParametrosDisenio(dynamic model){
    List<ParametrosDisenioData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeParametrosDisenio(item));
    }
    return items;
  }

  static SilaboEventoData converSerializeSilaboEvento(Map<String,dynamic> model){
    SilaboEventoSerial serial = SilaboEventoSerial.fromJson(model);
    return SilaboEventoData(
        silaboEventoId: serial.silaboEventoId??0,
        titulo: serial.titulo,
        descripcionGeneral: serial.descripcionGeneral,
        planCursoId: serial.planCursoId,
        entidadId: serial.entidadId,
        docenteId: serial.docenteId,
        seccionId: serial.seccionId,
        estadoId: serial.estadoId,
        anioAcademicoId: serial.anioAcademicoId,
        georeferenciaId: serial.georeferenciaId,
        silaboBaseId: serial.silaboBaseId,
        cargaCursoId: serial.cargaCursoId,
        parametroDisenioId: serial.parametroDisenioId,
        fechaInicio: serial.fechaFin,
        fechaFin: serial.fechaFin
    );
  }

  static List<SilaboEventoData> converListSerializeSilaboEvento(dynamic model){
    List<SilaboEventoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeSilaboEvento(item));
    }
    return items;
  }


  static RubroEvalDesempenioData converSerializeRubroEvalDesempenio(Map<String,dynamic> model){
    RubroEvalDesempeniosSerial serial = RubroEvalDesempeniosSerial.fromJson(model);
    return RubroEvalDesempenioData(
        nombreCurso: serial.nombreCurso,
        fechaEvaluacion: DateTime.fromMillisecondsSinceEpoch(serial.fechaEvaluacion??0),
        tituloEvaluacion: serial.tituloEvaluacion,
        formaEvaluacion: serial.formaEvaluacion,
        tipoRubroEvalId: serial.tipoRubroEvalId,
        cargaCursoId: serial.cargaCursoId,
        silaboEventoId: serial.silaboEventoId,
        anioAcademicoId: serial.anioAcademicoId,
        programaAcadId: serial.programaAcadId,
        rubroEvalProcesoId: serial.rubroEvalProcesoId,
        alumnoId: serial.alumnoId,
        gradoId: serial.gradoId,
        grado: serial.grado,
        seccionId: serial.seccionId,
        seccion: serial.seccion,
        calendarioPeriodoId: serial.calendarioPeriodoId,
        parametroDesenioId: serial.parametroDesenioId,
        iconoNivelLogro: serial.iconoNivelLogro,
        tituloNivelLogro: serial.tituloNivelLogro,
        descripcionNivelLogro: serial.descripcionNivelLogro,
        tipoIdNivelLogro: serial.tipoIdNivelLogro,
        notaEvalaucion: serial.notaEvalaucion,
        desempenioEvalaucion: serial.desempenioEvalaucion,
        desempenioIcdTipoId: serial.desempenioIcdTipoId,
        evaluacionProcesoId: serial.evaluacionProcesoId??""
    );
  }

  static List<RubroEvalDesempenioData> converListSerializeRubroEvalDesempenio(dynamic model){
    List<RubroEvalDesempenioData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeRubroEvalDesempenio(item));
    }
    return items;
  }


  static WebConfig converSerializeWebConfigs(Map<String,dynamic> model){
    WebConfigsSerial serial = WebConfigsSerial.fromJson(model);
    return WebConfig(
        nombre: serial.nombre,
        content: serial.content
    );
  }

  static List<WebConfig> converListSerializeWebConfigs(dynamic model){
    List<WebConfig> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeWebConfigs(item));
    }
    return items;
  }

  static TareaCursoData converSerializeTareaCurso(Map<String,dynamic> model){
    TareaCursoSerializable serial = TareaCursoSerializable.fromJson(model);
    return TareaCursoData(
        tareaId: serial.tareaId??"",
        tareaTitulo: serial.tareaTitulo,
        tareaInstrucciones: serial.tareaInstrucciones,
        tareafechaCreacion: DateTime.fromMillisecondsSinceEpoch(serial.tareafechaCreacion??0),
        tareaEstadoId: serial.tareaEstadoId,
        unidadAprendizajeId: serial.unidadAprendizajeId,
        sesionAprendizajeId: serial.sesionAprendizajeId,
        tareaFechaEntrega: serial.tareaFechaEntrega,
        tareaHoraEntrega: serial.tareaHoraEntrega,
        gradoId: serial.gradoId,
        grado: serial.grado,
        seccionId: serial.seccionId,
        seccion: serial.seccion,
        fechaEvaluacion: DateTime.fromMillisecondsSinceEpoch(serial.fechaEvaluacion??0),
        tituloEvaluacion: serial.tituloEvaluacion,
        formaEvaluacion: serial.formaEvaluacion,
        tipoRubroEvalId: serial.tipoRubroEvalId,
        cargaCursoId: serial.cargaCursoId,
        silaboEventoId: serial.silaboEventoId,
        anioAcademicoId: serial.anioAcademicoId,
        programaAcadId: serial.programaAcadId,
        rubroEvalProcesoId: serial.rubroEvalProcesoId,
        alumnoId: serial.alumnoId,
        calendarioPeriodoId: serial.calendarioPeriodoId,
        parametroDesenioId: serial.parametroDesenioId,
        iconoNivelLogro: serial.iconoNivelLogro,
        tituloNivelLogro: serial.tituloNivelLogro,
        descripcionNivelLogro: serial.descripcionNivelLogro,
        tipoIdNivelLogro: serial.tipoIdNivelLogro,
        notaEvalaucion: serial.notaEvalaucion,
        evaluacionProcesoId: serial.evaluacionProcesoId,
        nombreCurso: serial.nombreCurso,
        docenteApellMat: serial.docenteApellMat,
        docenteApellPat: serial.docenteApellPat,
        docenteNombre: serial.docenteNombre
    );
  }

  static List<TareaCursoData> converListSerializeTareaCurso(dynamic model){
    List<TareaCursoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeTareaCurso(item));
    }
    return items;
  }


  static EventoData converSerializeEvento(Map<String,dynamic> model){
    EventoSerializable serial = EventoSerializable.fromJson(model);
    return EventoData(
        eventoId: serial.eventoId??"",
        titulo: serial.titulo,
        descripcion: serial.descripcion,
        calendarioId: serial.calendarioId,
        tipoEventoId: serial.tipoEventoId,
        estadoId: serial.estadoId,
        estadoPublicacion: serial.estadoPublicacion,
        entidadId: serial.entidadId,
        georeferenciaId: serial.georeferenciaId,
        fechaEvento: serial.fechaEvento_,
        horaEvento: serial.horaEvento,
        pathImagen: serial.pathImagen,
        envioPersonalizado: serial.envioPersonalizado,
        tipoEventoNombre: serial.tipoEventoNombre,
        usuarioReceptorId: serial.usuarioReceptorId,
        eventoHijoId: serial.eventoHijoId,
        nombreEntidad: serial.nombreEntidad,
        fotoEntidad: serial.fotoEntidad,
        nombreEntidadSiglas: serial.nombreEntidadSiglas,
        fechaEventoTime: AppTools.convertDateTimePtBR(serial.fechaEvento_, serial.horaEvento)
    );
  }

  static List<EventoData> converListSerializeEvento(dynamic model){
    List<EventoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeEvento(item));
    }
    return items;
  }

  static CalendarioData converSerializeCalendario(Map<String,dynamic> model){
    CalendarioSerializable serial = CalendarioSerializable.fromJson(model);
    return CalendarioData(
      calendarioId: serial.calendarioId??"",
      nombre: serial.nombre,
      descripcion: serial.descripcion,
      estado: serial.estado,
      entidadId: serial.entidadId,
      georeferenciaId: serial.georeferenciaId,
      nUsuario: serial.nUsuario,
      cargo: serial.cargo,
      usuarioId: serial.usuarioId,
      cargaAcademicaId: serial.cargaAcademicaId,
      cargaCursoId: serial.cargaCursoId,
      estadoPublicacionCal: serial.estadoPublicacion,
      rolId: serial.rolId,
      fechaCreacion:  DateTime.fromMillisecondsSinceEpoch(serial.fechaCreacion??0),
      usuarioAccionId: serial.usuarioAccionId,
      fechaAccion:  DateTime.fromMillisecondsSinceEpoch(serial.fechaAccion??0),
    );
  }

  static List<CalendarioData> converListSerializeCalendario(dynamic model){
    List<CalendarioData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCalendario(item));
    }
    return items;
  }

  static ContactoData converSerializeContacto(Map<String,dynamic> model){
    ContactoSerializable serial = ContactoSerializable.fromJson(model);
    return ContactoData(
        personaId: serial.personaId??0,
        nombres: serial.nombres,
        apellidoPaterno: serial.apellidoPaterno,
        apellidoMaterno: serial.apellidoMaterno,
        ocupacion: serial.ocupacion,
        estadoId: serial.estadoId,
        telefono: serial.telefono,
        celular: serial.celular,
        fechaNac: serial.fechaNac,
        correo: serial.correo,
        genero: serial.genero,
        estadoCivil: serial.estadoCivil,
        numDoc: serial.numDoc,
        foto: serial.foto,
        nombreTipo: serial.nombreTipo,
        tipo: serial.tipo??0,
        companieroId: serial.companieroId??0,
        hijoRelacionId: serial.hijoRelacionId,
        relacion: serial.relacion,
        cargaCursoId: serial.cargaCursoId??0
    );
  }

  static List<ContactoData> converListSerializeContacto(dynamic model){
    List<ContactoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeContacto(item));
    }
    return items;
  }


  static EntidadData converSerializeEntidad(Map<String,dynamic> model){
    EntidadSerializable serial = EntidadSerializable.fromJson(model);
    return EntidadData(
        entidadId: serial.entidadId??0,
        tipoId: serial.tipoId,
        parentId: serial.parentId,
        nombre: serial.nombre,
        ruc: serial.ruc,
        site: serial.site,
        telefono: serial.telefono,
        correo: serial.correo,
        foto: serial.foto,
        estadoId: serial.entidadId
    );
  }

  static List<EntidadData> converListSerializeEntidad(dynamic model){
    List<EntidadData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeEntidad(item));
    }
    return items;
  }

  static GeoreferenciaData converSerializeGeoreferencia(Map<String,dynamic> model){
    GeoreferenciaSerializable serial = GeoreferenciaSerializable.fromJson(model);
    return GeoreferenciaData(
        georeferenciaId: serial.georeferenciaId??0,
        nombre: serial.nombre,
        entidadId: serial.entidadId,
        geoAlias: serial.alias,
        estadoId: serial.estadoId
    );
  }

  static List<GeoreferenciaData> converListSerializeGeoreferencia(dynamic model){
    List<GeoreferenciaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeGeoreferencia(item));
    }
    return items;
  }

  static RolData converSerializeRol(Map<String,dynamic> model){
    RolSerializable serial = RolSerializable.fromJson(model);
    return RolData(
        rolId: serial.rolId??0,
        nombre: serial.nombre,
        parentId: serial.parentId,
        estado: serial.estado
    );
  }

  static List<RolData> converListSerializeRol(dynamic model){
    List<RolData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeRol(item));
    }
    return items;
  }

  static UsuarioRolGeoreferenciaData converSerializeUsuarioRolGeoreferencia(Map<String,dynamic> model){
    UsuarioRolGeoreferenciaSerializable serial = UsuarioRolGeoreferenciaSerializable.fromJson(model);
    return UsuarioRolGeoreferenciaData(
        usuarioRolGeoreferenciaId: serial.usuarioRolGeoreferenciaId??0,
        usuarioId: serial.usuarioId,
        rolId: serial.rolId,
        geoReferenciaId: serial.geoReferenciaId,
        entidadId: serial.entidadId
    );
  }

  static List<UsuarioRolGeoreferenciaData> converListSerializeUsuarioRolGeoreferencia(dynamic model){
    List<UsuarioRolGeoreferenciaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeUsuarioRolGeoreferencia(item));
    }
    return items;
  }

  static List<Curso> converListSerializeCursos(dynamic model){
    List<Curso> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCursos(item));
    }
    return items;
  }

  static Curso converSerializeCursos(Map<String,dynamic> model){
    CursosSerializable serial = CursosSerializable.fromJson(model);
    return Curso(
        cursoId: serial.cursoId??0,
        nombre: serial.nombre,
        estadoId: serial.estadoId,
        descripcion: serial.descripcion,
        cursoAlias: serial.alias,
        entidadId: serial.entidadId,
        nivelAcadId: serial.nivelAcadId,
        tipoCursoId: serial.tipoCursoId,
        tipoConceptoId: serial.tipoConceptoId,
        color: serial.color,
        creditos: serial.creditos,
        totalHP: serial.totalHP,
        totalHT: serial.totalHT,
        notaAprobatoria: serial.notaAprobatoria,
        sumilla: serial.sumilla,
        superId: serial.superId,
        idServicioLaboratorio: serial.idServicioLaboratorio,
        horasLaboratorio: serial.horasLaboratorio,
        tipoSubcurso: serial.tipoSubcurso,
        foto: serial.foto,
        codigo: serial.codigo);
    //insert.personaId = Values(1);
  }

  static List<AulaData> converListSerializeAula(dynamic model){
    List<AulaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeAula(item));
    }
    return items;
  }

  static AulaData converSerializeAula(Map<String,dynamic> model){
    AulaSeraializable serial = AulaSeraializable.fromJson(model);
    return AulaData(
        aulaId: serial.aulaId??0,
        descripcion: serial.descripcion,
        numero: serial.numero,
        capacidad: serial.capacidad,
        estado: serial.estado);
  }

  static List<Periodo> converListSerializePeriodos(dynamic model){
    List<Periodo> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializePeriodos(item));
    }
    return items;
  }

  static Periodo converSerializePeriodos(Map<String,dynamic> model){
    PeriodosSeraializable serial = PeriodosSeraializable.fromJson(model);
    return Periodo(
        periodoId: serial.periodoId??0,
        nombre: serial.nombre,
        estadoId: serial.estadoId,
        aliasPeriodo: serial.alias,
        fecComienzo: serial.fecComienzo,
        fecTermino: serial.fecTermino,
        tipoId: serial.tipoId,
        superId: serial.superId,
        geoReferenciaId: serial.geoReferenciaId,
        organigramaId: serial.organigramaId,
        entidadId: serial.entidadId,
        activo: serial.activo,
        cicloId: serial.cicloId,
        docenteId: serial.docenteId,
        gruponombre: serial.gruponombre,
        grupoId: serial.grupoId,
        nivelAcademico: serial.nivelAcademico,
        nivelAcademicoId: serial.nivelAcademicoId,
        tutorId: serial.tutorId);
  }

  static List<SeccionData> converListSerializeSeccion(dynamic model){
    List<SeccionData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeSeccion(item));
    }
    return items;
  }

  static SeccionData converSerializeSeccion(Map<String,dynamic> model){
    SeccionSeraializable serial = SeccionSeraializable.fromJson(model);
    return SeccionData(
        seccionId: serial.seccionId??0,
        nombre: serial.nombre,
        descripcion: serial.descripcion,
        estado: serial.estado,
        georeferenciaId: serial.georeferenciaId);
  }

  static List<CargaAcademicaData> converListSerializeCargaAcademica(dynamic model){
    List<CargaAcademicaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeCargaAcademica(item));
    }
    return items;
  }

  static CargaAcademicaData converSerializeCargaAcademica(Map<String,dynamic> model){
    CargaAcademicaSeraializable serial = CargaAcademicaSeraializable.fromJson(model);
    return CargaAcademicaData(
        cargaAcademicaId: serial.cargaAcademicaId??0,
        estadoId: serial.estadoId,
        idAnioAcademico: serial.idAnioAcademico,
        idPeriodoAcad: serial.idPeriodoAcad,
        aulaId: serial.aulaId,
        idGrupo: serial.idGrupo,
        idPlanEstudio: serial.idPlanEstudio,
        idPlanEstudioVersion: serial.idPlanEstudioVersion,
        capacidadVacante: serial.capacidadVacante,
        capacidadVacanteD: serial.capacidadVacanteD,
        idEmpleadoTutor: serial.idEmpleadoTutor,
        seccionId: serial.seccionId,
        periodoId: serial.periodoId);
  }

  static List<NivelAcademicoData> converListSerializeNivelAcademico(dynamic model){
    List<NivelAcademicoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeNivelAcademico(item));
    }
    return items;
  }

  static NivelAcademicoData converSerializeNivelAcademico(Map<String,dynamic> model){
    NivelAcademicoSeraializable serial = NivelAcademicoSeraializable.fromJson(model);
    return NivelAcademicoData(
        nivelAcadId: serial.nivelAcadId??0,
        nombre: serial.nombre,
        activo: serial.activo,
        entidadId: serial.entidadId);
  }

  static List<AsistenciaAlumno> converListSerializeAsistenciaAlumnos(dynamic model){
    List<AsistenciaAlumno> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeAsistenciaAlumnos(item));
    }
    return items;
  }

  static AsistenciaAlumno converSerializeAsistenciaAlumnos(Map<String,dynamic> model){
    AsistenciaAlumnosSerializable serial = AsistenciaAlumnosSerializable.fromJson(model);
    return AsistenciaAlumno(
        asistenciaSesionId: serial.asistenciaSesionId??"",
        fechaAsistenciaN: serial.fechaAsistenciaN,
        hora: serial.hora,
        georeferenciaId: serial.georeferenciaId,
        alumnoId: serial.alumnoId,
        sesionAprendizajeId: serial.sesionAprendizajeId,
        calendarioPeriodoId: serial.calendarioPeriodoId,
        cargaCursoId: serial.cargaCursoId,
        valorTipoNotaId: serial.valorTipoNotaId,
        asistenciaSesionIdAndroid: serial.asistenciaSesionIdAndroid,
        periodoId: serial.periodoId,
        docenteId: serial.docenteId,
        grupoId: serial.grupoId,
        fechaAsistenciaS: serial.fechaAsistenciaS,
        nombreCurso: serial.nombreCurso,
        gradoId: serial.grupoId,
        grado: serial.grado,
        seccionId: serial.seccionId,
        seccion: serial.seccion,
        silaboEventoId: serial.silaboEventoId,
        parametroDesenioId: serial.parametroDesenioId,
        correoDocente: serial.correoDocente,
        celularDocente: serial.celularDocente,
        telefonoDocente: serial.telefonoDocente,
        fotoDocente: serial.fotoDocente,
        nombreDocente: serial.nombreDocente,
        personaIdDocente: serial.personaIdDocente,
        anioAcademicoId: serial.anioAcademicoId,
        programaAcadId: serial.programaAcadId,
        fechaAsistenciaTime: AppTools.convertDateTimePtBR(serial.fechaAsistenciaN, serial.hora));
  }

  static List<AsistenciaJustificacionData> converListSerializeAsistenciaJustificacion(dynamic model){
    List<AsistenciaJustificacionData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeAsistenciaJustificacion(item));
    }
    return items;
  }

  static AsistenciaJustificacionData converSerializeAsistenciaJustificacion(Map<String,dynamic> model){
    AsistenciaJustificacionSerializable serial = AsistenciaJustificacionSerializable.fromJson(model);
    return AsistenciaJustificacionData(
        justificacionId: serial.justificacionId??"",
        asistenciaId: serial.asistenciaId,
        descripcion: serial.descripcion,
        tipoJustificacionId: serial.tipoJustificacionId,
        tipoIngresoId: serial.tipoIngresoId,
        asistenciaSesionId: serial.asistenciaSesionId,
        asistenciaDocenteId: serial.asistenciaDocenteId);
  }

  static List<AsistecniaArchivoData> converListSerializeAsistecniaArchivo(dynamic model){
    List<AsistecniaArchivoData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeAsistecniaArchivo(item));
    }
    return items;
  }

  static AsistecniaArchivoData converSerializeAsistecniaArchivo(Map<String,dynamic> model){
    AsistecniaArchivoSerializable serial = AsistecniaArchivoSerializable.fromJson(model);
    return AsistecniaArchivoData(
        archivoAsistenciaId: serial.archivoAsistenciaId??"",
        path: serial.path,
        nombre: serial.nombre,
        tipoId: serial.tipoId,
        justificacionId: serial.justificacionId,
        pathLectura: serial.pathLectura);
  }

  static List<AsistenciaTipoNotaData> converListSerializeAsistenciaTipoNota(dynamic model){
    List<AsistenciaTipoNotaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeAsistecniaAsistenciaTipoNota(item));
    }
    return items;
  }

  static AsistenciaTipoNotaData converSerializeAsistecniaAsistenciaTipoNota(Map<String,dynamic> model){
    AsistenciaTipoNotaSerializable serial = AsistenciaTipoNotaSerializable.fromJson(model);
    return AsistenciaTipoNotaData(
        tipoNotaId: serial.tipoNotaId??"",
        nombre: serial.nombre,
        tipoId: serial.tipoId,
        valorDefecto: serial.valorDefecto,
        valorMaximo: serial.valorMaximo,
        valorMinino: serial.valorMinino,
        longitudPaso: serial.longitudPaso,
        intervalo: serial.intervalo,
        estatico: serial.estatico,
        entidadId: serial.entidadId,
        georeferenciaId: serial.georeferenciaId,
        organigramaId: serial.organigramaId,
        estadoId: serial.estadoId,
        tipoFuenteId: serial.tipoFuenteId,
        escalaEvaluacionId:serial.escalaEvaluacionId);
  }

  static List<AsistenciaValorTipoNotaData> converListSerializeAsistenciaValorTipoNota(dynamic model){
    List<AsistenciaValorTipoNotaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeAsistenciaValorTipoNota(item));
    }
    return items;
  }

  static AsistenciaValorTipoNotaData converSerializeAsistenciaValorTipoNota(Map<String,dynamic> model){
    AsistenciaValorTipoNotaSerializable serial = AsistenciaValorTipoNotaSerializable.fromJson(model);
    return AsistenciaValorTipoNotaData(
        valorTipoNotaId: serial.valorTipoNotaId??"",
        tipoNotaId: serial.tipoNotaId,
        titulo: serial.titulo,
        tipoNotaAlias: serial.alias,
        limiteInferior: serial.limiteInferior,
        limiteSuperior: serial.limiteSuperior,
        valorNumerico: serial.valorNumerico,
        icono: serial.icono,
        estadoId: serial.estadoId,
        incluidoLInferior: serial.incluidoLInferior,
        incluidoLSuperior: serial.incluidoLSuperior,
        tipoId: serial.tipoId);
  }

  static List<AsistenciaRelProgramaTipoNotaData> converListSerializeAsistenciaRelProgramaTipoNota(dynamic model){
    List<AsistenciaRelProgramaTipoNotaData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeAsisteciaRelProgramaTipoNota(item));
    }
    return items;
  }

  static AsistenciaRelProgramaTipoNotaData converSerializeAsisteciaRelProgramaTipoNota(Map<String,dynamic> model){
    AsistenciaRelProgramaTipoNotaSerializable serial = AsistenciaRelProgramaTipoNotaSerializable.fromJson(model);
    return AsistenciaRelProgramaTipoNotaData(
        programaEducativoId: serial.programaEducativoId??0,
        tipoNotaId: serial.tipoNotaId,
        estado: serial.estado);
  }

  static List<AsistenciaGeneralData> converListSerializeAsistenciaGeneral(dynamic model){
    List<AsistenciaGeneralData> items = [];
    Iterable l = model;
    for(var item in l){
      items.add(converSerializeAsistenciaGeneral(item));
    }
    return items;
  }

  static AsistenciaGeneralData converSerializeAsistenciaGeneral(Map<String,dynamic> model){
    AsistenciaGeneralSerializable serial = AsistenciaGeneralSerializable.fromJson(model);
    return AsistenciaGeneralData(
        controlAsistenciaId: serial.controlAsistenciaId??0,
        alumnoId: serial.alumnoId,
        calendarioPeriodoId: serial.calendarioPeriodoId,
        grupoId: serial.grupoId,
        periodoId: serial.periodoId,
        programaEducativoId: serial.programaEducativoId,
        docenteId: serial.docenteId,
        georeferenciaId: serial.georeferenciaId,
        fechaAsistencia: serial.fechaAsistencia,
        horaIngreso: serial.horaIngreso,
        horaSalida: serial.horaSalida,
        estadoIngresoId: serial.estadoIngresoId,
        estadosIngresoNombre: serial.estadosIngresoNombre,
        estadoSalidaId: serial.estadoSalidaId,
        estadosSalidaNombre: serial.estadosSalidaNombre,
        observaciones: serial.observaciones);
  }
}

