import 'dart:io';

import 'package:conta_app/domain/DespesaDomain.dart';
import 'package:conta_app/helpers/DespesaHelper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'DespesaPage.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>{
  int touchedIndex;
  int index;
  DespesaHelper helper = DespesaHelper();
  List<DespesaDomain> despesas = List();

  void updateList() {
    helper.getAllDespesa().then((list) {
      setState(() {
        despesas = list;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1000,
      child: Card(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 28,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Indicator(
                  color: const Color(0xff0293ee),
                  text: 'Lazer',
                  isSquare: false,
                  size: touchedIndex == 0 ? 18 : 16,
                  textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
                ),
                Indicator(
                  color: const Color(0xfff8b250),
                  text: 'Casa',
                  isSquare: false,
                  size: touchedIndex == 1 ? 18 : 16,
                  textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
                ),
                Indicator(
                  color: const Color(0xff845bef),
                  text: 'Fixas',
                  isSquare: false,
                  size: touchedIndex == 2 ? 18 : 16,
                  textColor: touchedIndex == 2 ? Colors.black : Colors.grey,
                ),
                Indicator(
                  color: const Color(0xff13d38e),
                  text: 'Outros',
                  isSquare: false,
                  size: touchedIndex == 3 ? 18 : 16,
                  textColor: touchedIndex == 3 ? Colors.black : Colors.grey,
                ),
              ],
            ),
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  "images/chart1.png",
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 4,
                child: Image.asset(
                  "images/listDespesas3.png",
                  fit: BoxFit.contain,
                ),

                /*
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
               */
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _despesaCard(BuildContext context, int index) {
    return GestureDetector(

        onTap: () {
          _showOptions(context, index);
        });
  }

  @override
  Widget buildDespesa(BuildContext context) {
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

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
          (i) {
        final isTouched = i == touchedIndex;
        final double opacity = isTouched ? 1 : 0.6;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: const Color(0xff0293ee).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 80,
              titleStyle: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: const Color(0xfff8b250).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 65,
              titleStyle: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
            );
          case 2:
            return PieChartSectionData(
              color: const Color(0xff845bef).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 60,
              titleStyle: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff4c3788)),
              titlePositionPercentageOffset: 0.6,
            );
          case 3:
            return PieChartSectionData(
              color: const Color(0xff13d38e).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 70,
              titleStyle: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff0c7f55)),
              titlePositionPercentageOffset: 0.55,
            );
          default:
            return null;
        }
      },
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}