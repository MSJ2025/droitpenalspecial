import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/cadre.dart';

class CadreListScreen extends StatefulWidget {
  const CadreListScreen({super.key});

  @override
  State<CadreListScreen> createState() => _CadreListScreenState();
}

class _CadreListScreenState extends State<CadreListScreen> {
  List<Cadre> cadres = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCadres();
  }

  Future<void> _loadCadres() async {
    final jsonString = await rootBundle.loadString('assets/data/cadres.json');
    final List<dynamic> data = json.decode(jsonString) as List<dynamic>;
    setState(() {
      cadres =
          data.map((e) => Cadre.fromJson(e as Map<String, dynamic>)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadres d'enquête")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cadres.length,
              itemBuilder: (context, index) {
                final cadre = cadres[index];
                return ListTile(
                  title: Text(cadre.titre),
                  subtitle: Text(cadre.details),
                );
              },
            ),
    );
  }
}
