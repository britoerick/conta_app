class ReceitaDomain {

  static final String receitaTable = "receitaTable";
  static final String idColumn = "idColumn";
  static final String descricaoColumn = "descricaoColumn";
  static final String dataColumn = "dataColumn";
  static final String imgColumn = "imgColumn";
  static final String valorColumn = "valorColumn";
  static final String bancoColumn = "bancoColumn";

  int id;
  String descricaoReceita;
  String dataReceita;
  String imgReceita;
  String valorReceita;
  String bancoReceita;

  ReceitaDomain();

  ReceitaDomain.fromMap(Map map) {
    id = map[idColumn];
    descricaoReceita = map[descricaoColumn];
    dataReceita = map[dataColumn];
    imgReceita = map[imgColumn];
    valorReceita = map[valorColumn];
    bancoReceita = map[bancoReceita];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      descricaoColumn: descricaoReceita,
      dataColumn: dataReceita,
      imgColumn: imgReceita,
      valorColumn: valorReceita,
      bancoColumn: bancoReceita
    };
    if (id != null) map[idColumn] = id;

    return map;
  }

  @override
  String toString() {
    return "ReceitaDomain(id: ${id}, descricao: ${descricaoReceita}, data: ${dataReceita}, img: ${imgReceita}, valor: ${bancoReceita})";
  }
}