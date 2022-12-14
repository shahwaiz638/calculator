import 'dart:ffi';

import 'package:flutter/material.dart';


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

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
        expression = "";
      } else if (buttonText == "=") {
        expression = equation;
        expression = expression.replaceAll('x', '*');


        try {
          Parser p = new Parser();
          result = p.parseExpr(expression).toString();
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
                color: Colors.white, width: 1, style: BorderStyle.solid)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: MediaQuery
          .of(context)
          .platformBrightness == Brightness.dark
          ? Column(children: <Widget>[
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Text(
            equation,
            style: TextStyle(fontSize: 50.0),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Text(
            result,
            style: TextStyle(fontSize: 50.0),
          ),
        ),
        Expanded(child: Divider()),
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
                    buildButton("C", 1, Colors.redAccent),
                    buildButton("⌫", 1, Colors.blueAccent),
                    buildButton("÷", 1, Colors.blueAccent),
                  ]),
                  TableRow(children: [
                    buildButton("7", 1, Colors.black54),
                    buildButton("8", 1, Colors.black54),
                    buildButton("9", 1, Colors.black54),
                  ]),
                  TableRow(children: [
                    buildButton("4", 1, Colors.black54),
                    buildButton("5", 1, Colors.black54),
                    buildButton("6", 1, Colors.black54),
                  ]),
                  TableRow(children: [
                    buildButton("1", 1, Colors.black54),
                    buildButton("2", 1, Colors.black54),
                    buildButton("3", 1, Colors.black54),
                  ]),
                  TableRow(children: [
                    buildButton(".", 1, Colors.black54),
                    buildButton("0", 1, Colors.black54),
                    buildButton("00", 1, Colors.black54),
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
                    buildButton("x", 1, Colors.blueAccent),
                  ]),
                  TableRow(children: [
                    buildButton("-", 1, Colors.blueAccent),
                  ]),
                  TableRow(children: [
                    buildButton("+", 1, Colors.blueAccent),
                  ]),
                  TableRow(children: [
                    buildButton("=", 2, Colors.redAccent),
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