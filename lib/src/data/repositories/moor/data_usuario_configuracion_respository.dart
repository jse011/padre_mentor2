import 'package:moor_flutter/moor_flutter.dart';
import 'package:padre_mentor/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:padre_mentor/src/data/repositories/moor/database/app_database.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/persona.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/programas_educativo.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/silabo_evento.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/usuario_rol_georeferencia.dart';
import 'package:padre_mentor/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:padre_mentor/src/domain/entities/contacto_ui.dart';
import 'package:padre_mentor/src/domain/entities/evento_adjunto_ui.dart';
import 'package:padre_mentor/src/domain/entities/evento_ui.dart';
import 'package:padre_mentor/src/domain/entities/familia_ui.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/entities/login_ui.dart';
import 'package:padre_mentor/src/domain/entities/programa_educativo_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_evento_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_recursos_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';
import 'package:padre_mentor/src/domain/repositories/usuario_configuarion_repository.dart';
import 'package:padre_mentor/src/domain/tools/app_tools.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:padre_mentor/src/domain/tools/domain_youtube_tools.dart';

class DataUsuarioAndRepository extends UsuarioAndConfiguracionRepository{
  static const int TIPO_VIDEO = 379, TIPO_VINCULO = 380, TIPO_DOCUMENTO = 397, TIPO_IMAGEN = 398, TIPO_AUDIO = 399, TIPO_HOJA_CALCULO = 400, TIPO_DIAPOSITIVA = 401, TIPO_PDF = 402,  TIPO_YOUTUBE = 581,TIPO_ENCUESTA = 630;
  static const TAG = 'DataUsuarioAndRepository';
  // sigleton
  static final DataUsuarioAndRepository _instance = DataUsuarioAndRepository._internal();
  DataUsuarioAndRepository._internal() {
  }

  factory DataUsuarioAndRepository() => _instance;

