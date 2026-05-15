import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tutorial_model.dart';
import 'tutorial_service.dart';

class TutorialIbadahPage extends StatefulWidget {
  const TutorialIbadahPage({super.key});

  @override
  State<TutorialIbadahPage> createState() => _TutorialIbadahPageState();
}

class _TutorialIbadahPageState extends State<TutorialIbadahPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TutorialService _tutorialService = TutorialService();
  
  late Future<List<TutorialModel>> _niatFuture;
  late Future<List<TutorialModel>> _bacaanFuture;
  late Future<List<TutorialModel>> _ayatKursiFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _niatFuture = _tutorialService.getNiatSholat();
    _bacaanFuture = _tutorialService.getBacaanSholat();
    _ayatKursiFuture = _tutorialService.getAyatKursi();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF13A884);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF9),
      appBar: AppBar(
        title: const Text(
          'Tutorial Ibadah',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          tabs: const [
            Tab(text: 'Niat Sholat'),
            Tab(text: 'Bacaan Sholat'),
            Tab(text: 'Ayat Kursi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildListSection(_niatFuture),
          _buildListSection(_bacaanFuture),
          _buildListSection(_ayatKursiFuture),
        ],
      ),
    );
  }

  Widget _buildListSection(Future<List<TutorialModel>> future) {
    return FutureBuilder<List<TutorialModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF13A884)));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Data tidak ditemukan'));
        }

        final items = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildTutorialCard(item);
          },
        );
      },
    );
  }

  Widget _buildTutorialCard(TutorialModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: item.name == "Ayat Kursi", // Auto open for Ayat Kursi
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF13A884).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${item.id}',
                style: const TextStyle(
                  color: Color(0xFF13A884),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            item.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF2D3436),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Text(
                    item.arabic,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.scheherazadeNew(
                      fontSize: 28,
                      height: 1.6,
                      color: const Color(0xFF13A884),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.latin,
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF636E72),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Artinya:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.terjemahan,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2D3436),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
