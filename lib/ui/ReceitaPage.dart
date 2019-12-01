import 'dart:io';
import 'package:conta_app/domain/ReceitaDomain.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:conta_app/lib/PatternFormatter.dart';

class ReceitaPage extends StatefulWidget {

  ReceitaDomain receita;

  ReceitaPage({this.receita});

  @override
  _ReceitaPageState createState() => _ReceitaPageState();
}

class _ReceitaPageState extends State<ReceitaPage> {

  ReceitaDomain _editedReceita;
  bool _userEdited;
  String selected;

  final _descricaoFocus = FocusNode();

  TextEditingController descricaoController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController valorController = TextEditingController();
  TextEditingController bancoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.receita == null)
      _editedReceita = ReceitaDomain();
    else {
      _editedReceita = ReceitaDomain.fromMap(widget.receita.toMap());
      descricaoController.text = _editedReceita.descricaoReceita;
      dataController.text = _editedReceita.dataReceita;
      valorController.text = _editedReceita.valorReceita;
      bancoController.text = _editedReceita.bancoReceita;
    }
  }

  Future<bool> _requestPop() {
    if (_userEdited != null &&_userEdited) {
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Cancelar alteração?"),
          content: Text("Os dados serão perdidos."),
          actions: <Widget>[
            FlatButton(
                child: Text("cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
            FlatButton(
              child: Text("sim"),
              onPressed: () {
                Navigator.pop(context);
              },
            )

          ]
          ,
        );
      });
    } else {
      return Future.value(true);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text("Nova Despesa"),
            centerTitle: true
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedReceita.descricaoReceita != null && _editedReceita.descricaoReceita.isNotEmpty)
              Navigator.pop(context, _editedReceita);
            else
              FocusScope.of(context).requestFocus(_descricaoFocus);
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editedReceita.imgReceita != null ?
                            FileImage(File(_editedReceita.imgReceita)) :
                            AssetImage("images/photo-camera.png"))
                    )
                ),
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file == null) return;
                    else {
                      setState(() {
                        _editedReceita.imgReceita = file.path;
                      });
                    }
                  });
                },
              ),
              TextField(
                controller: descricaoController,
                focusNode: _descricaoFocus,
                decoration: InputDecoration(
                    labelText: "Descrição"
                ),
                onChanged: (descricaoReceita) {
                  _userEdited = true;
                  setState(() {
                    _editedReceita.descricaoReceita = descricaoReceita;
                  });
                },
              ),
              TextField(
                controller: dataController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Data"
                ),
                inputFormatters: [
                  DateInputFormatter(),
                ],
                onChanged: (dataReceita) {
                  _userEdited = true;
                  _editedReceita.dataReceita = dataReceita;
                },
              ),
              TextField(
                controller: valorController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Valor"
                ),
                inputFormatters: [
                  ThousandsFormatter(allowFraction: true)
                ],
                onChanged: (valorReceita) {
                  _userEdited = true;
                  _editedReceita.valorReceita = valorReceita;
                },
              ),
              DropdownButtonFormField(
                value: selected,
                items: <String>['BANCO DO BRASIL', 'BRADESCO', 'CAIXA', 'ITAU'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() => selected = value);
                  _userEdited = true;
                  _editedReceita.bancoReceita = value;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}