import 'package:flutter/material.dart';

import '../resources/service_functions.dart';

class TransactionHistoryPage extends StatefulWidget {
  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  late Future<List<dynamic>> _transactionHistory;

  @override
  void initState() {
    super.initState();
    _transactionHistory = fetchTransactionHistory();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _transactionHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                var transaction = snapshot.data?[index];
                return ListTile(
                  title: Text('Transaction ${index + 1}'),
                  subtitle: Text('Amount: ${transaction['amount']}, Type: ${transaction['type']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}