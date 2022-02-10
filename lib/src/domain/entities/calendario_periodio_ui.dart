class CalendarioPeriodoUI{
  int? id;
  String? nombre;
  bool? selected = false;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  int? estadoId;
  CalendarioPeriodoUI({this.id, this.nombre, this.selected, this.fechaInicio, this.fechaFin, this.estadoId});
}