import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/cadre.dart';
import 'cadre_detail_screen.dart';

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
    cadres = list.map((e) => Cadre.fromJson(e as Map<String, dynamic>)).toList();
    setState(() {
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadres d'enquête")),
      body: Column(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      key: const ValueKey('list'),
                      itemCount: cadres.length,
                      itemBuilder: (context, index) {
                        final cadre = cadres[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Hero(
                              tag: 'cadreTitle-${cadre.cadre}',
                              child: Material(
                                color: Colors.transparent,
                                child: Text(cadre.cadre),
                              ),
                            ),
                            trailing:
                                const Icon(Icons.chevron_right_rounded),
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (_, animation, __) =>
                                      FadeTransition(
                                    opacity: animation,
                                    child: CadreDetailScreen(cadre: cadre),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
