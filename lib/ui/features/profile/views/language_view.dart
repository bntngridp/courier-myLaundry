import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  String _selectedLang = 'id';

  @override
  void initState() {
    super.initState();
    _loadLang();
  }

  Future<void> _loadLang() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLang = prefs.getString('app_lang') ?? 'id';
    });
  }

  Future<void> _saveLang(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_lang', lang);
    setState(() {
      _selectedLang = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0B1739)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bahasa',
          style: TextStyle(
            color: Color(0xFF0B1739),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              _buildOption('id', 'Bahasa Indonesia'),
              const SizedBox(height: 16),
              _buildOption('en', 'English'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String lang, String title) {
    final isSelected = _selectedLang == lang;

    return GestureDetector(
      onTap: () => _saveLang(lang),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF0007B0) : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: const Color(0xFF0B1739),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF0007B0), size: 20),
          ],
        ),
      ),
    );
  }
}
