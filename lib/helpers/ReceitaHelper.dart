import 'package:conta_app/domain/ReceitaDomain.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ReceitaHelper {

  static final ReceitaHelper _instance = ReceitaHelper.internal();

  factory ReceitaHelper() => _instance;

  ReceitaHelper.internal();

  Database dbconta;

  Future<Database> get db async {
    if (dbconta == null)
      dbconta = await initDb();
    return dbconta;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "conta_app.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
          await db.execute(
              "CREATE TABLE ${ReceitaDomain.receitaTable}(${ReceitaDomain
                  .idColumn} INTEGER PRIMARY KEY, "
                  "                                 ${ReceitaDomain
                  .descricaoColumn} TEXT, "
                  "                                 ${ReceitaDomain
                  .dataColumn} TEXT, "
                  "                                 ${ReceitaDomain
                  .imgColumn} TEXT, "
                  "                                 ${ReceitaDomain
                  .valorColumn} TEXT, "
                  "                                 ${ReceitaDomain
                  .bancoColumn} TEXT )");
        });
  }

  Future<ReceitaDomain> saveReceita(ReceitaDomain d) async {
    Database dbcontaconta = await dbconta;
    d.id = await dbcontaconta.insert(ReceitaDomain.receitaTable, d.toMap());
    return d;
  }

  Future<ReceitaDomain> getReceita(int id) async {
    Database dbContaConta = await dbconta;
    List<Map> maps = await dbContaConta.query(
        ReceitaDomain.receitaTable, columns: [
        ReceitaDomain.idColumn,
        ReceitaDomain.descricaoColumn,
        ReceitaDomain.dataColumn,
        ReceitaDomain.imgColumn,
        ReceitaDomain.valorColumn
    ], where: "${ReceitaDomain.idColumn} = ?",
        whereArgs: [id]);
    if(maps.length > 0)
      return ReceitaDomain.fromMap(maps.first);
    else
      return null;
  }

  Future<int> deleteReceita(int id)  async{
    Database dbContaConta = await dbconta;
    return await dbContaConta.delete(ReceitaDomain.receitaTable, where: "${ReceitaDomain.idColumn} = ?", whereArgs: [id]);
  }

  Future<int> updateReceita(ReceitaDomain d)  async{
    Database dbContaConta = await dbconta;
    return await dbContaConta.update(ReceitaDomain.receitaTable, d.toMap(), where: "${ReceitaDomain.idColumn} = ?", whereArgs: [d.id]);
  }

  Future<List> getAllReceita() async {
    Database dbContaContaDomain = await dbconta;
    List listMap = await dbContaContaDomain.query(ReceitaDomain.receitaTable);
    List<ReceitaDomain> listdbContaContaDomain = List();

    for(Map m in listMap) {
      listdbContaContaDomain.add(ReceitaDomain.fromMap(m));
    }
    return listdbContaContaDomain;
  }

  Future<int> getNumber() async {
    Database dbContaContaDomain = await dbconta;
    return Sqflite.firstIntValue(await dbContaContaDomain.rawQuery("select count(*) from ${ReceitaDomain.receitaTable}"));
  }

  Future close() async{
    Database dbContaContaDomain = await dbconta;
    dbContaContaDomain.close();
  }

}