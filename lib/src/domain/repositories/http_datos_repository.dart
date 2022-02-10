import 'package:padre_mentor/src/domain/entities/familia_ui.dart';
import 'package:padre_mentor/src/domain/entities/hijos_ui.dart';
import 'package:padre_mentor/src/domain/entities/usuario_ui.dart';

abstract class HttpDatosRepository {
  Future<Map<String, dynamic>?> getDatosInicioPadre(String urlServidor, int usuarioId);
  Future<Map<String, dynamic>?> getBoletasNotas(String urlServidor, int anioAcademicoId, int programaId, int periodoId, int seccionId, int calendarioPeridoId, int alumnoId, int georeferenciaId);
  Future<Map<String, dynamic>?> getEvaluacionesPorCurso(String urlServidor, int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId);
  Future<Map<String, dynamic>?> getTareaPorCurso(String urlServidor, int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId);
  Future<Map<String, dynamic>?> getEventoAgenda(String urlServidor, int usuarioId, int tipoEventoId);
  Future<Map<String, dynamic>?> getContacto(String urlServidor, int usuarioId);
  Future<Map<String, dynamic>?> getUsuarioExterno(int opcion, String usuario, String password, String correo, String dni);
  Future<Map<String, dynamic>?> getUsuario(String urlServidor, int usuarioId);
  Future<List<dynamic>?> updateFamilia(String urlServidor, int usuarioId, List<dynamic> jsonPersonas);
  Future<Map<String, dynamic>?> getEvaluacionAlumno(String urlServidorLocal, int anioAcademicoId, int programaId, int calendarioPeridoId, int alumnoId);
  Future<Map<String, dynamic>?> getEvaluacionGeneral(String urlServidorLocal, int calendarioPeridoId, int alumnoId);
  Future<bool?> isHabilitadoUsuario(String urlServidor, int hijoPersonId);
}