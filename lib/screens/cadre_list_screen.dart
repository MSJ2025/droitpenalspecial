import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/cadre.dart';
import 'cadre_detail_screen.dart';
import '../widgets/adaptive_appbar_title.dart';
import '../widgets/ad_banner.dart';
import '../utils/ad_event_manager.dart';

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
      appBar: AppBar(
        title: const AdaptiveAppBarTitle(
          "Cadres d'enquête",
          maxLines: 1,
        ),
      ),
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
                                child: Text(
                                  cadre.cadre,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right_rounded),
                            onTap: () {
                              AdEventManager.onCadreOpened();
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
          const AdBanner(),
        ],
      ),
    );
  }
}
