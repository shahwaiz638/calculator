import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MaterialApp(

      home: CalculatorApp()));
}


class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();


}

class _CalculatorAppState extends State<CalculatorApp> {


  String staticTarget = "default_value";
  String equation = "0";
  String result = "0";
  String expression = "";


  @override
  initState() {
    shared();
  }

  buttonPressed(String buttonText) async {

    SharedPreferences sp= await SharedPreferences.getInstance();

    setState(() {



      if (buttonText == "C") {
        equation = "0";
        result = "0";
        expression = "";
      }

      else if (buttonText == "=") {
        expression = equation;
        expression = expression.replaceAll('x', '*');

        sp.setString("eq", equation);
        try {
          Parser p = new Parser();
          result = p.parseExpr(expression).toString();
          sp.setString("result", result);
        } catch (e, stackTrace) {
          result = "Error";
          print(stackTrace);
        }

        //equation = result;
      } else if (buttonText == "⌫") {
        equation = equation.substring(0, equation.length - 1);

        if (equation == "") {
          equation = "0";
        }
      } else {
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  Widget buildButton(String buttonText, double buttonHeight,
      Color buttonColor) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.1 * buttonHeight,
      color: buttonColor,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
            side: BorderSide(
                color: Colors.black12, width: 1, style: BorderStyle.solid)),
        padding: EdgeInsets.all(16.0),
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.normal,
              color: Colors.white),
        ),
      ),
    );
  }

  void shared() async
  {
    SharedPreferences sp= await SharedPreferences.getInstance();
    result=sp.getString("result") ?? "";
    equation=sp.getString("eq") ?? "";

    //sp.remove("result");
    sp.remove("eq");
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(


      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Calculator'),
      ),
      body: MediaQuery
          .of(context)
          .platformBrightness == Brightness.light
          ? Column(children: <Widget>[
        Container(
          color: Colors.black,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Text(
            equation,
            style: TextStyle(
              color: Colors.white,
                fontSize: 50.0),
          ),
        ),
        Container(
          color: Colors.black,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Text(
            result,
            style: TextStyle(color: Colors.white,fontSize: 50.0),
          ),
        ),
        Expanded(

            child: Container(
              color: Colors.black,
            ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * .75,
              child: Table(
                children: [
                  TableRow(children: [
                    buildButton("C", 1, Colors.pink),
                    buildButton("⌫", 1, Colors.amber),
                    buildButton("÷", 1, Colors.amber),
                  ]),
                  TableRow(children: [
                    buildButton("7", 1, Colors. black),
                    buildButton("8", 1, Colors. black),
                    buildButton("9", 1, Colors. black),
                  ]),
                  TableRow(children: [
                    buildButton("4", 1, Colors.black),
                    buildButton("5", 1, Colors.black),
                    buildButton("6", 1, Colors. black),
                  ]),
                  TableRow(children: [
                    buildButton("1", 1, Colors. black),
                    buildButton("2", 1, Colors. black),
                    buildButton("3", 1, Colors. black),
                  ]),
                  TableRow(children: [
                    buildButton(".", 1, Colors. black),
                    buildButton("0", 1, Colors. black),
                    buildButton("00", 1, Colors. black),
                  ]),
                ],
              ),
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.25,
              child: Table(
                children: [
                  TableRow(children: [
                    buildButton("x", 1, Colors.amber),
                  ]),
                  TableRow(children: [
                    buildButton("-", 1, Colors.amber),
                  ]),
                  TableRow(children: [
                    buildButton("+", 1, Colors.amber),
                  ]),
                  TableRow(children: [
                    buildButton("=", 2, Colors.pink),
                  ]),
                ],
              ),
            )
          ],
        ),
      ])
          : Container(),
    );
  }
}

class Parser {
  List<String> _tokens=["0"];
  int _current=0;
  double finalresult=0;

  double parseExpr(String expression)
  {

    if(expression.contains("+"))
      {
        _tokens=expression.split("+");
        finalresult = double.parse(_tokens[0]) + double.parse(_tokens[1]);
      }
    else if(expression.contains("-"))
    {
      _tokens=expression.split("-");
      finalresult = double.parse(_tokens[0]) - double.parse(_tokens[1]);
    }
    else if(expression.contains("*"))
    {
      _tokens=expression.split("*");

      finalresult = double.parse(_tokens[0]) * double.parse(_tokens[1]);
    }
    else if(expression.contains("÷"))
    {
      _tokens=expression.split("÷");
      finalresult = double.parse(_tokens[0]) / double.parse(_tokens[1]);
    }
    return finalresult;
  }



}