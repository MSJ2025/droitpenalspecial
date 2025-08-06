import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/cadre.dart';
import 'cadre_detail_screen.dart';

class CadreEnqueteListScreen extends StatefulWidget {
  const CadreEnqueteListScreen({super.key});

  @override
  State<CadreEnqueteListScreen> createState() => _CadreEnqueteListScreenState();
}

class _CadreEnqueteListScreenState extends State<CadreEnqueteListScreen> {
  late Future<List<Cadre>> _cadresFuture;

  @override
  void initState() {
    super.initState();
    _cadresFuture = _loadCadres();
  }

  Future<List<Cadre>> _loadCadres() async {
    final data = await rootBundle.loadString('assets/data/cadres.json');
    final List list = json.decode(data) as List;
    return list
        .whereType<Map>()
        .map((e) => Cadre.fromJson(e.cast<String, dynamic>()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadres d'enquête"),
      ),
      body: FutureBuilder<List<Cadre>>(
        future: _cadresFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement'));
          }
          final cadres = snapshot.data ?? <Cadre>[];
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: snapshot.connectionState != ConnectionState.done
                ? const Center(
                    key: ValueKey('loading'),
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    key: const ValueKey('list'),
                    itemCount: cadres.length,
                    itemBuilder: (context, index) {
                      final cadre = cadres[index];
                      return ListTile(
                        title: Text(cadre.title),
                        subtitle: Text(cadre.description),
                        onTap: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder: (_, animation, __) => FadeTransition(
                                opacity: animation,
                                child: CadreDetailScreen(cadre: cadre),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
