import 'package:flutter/material.dart';
import '../services/service_functions.dart';
import 'package:intl/intl.dart';

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

  void clearTransactionHistory() {
    setState(() {
      _transactionHistory = Future.value([]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _transactionHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var sortedTransactions = List.from(snapshot.data ?? []);
            sortedTransactions.sort((a, b) => DateTime.parse(b['created_at'])
                .compareTo(DateTime.parse(a['created_at'])));
            return ListView.builder(
              itemCount: sortedTransactions.length,
              itemBuilder: (context, index) {
                var transaction = sortedTransactions[index];
                DateTime createdAt = DateTime.parse(transaction['created_at']);
                String formattedDate =
                    DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);
                var receiver = transaction['receiver'];
                String name =
                    receiver != null ? receiver['name'] : 'No name provided';
                return ListTile(
                  title: Text('Transaction ${index + 1}'),
                  subtitle: Text(
                      'Amount: ${transaction['amount']} Type: ${transaction['type']} Name: $name Phone Number: ${transaction['phone_number']}   Date and Time: $formattedDate'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      deleteTransactionHistory(transaction['id'].toString())
                          .then((_) {
                        // Optionally, refresh the list of transactions after deleting
                        setState(() {
                          _transactionHistory = fetchTransactionHistory();
                        });
                      }).catchError((error) {
                        // Handle the error here...
                        print('Error deleting transaction: $error');
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: clearTransactionHistory,
        tooltip: 'Clear History',
        child: const Icon(Icons.delete),
      ),
    );
  }
}
