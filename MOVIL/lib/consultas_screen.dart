import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ConsultasScreen extends StatelessWidget {
  final List<charts.Series<PaymentData, String>> seriesList = _createSampleData();

  static List<charts.Series<PaymentData, String>> _createSampleData() {
    final data = [
      PaymentData('Completados', 75),
      PaymentData('Pendientes', 25),
    ];

    return [
      charts.Series<PaymentData, String>(
        id: 'Pagos',
        domainFn: (PaymentData payment, _) => payment.status,
        measureFn: (PaymentData payment, _) => payment.percentage,
        data: data,
        colorFn: (PaymentData payment, _) =>
        payment.status == 'Completados' ? charts.MaterialPalette.blue.shadeDefault : charts.MaterialPalette.red.shadeDefault,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          padding: EdgeInsets.zero, // Elimina el espacio superior no deseado
          children: [
            Text(
              'Consultas de credito',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color:Colors.blue.shade700),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: charts.BarChart(
                seriesList,
                animate: true,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    'lib/img/historial.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                Text(
                  'Productos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            DataTable(
              columns: [
                DataColumn(label: Text('Producto')),
                DataColumn(label: Text('Fecha')),
                DataColumn(label: Text('Monto')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('Laptop Dell XPS')),
                  DataCell(Text('03/12/2024')),
                  DataCell(Text('\$1200')),
                ]),
                DataRow(cells: [
                  DataCell(Text('iPhone 13 Pro')),
                  DataCell(Text('02/12/2024')),
                  DataCell(Text('\$999')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Bicicleta Trek')),
                  DataCell(Text('01/12/2024')),
                  DataCell(Text('\$850')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Smart TV LG')),
                  DataCell(Text('30/11/2024')),
                  DataCell(Text('\$650')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Audífonos Sony ')),
                  DataCell(Text('29/11/2024')),
                  DataCell(Text('\$300')),
                ]),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.asset(
                    'lib/img/pendientes.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                Text(
                  'Créditos Pendientes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monto total pendiente: \$1000',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Próximo vencimiento: 05/12/2024',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentData {
  final String status;
  final int percentage;

  PaymentData(this.status, this.percentage);
}
