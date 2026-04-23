import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scientific Calculator',
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String displayValue = "0";

  void onBtnClick(String text) {
    setState(() {
      if (text == "C") {
        displayValue = "0";
      }
      else if (text == "⌫") {
        if (displayValue.length > 1) {
          displayValue = displayValue.substring(0, displayValue.length - 1);
        } else {
          displayValue = "0";
        }
      }
      else if (text == "=") {
        try {
          String expression = displayValue.replaceAll('x', '*');

          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);

          displayValue = eval.toString();
          if (displayValue.endsWith(".0")) {
            displayValue = displayValue.replaceAll(".0", "");
          }
        } catch (e) {
          displayValue = "Hata";
        }
      }
      else {
        bool isDigit = RegExp(r'[0-9]').hasMatch(text);

        if (displayValue == "0" && isDigit) {
          displayValue = text;
        } else {
          displayValue += text;
        }
      }
    });
  }

  Widget buildButton(String text, Color color, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.all(22),
          ),

          onPressed: () => onBtnClick(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color sciColor = Colors.blueGrey.shade700;
    Color numColor = Colors.grey.shade900;
    Color opColor = Colors.orange.shade700;
    Color delColor = Colors.redAccent.shade400;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                displayValue,
                style: const TextStyle(fontSize: 64, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(children: [buildButton("sin(", sciColor), buildButton("cos(", sciColor), buildButton("tan(", sciColor), buildButton("log(", sciColor)]),
                  Row(children: [buildButton("sqrt(", sciColor), buildButton("^", sciColor), buildButton("(", sciColor), buildButton(")", sciColor)]),
                  Row(children: [buildButton("7", numColor), buildButton("8", numColor), buildButton("9", numColor), buildButton("+", opColor)]),
                  Row(children: [buildButton("4", numColor), buildButton("5", numColor), buildButton("6", numColor), buildButton("x", opColor)]),
                  Row(children: [buildButton("1", numColor), buildButton("2", numColor), buildButton("3", numColor), buildButton("-", opColor)]),
                  Row(children: [buildButton("0", numColor), buildButton(".", numColor), buildButton("⌫", delColor), buildButton("/", opColor)]),
                  Row(children: [buildButton("C", delColor, flex: 2), buildButton("=", Colors.green, flex: 2)]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}