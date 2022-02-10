import 'package:padre_mentor/src/domain/entities/asistencia_tipo_ui.dart';
import 'package:padre_mentor/src/domain/entities/curso_ui.dart';

class AsistenciaUi{
 String? asistenciaId;
 String? fecha;
 DateTime? timeStamp;
 String? descripcion;
 AsistenciaTipoUi? asistenciaTipoUi;
  CursoUi? cursoUi;
 AsistenciaUi({this.asistenciaId, this.fecha, this.descripcion, this.asistenciaTipoUi, this.cursoUi, this.timeStamp});

}