import 'package:conta_app/ui/HomePage.dart';
import 'package:conta_app/ui/ListaDespesaPage.dart';
import 'package:conta_app/ui/ListaReceitaPage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp>{
  int _selectedPage = 1;
  final _pageOptions = [
    ListaReceitaPage(),
    HomePage(),
    ListaDespesaPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conta a Conta',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
          appBar: AppBar(
              title: Text("Conta a Conta"),
              backgroundColor: Colors.green,
              centerTitle: true
          ),
          body: _pageOptions[_selectedPage],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedPage,
            onTap: (int index){
              setState(() {
                _selectedPage = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                title: Text('Receita')
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  title: Text('Home')
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.landscape),
                  title: Text('Despesa')
              ),
            ],
          ),
        ),
      );
  }
}

/*
*Alterar caso queira iniciar na página de login

import 'package:conta_app/ui/LoginPage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(title: 'Flutter Login'),
    );
  }
}

 */