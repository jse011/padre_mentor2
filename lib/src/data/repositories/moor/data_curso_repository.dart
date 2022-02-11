import 'package:flutter/cupertino.dart';
import 'package:moor_flutter/moor_flutter.dart';
import 'package:padre_mentor/src/data/helpers/serelizable/rest_api_response.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/cursos.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/parametros_disenio.dart';
import 'package:padre_mentor/src/data/repositories/moor/tools/serializable_convert.dart';
import 'package:padre_mentor/src/domain/entities/asistencia_tipo_ui.dart';
import 'package:padre_mentor/src/domain/entities/asistencia_ui.dart';
import 'package:padre_mentor/src/domain/entities/calendario_periodio_ui.dart';
import 'package:padre_mentor/src/domain/entities/contacto_ui.dart';
import 'package:padre_mentor/src/domain/entities/contrato_ui_ui.dart';
import 'package:padre_mentor/src/domain/entities/curso_boleta_ui.dart';
import 'package:padre_mentor/src/domain/entities/curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/rubro_evaluacion_ui.dart';
import 'package:padre_mentor/src/domain/entities/tarea_eval_curso_ui.dart';
import 'package:padre_mentor/src/domain/entities/tipo_nota_enum_ui.dart';
import 'package:padre_mentor/src/domain/repositories/curso_repository.dart';
import 'package:padre_mentor/src/domain/tools/app_tools.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'database/app_database.dart';

