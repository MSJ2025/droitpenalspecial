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
    loadCadres();
  }

  Future<void> loadCadres() async {
    final data = await rootBundle.loadString('assets/data/cadres.json');
    final List<dynamic> list = json.decode(data);
    setState(() {
      cadres = list.map((e) => Cadre.fromJson(e)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadres d'enquête")),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: cadres.length,
                itemBuilder: (context, index) {
                  final cadre = cadres[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ExpansionTile(
                      title: Text(cadre.titre),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cadre.description),
                              const SizedBox(height: 8),
                              const Text('Références :',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              ...cadre.references
                                  .map((r) => Padding(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 2),
                                        child: Text('• $r'),
                                      ))
                                  .toList(),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
