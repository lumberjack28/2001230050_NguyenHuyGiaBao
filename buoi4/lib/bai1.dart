import 'dart:math';
import 'package:flutter/material.dart';

class Bai1Screen extends StatefulWidget {
  const Bai1Screen({super.key});

  @override
  State<Bai1Screen> createState() => _Bai1ScreenState();
}

class _Bai1ScreenState extends State<Bai1Screen> {
  String _display = '0';
  String _expression = ''; // Dòng hiển thị biểu thức nhỏ phía trên
  double? _firstOperand;
  String? _operator;
  bool _isNewNumber = true;

  String _formatNumber(double num) {
    if (num % 1 == 0) {
      return num.toInt().toString();
    }
    return num.toString();
  }

  void _onDigit(String digit) {
    setState(() {
      if (_isNewNumber || _display == '0') {
        _display = digit;
        _isNewNumber = false;
      } else {
        _display += digit;
      }
    });
  }

  void _onDecimal() {
    setState(() {
      if (_isNewNumber) {
        _display = '0.';
        _isNewNumber = false;
      } else if (!_display.contains('.')) {
        _display += '.';
      }
    });
  }

  void _onOperator(String op) {
    final current = double.tryParse(_display) ?? 0;

    setState(() {
      // Nếu đã có toán tử trước đó và người dùng nhập tiếp số mới rồi bấm toán tử tiếp theo
      if (_firstOperand != null && _operator != null && !_isNewNumber) {
        double result = 0;
        switch (_operator) {
          case '+':
            result = _firstOperand! + current;
            break;
          case '-':
            result = _firstOperand! - current;
            break;
          case '×':
            result = _firstOperand! * current;
            break;
          case '÷':
            result = current != 0 ? _firstOperand! / current : 0;
            break;
        }
        _firstOperand = result;
        _display = _formatNumber(result);
      } else {
        _firstOperand = current;
      }

      _operator = op;
      _expression = '${_formatNumber(_firstOperand!)} $op';
      _isNewNumber = true;
    });
  }

  void _onEqual() {
    if (_operator == null || _firstOperand == null) return;
    final secondOperand = double.tryParse(_display) ?? 0;
    double result = 0;

    switch (_operator) {
      case '+':
        result = _firstOperand! + secondOperand;
        break;
      case '-':
        result = _firstOperand! - secondOperand;
        break;
      case '×':
        result = _firstOperand! * secondOperand;
        break;
      case '÷':
        result = secondOperand != 0 ? _firstOperand! / secondOperand : 0;
        break;
    }

    setState(() {
      _expression = '${_formatNumber(_firstOperand!)} $_operator ${_formatNumber(secondOperand)} =';
      _display = _formatNumber(result);
      _operator = null;
      _firstOperand = null;
      _isNewNumber = true;
    });
  }

  void _clearAll() {
    setState(() {
      _display = '0';
      _expression = '';
      _firstOperand = null;
      _operator = null;
      _isNewNumber = true;
    });
  }

  void _clearEntry() {
    setState(() {
      _display = '0';
      _isNewNumber = true;
    });
  }

  void _backspace() {
    setState(() {
      if (_isNewNumber) return;
      if (_display.length > 1) {
        _display = _display.substring(0, _display.length - 1);
      } else {
        _display = '0';
        _isNewNumber = true;
      }
    });
  }

  void _negate() {
    setState(() {
      if (_display != '0') {
        if (_display.startsWith('-')) {
          _display = _display.substring(1);
        } else {
          _display = '-$_display';
        }
      }
    });
  }

  void _square() {
    final val = double.tryParse(_display) ?? 0;
    final res = val * val;
    setState(() {
      _expression = 'sqr(${_formatNumber(val)})';
      _display = _formatNumber(res);
      _isNewNumber = true;
    });
  }

  void _sqrt() {
    final val = double.tryParse(_display) ?? 0;
    if (val >= 0) {
      final res = sqrt(val);
      setState(() {
        _expression = '√(${_formatNumber(val)})';
        _display = _formatNumber(res);
        _isNewNumber = true;
      });
    }
  }

  void _reciprocal() {
    final val = double.tryParse(_display) ?? 0;
    if (val != 0) {
      final res = 1 / val;
      setState(() {
        _expression = '1/(${_formatNumber(val)})';
        _display = _formatNumber(res);
        _isNewNumber = true;
      });
    }
  }

