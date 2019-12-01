import 'dart:io';

import 'package:conta_app/domain/DespesaDomain.dart';
import 'package:conta_app/helpers/DespesaHelper.dart';
import 'package:conta_app/ui/DespesaPage.dart';
import 'package:flutter/material.dart';



class ListaDespesaPage extends StatefulWidget {
  @override
  _ListaDespesaPageState createState() => _ListaDespesaPageState();
}

class _ListaDespesaPageState extends State<ListaDespesaPage> {
  DespesaHelper helper = DespesaHelper();
  List<DespesaDomain> despesas = List();

  @override
  void initState() {
    super.initState();
    updateList();
  }

  void updateList() {
    helper.getAllDespesa().then((list) {
      setState(() {
        despesas = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDespesaPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: despesas.length,
          itemBuilder: (context, index) {
            return _despesaCard(context, index);
          }),
    );
  }

  Widget _despesaCard(BuildContext context, int index) {
    return GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: despesas[index].imgDespesa != null ?
                            FileImage(File(despesas[index].imgDespesa)) :
                            AssetImage("images/photo-camera.png"))
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        despesas[index].descricaoDespesa ?? "",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        despesas[index].dataDespesa ?? "",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        despesas[index].valorDespesa ?? "",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          _showOptions(context, index);
        });
  }

  //mostra as opções
  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            //onclose obrigatório. Não fará nada
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            child: Text("editar",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 20.0)),
                            onPressed: () {
                              Navigator.pop(context);
                              _showDespesaPage(despesa: despesas[index]);
                            })),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            child: Text("feito",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 20.0)),
                            onPressed: () {
                              helper.deleteDespesa(despesas[index].id);
                              updateList();
                              Navigator.pop(context);
                            }))
                  ],
                ),
              );
            },
          );
        });
  }

  void _showDespesaPage({DespesaDomain despesa}) async {
    DespesaDomain despesaRet = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => DespesaPage(despesa: despesa)));

    if (despesaRet != null) {
      print(despesaRet.id);
      if (despesaRet.id == null)
        await helper.saveDespesa(despesaRet);
      else
        await helper.updateDespesa(despesaRet);

      updateList();
    }
  }
}