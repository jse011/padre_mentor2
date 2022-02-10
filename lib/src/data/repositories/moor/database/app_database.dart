import 'package:moor_flutter/moor_flutter.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/Calendario.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/anio_academico_alumno.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/areas_boleta.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/asistencia_alumnos.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/asistencia_general.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/aula.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/calendario_acalendario.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/calendario_periodo.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/carga_academica.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/carga_cursos.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/contacto.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/contrato.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/cursos.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/detalle_contrato_acad.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/entidad.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/evento.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/georeferencia.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/nivel_academico.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/notas_calendario_boleta.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/parametros_disenio.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/periodos.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/persona.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/plan_cursos.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/plan_estudios.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/programas_educativo.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/relaciones.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/rol.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/rubro_eval_desempenio.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/seccion.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/session_user.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/session_user_hijo_programa.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/silabo_evento.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/tarea_curso.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/tipos.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/usuario.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/usuario_rol_georeferencia.dart';
import 'package:padre_mentor/src/data/repositories/moor/model/web_configs.dart';

part 'app_database.g.dart';

@UseMoor(tables: [Persona, Usuario, SessionUser, Relaciones, AnioAcademicoAlumno, ProgramasEducativo, PlanEstudio, PlanCursos, CargaCurso, DetalleContratoAcad, Contrato, CalendarioAcademico, CalendarioPeriodo, Tipos,
                  AreasBoleta, NotasCalendarioBoleta, ParametrosDisenio, SilaboEvento, RubroEvalDesempenio, WebConfigs, TareaCurso, Evento, Calendario, SessionUserHijoPrograma, Contacto, Entidad, Georeferencia, Rol, UsuarioRolGeoreferencia,
                  Cursos, Aula, Periodos, Seccion, CargaAcademica, NivelAcademico, AsistenciaAlumnos, AsistenciaJustificacion, AsistecniaArchivo, AsistenciaTipoNota, AsistenciaValorTipoNota, AsistenciaRelProgramaTipoNota,
                  AsistenciaGeneral])
class AppDataBase extends _$AppDataBase{

  @override
  int get schemaVersion => 1;

  static final AppDataBase _singleton = AppDataBase._internal();

  factory AppDataBase() {
    return _singleton;
  }

  AppDataBase._internal(): super(FlutterQueryExecutor.inDatabaseFolder(
      path: "db.sqlite", logStatements: true));

  SimpleSelectStatement<T, R> selectSingle<T extends Table, R extends DataClass>(TableInfo<T, R> table, {bool distinct = false}){
    var query = select(table, distinct: distinct);
    query.limit(1);
    return query;
  }
}
/*
* Moor integrates with Dart’s build system, so you can generate all the code needed with |.
* If you want to continuously rebuild the generated code where you change your code, run flutter packages pub run build_runner watch instead.
* After running either command once, the moor generator will have created a class for your database and data classes for your entities.
* To use it, change the MyDatabase class as follows:
* */
