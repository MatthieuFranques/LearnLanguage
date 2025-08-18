import 'package:flutter/material.dart';
import 'package:learn_language/components/customAppBar.dart';
import 'package:learn_language/models/ranking.dart';
import 'package:learn_language/services/words/rankingStorage.dart';
import 'package:learn_language/theme/appColor.dart';

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
      appBar: const CustomAppBar(title: 'Historique', showBackButton: false),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Choix du quiz à filtrer
                if (quizNames.isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ChoiceChip(
                            label: const Text('Tous', style: TextStyle(color: AppColors.textPrimary)),
                            selected: _selectedQuizName == null,
                            onSelected: (_) {
                              setState(() {
                                _selectedQuizName = null;
                                _applyFilter();
                              });
                            },
                            selectedColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: _selectedQuizName == null
                                   ? AppColors.buttonText
                                   : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ...quizNames.map((name) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(name),
                                  selected: _selectedQuizName == name,
                                  onSelected: (_) {
                                    setState(() {
                                      _selectedQuizName =
                                          _selectedQuizName == name
                                              ? null
                                              : name;
                                      _applyFilter();
                                    });
                                  },
                                  selectedColor: Theme.of(context).primaryColor,
                                  labelStyle: TextStyle(
                                    color: _selectedQuizName == name
                                        ? AppColors.buttonText
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              )),
                        ],
                      ),
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
                                  child: Text('${index + 1}', style: const TextStyle(color: AppColors.textPrimary)),
                                ),
                                title: Text(ranking.quizName, style: const TextStyle(color: AppColors.textPrimary)),
                                trailing: Text('Score : ${ranking.score}', style: const TextStyle(color: AppColors.textPrimary)),
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
