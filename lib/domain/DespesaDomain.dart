class DespesaDomain {

  static final String despesaTable = "despesaTable";
  static final String idColumn = "idColumn";
  static final String descricaoColumn = "descricaoColumn";
  static final String dataColumn = "dataColumn";
  static final String imgColumn = "imgColumn";
  static final String valorColumn = "valorColumn";

  int id;
  String descricaoDespesa;
  String dataDespesa;
  String imgDespesa;
  String valorDespesa;

  DespesaDomain();

  DespesaDomain.fromMap(Map map) {
    id = map[idColumn];
    descricaoDespesa = map[descricaoColumn];
    dataDespesa = map[dataColumn];
    imgDespesa = map[imgColumn];
    valorDespesa = map[valorColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      descricaoColumn: descricaoDespesa,
      dataColumn: dataDespesa,
      imgColumn: imgDespesa,
      valorColumn: valorDespesa,
    };
    if (id != null) map[idColumn] = id;

    return map;
  }

  @override
  String toString() {
    return "DespesaDomain(id: ${id}, descricao: ${descricaoDespesa}, data: ${dataDespesa}, img: ${imgDespesa}, valor: ${valorDespesa})";
  }
}