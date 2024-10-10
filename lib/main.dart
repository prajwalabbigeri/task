import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'dart:convert'; // for decoding JSON
import 'package:http/http.dart' as http; // for making network requests

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> data = [];
  bool isLoading = true; // To show a loader while fetching data

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // Function to fetch data from the API
  Future<void> fetchData() async {
    final url = 'https://66fbb69f8583ac93b40cdf37.mockapi.io/sample';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Successfully fetched the data
        setState(() {
          data = json.decode(response.body);
          isLoading = false; // Disable loading
        });
      } else {
        // Handle error response
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false; // Disable loading even if there is an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID & Name Table'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader while fetching data
          : data.isEmpty
          ? Center(child: Text('No data available'))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Table(
            border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'ID',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ...data.map((item) {
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item['id'].toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item['name']),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}