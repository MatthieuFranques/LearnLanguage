import 'package:flutter/material.dart';
import 'package:learn_language/models/ranking.dart';
import 'package:learn_language/services/words/rankingStorage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Ranking> _rankings = [];
  List<Ranking> _filteredRankings = [];
  String _filter = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRankings();
  }

  Future<void> _loadRankings() async {
    final data = await RankingStorage.readWords();
    setState(() {
      _rankings = data;
      _applyFilter();
      _isLoading = false;
    });
  }

  void _applyFilter() {
    _filteredRankings = _rankings
        .where((r) => r.quizName.toLowerCase().contains(_filter.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des scores'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Rechercher un quiz',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filter = value;
                        _applyFilter();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: _filteredRankings.isEmpty
                      ? const Center(child: Text('Aucun score trouvé.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _filteredRankings.length,
                          itemBuilder: (context, index) {
                            final ranking = _filteredRankings[index];
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  child: Text('${index + 1}'),
                                ),
                                title: Text(ranking.quizName),
                                trailing: Text('Score : ${ranking.score}'),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