  @override
  Future<UsuarioUi> getSessionUsuario() async{
    print("getSessionUsuario" );
    AppDataBase SQL = AppDataBase();
    int usuarioId = await getSessionUsuarioId();

    var query =  await SQL.selectSingle(SQL.persona).join([
      innerJoin(SQL.usuario, SQL.usuario.personaId.equalsExp(SQL.persona.personaId))
    ]);
    query.where(SQL.usuario.usuarioId.equals(usuarioId));
    var resultRow = await query.getSingleOrNull();
    PersonaData? personaData = resultRow?.readTable(SQL.persona);

    var queryRelaciones =  await SQL.select(SQL.persona).join([
      innerJoin(SQL.relaciones, SQL.relaciones.personaPrincipalId.equalsExp(SQL.persona.personaId))
    ]);
    queryRelaciones.where(SQL.relaciones.personaVinculadaId.equals(personaData?.personaId));
    var rowRelaciones = await queryRelaciones.get();
    List<HijosUi> hijos = [];
    List<int> hijosIdList = [];
    for(var hijo in rowRelaciones){
      PersonaData personaData = hijo.readTable(SQL.persona);
      hijosIdList.add(personaData.personaId);
      String fechaNacimientoHijo = "";
      if((personaData.fechaNac??"").isNotEmpty){
        DateTime fecPad = AppTools.convertDateTimePtBR(personaData.fechaNac, null);
        fechaNacimientoHijo = "${AppTools.calcularEdad(fecPad)} años (${AppTools.f_fecha_anio_mes_letras(fecPad)})";
      }

      UsuarioData? usuarioData = await (SQL.select(SQL.usuario)..where((tbl) => tbl.personaId.equals(personaData.personaId))).getSingleOrNull();
      hijos.add(HijosUi(usuarioId: usuarioData==null ? 0 : usuarioData.usuarioId, personaId: personaData.personaId, nombre: personaData == null ? '' : '${AppTools.capitalize(personaData.nombres??"")} ${AppTools.capitalize(personaData.apellidoPaterno??"")} ${AppTools.capitalize(personaData.apellidoMaterno??"")}', foto: personaData.foto==null?'':'${AppTools.capitalize(personaData.foto??"")}',documento: personaData.numDoc, celular: personaData.celular??personaData.telefono??'', correo: personaData.correo, fechaNacimiento: fechaNacimientoHijo, fechaNacimiento2:  personaData.fechaNac));
    }
    String fechaNacimientoPadre = "";
    if((personaData?.fechaNac??"").isNotEmpty){
      DateTime fecPad = AppTools.convertDateTimePtBR(personaData?.fechaNac, null);
      fechaNacimientoPadre = "${AppTools.calcularEdad(fecPad)} años (${AppTools.f_fecha_anio_mes_letras(fecPad)})";

    }
    print("getSessionUsuario 1" );
    List<FamiliaUi> familiaUiList = [];

    var queryFamiliare =  await SQL.select(SQL.persona).join([
      innerJoin(SQL.relaciones, SQL.relaciones.personaVinculadaId.equalsExp(SQL.persona.personaId)),
      //innerJoin(SQL.tipos, SQL.tipos.tipoId.equalsExp(SQL.relaciones.tipoId))
    ]);

    queryFamiliare.where(SQL.relaciones.personaPrincipalId.isIn(hijosIdList));
    queryFamiliare.where(SQL.persona.personaId.isNotIn([personaData?.personaId]));
    queryFamiliare.groupBy([SQL.persona.personaId]);
    var rowFamiliares = await queryFamiliare.get();
    for(var familia in rowFamiliares){
      PersonaData personaData = familia.readTable(SQL.persona);
      //Tipo relacion = familia.readTable(SQL.relaciones);

      hijosIdList.add(personaData.personaId);
      String fechaNacimientoHijo = "";
      if((personaData.fechaNac??"").isNotEmpty){
        DateTime fecPad = AppTools.convertDateTimePtBR(personaData.fechaNac, null);
        fechaNacimientoHijo = "${AppTools.calcularEdad(fecPad)} años (${AppTools.f_fecha_anio_mes_letras(fecPad)})";
      }

      familiaUiList.add(FamiliaUi(personaId: personaData.personaId, nombre: personaData == null ? '' : '${AppTools.capitalize(personaData.nombres??"")} ${AppTools.capitalize(personaData.apellidoPaterno??"")} ${AppTools.capitalize(personaData.apellidoMaterno??"")}', foto: personaData.foto==null?'':'${AppTools.capitalize(personaData.foto??"")}',documento: personaData.numDoc, celular: personaData.celular??personaData.telefono??'', correo: personaData.correo, fechaNacimiento: fechaNacimientoHijo, relacion: "Familiar", fechaNacimiento2: personaData.fechaNac));
    }
    print("getSessionUsuario 2" );
    UsuarioUi usuarioUi = UsuarioUi(personaId: personaData == null ? 0 : personaData.personaId ,
        nombre: personaData == null ? '' : '${AppTools.capitalize(personaData.nombres??"")} ${AppTools.capitalize(personaData.apellidoPaterno??"")} ${AppTools.capitalize(personaData.apellidoMaterno??"")}',
        foto: personaData?.foto==null?'':'${AppTools.capitalize(personaData?.foto??"")}',
        hijos: hijos, correo: personaData?.correo, celular: personaData?.celular??personaData?.telefono??"", fechaNacimiento: fechaNacimientoPadre, familiaUiList: familiaUiList, nombreSimple: AppTools.capitalize(personaData?.nombres??""), fechaNacimiento2: personaData?.fechaNac);



    /*
      * Obtner el Programa de los Alumnos
      *PRE_MATRICULA = 189, MATRICULA = 190;
      *ANIO_ACADEMICO_MATRICULA = 192, ANIO_ACADEMICO_ACTIVO = 193, ANIO_ACADEMICO_CERRADO = 194, ANIO_ACADEMICO_CREADO = 195, ANIO_ACADEMICO_ELIMINADO = 196;
      * */

    var queryPrograma=  await SQL.select(SQL.programasEducativo).join([
      innerJoin(SQL.planEstudio, SQL.planEstudio.programaEduId.equalsExp(SQL.programasEducativo.programaEduId)),
      innerJoin(SQL.planCursos, SQL.planCursos.planEstudiosId.equalsExp(SQL.planEstudio.planEstudiosId)),
      innerJoin(SQL.cargaCurso, SQL.cargaCurso.planCursoId.equalsExp(SQL.planCursos.planCursoId)),
      innerJoin(SQL.detalleContratoAcad, SQL.detalleContratoAcad.cargaCursoId.equalsExp(SQL.cargaCurso.cargaCursoId)),
      innerJoin(SQL.anioAcademicoAlumno, SQL.anioAcademicoAlumno.idAnioAcademico.equalsExp(SQL.detalleContratoAcad.anioAcademicoId)),
      innerJoin(SQL.contrato, SQL.contrato.idContrato.equalsExp(SQL.detalleContratoAcad.idContrato)),
      innerJoin(SQL.persona, SQL.contrato.personaId.equalsExp(SQL.persona.personaId)),
    ]);
    queryPrograma.where(SQL.contrato.personaId.equalsExp(SQL.anioAcademicoAlumno.personaId));
    queryPrograma.where(SQL.contrato.estadoId.equals(190));
    //queryPrograma.where(SQL.anioAcademicoAlumno.estadoId.equals(193));


    queryPrograma.groupBy([SQL.programasEducativo.programaEduId, SQL.anioAcademicoAlumno.idAnioAcademico, SQL.anioAcademicoAlumno.personaId]);

    var rowPrograma = await queryPrograma.get();

    print("getSessionUsuario 3" );
    rowPrograma.sort((a, b) => AppTools.convertDateTimePtBR(b.readTable(SQL.anioAcademicoAlumno).fechaInicio, null).compareTo(AppTools.convertDateTimePtBR(a.readTable(SQL.anioAcademicoAlumno).fechaInicio, null)));
    List<ProgramaEducativoUi> programaEducativoUiList = [];
    for(var programa in rowPrograma){
      ProgramasEducativoData programasEducativoData = programa.readTable(SQL.programasEducativo);
      PlanEstudioData planEstudioData = programa.readTable(SQL.planEstudio);
      AnioAcademicoAlumnoData academicoAlumnoData = programa.readTable(SQL.anioAcademicoAlumno);
      PersonaData personaData = programa.readTable(SQL.persona);

      UsuarioData? usuarioData = await (SQL.select(SQL.usuario)..where((tbl) => tbl.personaId.equals(academicoAlumnoData.personaId))).getSingleOrNull();

      programaEducativoUiList.add(ProgramaEducativoUi(
          programaId: programasEducativoData.programaEduId,
          nombrePrograma: programasEducativoData.nombre,
          hijoId: personaData.personaId,
          nombreHijo: '${AppTools.capitalize(personaData.nombres??"")} ${AppTools.capitalize(personaData.apellidoPaterno??"")} ${AppTools.capitalize(personaData.apellidoMaterno??"")}',
          fotoHijo: personaData.foto==null?'':'${AppTools.capitalize(personaData.foto??"")}',
          anioAcademicoId: academicoAlumnoData.idAnioAcademico,
          nombreAnioAcademico: academicoAlumnoData.nombre,
          alumnoId: usuarioData==null ? 0 : usuarioData.usuarioId,
          cerrado: academicoAlumnoData.estadoId == 194 ||academicoAlumnoData.estadoId == 196
      ));

    }
    print("getSessionUsuario 4" );
    usuarioUi.programaEducativoUiList = programaEducativoUiList;

    SessionUserData? sessionUserData = await (SQL.selectSingle(SQL.sessionUser)).getSingleOrNull();
    int hijoIdSelected = sessionUserData?.hijoIdSelect??0;

    if(hijoIdSelected==null || hijoIdSelected == 0 && sessionUserData != null){
      if((usuarioUi.hijos??[]).isNotEmpty){
        hijoIdSelected = usuarioUi.hijos![0].personaId??0;
        await SQL.update(SQL.sessionUser).replace(sessionUserData!.copyWith(hijoIdSelect: hijoIdSelected));
      }
    }
    print("getSessionUsuario 5" );
    if(hijoIdSelected!=null && hijoIdSelected > 0){
      if((usuarioUi.hijos??[]).isNotEmpty){

        usuarioUi.hijoSelected = usuarioUi.hijos?.firstWhereOrNull((element) => element.personaId == hijoIdSelected);
        if(usuarioUi.hijoSelected==null){
          usuarioUi.hijoSelected = usuarioUi.hijos![0];
        }
        var rowSessionUsuarioPrograma = SQL.selectSingle(SQL.sessionUserHijoPrograma)..where((tbl) => tbl.hijoId.equals(hijoIdSelected));
        rowSessionUsuarioPrograma.where((tbl) => tbl.selected.equals(true));
        SessionUserHijoProgramaData? sessionUserHijoData = await rowSessionUsuarioPrograma.getSingleOrNull();
        int programaIdSelected = sessionUserHijoData != null?sessionUserHijoData.prograAcademicoId : 0;
        int anioAcademicoIdSelected = sessionUserHijoData != null?sessionUserHijoData.anioAcademicoId : 0;
        print(TAG+ " programaEduSelectedId:" + programaIdSelected.toString() + ", hijoSelectedId:" + hijoIdSelected.toString() +", anioAcademicoId: "+anioAcademicoIdSelected.toString());
        usuarioUi.programaEducativoUiSelected = usuarioUi.programaEducativoUiList?.firstWhereOrNull((element) =>
        element.programaId == programaIdSelected && element.anioAcademicoId == anioAcademicoIdSelected && element.hijoId == hijoIdSelected);
        if(usuarioUi.programaEducativoUiSelected==null){
          usuarioUi.programaEducativoUiSelected = usuarioUi.programaEducativoUiList?.firstWhereOrNull((element) => element.hijoId==hijoIdSelected);
        }
        print(TAG+ "programaEducativoUiSelected " +(usuarioUi.programaEducativoUiSelected!=null?"true":"false"));

      }
    }
    print("getSessionUsuario 6" );

    return usuarioUi;
    //var resultRow = rows.single;
  }

