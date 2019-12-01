import 'package:conta_app/domain/DespesaDomain.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DespesaHelper {

  static final DespesaHelper _instance = DespesaHelper.internal();

  factory DespesaHelper() => _instance;

  DespesaHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db == null)
      _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "conta_app.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
          await db.execute(
              "CREATE TABLE ${DespesaDomain.despesaTable}(${DespesaDomain
                  .idColumn} INTEGER PRIMARY KEY, "
                  "                                 ${DespesaDomain
                  .descricaoColumn} TEXT, "
                  "                                 ${DespesaDomain
                  .dataColumn} TEXT, "
                  "                                 ${DespesaDomain
                  .imgColumn} TEXT, "
                  "                                 ${DespesaDomain
                  .valorColumn} TEXT) ");
        });
  }

  Future<DespesaDomain> saveDespesa(DespesaDomain d) async {
    Database dbContaConta = await db;
    d.id = await dbContaConta.insert(DespesaDomain.despesaTable, d.toMap());
    return d;
  }

  Future<DespesaDomain> getDespesa(int id) async {
    Database dbContaConta = await db;
    List<Map> maps = await dbContaConta.query(
        DespesaDomain.despesaTable, columns: [
        DespesaDomain.idColumn,
        DespesaDomain.descricaoColumn,
        DespesaDomain.dataColumn,
        DespesaDomain.imgColumn,
        DespesaDomain.valorColumn
    ], where: "${DespesaDomain.idColumn} = ?",
        whereArgs: [id]);
    if(maps.length > 0)
      return DespesaDomain.fromMap(maps.first);
    else
      return null;
  }

  Future<int> deleteDespesa(int id)  async{
    Database dbContaConta = await db;
    return await dbContaConta.delete(DespesaDomain.despesaTable, where: "${DespesaDomain.idColumn} = ?", whereArgs: [id]);
  }

  Future<int> updateDespesa(DespesaDomain d)  async{
    Database dbContaConta = await db;
    return await dbContaConta.update(DespesaDomain.despesaTable, d.toMap(), where: "${DespesaDomain.idColumn} = ?", whereArgs: [d.id]);
  }

  Future<List> getAllDespesa() async {
    Database dbContaContaDomain = await db;
    List listMap = await dbContaContaDomain.query(DespesaDomain.despesaTable);
    List<DespesaDomain> listdbContaContaDomain = List();

    for(Map m in listMap) {
      listdbContaContaDomain.add(DespesaDomain.fromMap(m));
    }
    return listdbContaContaDomain;
  }

  Future<int> getNumber() async {
    Database dbContaContaDomain = await db;
    return Sqflite.firstIntValue(await dbContaContaDomain.rawQuery("select count(*) from ${DespesaDomain.despesaTable}"));
  }

  Future close() async{
    Database dbContaContaDomain = await db;
    dbContaContaDomain.close();
  }

}