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
    });
  }

  void _applyFilter() {
    setState(() {
      _filteredRankings = _rankings
          .where((r) => r.quizName.toLowerCase().contains(_filter.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Filtrer par nom de quiz',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                _filter = value;
                _applyFilter();
              },
            ),
          ),
          Expanded(
            child: _filteredRankings.isEmpty
                ? const Center(child: Text('Aucun résultat trouvé.'))
                : ListView.builder(
                    itemCount: _filteredRankings.length,
                    itemBuilder: (context, index) {
                      final ranking = _filteredRankings[index];
                      return ListTile(
                        leading: const Icon(Icons.quiz),
                        title: Text(ranking.quizName),
                        trailing: Text('${ranking.score}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