  @override
  Future<void> saveDatosGlobales(Map<String, dynamic>? datosInicioPadre) async{
   AppDataBase SQL = AppDataBase();
   try{
     await SQL.batch((batch) async {
       // functions in a batch don't have to be awaited - just
       // await the whole batch afterwards.

       print("saveDatosGlobales");
       if(datosInicioPadre?.containsKey("usuariosrelacionados")??false){
         batch.deleteWhere(SQL.usuario, (row) => const Constant(true));
         batch.insertAll(SQL.usuario, SerializableConvert.converListSerializeUsuario(datosInicioPadre!["usuariosrelacionados"]), mode: InsertMode.insertOrReplace );
       }

       if(datosInicioPadre?.containsKey("personas")??false){
         //personaSerelizable.addAll(datosInicioPadre["usuariosrelacionados"]);
         //database.personaDao.insertAllTodo(SerializableConvert.converListSerializePersona(datosInicioPadre["personas"]));
         batch.deleteWhere(SQL.persona, (row) => const Constant(true));
         batch.insertAll(SQL.persona, SerializableConvert.converListSerializePersona(datosInicioPadre!["personas"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("relaciones")??false){
         //personaSerelizable.addAll(datosInicioPadre["usuariosrelacionados"]);
         batch.deleteWhere(SQL.relaciones, (row) => const Constant(true));
         batch.insertAll(SQL.relaciones, SerializableConvert.converListSerializeRelaciones(datosInicioPadre!["relaciones"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("anioAcademicosAlumno")??false){
         batch.deleteWhere(SQL.anioAcademicoAlumno, (row) => const Constant(true));
         batch.insertAll(SQL.anioAcademicoAlumno, SerializableConvert.converListSerializeAnioAcademicoAlumno(datosInicioPadre!["anioAcademicosAlumno"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("cargaCursos")??false){
         batch.deleteWhere(SQL.cargaCurso, (row) => const Constant(true));
         batch.insertAll(SQL.cargaCurso, SerializableConvert.converListSerializeCargaCurso(datosInicioPadre!["cargaCursos"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("contratos")??false){
         batch.deleteWhere(SQL.contrato, (row) => const Constant(true));
         batch.insertAll(SQL.contrato, SerializableConvert.converListSerializeContrato(datosInicioPadre!["contratos"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("detalleContratoAcad")??false){
         batch.deleteWhere(SQL.detalleContratoAcad, (row) => const Constant(true));
         batch.insertAll(SQL.detalleContratoAcad, SerializableConvert.converListSerializeDetalleContratoAcad(datosInicioPadre!["detalleContratoAcad"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("planCursos")??false){
         batch.deleteWhere(SQL.planCursos, (row) => const Constant(true));
         batch.insertAll(SQL.planCursos, SerializableConvert.converListSerializePlanCurso(datosInicioPadre!["planCursos"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("planEstudios")??false){
         batch.deleteWhere(SQL.planEstudio, (row) => const Constant(true));
         batch.insertAll(SQL.planEstudio, SerializableConvert.converListSerializePlanEstudio(datosInicioPadre!["planEstudios"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("programasEducativos")??false){
         batch.deleteWhere(SQL.programasEducativo, (row) => const Constant(true));
         batch.insertAll(SQL.programasEducativo, SerializableConvert.converListSerializeProgramasEducativo(datosInicioPadre!["programasEducativos"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("calendarioPeriodos")??false){
         batch.deleteWhere(SQL.calendarioPeriodo, (row) => const Constant(true));
         batch.insertAll(SQL.calendarioPeriodo, SerializableConvert.converListSerializeCalendarioPeriodo(datosInicioPadre!["calendarioPeriodos"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("calendarioAcademicos")??false){
         batch.deleteWhere(SQL.calendarioAcademico, (row) => const Constant(true));
         batch.insertAll(SQL.calendarioAcademico, SerializableConvert.converListSerializeCalendarioAcademico(datosInicioPadre!["calendarioAcademicos"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("tipos")??false){

         batch.insertAll(SQL.tipos, SerializableConvert.converListSerializeTipos(datosInicioPadre!["tipos"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("obtener_parametros_disenio")??false){
         batch.deleteWhere(SQL.parametrosDisenio, (row) => const Constant(true));
         batch.insertAll(SQL.parametrosDisenio, SerializableConvert.converListSerializeParametrosDisenio(datosInicioPadre!["obtener_parametros_disenio"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("silaboEvento")??false){
         batch.deleteWhere(SQL.silaboEvento, (row) => const Constant(true));
         batch.insertAll(SQL.silaboEvento, SerializableConvert.converListSerializeSilaboEvento(datosInicioPadre!["silaboEvento"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("cursos")??false){
         batch.deleteWhere(SQL.cursos, (row) => const Constant(true));
         batch.insertAll(SQL.cursos, SerializableConvert.converListSerializeCursos(datosInicioPadre!["cursos"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("secciones")??false){
         batch.deleteWhere(SQL.seccion, (row) => const Constant(true));
         batch.insertAll(SQL.seccion, SerializableConvert.converListSerializeSeccion(datosInicioPadre!["secciones"]), mode: InsertMode.insertOrReplace);
       }
       if(datosInicioPadre?.containsKey("aulas")??false){
         batch.deleteWhere(SQL.aula, (row) => const Constant(true));
         batch.insertAll(SQL.aula, SerializableConvert.converListSerializeAula(datosInicioPadre!["aulas"]), mode: InsertMode.insertOrReplace);
       }
       if(datosInicioPadre?.containsKey("periodos")??false){
         batch.deleteWhere(SQL.periodos, (row) => const Constant(true));
         batch.insertAll(SQL.periodos, SerializableConvert.converListSerializePeriodos(datosInicioPadre!["periodos"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("cargasAcademicas")??false){
         batch.deleteWhere(SQL.cargaAcademica, (row) => const Constant(true));
         batch.insertAll(SQL.cargaAcademica, SerializableConvert.converListSerializeCargaAcademica(datosInicioPadre!["cargasAcademicas"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("nivelesAcademicos")??false){
         batch.deleteWhere(SQL.nivelAcademico, (row) => const Constant(true));
         batch.insertAll(SQL.nivelAcademico, SerializableConvert.converListSerializeNivelAcademico(datosInicioPadre!["nivelesAcademicos"]), mode: InsertMode.insertOrReplace);
       }

       if(datosInicioPadre?.containsKey("bEWebConfigs")??false){
         batch.deleteWhere(SQL.webConfigs, (row) => const Constant(true));
         batch.insertAll(SQL.webConfigs, SerializableConvert.converListSerializeWebConfigs(datosInicioPadre!["bEWebConfigs"]), mode: InsertMode.insertOrReplace);
       }

     });
   }catch(e){
     throw Exception(e);
   }
  }

  @override
  Future<HijosUi> getHijo(int alumnoId) async {
    print("getHijo" );
    AppDataBase SQL = AppDataBase();
    try{

      PersonaData? personaData = await (SQL.selectSingle(SQL.persona)..where((tbl) => tbl.personaId.equals(alumnoId))).getSingleOrNull();
      UsuarioData? usuarioData = await (SQL.select(SQL.usuario)..where((tbl) => tbl.personaId.equals(alumnoId))).getSingleOrNull();
      return HijosUi(usuarioId: usuarioData==null ? 0 : usuarioData.usuarioId, personaId: personaData?.personaId, nombre: personaData == null ? '' : '${AppTools.capitalize(personaData.nombres??"")} ${AppTools.capitalize(personaData.apellidoPaterno??"")} ${AppTools.capitalize(personaData.apellidoMaterno??"")}', foto: personaData?.foto==null?'':'${AppTools.capitalize(personaData?.foto??"")}',documento: personaData?.numDoc, celular: personaData?.celular??personaData?.telefono??'', correo: personaData?.correo, fechaNacimiento: "", fechaNacimiento2: personaData?.fechaNac);

    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> saveEventoAgenda(Map<String, dynamic> eventoAgenda, int usuarioId, int tipoEventoId, List<int> hijoIdList) async{
    AppDataBase SQL = AppDataBase();
    try{
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      String string = dateFormat.format(DateTime.now());
      print("saveEventoAgenda tipoEventoId : "+tipoEventoId.toString());
      await SQL.transaction(() async {

        List<CalendarioData> calendarioDataList = [];
        var queryCalendario = SQL.select(SQL.calendario).join([
          innerJoin(SQL.evento,SQL.calendario.calendarioId.equalsExp(SQL.evento.calendarioId))
        ]);

        queryCalendario.where(SQL.evento.usuarioReceptorId.equals(usuarioId));
        if(tipoEventoId > 0){
          queryCalendario.where(SQL.evento.tipoEventoId.equals(tipoEventoId));
        }

        //queryCalendario.groupBy([SQL.calendario.calendarioId]);
        var rows = await queryCalendario.get();
        /*print("saveEventoAgenda cantidad : "+rows.length.toString());*/
        for (var row in rows) {
          CalendarioData calendarioData = row.readTable(SQL.calendario);
          EventoData eventoData = row.readTable(SQL.evento);
          if(hijoIdList != null && hijoIdList.isNotEmpty && (eventoData.eventoHijoId??0)> 0){
            int id = hijoIdList.firstWhere((hijoId) => hijoId == eventoData.eventoHijoId, orElse:()=> -1);
            if(id!=-1)continue;
          }
          await (SQL.delete(SQL.evento).delete(eventoData));
          await (SQL.delete(SQL.eventoAdjunto)..where((tbl) => tbl.eventoId.equals(eventoData.eventoId))).go();
          if(calendarioDataList.firstWhereOrNull((element) => element.calendarioId == calendarioData.calendarioId) == null){
            calendarioDataList.add(calendarioData);
          }
        }

        for(CalendarioData calendarioData in calendarioDataList){
          List<EventoData> eventoDataList = await (SQL.select(SQL.evento)..where((tbl) => tbl.calendarioId.equals(calendarioData.calendarioId))).get();
          if(eventoDataList==null||eventoDataList.isEmpty){
            await (SQL.delete(SQL.calendario).delete(calendarioData));
          }
        }
        var query = SQL.select(SQL.tipos)..where((tbl) => tbl.concepto.equals("TipoEvento"));
        query.where((tbl) => tbl.objeto.equals("T_CE_MOV_EVENTOS"));
        /*EVENTO=526, ACTIVIDAD=528, CITA=530, TAREA=529, NOTICIA=527, AGENDA = 620;
        * */
        List<Tipo> tipos =  await query.get();
        for(Tipo tipo in tipos){
          await (SQL.delete(SQL.tipos).delete(tipo));
        }

      });


      await SQL.batch((batch) async {

        //
        print("saveEventoAgenda tipoEventoId : "+tipoEventoId.toString());

        if(eventoAgenda.containsKey("calendarios")){
          //personaSerelizable.addAll(datosInicioPadre["usuariosrelacionados"]);
          //database.personaDao.insertAllTodo(SerializableConvert.converListSerializePersona(datosInicioPadre["personas"]));
          batch.insertAll(SQL.calendario, SerializableConvert.converListSerializeCalendario(eventoAgenda["calendarios"]), mode: InsertMode.insertOrReplace);
        }

        if(eventoAgenda.containsKey("eventoAdjuntos")){
          batch.insertAll(SQL.eventoAdjunto, SerializableConvert.converListSerializeEventoAjunto(eventoAgenda["eventoAdjuntos"]), mode: InsertMode.insertOrReplace );
        }

        if(eventoAgenda.containsKey("eventos")){
          batch.insertAll(SQL.evento, SerializableConvert.converListSerializeEvento(eventoAgenda["eventos"]), mode: InsertMode.insertOrReplace );
        }

        if(eventoAgenda.containsKey("tipos")){
          //personaSerelizable.addAll(datosInicioPadre["usuariosrelacionados"]);
          batch.insertAll(SQL.tipos, SerializableConvert.converListSerializeTipos(eventoAgenda["tipos"]), mode: InsertMode.insertOrReplace);
        }

      });
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<TipoEventoUi>> getTiposEvento()async {

      AppDataBase SQL = AppDataBase();
      try{

        List<TipoEventoUi> tipoEventoUiList = [];
        var query = SQL.select(SQL.tipos)..where((tbl) => tbl.concepto.equals("TipoEvento"));
        query.where((tbl) => tbl.objeto.equals("T_CE_MOV_EVENTOS"));
        /*EVENTO=526, ACTIVIDAD=528, CITA=530, TAREA=529, NOTICIA=527, AGENDA = 620;
        * */
        List<Tipo> tipos =  await query.get();
        for(Tipo item in tipos){
          TipoEventoUi tipoEventoUi = TipoEventoUi();
          tipoEventoUi.id = item.tipoId;
          tipoEventoUi.nombre = item.nombre;
          switch(item.tipoId){
            case 526:
              tipoEventoUi.tipo = EventoIconoEnumUI.EVENTO;
              break;
            case 528:
              tipoEventoUi.tipo = EventoIconoEnumUI.ACTIVIDAD;
              break;
            case 530:
              tipoEventoUi.tipo = EventoIconoEnumUI.CITA;
              break;
            case 529:
              tipoEventoUi.tipo = EventoIconoEnumUI.TAREA;
              break;
            case 527:
              tipoEventoUi.tipo = EventoIconoEnumUI.NOTICIA;
              break;
            case 620:
              tipoEventoUi.tipo = EventoIconoEnumUI.AGENDA;
              break;
            default:
              tipoEventoUi.tipo = EventoIconoEnumUI.DEFAULT;
              break;
          }

          tipoEventoUiList.add(tipoEventoUi);
        }

        TipoEventoUi tipoEventoUi = TipoEventoUi();
        tipoEventoUi.id = 0;
        tipoEventoUi.nombre = "Todos";
        tipoEventoUi.tipo = EventoIconoEnumUI.TODOS;
        tipoEventoUiList.add(tipoEventoUi);

        return tipoEventoUiList;
      }catch(e){
        throw Exception(e);
      }
  }

  @override
  Future<List<EventoUi>> getEventosAgenda(int padreId, int tipoEventoId, List<int> hijos) async{

    AppDataBase SQL = AppDataBase();
    try{

      List<EventoUi> eventoUiList = [];
      var query = SQL.select(SQL.evento).join([
        innerJoin(SQL.calendario, SQL.evento.calendarioId.equalsExp(SQL.calendario.calendarioId)),
      ]);
      query.where(SQL.evento.usuarioReceptorId.equals(padreId));
      print("getEventosAgenda tipoEventoId : "+tipoEventoId.toString());
      if(tipoEventoId>0){
        query.where(SQL.evento.tipoEventoId.equals(tipoEventoId));
      }
      //else{
        //query.where(SQL.evento.tipoEventoId.equals(529));
      //}
      query.orderBy([
        OrderingTerm(expression: SQL.evento.fechaEventoTime, mode: OrderingMode.desc)
      ]);
      var rows = await query.get();
      for(var item in  rows){
        EventoData eventoData = item.readTable(SQL.evento);
        CalendarioData calendarioData = item.readTable(SQL.calendario);
        if(hijos != null && hijos.isNotEmpty && (eventoData.eventoHijoId??0) > 0){
            int id = hijos.firstWhere((hijoId) => hijoId == eventoData.eventoHijoId, orElse:()=> -1);
            if(id!=-1)continue;
        }
        EventoUi eventoUi = new EventoUi();
        eventoUi.id = eventoData.eventoId;
        eventoUi.nombreEntidad = eventoData.nombreEntidad;
        eventoUi.fotoEntidad = eventoData.fotoEntidad;
        eventoUi.cantLike =  eventoData.likeCount;
        eventoUi.titulo = eventoData.titulo;
        eventoUi.descripcion = eventoData.descripcion;
        eventoUi.fecha =  eventoData.fechaEvento!=null?AppTools.convertDateTimePtBR(eventoData.fechaEvento, eventoData.horaEvento):null;
        eventoUi.foto = eventoData.pathImagen;
        eventoUi.tipoEventoUi = TipoEventoUi();
        eventoUi.tipoEventoUi?.id = eventoData.tipoEventoId;
        eventoUi.tipoEventoUi?.nombre = eventoData.tipoEventoNombre;
        eventoUi.rolEmisor = calendarioData.cargo;
        eventoUi.nombreEmisor = calendarioData.nUsuario;

        switch(eventoUi.tipoEventoUi?.id){
          case 526:
            eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.EVENTO;
            break;
          case 528:
            eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.ACTIVIDAD;
            break;
          case 530:
            eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.CITA;
            break;
          case 529:
            eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.TAREA;
            break;
          case 527:
            eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.NOTICIA;
            break;
          case 620:
            eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.AGENDA;
            break;
          default:
            eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.DEFAULT;
            break;
        }
        await getEventoAdjunto(eventoUi);
        eventoUiList.add(eventoUi);
      }


      return eventoUiList;
    }catch(e){
      throw Exception(e);
    }
  }

  Future<void> getEventoAdjunto(EventoUi? eventoUi) async{
    AppDataBase SQL = AppDataBase();
    List<EventoAdjuntoData> eventoAdjuntoDataList = await (SQL.select(SQL.eventoAdjunto)..where((tbl) => tbl.eventoId.equals(eventoUi?.id))).get();
    List<EventoAdjuntoUi> eventoAdjuntoUiEncuestaList = [];
    List<EventoAdjuntoUi> eventoAdjuntoUiDownloadList = [];
    List<EventoAdjuntoUi> eventoAdjuntoUiPreviewList = [];
    List<EventoAdjuntoUi> eventoAdjuntoUiList = [];

/*
    eventoAdjuntoDataList.add(EventoAdjuntoData(
      eventoAdjuntoId: "121",
      titulo: "Mi documento pptx",
      driveId: "19folRaCmWHXfTTY_O46R4xSBSTkx8pKM",
      tipoId: TIPO_DIAPOSITIVA,
      eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento pptx",
        driveId: "19folRaCmWHXfTTY_O46R4xSBSTkx8pKM",
        tipoId: TIPO_DIAPOSITIVA,
        eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento pptx",
        driveId: "19folRaCmWHXfTTY_O46R4xSBSTkx8pKM",
        tipoId: TIPO_DIAPOSITIVA,
        eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento pptx",
        driveId: "19folRaCmWHXfTTY_O46R4xSBSTkx8pKM",
        tipoId: TIPO_DIAPOSITIVA,
        eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento pptx",
        driveId: "19folRaCmWHXfTTY_O46R4xSBSTkx8pKM",
        tipoId: TIPO_DIAPOSITIVA,
        eventoId: eventoUi?.id
    ));

    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento pptx",
        driveId: "1eBerHlMdqBxSkK-QGWVnjTzLUffZAvx4",
        tipoId: TIPO_IMAGEN,
        eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento pptx",
        driveId: "1LIICPqNx3UDquTB-ew0sZ4eRmrWCizJ1",
        tipoId: TIPO_IMAGEN,
        eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento.mp4",
        driveId: "16AgweRtjkBvqEu2e8zhnMVSbycyNDW2Y",
        tipoId: TIPO_VIDEO,
        eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "https://www.youtube.com/watch?v=tIDqVU15EBU&ab_channel=POCOY%C3%93enESPA%C3%91OL-CanalOficial",
        driveId: "1LIICPqNx3UDquTB-ew0sZ4eRmrWCizJ1",
        tipoId: TIPO_YOUTUBE,
        eventoId: eventoUi?.id
    ));
    eventoAdjuntoDataList.add(EventoAdjuntoData(
        eventoAdjuntoId: "121",
        titulo: "Mi documento.mp4",
        driveId: "16AgweRtjkBvqEu2e8zhnMVSbycyNDW2Y",
        tipoId: TIPO_VIDEO,
        eventoId: eventoUi?.id
    ));*/

    for(EventoAdjuntoData eventoAdjuntoData in eventoAdjuntoDataList){
      EventoAdjuntoUi eventoAdjuntoUi = EventoAdjuntoUi();
      eventoAdjuntoUi.eventoAdjuntoId = eventoAdjuntoData.eventoAdjuntoId;
      eventoAdjuntoUi.eventoId = eventoAdjuntoData.eventoId;
      eventoAdjuntoUi.driveId = eventoAdjuntoData.driveId;
      eventoAdjuntoUi.tipoId = eventoAdjuntoData.tipoId;
      eventoAdjuntoUi.titulo = eventoAdjuntoData.titulo;
      switch (eventoAdjuntoUi.tipoId){
        case TIPO_VIDEO:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_VIDEO;
          break;
        case TIPO_VINCULO:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_VINCULO;
          break;
        case TIPO_DOCUMENTO:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_DOCUMENTO;
          break;
        case TIPO_IMAGEN:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_IMAGEN;
          break;
        case TIPO_AUDIO:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_AUDIO;
          break;
        case TIPO_HOJA_CALCULO:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_HOJA_CALCULO;
          break;
        case TIPO_DIAPOSITIVA:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_DIAPOSITIVA;
          break;
        case TIPO_PDF:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_PDF;
          break;
        case TIPO_YOUTUBE:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_VINCULO_YOUTUBE;
          break;
        case TIPO_ENCUESTA:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_ENCUESTA;
          break;
        default:
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_VINCULO;//
          break;
      }

      if(eventoAdjuntoUi.tipoRecursosUi==TipoRecursosUi.TIPO_VIDEO){
        String? idYoutube = YouTubeUrlParser.getYoutubeVideoId(eventoAdjuntoUi.titulo);
        if((idYoutube??"").isEmpty){
          eventoAdjuntoUi.imagePreview = "https://drive.google.com/thumbnail?id=${eventoAdjuntoUi.driveId}";
        }else {
          eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_VINCULO_YOUTUBE;
          eventoAdjuntoUi.imagePreview = YouTubeThumbnail.getUrlFromVideoId(idYoutube,Quality.MEDIUM);
          eventoAdjuntoUi.yotubeId = idYoutube;
        }
      }else if(eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_VINCULO_YOUTUBE){
        String? idYoutube = YouTubeUrlParser.getYoutubeVideoId(eventoAdjuntoUi.titulo);
        print("idYoutube: ${idYoutube}");
        eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_VINCULO_YOUTUBE;
        eventoAdjuntoUi.imagePreview = YouTubeThumbnail.getUrlFromVideoId(idYoutube,Quality.MEDIUM);
        print("idYoutube: ${eventoAdjuntoUi.imagePreview}");
        eventoAdjuntoUi.yotubeId = idYoutube;
      }else if(eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_IMAGEN){
        eventoAdjuntoUi.imagePreview = "https://drive.google.com/uc?id=${eventoAdjuntoUi.driveId}";
      }

      if(eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_IMAGEN ||
          eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_VIDEO ||
          eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_VINCULO_YOUTUBE){
        eventoAdjuntoUiPreviewList.add(eventoAdjuntoUi);
      }else if(eventoAdjuntoUi.tipoRecursosUi == TipoRecursosUi.TIPO_ENCUESTA){
        eventoAdjuntoUiEncuestaList.add(eventoAdjuntoUi);
      }else{
        eventoAdjuntoUiDownloadList.add(eventoAdjuntoUi);
      }
      eventoAdjuntoUiList.add(eventoAdjuntoUi);
    }
    eventoUi?.eventoAdjuntoUiList = eventoAdjuntoUiList;
    eventoUi?.eventoAdjuntoUiEncuestaList = eventoAdjuntoUiEncuestaList;
    eventoUi?.eventoAdjuntoUiDownloadList = eventoAdjuntoUiDownloadList;
    eventoUi?.eventoAdjuntoUiPreviewList = eventoAdjuntoUiPreviewList;

    if(eventoUi?.tipoEventoUi == EventoIconoEnumUI.NOTICIA||
        eventoUi?.tipoEventoUi == EventoIconoEnumUI.EVENTO||
        (eventoUi?.tipoEventoUi == EventoIconoEnumUI.AGENDA &&
            (eventoUi?.foto??"").isNotEmpty)){

      if((eventoUi?.foto??"").isNotEmpty){
        EventoAdjuntoUi eventoAdjuntoUi = EventoAdjuntoUi();
        eventoAdjuntoUi.imagePreview = eventoUi?.foto;
        eventoAdjuntoUi.tipoRecursosUi = TipoRecursosUi.TIPO_IMAGEN;
        eventoAdjuntoUi.titulo = eventoUi?.titulo;
        eventoUi?.eventoAdjuntoUiPreviewList?.add(eventoAdjuntoUi);
      }

      if((eventoUi?.foto??"").isNotEmpty && (eventoUi?.eventoAdjuntoUiPreviewList?.isNotEmpty??false)){
        eventoUi?.foto = eventoUi.eventoAdjuntoUiPreviewList?[0].imagePreview;
      }
    }



  }

  @override
  Future<void> updateSessionHijoSelected(int hijoSelectedId) async{
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData? sessionUserData = await(SQL.selectSingle(SQL.sessionUser).getSingleOrNull());
      if(sessionUserData!=null){
        await SQL.update(SQL.sessionUser).replace(sessionUserData.copyWith(hijoIdSelect: hijoSelectedId));
      }
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> updateSessionProgramaEduSelected(int programaEduSelectedId, int hijoSelectedId, int anioAcademicoId) async {
    print("updateSessionProgramaEduSelected 1 programaEduSelectedId:" + programaEduSelectedId.toString() + ", hijoSelectedId:" + hijoSelectedId.toString() +", anioAcademicoId: "+anioAcademicoId.toString());
    AppDataBase SQL = AppDataBase();
    try{
      List<SessionUserHijoProgramaData> sessionUserDataList = await(SQL.select(SQL.sessionUserHijoPrograma)..where((tbl) => tbl.hijoId.equals(hijoSelectedId))).get();
      await SQL.transaction(() async {

        SessionUserHijoProgramaData? sessionUserHijoData = null;

        for (var entity in sessionUserDataList) {

          if(programaEduSelectedId == entity.prograAcademicoId && anioAcademicoId== entity.anioAcademicoId && hijoSelectedId == entity.hijoId){
            sessionUserHijoData = entity;
            print("updateSessionProgramaEduSelected 2 programaEduSelectedId:" + programaEduSelectedId.toString() + ", hijoSelectedId:" + hijoSelectedId.toString() +", anioAcademicoId: "+anioAcademicoId.toString());
          }

          await SQL.update(SQL.sessionUserHijoPrograma).replace(entity.copyWith(selected: false));
        }

        if(sessionUserHijoData == null){
          sessionUserHijoData = SessionUserHijoProgramaData(prograAcademicoId: programaEduSelectedId, anioAcademicoId: anioAcademicoId,hijoId: hijoSelectedId, selected: true);
          print("updateSessionProgramaEduSelected 3 programaEduSelectedId:" + programaEduSelectedId.toString() + ", hijoSelectedId:" + hijoSelectedId.toString() +", anioAcademicoId: "+anioAcademicoId.toString());
          await SQL.into(SQL.sessionUserHijoPrograma).insert(sessionUserHijoData, mode: InsertMode.insertOrIgnore);
        }else{
          await SQL.update(SQL.sessionUserHijoPrograma).replace(sessionUserHijoData.copyWith(selected: true));
        }

      });
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<EventoUi>> getTopEventosAgenda(int padreId, int tipoEventoId, List<int> hijos) async {

    AppDataBase SQL = AppDataBase();
    try{

      List<EventoUi> eventoUiList = [];
      var query = SQL.select(SQL.evento).join([
        innerJoin(SQL.calendario, SQL.evento.calendarioId.equalsExp(SQL.calendario.calendarioId)),
      ]);
      query.where(SQL.evento.usuarioReceptorId.equals(padreId));
      if(tipoEventoId>0){
        query.where(SQL.evento.tipoEventoId.equals(tipoEventoId));
      }
      query.orderBy([
        OrderingTerm(expression: SQL.evento.fechaEventoTime, mode: OrderingMode.desc)
      ]);
      var rows = await query.get();
      for(var item in  rows){
        EventoData eventoData = item.readTable(SQL.evento);
        CalendarioData calendarioData = item.readTable(SQL.calendario);
        if(hijos != null && hijos.isNotEmpty && (eventoData.eventoHijoId??0) > 0){
          int id = hijos.firstWhere((element) => hijos == eventoData.eventoHijoId, orElse:()=> -1);
          if(id!=-1)continue;
        }
        EventoUi eventoUi = new EventoUi();
        eventoUi.id = eventoData.eventoId;
        eventoUi.nombreEntidad = eventoData.nombreEntidad;
        eventoUi.fotoEntidad = eventoData.fotoEntidad;
        eventoUi.cantLike =  eventoData.likeCount;
        eventoUi.titulo = eventoData.titulo;
        eventoUi.descripcion = eventoData.descripcion;
        eventoUi.fecha =  eventoData.fechaEvento!=null?AppTools.convertDateTimePtBR(eventoData.fechaEvento, eventoData.horaEvento):null;
        eventoUi.foto = eventoData.pathImagen;
        eventoUi.tipoEventoUi = TipoEventoUi();
        eventoUi.tipoEventoUi?.id = eventoData.tipoEventoId;
        eventoUi.tipoEventoUi?.nombre = eventoData.tipoEventoNombre;
        eventoUi.rolEmisor = calendarioData.cargo;
        eventoUi.nombreEmisor = calendarioData.nUsuario;

        switch(eventoUi.tipoEventoUi?.id){
          case 526:
            eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.EVENTO;
            break;
          case 528:
            eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.ACTIVIDAD;
            break;
          case 530:
            eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.CITA;
            break;
          case 529:
            eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.TAREA;
            break;
          case 527:
            eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.NOTICIA;
            break;
          case 620:
            eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.AGENDA;
            break;
          default:
            eventoUi.tipoEventoUi?.tipo = EventoIconoEnumUI.DEFAULT;
            break;
        }
        await getEventoAdjunto(eventoUi);
        eventoUiList.add(eventoUi);
      }

     // eventoUiList.sort((a, b) => a.getFecha().compareTo(b.getFecha()));
      int count = 0;
      int max = 10;
      List<EventoUi> limitList = [];
      for(EventoUi eventoUi in eventoUiList){
        count++;
        if(count == max)break;
        limitList.add(eventoUi);
      }
      return eventoUiList;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<bool> validarUsuario() async{
    AppDataBase SQL = AppDataBase();
    try{

      SessionUserData? sessionUserData = await (SQL.select(SQL.sessionUser)).getSingleOrNull();//El ORM genera error si hay dos registros
      //Solo deve haber una registro de session user data
      return sessionUserData?.complete??false;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<LoginUi> saveDatosServidor(Map<String, dynamic> datosServidor) async {
    AppDataBase SQL = AppDataBase();
    try{
      LoginUi loginUi;
      AdminServiceSerializable serviceSerializable = AdminServiceSerializable.fromJson(datosServidor);

      if(serviceSerializable.UsuarioId==-1){
        loginUi = LoginUi.INVALIDO;
      }else{
        if((serviceSerializable.UsuarioExternoId??0)>0){
          loginUi = LoginUi.SUCCESS;
          SessionUserData sessionUserData = SessionUserData(userId: serviceSerializable.UsuarioExternoId??0, urlServerLocal: serviceSerializable.UrlServiceMovil);
          await SQL.into(SQL.sessionUser).insert(sessionUserData, mode: InsertMode.insertOrReplace);
        }else{
          loginUi = LoginUi.DUPLICADO;
        }
      }
      return loginUi;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<bool> cerrarCesion() async{
    AppDataBase SQL = AppDataBase();
    try{
      return await SQL.delete(SQL.sessionUser).go()>0;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> saveUsuario(Map<String, dynamic> datosUsuario) async{
    AppDataBase SQL = AppDataBase();
    try{
      await SQL.batch((batch) async {

        if(datosUsuario.containsKey("entidades")){
          //personaSerelizable.addAll(datosInicioPadre["usuariosrelacionados"]);
          //database.personaDao.insertAllTodo(SerializableConvert.converListSerializePersona(datosInicioPadre["personas"]));
          batch.insertAll(SQL.entidad, SerializableConvert.converListSerializeEntidad(datosUsuario["entidades"]), mode: InsertMode.insertOrReplace);
        }

        if(datosUsuario.containsKey("georeferencias")){
          batch.insertAll(SQL.georeferencia, SerializableConvert.converListSerializeGeoreferencia(datosUsuario["georeferencias"]), mode: InsertMode.insertOrReplace );
        }

        if(datosUsuario.containsKey("roles")){
          //personaSerelizable.addAll(datosInicioPadre["usuariosrelacionados"]);
          batch.insertAll(SQL.rol, SerializableConvert.converListSerializeRol(datosUsuario["roles"]), mode: InsertMode.insertOrReplace);
        }

        if(datosUsuario.containsKey("usuarioRolGeoreferencias")){
          //personaSerelizable.addAll(datosInicioPadre["usuariosrelacionados"]);
          batch.insertAll(SQL.usuarioRolGeoreferencia, SerializableConvert.converListSerializeUsuarioRolGeoreferencia(datosUsuario["usuarioRolGeoreferencias"]), mode: InsertMode.insertOrReplace);
        }
      });
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<int> getSessionUsuarioId() async {
    AppDataBase SQL = AppDataBase();
    try{
    SessionUserData? sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingleOrNull();
    print("getSessionUsuarioId: ${sessionUserData?.userId}");
    return sessionUserData?.userId??0;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<bool> validarRol(int usuarioId) async{
    AppDataBase SQL = AppDataBase();
    try{
      var query = SQL.selectSingle(SQL.usuarioRolGeoreferencia)..where((tbl) => tbl.usuarioId.equals(usuarioId));
      query.where((tbl) => tbl.rolId.equals(5));
      UsuarioRolGeoreferenciaData? usuarioRolGeoreferenciaData = await query.getSingleOrNull();
      return usuarioRolGeoreferenciaData!=null;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> destroyBaseDatos() async{
    AppDataBase SQL = AppDataBase();
    try{
      await SQL.transaction(() async {
        // you only need this if you've manually enabled foreign keys
        // await customStatement('PRAGMA foreign_keys = OFF');
        for (final table in SQL.allTables) {
          await SQL.delete(table).go();
        }

        for (final table in SQL.allTables) {
          await SQL.delete(table).go();
        }
      });
    }catch(e){
      throw Exception(e);
    }

  }

  @override
  Future<String> getSessionUsuarioUrlServidor() async{
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData? sessionUserData =  await SQL.selectSingle(SQL.sessionUser).getSingleOrNull();
      return sessionUserData?.urlServerLocal??"";
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> updateUsuarioSuccessData(int usuarioId) async{
    AppDataBase SQL = AppDataBase();
    try{
      SessionUserData? sessionUserData = await(SQL.selectSingle(SQL.sessionUser).getSingleOrNull());
      if(sessionUserData!=null){
        await SQL.update(SQL.sessionUser).replace(sessionUserData.copyWith(complete: true));
      }
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  List<dynamic> getJsonUpdatePersonas(UsuarioUi? usuarioUi, List<HijosUi>? hijosUiList, List<FamiliaUi>? familiaUiList) {
   List<dynamic> personaSerialList = [];
   if(usuarioUi?.change??false){
     PersonaSerial personaSerial = PersonaSerial(personaId: usuarioUi?.personaId, correo: usuarioUi?.correo, celular: usuarioUi?.celular, image64: usuarioUi?.image64);
     personaSerialList.add(personaSerial.toJson());
   }

   for(HijosUi hijosUi in hijosUiList??[]){
     if(hijosUi.change??false){
       PersonaSerial personaSerial = PersonaSerial(personaId: hijosUi.personaId, correo: hijosUi.correo, celular: hijosUi.celular, image64: hijosUi.image64);
       personaSerialList.add(personaSerial.toJson());
     }

   }

   for(FamiliaUi familiaUi in familiaUiList??[]){
     if(familiaUi.change??false){
       PersonaSerial personaSerial = PersonaSerial(personaId: familiaUi.personaId, correo: familiaUi.correo, celular: familiaUi.celular, image64: familiaUi.image64);
       personaSerialList.add(personaSerial.toJson());
     }

   }

   return personaSerialList;
  }

  @override
  Future<void> updatePersona(List<dynamic>? listaPersonas) async {
    AppDataBase SQL = AppDataBase();
    try{
      if(listaPersonas!=null){
        await SQL.transaction(() async {

          List<PersonaData> personaDataList = SerializableConvert.converListSerializePersona(listaPersonas);
          for (PersonaData item in personaDataList) {
            PersonaData? personaData = await (SQL.selectSingle(SQL.persona)..where((tbl) => tbl.personaId.equals(item.personaId))).getSingleOrNull();
            if(personaData!=null)await SQL.update(SQL.persona).replace(personaData.copyWith(celular: item.celular, correo: item.correo, foto: item.foto??personaData.foto));
          }
        });
      }
    }catch(e){
      throw Exception(e);
    }

  }


  @override
  Future<String?> gePrematricula() async{

    try{
      AppDataBase SQL = AppDataBase();
      WebConfig? webConfig = await (SQL.selectSingle(SQL.webConfigs)..where((tbl) => tbl.nombre.equals("wstr_Nombre_Pre_Matricula"))).getSingleOrNull();
      if(webConfig!=null&&
          webConfig.content!=null && (webConfig.content??"").isNotEmpty&&
          webConfig.content?.toUpperCase() != "NULL"){
        return webConfig.content;
      }
      return null;
    }catch(e){
      return null;
    }
  }

  @override
  Future<String> getIconoPadre() async {
    try{
      AppDataBase SQL = AppDataBase();
      WebConfig? webConfig = await (SQL.selectSingle(SQL.webConfigs)..where((tbl) => tbl.nombre.equals("wstr_icono_padre"))).getSingleOrNull();
      return webConfig?.content??"";
    }catch(e){
      return "";
    }
  }



}