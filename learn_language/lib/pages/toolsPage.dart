import 'package:flutter/material.dart';
import 'package:learn_language/components/toolsPage/alphabetTrainer.dart';
import 'package:learn_language/components/toolsPage/conjugationTrainer.dart';
import 'package:learn_language/components/layout/customAppBar.dart';
import 'package:learn_language/components/toolsPage/grammarTrainer.dart';
import 'package:learn_language/components/buttons/primaryIconButton.dart';
import 'package:learn_language/components/toolsPage/translationCard.dart';
import 'package:learn_language/controllers/homePageController.dart';
import 'package:learn_language/services/pickImage.dart';
import 'package:learn_language/components/popups/wordSelectionDialog.dart';
import 'package:learn_language/theme/appColor.dart';

class ToolsPage extends StatefulWidget {
  const ToolsPage({super.key});

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  final HomePageController _controller = HomePageController();

  @override
  void initState() {
    super.initState();

    _controller.englishController.addListener(() {
      _controller.onEnglishChanged(
        _translateWord,
        () => setState(() => _controller.frenchController.text = ''),
      );
    });

    _controller.frenchController.addListener(() {
      _controller.onFrenchChanged(
        _translateWord,
        () => setState(() => _controller.englishController.text = ''),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _translateWord() async {
    final translation = await _controller.translateWord();
    if (translation != null) {
      setState(() {
        if (_controller.isEnglishToFrench) {
          _controller.frenchController.text = translation;
        } else {
          _controller.englishController.text = translation;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur de traduction')),
      );
    }
  }

  void _toggleDirection() {
    setState(() {
      _controller.toggleDirection();
    });
  }

  Future<void> _addWord() async {
    final success = await _controller.addWord();
    final message =
        success ? 'Mot ajouté !' : 'Veuillez remplir les deux champs';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );

    if (success) setState(() {});
  }

  Future<void> _scanWord() async {
    final ocrResult = await pickImageAndExtractText();
    if (!mounted) return;

    if (ocrResult != null) {
      showDialog(
        context: context,
        builder: (_) => WordSelectionDialog(
          ocrResult: ocrResult,
          onWordSelected: (word) {
            setState(() {
              _controller.englishController.text = word;
            });
            _translateWord();
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun texte détecté')),
      );
    }
  }

  Widget _buildTranslationSection() {
    return ExpansionTile(
      title: const Text(
        'Traduction',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
      ),
      initiallyExpanded: true,
      children: [
        TranslationCard(
          isEnglishToFrench: _controller.isEnglishToFrench,
          englishController: _controller.englishController,
          frenchController: _controller.frenchController,
          onToggleDirection: _toggleDirection,
          onAddWord: _addWord,
        ),
        const SizedBox(height: 32),
        PrimaryIconButton(
          text: 'Scanner un mot',
          icon: Icons.camera_alt,
          onPressed: _scanWord,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAlphabetSection() {
    return const ExpansionTile(
      title: Text(
        'Alphabet',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
      ),
      initiallyExpanded: false,
      children: [AlphabetTrainer()],
    );
  }

  Widget _buildConjugationSection() {
    return const ExpansionTile(
      title: Text(
        'Conjugaison : To Be',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
      ),
      initiallyExpanded: false,
      children: [ConjugationTrainer()],
    );
  }

  Widget _buildGrammarSection() {
    return const ExpansionTile(
      title: Text(
        'Grammaire anglaise',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary),
      ),
      initiallyExpanded: false,
      children: [GrammarTrainer()],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppBar(title: 'Outils', showBackButton: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTranslationSection(),
            _buildAlphabetSection(),
            _buildConjugationSection(),
            _buildGrammarSection(),
          ],
        ),
      ),
    );
  }
}
