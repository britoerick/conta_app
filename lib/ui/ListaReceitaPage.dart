import 'dart:io';

import 'package:conta_app/domain/ReceitaDomain.dart';
import 'package:conta_app/helpers/ReceitaHelper.dart';
import 'package:conta_app/ui/ReceitaPage.dart';
import 'package:flutter/material.dart';


class ListaReceitaPage extends StatefulWidget {
  @override
  _ListaReceitaPageState createState() => _ListaReceitaPageState();
}

class _ListaReceitaPageState extends State<ListaReceitaPage> {
  ReceitaHelper helper = ReceitaHelper();
  List<ReceitaDomain> receitas = List();

  @override
  void initState() {
    super.initState();
    updateList();
  }

  void updateList() {
    helper.getAllReceita().then((list) {
      setState(() {
        receitas = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showReceitaPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: receitas.length,
          itemBuilder: (context, index) {
            return _receitaCard(context, index);
          }),
    );
  }

  Widget _receitaCard(BuildContext context, int index) {
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
                          image: receitas[index].imgReceita != null ?
                          FileImage(File(receitas[index].imgReceita)) :
                          AssetImage("images/photo-camera.png"))
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        receitas[index].descricaoReceita ?? "",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        receitas[index].dataReceita ?? "",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        receitas[index].valorReceita ?? "",
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Text(
                        receitas[index].bancoReceita ?? "",
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
                              _showReceitaPage(receita: receitas[index]);
                            })),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                            child: Text("excluir",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 20.0)),
                            onPressed: () {
                              helper.deleteReceita(receitas[index].id);
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

  void _showReceitaPage({ReceitaDomain receita}) async {
    ReceitaDomain receitaRet = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ReceitaPage(receita: receita)));

    if (receitaRet != null) {
      print(receitaRet.id);
      if (receitaRet.id == null)
        await helper.saveReceita(receitaRet);
      else
        await helper.updateReceita(receitaRet);

      updateList();
    }
  }
}