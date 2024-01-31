import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/variable.dart';
import '../model/data_model.dart';


class InsightPage extends StatefulWidget {
  @override
  State<InsightPage> createState() => _InsightPageState();
}

class _InsightPageState extends State<InsightPage> {
  late int showingTooltip;

  final List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.cyan,
    Colors.brown,
    Colors.pink,
    Colors.teal,
    Colors.indigo,
    Colors.lime,
  ];

  @override
  void initState() {
    showingTooltip = -1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Insights'),
      ),
      body: FutureBuilder(
  future: fetchTransactionData(),
  builder: (BuildContext context, AsyncSnapshot<List<TransactionData>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return Column(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 80,
                sections: snapshot.data?.asMap().map((index, transaction) => MapEntry(index, PieChartSectionData(
                  color: colorList[index % colorList.length],
                  value: transaction.amount,
                  title: '${transaction.type} ', //(${transaction.date}) ( ${transaction.amount})
                  showTitle: false, // Hide the title on the chart
                ),),).values.toList(),
              ),
            ),
          ),
          ...snapshot.data?.asMap().map((index, transaction) => MapEntry(index, ListTile(
            leading: Icon(Icons.circle, color: colorList[index % colorList.length]),
            title: Text('${transaction.date} - ${transaction.type} ' ),// ${transaction.amount} 
          ),),).values.toList() ?? [],
        ],
      );
    }
  },
),
    );
  }
}

Future<List<TransactionData>> fetchTransactionData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  final response = await http.get(Uri.parse('$ipaddress/users/transactions'),
    headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    List<dynamic> transactionList = data['transactions'];
    return transactionList.map((item) {
      // Parse the date
      DateTime parsedDate = DateTime.parse(item['created_at']);
      String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);

      return TransactionData(double.parse(item['amount']), formattedDate, item['type']);
    }).toList();
  } else {
    throw Exception('Failed to load transaction data');
  }
}