class DataCursoRepository extends CursoRepository{
  @override
  Future<List<CalendarioPeriodoUI>> getCalendarioPerios(int programaEducativoId, int alumnoId, int anioAcademicoId) async{
    print("getCalendarioPerios" );
    AppDataBase SQL = AppDataBase();
    try{

      /*
      * Obtner calendario Periodo
      *  CALENDARIO_PERIODO_CREADO = 214, CALENDARIO_PERIODO_VIGENTE = 215, CALENDARIO_PERIODO_CERRADO = 217
      *
      * */
      var query=  await SQL.select(SQL.calendarioPeriodo).join([
        innerJoin(SQL.calendarioAcademico, SQL.calendarioAcademico.calendarioAcademicoId.equalsExp(SQL.calendarioPeriodo.calendarioAcademicoId)),
        innerJoin(SQL.anioAcademicoAlumno, SQL.anioAcademicoAlumno.idAnioAcademico.equalsExp(SQL.calendarioAcademico.idAnioAcademico)),
        innerJoin(SQL.tipos, SQL.tipos.tipoId.equalsExp(SQL.calendarioPeriodo.tipoId))
      ]);
      query.where(SQL.anioAcademicoAlumno.personaId.equals(alumnoId));
      query.where(SQL.anioAcademicoAlumno.idAnioAcademico.equals(anioAcademicoId));
      query.where(SQL.calendarioAcademico.programaEduId.equals(programaEducativoId));
      query.groupBy([SQL.calendarioPeriodo.calendarioPeriodoId]);
      var rows = await query.get();
      List<CalendarioPeriodoUI> calendarioPeriodoList = [];

      CalendarioPeriodoUI? calendarioPeriodoUI;

      for(var data in rows){
        CalendarioPeriodoData calendarioPeriodoData = data.readTable(SQL.calendarioPeriodo);
        Tipo tipo = data.readTable(SQL.tipos);
        calendarioPeriodoUI = CalendarioPeriodoUI(id: calendarioPeriodoData.calendarioPeriodoId, nombre: tipo.nombre, selected: calendarioPeriodoData.estadoId==215, fechaFin: calendarioPeriodoData.fechaFin, fechaInicio: calendarioPeriodoData.fechaInicio, estadoId: calendarioPeriodoData.estadoId);
        calendarioPeriodoList.add(calendarioPeriodoUI);
      }


      if (!calendarioPeriodoList.isEmpty && calendarioPeriodoUI == null){
        final List<CalendarioPeriodoUI> orderList = [];
        orderList.addAll(calendarioPeriodoList);
        orderList.sort((a, b) => (b.fechaFin??DateTime(1960)).compareTo(a.fechaFin??DateTime(1960)));

        //#region Buscar el calendario en el estado creado proximo a estar vigente
        int count = 0;
        calendarioPeriodoUI =  orderList[0];
        for(var item in orderList){
          if (calendarioPeriodoUI?.estadoId == 214)
          {
            calendarioPeriodoUI =  item;
            if (count != 0 &&
                orderList[count - 1].estadoId == 217)
            {
              calendarioPeriodoUI = orderList[count - 1];
              break;
            }
          }

          count++;
        }

        calendarioPeriodoUI?.selected = true;
        //#endregion
      }
      print("getCalendarioPerios count:" + calendarioPeriodoList.length.toString() );
      return calendarioPeriodoList;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> saveBoletaNotas(Map<String, dynamic> datosBoleta, int anioAcademicoId, int programaEducativoId, int periodoId, int seccionId, int calendarioPeridoId, int alumnoId, int georeferenciaId)async {
    AppDataBase SQL = AppDataBase();
    try{
      await SQL.transaction(() async {


        var _queryAreaBoleta =  await SQL.select(SQL.areasBoleta).join(
            [
              innerJoin(SQL.notasCalendarioBoleta, SQL.notasCalendarioBoleta.rubroEvalResultadoId.equalsExp(SQL.areasBoleta.rubroEvalResultadoId))
            ]
        );

        _queryAreaBoleta.where(SQL.areasBoleta.calendarioPeriodoId.equals(calendarioPeridoId));
        _queryAreaBoleta.where(SQL.areasBoleta.seccionId.equals(seccionId));
        _queryAreaBoleta.where(SQL.areasBoleta.periodoId.equals(periodoId));
        _queryAreaBoleta.where(SQL.areasBoleta.anioAcademicoId.equals(anioAcademicoId));
        _queryAreaBoleta.where(SQL.areasBoleta.programaEducativoId.equals(programaEducativoId));
        _queryAreaBoleta.where(SQL.notasCalendarioBoleta.alumnoId.equals(alumnoId));
        var rows = await _queryAreaBoleta.get();

        for (var data in rows) {
          NotasCalendarioBoletaData notasCalendarioBoletaData = data.readTable(SQL.notasCalendarioBoleta);
          await (SQL.delete(SQL.notasCalendarioBoleta).delete(notasCalendarioBoletaData));
        }

        var query =  await SQL.select(SQL.areasBoleta)..where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeridoId));
        query.where((tbl) => tbl.seccionId.equals(seccionId));
        query.where((tbl) => tbl.periodoId.equals(periodoId));
        query.where((tbl) => tbl.anioAcademicoId.equals(anioAcademicoId));
        query.where((tbl) => tbl.programaEducativoId.equals(programaEducativoId));
        var areaBoletarows = await query.get();
        print("saveEvaluaciones cantidad : "+rows.length.toString());
        for (AreasBoletaData row in areaBoletarows) {
          await (SQL.delete(SQL.areasBoleta).delete(row));
        }
      });

      await SQL.batch((batch) async {
        // functions in a batch don't have to be awaited - just
        // await the whole batch afterwards.
        if(datosBoleta.containsKey("bEBoletaNotas")){
          var bEBoletaNotasList = SerializableConvert.converListSerializeNotasCalendarioBoleta(datosBoleta["bEBoletaNotas"]);
          if(!bEBoletaNotasList.isEmpty){

            batch.insertAll(SQL.areasBoleta, SerializableConvert.converListSerializeAreasBoleta(datosBoleta["bEBoletasAreas"], anioAcademicoId, seccionId, periodoId, programaEducativoId), mode: InsertMode.insertOrReplace );

            if(datosBoleta.containsKey("bEBoletasAreas")){
              batch.insertAll(SQL.notasCalendarioBoleta, bEBoletaNotasList, mode: InsertMode.insertOrReplace );
            }
          }
        }

      });
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<CursoBoletaUi>> getBoletaNotas(int alumnoId, int anioAcademicoId, int calendarioPeridoId, int programaEducativoId, int periodoId, int seccionId) async {
    //print("getBoletaNotas alumnoId: "+alumnoId.toString() + "anioAcademicoId: " + anioAcademicoId.toString() +" calendarioPeridoId: "+calendarioPeridoId.toString()+" programaEducativoId: "+programaEducativoId.toString() +" periodoId: "+periodoId.toString()+" seccionId: "+seccionId.toString() );
    AppDataBase SQL = AppDataBase();
    try{

      /*
      * Obtner boleta notas
      *  CALENDARIO_PERIODO_CREADO = 214, CALENDARIO_PERIODO_VIGENTE = 215, CALENDARIO_PERIODO_CERRADO = 217
      *  PRE_MATRICULA = 189, MATRICULA = 190
      *  VALOR_NUMERICO = 410, SELECTOR_NUMERICO = 411, SELECTOR_VALORES = 412, SELECTOR_ICONOS = 409, VALOR_ASISTENCIA= 474
      * */

      if(calendarioPeridoId==0)return [];

      var _queryAreaBoleta =  await SQL.select(SQL.areasBoleta)..where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeridoId));
      _queryAreaBoleta.where((tbl) => tbl.seccionId.equals(seccionId));
      _queryAreaBoleta.where((tbl) => tbl.periodoId.equals(periodoId));
      _queryAreaBoleta.where((tbl) => tbl.anioAcademicoId.equals(anioAcademicoId));
      _queryAreaBoleta.where((tbl) => tbl.programaEducativoId.equals(programaEducativoId));

      /*queryAreaBoleta.orderBy([
            (tbl)=> OrderingTerm(expression: tbl.tipoConceptoId),
            (tbl)=> OrderingTerm(expression: tbl.totalHt),
            (tbl)=> OrderingTerm(expression: tbl.nombre),
            (tbl)=> OrderingTerm(expression: tbl.competenciaId)]);*/

      List<AreasBoletaData> areasBoletaList = await _queryAreaBoleta.get();
      List<CursoBoletaUi> cursoBoletaUiList = [];
      List<CursoBoletaUi> asignados = [];

      ParametrosDisenioData? defaultParametrosDisenioData = await (SQL.selectSingle(SQL.parametrosDisenio)..where((tbl) => tbl.nombre.equals("default"))).getSingleOrNull();
      await SQL.transaction(() async {
        await Future.forEach(areasBoletaList, (AreasBoletaData  boleta) async{


          CursoBoletaUi cursoBoletaUi = CursoBoletaUi(
              rubroEvalResultadoId: boleta.rubroEvalResultadoId,
              competencia: boleta.competencia,
              competenciaId: boleta.competenciaId,
              tipoNotaEnum: getTipoNotaEnumUi(boleta.tipoNotaId),
              nombre: boleta.nombre,
              silaboEventoId: boleta.silaboEventoId,
              tipoConceptoId: boleta.tipoConceptoId,
              totalHt: boleta.totalHt,
              cursoBoletaUiList: []
          );


          cursoBoletaUiList.add(cursoBoletaUi);
          var queryNotasCalendarioBoletas = SQL.selectSingle(SQL.notasCalendarioBoleta)..where((tbl) => tbl.alumnoId.equals(alumnoId));
          queryNotasCalendarioBoletas.where((tbl) => tbl.rubroEvalResultadoId.equals(boleta.rubroEvalResultadoId));
          NotasCalendarioBoletaData? notasCalendarioBoleta = await queryNotasCalendarioBoletas.getSingleOrNull();
          if(notasCalendarioBoleta!=null){
            cursoBoletaUi.nota = notasCalendarioBoleta.nota;
            cursoBoletaUi.tipoNotaEnum = getTipoNotaEnumUi(boleta.tipoNotaId);
            cursoBoletaUi.color = notasCalendarioBoleta.color;

            if((cursoBoletaUi.tipoNotaEnum == TipoNotaEnumUi.VALOR_NUMERICO||
                cursoBoletaUi.tipoNotaEnum == TipoNotaEnumUi.SELECTOR_NUMERICO) && cursoBoletaUi.nota!=null && !(cursoBoletaUi.nota??"").isEmpty){
              try{
                int notaformat = double.parse(cursoBoletaUi.nota??"0").toInt();
                if (notaformat < 11) {
                  cursoBoletaUi.color = "#f44336";
                }
                if (notaformat >= 11) {
                  cursoBoletaUi.color  = "#3a4fc6";
                }
                cursoBoletaUi.nota = notaformat.toString();
              }catch(e){
                print(e.toString());
              }

            }
          }

          SilaboEventoData? silaboEventoData = await (SQL.selectSingle(SQL.silaboEvento)..where((tbl) => tbl.silaboEventoId.equals(cursoBoletaUi.silaboEventoId))).getSingleOrNull();
          ParametrosDisenioData? parametrosDisenioData = await (SQL.selectSingle(SQL.parametrosDisenio)..where((tbl) => tbl.parametroDisenioId.equals(silaboEventoData==null?0:silaboEventoData.parametroDisenioId))).getSingleOrNull();
          if(parametrosDisenioData!=null){
            cursoBoletaUi.colorCurso = parametrosDisenioData.color1;
            cursoBoletaUi.colorCurso2 = parametrosDisenioData.color2;
            cursoBoletaUi.colorCurso3 = parametrosDisenioData.color3;
          }else{
            if(defaultParametrosDisenioData!=null){
              cursoBoletaUi.colorCurso = defaultParametrosDisenioData.color1;
              cursoBoletaUi.colorCurso2 = defaultParametrosDisenioData.color2;
              cursoBoletaUi.colorCurso3 = defaultParametrosDisenioData.color3;
            }
          }


        });
      });

      List<CursoBoletaUi> finales = [];
      for (CursoBoletaUi cursoBoletaUi in cursoBoletaUiList){
        if(cursoBoletaUi.competenciaId==0){
          finales.add(cursoBoletaUi);
          asignados.add(cursoBoletaUi);
        }
      }

      for (CursoBoletaUi _final in finales){
        List<CursoBoletaUi> hijos = [];
        for (CursoBoletaUi cursoBoletaUi in cursoBoletaUiList){
          if(_final.silaboEventoId==cursoBoletaUi.silaboEventoId&&cursoBoletaUi.competenciaId!=0){
            hijos.add(cursoBoletaUi);
            asignados.add(cursoBoletaUi);
          }
        }
        _final.cursoBoletaUiList = hijos;
      }

      //cursoBoletaUiList.removeAll(asignados);
      for(var asignado in asignados)cursoBoletaUiList.remove(asignado);


      for (CursoBoletaUi cursoBoletaUi in cursoBoletaUiList){
        cursoBoletaUi.tranversal = true;
        cursoBoletaUi.cursoBoletaUiList?.add(cursoBoletaUi);
      }

      finales.addAll(cursoBoletaUiList);

      //Collections.sort(finales,new CursoBoletaUiComprador());
      finales.sort((o1, o2){
        int value1 = (o2.totalHt??0).compareTo(o1.totalHt??0);
        if (value1 == 0) {
          int value2 = ( o1.tipoConceptoId??0).compareTo(o2.tipoConceptoId??0);
          if (value2 == 0) {
            int value3 = (o1.nombre??"").compareTo(o2.nombre??"");
            if(value3==0){
              return (o1.competenciaId??0).compareTo(o2.competenciaId??0);
            }else {
              return value3;
            }
          } else {
            return value2;
          }
        }
        return value1;
      });

      return finales;
    }catch(e){
      throw Exception(e);
    }



  }

