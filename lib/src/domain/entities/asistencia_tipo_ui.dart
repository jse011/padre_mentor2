class AsistenciaTipoUi{

  String? valorTipoNotaId;
  AsistenciaEstadoEnumUi? estado;
  String? alias;
  int? cantidad;
  String? nombre;
  int? porcentaje;
  String? logo;

  AsistenciaTipoUi({this.valorTipoNotaId, this.estado, this.alias, this.cantidad,
      this.nombre, this.porcentaje, this.logo});

}

enum AsistenciaEstadoEnumUi{
  PUNTUAL,TARDE,AUSENTE,TARDE_JDT,AUSENTE_JDT
}