  void _percentage() {
    final current = double.tryParse(_display) ?? 0;
    double res = 0;
    if (_firstOperand != null) {
      res = (_firstOperand! * current) / 100;
    } else {
      res = current / 100;
    }
    setState(() {
      _expression = _firstOperand != null
          ? '${_formatNumber(_firstOperand!)} $_operator ${_formatNumber(res)}'
          : '${_formatNumber(res)}';
      _display = _formatNumber(res);
      _isNewNumber = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        elevation: 0,
        title: const Row(
          children: [
            Text('Standard', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(width: 8),
            Icon(Icons.picture_in_picture_alt, size: 18, color: Colors.black54),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Khu vực hiển thị: gồm Dòng công thức phụ và Số nhập chính
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Dòng biểu thức phụ (hiển thị phép tính kèm dấu)
                    Text(
                      _expression,
                      style: const TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w400),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Dòng số chính đang nhập / kết quả
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        _display,
                        style: const TextStyle(fontSize: 50, fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Hàng phím nhớ Memory (MC, MR, M+, M-, MS, Mv)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['MC', 'MR', 'M+', 'M-', 'MS', 'M▾']
                    .map((label) => Text(
                          label,
                          style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 10),

            // Lưới bàn phím tính toán
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    _buildButtonRow(['%', 'CE', 'C', '⌫']),
                    _buildButtonRow(['¹/x', 'x²', '²√x', '÷']),
                    _buildButtonRow(['7', '8', '9', '×']),
                    _buildButtonRow(['4', '5', '6', '-']),
                    _buildButtonRow(['1', '2', '3', '+']),
                    _buildButtonRow(['+/-', '0', '.', '=']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(List<String> labels) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: labels.map((label) => _buildButton(label)).toList(),
      ),
    );
  }

  Widget _buildButton(String label) {
    final bool isNumber = RegExp(r'^[0-9]$').hasMatch(label) || label == '.' || label == '+/-';
    final bool isEqual = label == '=';

    Color bgColor = isNumber ? Colors.white : const Color(0xFFF7F7F7);
    Color textColor = Colors.black;

    if (isEqual) {
      bgColor = const Color(0xFF005A9E);
      textColor = Colors.white;
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            elevation: 0.5,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          onPressed: () {
            if (RegExp(r'^[0-9]$').hasMatch(label)) {
              _onDigit(label);
            } else if (label == '.') {
              _onDecimal();
            } else if (['+', '-', '×', '÷'].contains(label)) {
              _onOperator(label);
            } else if (label == '=') {
              _onEqual();
            } else if (label == '%') {
              _percentage();
            } else if (label == 'C') {
              _clearAll();
            } else if (label == 'CE') {
              _clearEntry();
            } else if (label == '⌫') {
              _backspace();
            } else if (label == '+/-') {
              _negate();
            } else if (label == 'x²') {
              _square();
            } else if (label == '²√x') {
              _sqrt();
            } else if (label == '¹/x') {
              _reciprocal();
            }
          },
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isNumber || isEqual ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 12, bottom: 6),
              child: Text('Calculator', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            _buildDrawerTile(Icons.calculate, 'Standard', selected: true),
            _buildDrawerTile(Icons.science_outlined, 'Scientific'),
            _buildDrawerTile(Icons.show_chart, 'Graphing'),
            _buildDrawerTile(Icons.code, 'Programmer'),
            _buildDrawerTile(Icons.calendar_month_outlined, 'Date calculation'),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 6, bottom: 6),
              child: Text('Converter', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            _buildDrawerTile(Icons.currency_exchange, 'Currency'),
            _buildDrawerTile(Icons.view_in_ar, 'Volume'),
            _buildDrawerTile(Icons.straighten, 'Length'),
            _buildDrawerTile(Icons.scale_outlined, 'Weight and mass'),
            _buildDrawerTile(Icons.thermostat, 'Temperature'),
            _buildDrawerTile(Icons.bolt, 'Energy'),
            _buildDrawerTile(Icons.grid_view, 'Area'),
            _buildDrawerTile(Icons.speed, 'Speed'),
            const Divider(),
            _buildDrawerTile(Icons.settings_outlined, 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, {bool selected = false}) {
    return ListTile(
      dense: true,
      selected: selected,
      selectedTileColor: const Color(0xFFE5E5E5),
      leading: Icon(icon, color: Colors.black87, size: 20),
      title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      onTap: () => Navigator.pop(context),
    );
  }
}