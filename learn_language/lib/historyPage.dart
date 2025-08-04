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
  String? _selectedQuizName;

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
    _filteredRankings = _rankings.where((r) {
      final matchesSearch =
          r.quizName.toLowerCase().contains(_filter.toLowerCase());
      final matchesQuizName =
          _selectedQuizName == null || r.quizName == _selectedQuizName;
      return matchesSearch && matchesQuizName;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final quizNames = _rankings.map((r) => r.quizName).toSet().toList();

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
                // Choix du quiz à filtrer
                if (quizNames.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Filtrer par quiz',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedQuizName,
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Tous les quiz'),
                        ),
                        ...quizNames.map(
                          (name) => DropdownMenuItem(
                            value: name,
                            child: Text(name),
                          ),
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedQuizName = value;
                          _applyFilter();
                        });
                      },
                    ),
                  ),

                // Champ de recherche
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

                // Liste des scores filtrés
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