  TipoNotaEnumUi getTipoNotaEnumUi(int? tipoNotaId){
    TipoNotaEnumUi tipoNotaEnumUi = TipoNotaEnumUi.VALOR_NUMERICO;
    if(tipoNotaId == 410){
      tipoNotaEnumUi = TipoNotaEnumUi.VALOR_NUMERICO;
    }else if (tipoNotaId == 411){
      tipoNotaEnumUi = TipoNotaEnumUi.SELECTOR_NUMERICO;
    }else if (tipoNotaId == 412){
      tipoNotaEnumUi = TipoNotaEnumUi.SELECTOR_VALORES;
    }else if (tipoNotaId == 409){
      tipoNotaEnumUi = TipoNotaEnumUi.SELECTOR_ICONOS;
    }else if (tipoNotaId == 474){
      tipoNotaEnumUi = TipoNotaEnumUi.VALOR_ASISTENCIA;
    }
    print("getTipoNotaEnumUi " + tipoNotaEnumUi.toString());
    return tipoNotaEnumUi;
  }

  @override
  Future<ContratoUi> getContratoUi(int anioAcademicoId, int alumnoId) async{
    print("getBoletaNotas" );
    AppDataBase SQL = AppDataBase();
    try{
      var queryContrato =  await SQL.selectSingle(SQL.contrato)..where((tbl) => tbl.personaId.equals(alumnoId));
      queryContrato.where((tbl) => tbl.estadoId.equals(190));
      queryContrato.where((tbl) => tbl.idAnioAcademico.equals(anioAcademicoId));
      ContratoData? contratoData = await queryContrato.getSingleOrNull();

      int contratoId = contratoData?.idContrato??0;
      int periodoId = contratoData?.periodoId??0;
      int seccionId = contratoData?.seccionId??0;

      return ContratoUi(id: contratoId, periodoId: periodoId, seccionId: seccionId);
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> saveEvaluaciones(Map<String, dynamic> datosEvaluaciones, int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId) async{
    AppDataBase SQL = AppDataBase();
    try{

      await SQL.transaction(() async {
        var query = SQL.select(SQL.rubroEvalDesempenio)..where((tbl) =>  tbl.anioAcademicoId.equals(anioAcademicoId));
        query.where((tbl) => tbl.programaAcadId.equals(programaId));
        query.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeridoId));
        query.where((tbl) => tbl.alumnoId.equals(alumnoId));

        var rows = await query.get();
        print("saveEvaluaciones cantidad : "+rows.length.toString());
        for (RubroEvalDesempenioData row in rows) {
          await (SQL.delete(SQL.rubroEvalDesempenio).delete(row));
        }
      });
      await SQL.batch((batch) async {
        // functions in a batch don't have to be awaited - just
        // await the whole batch afterwards.
        //rubroEvalList.add(SerializableConvert.converSerializeRubroEvalDesempenio(item));
        batch.insertAll(SQL.rubroEvalDesempenio, SerializableConvert.converListSerializeRubroEvalDesempenio(datosEvaluaciones["evaluaciones"]), mode: InsertMode.insertOrReplace );

      });
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<RubroEvaluacionUi>> getEvaluacionesPorCurso(int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId) async{
    print("getEvaluacionesPorCurso alumnoId: "+alumnoId.toString() + "anioAcademicoId: " + anioAcademicoId.toString() +" calendarioPeridoId: "+calendarioPeridoId.toString()+" programaEducativoId: "+programaId.toString());
    AppDataBase SQL = AppDataBase();
    WebConfig? webConfig = await (SQL.selectSingle(SQL.webConfigs)..where((tbl) => tbl.nombre.equals("wstr_UrlExpresiones"))).getSingleOrNull();
    String urlExpresiones =  webConfig?.content??"";
    /*
      * Obtner evaluaciones por cursos
      * */
    List<RubroEvaluacionUi> rubroEvaluacionList = [];

    var query = SQL.select(SQL.rubroEvalDesempenio)
        .join([
      leftOuterJoin(SQL.parametrosDisenio, SQL.rubroEvalDesempenio.parametroDesenioId.equalsExp(SQL.parametrosDisenio.parametroDisenioId))]);
    query.where(SQL.rubroEvalDesempenio.anioAcademicoId.equals(anioAcademicoId));
    query.where(SQL.rubroEvalDesempenio.programaAcadId.equals(programaId));
    query.where(SQL.rubroEvalDesempenio.calendarioPeriodoId.equals(calendarioPeridoId));
    query.where(SQL.rubroEvalDesempenio.alumnoId.equals(alumnoId));
    query.orderBy([OrderingTerm(expression: SQL.rubroEvalDesempenio.silaboEventoId)]);
    //query.where(SQL.evaluacionDesempenio.secRubroEvalProcesoId.equals(""));
    var rows = await query.get();

    ParametrosDisenioData? defaultParametrosDisenioData = await (SQL.selectSingle(SQL.parametrosDisenio)..where((tbl) => tbl.nombre.equals("default"))).getSingleOrNull();

    print("getEvaluacionesPorCurso 1");
    for(var item in rows){
      RubroEvalDesempenioData rubroEvalDesempenioData = item.readTable(SQL.rubroEvalDesempenio);
      ParametrosDisenioData? parametrosDisenioData = item.readTableOrNull(SQL.parametrosDisenio);
      RubroEvaluacionUi rubroEvaluacionUi = RubroEvaluacionUi();
      rubroEvaluacionUi.rubroEvalId = rubroEvalDesempenioData.rubroEvalProcesoId;
      rubroEvaluacionUi.titulo = rubroEvalDesempenioData.tituloEvaluacion;
      rubroEvaluacionUi.tipo = rubroEvalDesempenioData.formaEvaluacion;
      rubroEvaluacionUi.fecha = AppTools.f_fecha_letras(rubroEvalDesempenioData.fechaEvaluacion);
      rubroEvaluacionUi.tipoNotaEnum = getTipoNotaEnumUi(rubroEvalDesempenioData.tipoIdNivelLogro);
      rubroEvaluacionUi.nota = rubroEvalDesempenioData.notaEvalaucion != null ? rubroEvalDesempenioData.notaEvalaucion?.toStringAsFixed(1): "";
      rubroEvaluacionUi.iconoNota = rubroEvalDesempenioData.iconoNivelLogro != null && (rubroEvalDesempenioData.iconoNivelLogro?.length??0) > 0 ? urlExpresiones + (rubroEvalDesempenioData.iconoNivelLogro??""): null;
      rubroEvaluacionUi.descNota = rubroEvalDesempenioData.descripcionNivelLogro;
      rubroEvaluacionUi.tituloNota = rubroEvalDesempenioData.tituloNivelLogro;
      rubroEvaluacionUi.cursoUi = CursoUi();
      rubroEvaluacionUi.cursoUi?.silaboEventoId = rubroEvalDesempenioData.silaboEventoId;
      rubroEvaluacionUi.cursoUi?.cargaCursoId = rubroEvalDesempenioData.cargaCursoId;
      rubroEvaluacionUi.cursoUi?.nombre = rubroEvalDesempenioData.nombreCurso;
      if(parametrosDisenioData!=null){
        rubroEvaluacionUi.cursoUi?.colorCurso = parametrosDisenioData.color1;
        rubroEvaluacionUi.cursoUi?.colorCurso2 = parametrosDisenioData.color2;
        rubroEvaluacionUi.cursoUi?.colorCurso3 = parametrosDisenioData.color3;
      }else{
        if(defaultParametrosDisenioData!=null){
          rubroEvaluacionUi.cursoUi?.colorCurso = defaultParametrosDisenioData.color1;
          rubroEvaluacionUi.cursoUi?.colorCurso2 = defaultParametrosDisenioData.color2;
          rubroEvaluacionUi.cursoUi?.colorCurso3 = defaultParametrosDisenioData.color3;
        }
      }
      rubroEvaluacionList.add(rubroEvaluacionUi);
    }
    print("getEvaluacionesPorCurso 2");
    return rubroEvaluacionList;
  }

  @override
  Future<void> saveTareaEvaluaciones(Map<String, dynamic> datosTareaEvalaucion, int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId) async{
    AppDataBase SQL = AppDataBase();
    try{

      await SQL.transaction(() async {
        var query = SQL.select(SQL.tareaCurso)..where((tbl) => tbl.anioAcademicoId.equals(anioAcademicoId));
        query.where((tbl) => tbl.programaAcadId.equals(programaId));
        query.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeridoId));
        query.where((tbl) => tbl.alumnoId.equals(alumnoId));

        var rows = await query.get();
        print("saveTareaEvaluaciones cantidad : "+rows.length.toString());
        for (TareaCursoData row in rows) {
          await (SQL.delete(SQL.tareaCurso).delete(row));
        }
      });

      await SQL.batch((batch) async {
        // functions in a batch don't have to be awaited - just
        // await the whole batch afterwards.
        //rubroEvalList.add(SerializableConvert.converSerializeRubroEvalDesempenio(item));
        batch.insertAll(SQL.tareaCurso, SerializableConvert.converListSerializeTareaCurso(datosTareaEvalaucion["tareas"]), mode: InsertMode.insertOrReplace );

      });
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<TareaEvaluacionCursoUi>> getTareaEvaluacionPorCurso(int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId) async{
    print("getTareaEvaluacionPorCurso alumnoId: "+alumnoId.toString() + "anioAcademicoId: " + anioAcademicoId.toString() +" calendarioPeridoId: "+calendarioPeridoId.toString()+" programaEducativoId: "+programaId.toString());
    AppDataBase SQL = AppDataBase();
    try{

      WebConfig? webConfig = await (SQL.selectSingle(SQL.webConfigs)..where((tbl) => tbl.nombre.equals("wstr_UrlExpresiones"))).getSingleOrNull();
      String urlExpresiones = webConfig?.content??"";
      /*
      * Obtner tareas por cursos
      * */
      List<TareaEvaluacionCursoUi> tareaCursoUiList = [];

      var query = SQL.select(SQL.tareaCurso)
          .join([
        leftOuterJoin(SQL.parametrosDisenio, SQL.tareaCurso.parametroDesenioId.equalsExp(SQL.parametrosDisenio.parametroDisenioId))]);
      //
      query.where(SQL.tareaCurso.anioAcademicoId.equals(anioAcademicoId));
      query.where(SQL.tareaCurso.programaAcadId.equals(programaId));
      query.where(SQL.tareaCurso.calendarioPeriodoId.equals(calendarioPeridoId));
      query.where(SQL.tareaCurso.alumnoId.equals(alumnoId));
      query.orderBy([OrderingTerm(expression: SQL.tareaCurso.silaboEventoId)]);
      //query.where(SQL.evaluacionDesempenio.secRubroEvalProcesoId.equals(""));
      var rows = await query.get();

      ParametrosDisenioData? defaultParametrosDisenioData = await (SQL.selectSingle(SQL.parametrosDisenio)..where((tbl) => tbl.nombre.equals("default"))).getSingleOrNull();

      for(var item in rows) {
        TareaCursoData tareaCursoData = item.readTable(SQL.tareaCurso);
        ParametrosDisenioData parametrosDisenioData = item.readTable(SQL.parametrosDisenio);
        TareaEvaluacionCursoUi tareaEvaluacionCursoUi = TareaEvaluacionCursoUi();
        tareaEvaluacionCursoUi.tareaId = tareaCursoData.tareaId;
        tareaEvaluacionCursoUi.tituloTarea = tareaCursoData.tareaTitulo;
        tareaEvaluacionCursoUi.nombreDocente = AppTools.capitalize(tareaCursoData.docenteNombre??"") + " " + AppTools.capitalize(tareaCursoData.docenteApellPat??"") + " " + AppTools.capitalize(tareaCursoData.docenteApellMat??"");
        tareaEvaluacionCursoUi.fechaInicio = tareaCursoData.tareafechaCreacion;
        tareaEvaluacionCursoUi.fechaEntrega =  tareaCursoData.tareaFechaEntrega!=null?AppTools.convertDateTimePtBR(tareaCursoData.tareaFechaEntrega, tareaCursoData.tareaHoraEntrega):null; //tareaCursoData.tareaFechaEntrega;
        //tareaEvaluacionCursoUi.rubroEvalId = rubroEvalDesempenioData.rubroEvalProcesoId;
        //tareaEvaluacionCursoUi.titulo = rubroEvalDesempenioData.tituloEvaluacion;

        //tareaEvaluacionCursoUi.fecha = AppTools.f_fecha_letras(rubroEvalDesempenioData.fechaEvaluacion);
        tareaEvaluacionCursoUi.tipoNotaEnum = getTipoNotaEnumUi(tareaCursoData.tipoIdNivelLogro);
        tareaEvaluacionCursoUi.nota = tareaCursoData.notaEvalaucion != null ? tareaCursoData.notaEvalaucion?.toStringAsFixed(1): "";
        tareaEvaluacionCursoUi.iconoNota = tareaCursoData.iconoNivelLogro != null && (tareaCursoData.iconoNivelLogro?.length??0) > 0 ? urlExpresiones + (tareaCursoData.iconoNivelLogro??""): null;
        tareaEvaluacionCursoUi.descNota = tareaCursoData.descripcionNivelLogro;
        tareaEvaluacionCursoUi.tituloNota = tareaCursoData.tituloNivelLogro;
        tareaEvaluacionCursoUi.cursoUi = CursoUi();
        tareaEvaluacionCursoUi.cursoUi?.silaboEventoId = tareaCursoData.silaboEventoId;
        tareaEvaluacionCursoUi.cursoUi?.cargaCursoId = tareaCursoData.cargaCursoId;
        tareaEvaluacionCursoUi.cursoUi?.nombre = tareaCursoData.nombreCurso;
        tareaEvaluacionCursoUi.cursoUi?.seccion = tareaCursoData.seccion;
        tareaEvaluacionCursoUi.cursoUi?.grado = tareaCursoData.grado;

        tareaEvaluacionCursoUi.rubroEvaluacionId = tareaCursoData.rubroEvalProcesoId;

        if(parametrosDisenioData!=null){
          tareaEvaluacionCursoUi.cursoUi?.colorCurso = parametrosDisenioData.color1;
          tareaEvaluacionCursoUi.cursoUi?.colorCurso2 = parametrosDisenioData.color2;
          tareaEvaluacionCursoUi.cursoUi?.colorCurso3 = parametrosDisenioData.color3;
        }else{
          if(defaultParametrosDisenioData!=null){
            tareaEvaluacionCursoUi.cursoUi?.colorCurso = defaultParametrosDisenioData.color1;
            tareaEvaluacionCursoUi.cursoUi?.colorCurso2 = defaultParametrosDisenioData.color2;
            tareaEvaluacionCursoUi.cursoUi?.colorCurso3 = defaultParametrosDisenioData.color3;
          }
        }
        tareaCursoUiList.add(tareaEvaluacionCursoUi);
      }


      return tareaCursoUiList;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<ContactoUi>> getContactos(List<int> hijoIdList) async{
    AppDataBase SQL = AppDataBase();
    try{

      List<ContactoUi> contactoUiList = [];
      //List<ContactoData> contactosDataList  = await (SQL.select(SQL.contacto)..where((tbl) => tbl.companieroId.isIn(hijoIdList))).get();
      final padre = SQL.alias(SQL.contacto, 'padre');
      final apoderado = SQL.alias(SQL.contacto, 'apoderado');

      var query = SQL.select(SQL.contacto).join([
        leftOuterJoin(padre, padre.hijoRelacionId.equalsExp(SQL.contacto.personaId)),
        leftOuterJoin(apoderado, apoderado.hijoRelacionId.equalsExp(SQL.contacto.personaId))
      ]);

      query.where(SQL.contacto.companieroId.isIn(hijoIdList));
      query.groupBy([SQL.contacto.personaId,SQL.contacto.companieroId, SQL.contacto.tipo]);
      var rows = await query.get();

      for(var row  in rows){
        ContactoData contactoData = row.readTable(SQL.contacto);
        ContactoData padreData = row.readTable(padre);
        ContactoData apoderadoData = row.readTable(padre);
        ContactoUi? contactoUi = contactoUiList.firstWhereOrNull((element) => element.personaId == contactoData.personaId && element.tipo == contactoData.tipo);
        if(contactoUi == null){
          contactoUi = new ContactoUi();
          contactoUi.personaId = contactoData.personaId;
          contactoUi.relacionList = [];
          contactoUi.foto = contactoData.foto;
          contactoUi.nombre = '${AppTools.capitalize(contactoData.nombres??"")} ${AppTools.capitalize(contactoData.apellidoPaterno??"")} ${AppTools.capitalize(contactoData.apellidoMaterno??"")}';
          contactoUi.relacion = contactoData.relacion;
          contactoUi.telfono = contactoData.celular!=null?contactoData.celular: contactoData.telefono??"";

        }

        if(padreData!=null){
          ContactoUi padreUi = new ContactoUi();
          padreUi.personaId = padreData.personaId;
          padreUi.relacion = padreData.relacion;
          contactoUi.relacionList?.add(padreUi);
        }

        if(apoderadoData!=null){
          contactoUi.apoderadoTelfono = apoderadoData.celular!=null?apoderadoData.celular: apoderadoData.telefono??"";
        }

        contactoUi.tipo = contactoData.tipo;
        contactoUiList.add(contactoUi);

      }

      print("getContactos: "+contactoUiList.length.toString());
      return contactoUiList;

    }catch(e){
      throw Exception(e);
    }


  }

  @override
  Future<void> saveContactos(Map<String, dynamic> datosTareaEvalaucion) async{
    AppDataBase SQL = AppDataBase();
    try{
      await SQL.batch((batch) async {
        // functions in a batch don't have to be awaited - just
        // await the whole batch afterwards.
        //rubroEvalList.add(SerializableConvert.converSerializeRubroEvalDesempenio(item));
        batch.deleteWhere(SQL.contacto, (row) => const Constant(true));
        batch.insertAll(SQL.contacto, SerializableConvert.converListSerializeContacto(datosTareaEvalaucion["contactos"]), mode: InsertMode.insertOrReplace );

      });
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<CursoUi>> getCursos(int programaAcademicoId, int alumnoId, int anioAcademico) async{
    AppDataBase SQL = AppDataBase();
    try{
      var query = SQL.select(SQL.cargaCurso).join([
        innerJoin(SQL.detalleContratoAcad, SQL.cargaCurso.cargaCursoId.equalsExp(SQL.detalleContratoAcad.cargaCursoId)),
        innerJoin(SQL.contrato, SQL.contrato.idContrato.equalsExp(SQL.detalleContratoAcad.idContrato)),
        innerJoin(SQL.planCursos, SQL.cargaCurso.planCursoId.equalsExp(SQL.planCursos.planCursoId)),
        innerJoin(SQL.planEstudio, SQL.planCursos.planEstudiosId.equalsExp(SQL.planEstudio.planEstudiosId)),
        innerJoin(SQL.programasEducativo, SQL.planEstudio.programaEduId.equalsExp(SQL.programasEducativo.programaEduId)),
        innerJoin(SQL.silaboEvento, SQL.cargaCurso.cargaCursoId.equalsExp(SQL.silaboEvento.cargaCursoId)),
        innerJoin(SQL.cursos, SQL.cursos.cursoId.equalsExp(SQL.planCursos.cursoId)),
        innerJoin(SQL.cargaAcademica, SQL.cargaCurso.cargaAcademicaId.equalsExp(SQL.cargaAcademica.cargaAcademicaId)),
        innerJoin(SQL.aula, SQL.cargaAcademica.aulaId.equalsExp(SQL.aula.aulaId)),
        innerJoin(SQL.seccion, SQL.cargaAcademica.seccionId.equalsExp(SQL.seccion.seccionId)),
        innerJoin(SQL.periodos, SQL.cargaAcademica.periodoId.equalsExp(SQL.periodos.periodoId)),
        innerJoin(SQL.nivelAcademico, SQL.programasEducativo.nivelAcadId.equalsExp(SQL.nivelAcademico.nivelAcadId)),
        leftOuterJoin(SQL.parametrosDisenio, SQL.silaboEvento.parametroDisenioId.equalsExp(SQL.parametrosDisenio.parametroDisenioId))
      ]);

      query.where(SQL.contrato.personaId.equals(alumnoId));
      query.where(SQL.detalleContratoAcad.anioAcademicoId.equals(anioAcademico));
      query.where(SQL.silaboEvento.estadoId.isNotIn([243]));
      query.where(SQL.programasEducativo.programaEduId.equals(programaAcademicoId));
      query.where(SQL.cursos.tipoConceptoId.equals(495));
      query.where(SQL.contrato.estadoId.equals(190));
      query.groupBy([SQL.silaboEvento.silaboEventoId]);
      var rows = await query.get();

      ParametrosDisenioData? defaultParametrosDisenioData = await (SQL.selectSingle(SQL.parametrosDisenio)..where((tbl) => tbl.nombre.equals("default"))).getSingleOrNull();
      List<CursoUi> cursoUiList = [];
      for(var data in rows){
        CursoUi cursoUi = CursoUi();
        Curso curso = data.readTable(SQL.cursos);
        CargaCursoData cargaCursoData = data.readTable(SQL.cargaCurso);
        ParametrosDisenioData parametrosDisenioData = data.readTable(SQL.parametrosDisenio);
        SeccionData seccionData = data.readTable(SQL.seccion);
        Periodo periodoData = data.readTable(SQL.periodos);
        AulaData aulaData = data.readTable(SQL.aula);
        NivelAcademicoData nivelAcademicoData = data.readTable(SQL.nivelAcademico);

        cursoUi.nombre = curso.nombre;
        cursoUi.nombreDocente = AppTools.capitalize(cargaCursoData.nombreDocente??"");
        cursoUi.fotoDocente = cargaCursoData.fotoDocente;
        cursoUi.seccion = seccionData.nombre;
        cursoUi.grado = periodoData.aliasPeriodo;
        cursoUi.nivelAcademico = nivelAcademicoData.nombre;
        cursoUi.salon = (aulaData.descripcion??"")+ ": " + (aulaData.numero??"");

        if(parametrosDisenioData!=null){
          cursoUi.colorCurso = parametrosDisenioData.color1;
          cursoUi.colorCurso2 = parametrosDisenioData.color2;
          cursoUi.colorCurso3 = parametrosDisenioData.color3;
          cursoUi.imagenCurso = parametrosDisenioData.path;
        }else{
          if(defaultParametrosDisenioData!=null){
            cursoUi.colorCurso = defaultParametrosDisenioData.color1;
            cursoUi.colorCurso2 = defaultParametrosDisenioData.color2;
            cursoUi.colorCurso3 = defaultParametrosDisenioData.color3;
            cursoUi.imagenCurso = parametrosDisenioData.path;
          }
        }
        cursoUiList.add(cursoUi);
      }

      return cursoUiList;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> saveAsistencia(Map<String, dynamic> datosAsistencia, int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId) async {
    AppDataBase SQL = AppDataBase();
    try{

      await SQL.transaction(() async {
        var query = SQL.select(SQL.asistenciaAlumnos).join([
          leftOuterJoin(SQL.asistenciaJustificacion, SQL.asistenciaJustificacion.asistenciaSesionId.equalsExp(SQL.asistenciaAlumnos.asistenciaSesionId)),
          leftOuterJoin(SQL.asistecniaArchivo, SQL.asistecniaArchivo.justificacionId.equalsExp(SQL.asistenciaJustificacion.justificacionId)),
        ]);

        query.where(SQL.asistenciaAlumnos.anioAcademicoId.equals(anioAcademicoId));
        query.where(SQL.asistenciaAlumnos.programaAcadId.equals(programaId));
        query.where(SQL.asistenciaAlumnos.calendarioPeriodoId.equals(calendarioPeridoId));
        query.where(SQL.asistenciaAlumnos.alumnoId.equals(alumnoId));

        var rows = await query.get();
        print("saveEvaluaciones cantidad : "+rows.length.toString());
        for (var row in rows) {
          AsistenciaAlumno asistenciaAlumno = row.readTable(SQL.asistenciaAlumnos);
          await (SQL.delete(SQL.asistenciaAlumnos).delete(asistenciaAlumno));
          AsistenciaJustificacionData asistenciaJustificacionData = row.readTable(SQL.asistenciaJustificacion);
          if(asistenciaJustificacionData!=null){
            await (SQL.delete(SQL.asistenciaJustificacion).delete(asistenciaJustificacionData));
          }
          AsistecniaArchivoData asistecniaArchivoData = row.readTable(SQL.asistecniaArchivo);
          if(asistecniaArchivoData!=null){
            await (SQL.delete(SQL.asistecniaArchivo).delete(asistecniaArchivoData));
          }
        }

        var queryNota = SQL.select(SQL.asistenciaTipoNota).join([
          innerJoin(SQL.asistenciaRelProgramaTipoNota, SQL.asistenciaTipoNota.tipoNotaId.equalsExp(SQL.asistenciaRelProgramaTipoNota.tipoNotaId)),
        ]);
        var rowsNota = await queryNota.get();
        for (var row in rowsNota) {
          AsistenciaTipoNotaData asistenciaTipoNotaData = row.readTable(SQL.asistenciaTipoNota);
          await (SQL.delete(SQL.asistenciaTipoNota).delete(asistenciaTipoNotaData));
          AsistenciaRelProgramaTipoNotaData asistenciaRelProgramaTipoNotaData = row.readTable(SQL.asistenciaRelProgramaTipoNota);
          await (SQL.delete(SQL.asistenciaRelProgramaTipoNota).delete(asistenciaRelProgramaTipoNotaData));
          await (SQL.delete(SQL.asistenciaValorTipoNota)..where((tbl) => tbl.tipoNotaId.equals(asistenciaTipoNotaData.tipoNotaId))).go();

        }

      });

      await SQL.batch((batch) async {
        if(datosAsistencia.containsKey("asistenciaAlumnos")){
          //personaSerelizable.addAll(datosInicioPadre["usuariosrelacionados"]);
          batch.insertAll(SQL.asistenciaAlumnos, SerializableConvert.converListSerializeAsistenciaAlumnos(datosAsistencia["asistenciaAlumnos"]), mode: InsertMode.insertOrReplace );

        }

        if(datosAsistencia.containsKey("justificacion")){
          batch.insertAll(SQL.asistenciaJustificacion, SerializableConvert.converListSerializeAsistenciaJustificacion(datosAsistencia["justificacion"]), mode: InsertMode.insertOrReplace );
        }

        if(datosAsistencia.containsKey("archivoAsistencia")){
          batch.insertAll(SQL.asistecniaArchivo, SerializableConvert.converListSerializeAsistecniaArchivo(datosAsistencia["archivoAsistencia"]), mode: InsertMode.insertOrReplace );
        }

        if(datosAsistencia.containsKey("tipoNota")){
          batch.insertAll(SQL.asistenciaTipoNota, SerializableConvert.converListSerializeAsistenciaTipoNota(datosAsistencia["tipoNota"]), mode: InsertMode.insertOrReplace );
        }

        if(datosAsistencia.containsKey("valorTipoNota")){
          batch.insertAll(SQL.asistenciaValorTipoNota, SerializableConvert.converListSerializeAsistenciaValorTipoNota(datosAsistencia["valorTipoNota"]), mode: InsertMode.insertOrReplace );
        }

        if(datosAsistencia.containsKey("relProgramaEducativoTipoNota")){
          batch.insertAll(SQL.asistenciaRelProgramaTipoNota, SerializableConvert.converListSerializeAsistenciaRelProgramaTipoNota(datosAsistencia["relProgramaEducativoTipoNota"]), mode: InsertMode.insertOrReplace );
        }

      });
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<AsistenciaUi>> getAsistenciaAlumno(int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId) async{
    AppDataBase SQL = AppDataBase();
    try{

      WebConfig? webConfig = await (SQL.selectSingle(SQL.webConfigs)..where((tbl) => tbl.nombre.equals("wstr_UrlExpresiones"))).getSingleOrNull();
      String urlExpresiones = webConfig?.content??"";
      /*
      * Obtner asistencia por cursos
      * */
      List<AsistenciaUi> asistenciaUiList = [];

      var query = SQL.select(SQL.asistenciaAlumnos).join([
        leftOuterJoin(SQL.parametrosDisenio, SQL.asistenciaAlumnos.parametroDesenioId.equalsExp(SQL.parametrosDisenio.parametroDisenioId)),
        leftOuterJoin(SQL.asistenciaValorTipoNota, SQL.asistenciaValorTipoNota.valorTipoNotaId.equalsExp(SQL.asistenciaAlumnos.valorTipoNotaId)),

      ]);

      query.where(SQL.asistenciaAlumnos.anioAcademicoId.equals(anioAcademicoId));
      query.where(SQL.asistenciaAlumnos.programaAcadId.equals(programaId));
      query.where(SQL.asistenciaAlumnos.calendarioPeriodoId.equals(calendarioPeridoId));
      query.where(SQL.asistenciaAlumnos.alumnoId.equals(alumnoId));
      query.orderBy([OrderingTerm(expression: SQL.asistenciaAlumnos.silaboEventoId), OrderingTerm(expression: SQL.asistenciaAlumnos.fechaAsistenciaTime)]);
      //query.where(SQL.evaluacionDesempenio.secRubroEvalProcesoId.equals(""));
      var rows = await query.get();

      ParametrosDisenioData? defaultParametrosDisenioData = await (SQL.selectSingle(SQL.parametrosDisenio)..where((tbl) => tbl.nombre.equals("default"))).getSingleOrNull();

      for(var item in rows){
        AsistenciaAlumno asistenciaAlumnoData = item.readTable(SQL.asistenciaAlumnos);
        ParametrosDisenioData parametrosDisenioData = item.readTable(SQL.parametrosDisenio);
        AsistenciaValorTipoNotaData asistenciaValorTipoNotaData = item.readTable(SQL.asistenciaValorTipoNota);
        AsistenciaUi asistenciaUi = AsistenciaUi();
        asistenciaUi.asistenciaId = asistenciaAlumnoData.asistenciaSesionId;

        AsistenciaJustificacionData? asistenciaJustificacionData = await (SQL.selectSingle(SQL.asistenciaJustificacion)..where((tbl) => tbl.asistenciaSesionId.equals(asistenciaAlumnoData.asistenciaSesionId))).getSingleOrNull();
        if(asistenciaJustificacionData!=null){
          asistenciaUi.descripcion = asistenciaJustificacionData.descripcion;
        }
        asistenciaUi.fecha = AppTools.f_fecha_letras(asistenciaAlumnoData.fechaAsistenciaTime);
        if(asistenciaValorTipoNotaData!=null){
          AsistenciaEstadoEnumUi asistenciaEstadoEnumUi;
          switch(asistenciaValorTipoNotaData.estadoId){
            case 285://Puntual
              asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.PUNTUAL;
              break;
            case 286://TARDE
              asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.TARDE;
              break;
            case 287://AUSENTE
              asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.AUSENTE;
              break;
            case 288://TARDE_JDT
              asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.TARDE_JDT;
              break;
            case 289://AUSENTE_JDT
              asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.AUSENTE_JDT;
              break;
            default:
              asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.TARDE;
              break;
          }
          AsistenciaTipoUi asistenciaTipoUi = AsistenciaTipoUi(valorTipoNotaId: asistenciaValorTipoNotaData.valorTipoNotaId, nombre: asistenciaValorTipoNotaData.tipoNotaAlias, logo: asistenciaValorTipoNotaData.icono, estado: asistenciaEstadoEnumUi);
          asistenciaUi.asistenciaTipoUi = asistenciaTipoUi;
        }


        asistenciaUi.cursoUi = CursoUi();
        asistenciaUi.cursoUi?.silaboEventoId = asistenciaAlumnoData.silaboEventoId;
        asistenciaUi.cursoUi?.cargaCursoId = asistenciaAlumnoData.cargaCursoId;
        asistenciaUi.cursoUi?.nombre = asistenciaAlumnoData.nombreCurso;
        if(parametrosDisenioData!=null){
          asistenciaUi.cursoUi?.colorCurso = parametrosDisenioData.color1;
          asistenciaUi.cursoUi?.colorCurso2 = parametrosDisenioData.color2;
          asistenciaUi.cursoUi?.colorCurso3 = parametrosDisenioData.color3;
        }else{
          if(defaultParametrosDisenioData!=null){
            asistenciaUi.cursoUi?.colorCurso = defaultParametrosDisenioData.color1;
            asistenciaUi.cursoUi?.colorCurso2 = defaultParametrosDisenioData.color2;
            asistenciaUi.cursoUi?.colorCurso3 = defaultParametrosDisenioData.color3;
          }
        }
        asistenciaUiList.add(asistenciaUi);
      }


      return asistenciaUiList;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<AsistenciaTipoUi>> getAsistenciaTipo(int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId)async {
    AppDataBase SQL = AppDataBase();
    try{


      var query = SQL.select(SQL.asistenciaAlumnos).join([
        innerJoin(SQL.asistenciaValorTipoNota, SQL.asistenciaValorTipoNota.valorTipoNotaId.equalsExp(SQL.asistenciaAlumnos.valorTipoNotaId)),
        innerJoin(SQL.asistenciaTipoNota, SQL.asistenciaTipoNota.tipoNotaId.equalsExp(SQL.asistenciaValorTipoNota.tipoNotaId)),
      ]);

      query.where(SQL.asistenciaAlumnos.anioAcademicoId.equals(anioAcademicoId));
      query.where(SQL.asistenciaAlumnos.programaAcadId.equals(programaId));
      query.where(SQL.asistenciaAlumnos.calendarioPeriodoId.equals(calendarioPeridoId));
      query.where(SQL.asistenciaAlumnos.alumnoId.equals(alumnoId));

      int p=0;
      int t=0;
      int tj=0;
      int a=0;
      int aj=0;
      int cantidad=0;

      var rows = await query.get();
      for(var row in rows){
        AsistenciaValorTipoNotaData asistenciaValorTipoNotaData = row.readTable(SQL.asistenciaValorTipoNota);
        switch(asistenciaValorTipoNotaData.estadoId){
          case 285://Puntual
            p++;
            break;
          case 286://TARDE
            t++;
            break;
          case 287://AUSENTE
            a++;
            break;
          case 288://TARDE_JDT
            tj++;
            break;
          case 289://AUSENTE_JDT
            aj++;
            break;
        }
        cantidad++;
      }

      var queryTipoNota = SQL.select(SQL.asistenciaValorTipoNota).join([
        innerJoin(SQL.asistenciaTipoNota, SQL.asistenciaTipoNota.tipoNotaId.equalsExp(SQL.asistenciaValorTipoNota.tipoNotaId)),
        innerJoin(SQL.asistenciaRelProgramaTipoNota, SQL.asistenciaRelProgramaTipoNota.tipoNotaId.equalsExp(SQL.asistenciaTipoNota.tipoNotaId)),
      ]);

      queryTipoNota.where(SQL.asistenciaRelProgramaTipoNota.programaEducativoId.equals(programaId));
      queryTipoNota.where(SQL.asistenciaTipoNota.tipoId.equals(474));
      queryTipoNota.where(SQL.asistenciaRelProgramaTipoNota.estado.equals(true));
      query.orderBy([OrderingTerm(expression: SQL.asistenciaValorTipoNota.estadoId)]);
      var rowsTipoNota = await queryTipoNota.get();

      List<AsistenciaTipoUi> asistenciaTipoUiList = [];
      for(var row in rowsTipoNota){
        AsistenciaTipoNotaData asistenciaTipoNotaData = row.readTable(SQL.asistenciaTipoNota);
        AsistenciaValorTipoNotaData asistenciaValorTipoNotaData = row.readTable(SQL.asistenciaValorTipoNota);
        AsistenciaTipoUi asistenciaTipoUi = AsistenciaTipoUi();
        switch(asistenciaValorTipoNotaData.estadoId){
          case 285://Puntual
            asistenciaTipoUi.alias = "P";
            asistenciaTipoUi.cantidad = p;
            if(cantidad!=0)asistenciaTipoUi.porcentaje  = (p * 100 / cantidad).toInt();
            break;
          case 286://TARDE
            asistenciaTipoUi.alias = "T";
            asistenciaTipoUi.cantidad = t;
            if(cantidad!=0)asistenciaTipoUi.porcentaje  = (t * 100 / cantidad).round().toInt();
            break;
          case 287://AUSENTE
            asistenciaTipoUi.alias = "A";
            asistenciaTipoUi.cantidad = a;
            if(cantidad!=0)asistenciaTipoUi.porcentaje  = (a * 100 / cantidad).round().toInt();
            break;
          case 288://TARDE_JDT
            asistenciaTipoUi.alias = "TJ";
            asistenciaTipoUi.cantidad = tj;
            if(cantidad!=0)asistenciaTipoUi.porcentaje  = (tj * 100 / cantidad).round().toInt();
            break;
          case 289://AUSENTE_JDT
            asistenciaTipoUi.alias = "AJ";
            asistenciaTipoUi.cantidad = aj;
            if(cantidad!=0)asistenciaTipoUi.porcentaje  = (aj * 100 / cantidad).round().toInt();
            break;
          default:
            asistenciaTipoUi.alias = "";
            asistenciaTipoUi.cantidad = 0;
            if(cantidad!=0)asistenciaTipoUi.porcentaje  = 0;
            break;
        }

        AsistenciaEstadoEnumUi asistenciaEstadoEnumUi;
        switch(asistenciaValorTipoNotaData.estadoId){
          case 285://Puntual
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.PUNTUAL;
            break;
          case 286://TARDE
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.TARDE;
            break;
          case 287://AUSENTE
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.AUSENTE;
            break;
          case 288://TARDE_JDT
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.TARDE_JDT;
            break;
          case 289://AUSENTE_JDT
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.AUSENTE_JDT;
            break;
          default:
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.TARDE;
            break;
        }
        asistenciaTipoUi.estado = asistenciaEstadoEnumUi;
        asistenciaTipoUi.logo = asistenciaValorTipoNotaData.icono;
        asistenciaTipoUiList.add(asistenciaTipoUi);
      }



      return asistenciaTipoUiList;

    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<void> saveAsistenciaGeneral(Map<String, dynamic> datosAsistencia, int calendarioPeridoId, int alumnoId) async {
    AppDataBase SQL = AppDataBase();
    try{

      await SQL.transaction(() async {
        var query = SQL.select(SQL.asistenciaGeneral)..where((tbl) =>  tbl.alumnoId.equals(alumnoId));
        query.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeridoId));

        var rows = await query.get();
        print("saveEvaluaciones cantidad : "+rows.length.toString());
        for (AsistenciaGeneralData row in rows) {
          await (SQL.delete(SQL.asistenciaGeneral).delete(row));
        }
      });

      await SQL.batch((batch) async {

        if(datosAsistencia.containsKey("asistencia")){

          batch.insertAll(SQL.asistenciaGeneral, SerializableConvert.converListSerializeAsistenciaGeneral(datosAsistencia["asistencia"]), mode: InsertMode.insertOrReplace );

        }
      });
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<AsistenciaUi>> getAsistenciaGeneral(int calendarioPeridoId, int alumnoId) async{
    AppDataBase SQL = AppDataBase();
    try{

      WebConfig? webConfig = await (SQL.selectSingle(SQL.webConfigs)..where((tbl) => tbl.nombre.equals("wstr_UrlExpresiones"))).getSingleOrNull();
      String? urlExpresiones = webConfig?.content??"";
      /*
      * Obtner asistencia por cursos
      * */
      List<AsistenciaUi> asistenciaUiList = [];

      var query = SQL.select(SQL.asistenciaGeneral)..where((tbl) => tbl.alumnoId.equals(alumnoId));
      query.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeridoId));

      var rows = await query.get();

      await Future.forEach(rows, (AsistenciaGeneralData asistenciaGeneralData) async{

        AsistenciaUi asistenciaUi = AsistenciaUi();
        asistenciaUi.asistenciaId = asistenciaGeneralData.controlAsistenciaId.toString();
        DateTime dateTime = AppTools.convertDateTimePtBR(asistenciaGeneralData.fechaAsistencia, asistenciaGeneralData.horaIngreso);
        asistenciaUi.fecha = AppTools.f_fecha_letras(dateTime);
        asistenciaUi.timeStamp = dateTime;
        AsistenciaTipoUi asistenciaTipoUi = AsistenciaTipoUi();
        asistenciaTipoUi.nombre = asistenciaGeneralData.estadosIngresoNombre;

        AsistenciaEstadoEnumUi asistenciaEstadoEnumUi;
        switch(asistenciaGeneralData.estadoIngresoId){
          case 285://Puntual
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.PUNTUAL;
            break;
          case 286://TARDE
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.TARDE;
            break;
          case 287://AUSENTE
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.AUSENTE;
            break;
          case 288://TARDE_JDT
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.TARDE_JDT;
            break;
          case 289://AUSENTE_JDT
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.AUSENTE_JDT;
            break;
          default:
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.TARDE;
            break;
        }
        asistenciaTipoUi.estado = asistenciaEstadoEnumUi;
        asistenciaUi.asistenciaTipoUi = asistenciaTipoUi;

        asistenciaUiList.add(asistenciaUi);
      });

      asistenciaUiList.sort((o2, o1) => (o2.timeStamp??DateTime(1960)).compareTo(o1.timeStamp??DateTime(1960)));

      return asistenciaUiList;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<List<AsistenciaTipoUi>> getAsistenciaTipoGeneral(int calendarioPeridoId, int alumnoId)async {
    AppDataBase SQL = AppDataBase();
    try{


      var query = SQL.select(SQL.asistenciaGeneral)..where((tbl) => tbl.alumnoId.equals(alumnoId));
      query.where((tbl) => tbl.calendarioPeriodoId.equals(calendarioPeridoId));

      int p=0;
      int t=0;
      int tj=0;
      int a=0;
      int aj=0;
      int cantidad=0;

      var rows = await query.get();
      for(AsistenciaGeneralData asistenciaGeneral in rows){

        switch(asistenciaGeneral.estadoIngresoId){
          case 285://Puntual
            p++;
            break;
          case 286://TARDE
            t++;
            break;
          case 287://AUSENTE
            a++;
            break;
          case 288://TARDE_JDT
            tj++;
            break;
          case 289://AUSENTE_JDT
            aj++;
            break;
        }
        cantidad++;
      }

      var estadoIdList = [285, 286, 287, 288, 289];
      List<AsistenciaTipoUi> asistenciaTipoUiList = [];
      for(var estadoId in estadoIdList){

        AsistenciaTipoUi asistenciaTipoUi = AsistenciaTipoUi();
        switch(estadoId){
          case 285://Puntual
            asistenciaTipoUi.alias = "P";
            asistenciaTipoUi.cantidad = p;
            if(cantidad!=0)asistenciaTipoUi.porcentaje  = (p * 100 / cantidad).round().toInt();
            break;
          case 286://TARDE
            asistenciaTipoUi.alias = "T";
            asistenciaTipoUi.cantidad = t;
            if(cantidad!=0)asistenciaTipoUi.porcentaje  = (t * 100 / cantidad).round().toInt();
            break;
          case 287://AUSENTE
            asistenciaTipoUi.alias = "A";
            asistenciaTipoUi.cantidad = a;
            if(cantidad!=0)asistenciaTipoUi.porcentaje  = (a * 100 / cantidad).round().toInt();
            break;
          case 288://TARDE_JDT
            asistenciaTipoUi.alias = "TJ";
            asistenciaTipoUi.cantidad = tj;
            if(cantidad!=0)asistenciaTipoUi.porcentaje  = (tj * 100 / cantidad).round().toInt();
            break;
          case 289://AUSENTE_JDT
            asistenciaTipoUi.alias = "AJ";
            asistenciaTipoUi.cantidad = aj;
            if(cantidad!=0)asistenciaTipoUi.porcentaje  = (aj * 100 / cantidad).round().toInt();
            break;
          default:
            asistenciaTipoUi.alias = "";
            asistenciaTipoUi.cantidad = 0;
            if(cantidad!=0)asistenciaTipoUi.porcentaje  = 0;
            break;
        }

        AsistenciaEstadoEnumUi asistenciaEstadoEnumUi;
        switch(estadoId){
          case 285://Puntual
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.PUNTUAL;
            break;
          case 286://TARDE
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.TARDE;
            break;
          case 287://AUSENTE
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.AUSENTE;
            break;
          case 288://TARDE_JDT
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.TARDE_JDT;
            break;
          case 289://AUSENTE_JDT
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.AUSENTE_JDT;
            break;
          default:
            asistenciaEstadoEnumUi = AsistenciaEstadoEnumUi.TARDE;
            break;
        }
        asistenciaTipoUi.estado = asistenciaEstadoEnumUi;
        asistenciaTipoUiList.add(asistenciaTipoUi);
      }



      return asistenciaTipoUiList;

    }catch(e){
      throw Exception(e);
    }
  }



}