import 'dart:io';
import 'package:conta_app/domain/DespesaDomain.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:conta_app/lib/PatternFormatter.dart';

class DespesaPage extends StatefulWidget {

  DespesaDomain despesa;

  DespesaPage({this.despesa});

  @override
  _DespesaPageState createState() => _DespesaPageState();
}

class _DespesaPageState extends State<DespesaPage> {

  DespesaDomain _editedDespesa;
  bool _userEdited;

  final _descricaoFocus = FocusNode();

  TextEditingController descricaoController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController valorController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.despesa == null)
      _editedDespesa = DespesaDomain();
    else {
      _editedDespesa = DespesaDomain.fromMap(widget.despesa.toMap());
      descricaoController.text = _editedDespesa.descricaoDespesa;
      dataController.text = _editedDespesa.dataDespesa;
      valorController.text = _editedDespesa.valorDespesa;
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
            if (_editedDespesa.descricaoDespesa != null && _editedDespesa.descricaoDespesa.isNotEmpty)
              Navigator.pop(context, _editedDespesa);
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
                            image: _editedDespesa.imgDespesa != null ?
                            FileImage(File(_editedDespesa.imgDespesa)) :
                            AssetImage("images/photo-camera.png"))
                    )
                ),
                onTap: () {
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file == null) return;
                    else {
                      setState(() {
                        _editedDespesa.imgDespesa = file.path;
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
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedDespesa.descricaoDespesa = text;
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
                onChanged: (date) {
                  _userEdited = true;
                  _editedDespesa.dataDespesa = date;
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
                onChanged: (valor) {
                  _userEdited = true;
                  _editedDespesa.valorDespesa = valor;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}