import 'package:flutter/material.dart';

class PagoScreen extends StatefulWidget {
  @override
  _PagoScreenState createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String? _selectedMonth;
  String? _selectedYear;
  bool _payTotal = false;
  double _minimumPayment = 2000;

  final List<String> _months = [
    '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12'
  ];
  final List<String> _years = [
    '2024', '2025', '2026', '2027', '2028', '2029'
  ];

  void _processPayment() {
    if (_cardNumberController.text.length != 16 ||
        _cvvController.text.length != 3 ||
        _selectedMonth == null ||
        _selectedYear == null ||
        (!_payTotal && _amountController.text.isEmpty)) {
      _showAlertDialog("Error", "Por favor, complete todos los campos.");
      return;
    }

    setState(() {
      if (_payTotal) {
        _minimumPayment = 0;
      } else {
        double enteredAmount = double.tryParse(_amountController.text) ?? 0;
        _minimumPayment -= enteredAmount;
      }
    });

    _showAlertDialog(
      "¡Pago Exitoso!",
      _payTotal
          ? "Se ha pagado la totalidad de la deuda."
          : "Gracias por tu abono puntual.",
    );
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Icono sobre el título
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'lib/img/tarjetas.png', // Cambia la ruta según tu archivo en assets
                    width: 60,          // Ajusta el tamaño según sea necesario
                    height: 60,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Detalles de la tarjeta",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              maxLength: 16,
              decoration: InputDecoration(
                labelText: "Número de tarjeta",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Mes (MM)",
                      border: OutlineInputBorder(),
                    ),
                    items: _months.map((month) {
                      return DropdownMenuItem(
                        value: month,
                        child: Text(month),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedMonth = value;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Año (AA)",
                      border: OutlineInputBorder(),
                    ),
                    items: _years.map((year) {
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedYear = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: _cvvController,
              keyboardType: TextInputType.number,
              maxLength: 3,
              obscureText: true, // Oculta el texto como una contraseña
              decoration: InputDecoration(
                labelText: "Código CVV",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Detalles de pago
            Text(
              "Detalles de pago",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Monto mínimo a pagar: \$${_minimumPayment.toStringAsFixed(2)}",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Monto a pagar",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _payTotal,
                  onChanged: (value) {
                    setState(() {
                      _payTotal = value ?? false;
                      if (_payTotal) {
                        _amountController.clear();
                      }
                    });
                  },
                ),
                Text("Pagar totalidad de la deuda"),
              ],
            ),
            SizedBox(height: 20),
            // Botón de pagar
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _processPayment,
                child: Text(
                  "Pagar",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
