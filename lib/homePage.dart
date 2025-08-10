import 'package:flutter/material.dart';
import 'package:taxi_app/editPage.dart';
import 'package:taxi_app/settingPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String currentAd =
      "Bu sizning yagona e'loningiz matni. Tahrirlash uchun bosing.";
  List<String> selectedGroups = ["Guruh Alpha", "Test Guruxi Beta"];
  bool isSending = false;
  String sendingInterval = "Har 30 daqiqada";

  void _editAd() async {
    final updatedAd = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditAdPage(initialAdText: currentAd),
      ),
    );
    if (updatedAd != null && updatedAd.isNotEmpty) {
      setState(() {
        currentAd = updatedAd;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E\'lon muvaffaqiyatli yangilandi!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _goToSettings() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          initialSelectedGroups: List<String>.from(selectedGroups),
          initialInterval: sendingInterval,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (result.containsKey('selectedGroups')) {
          selectedGroups = result['selectedGroups'] as List<String>;
        }
        if (result.containsKey('interval')) {
          sendingInterval = result['interval'] as String;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sozlamalar saqlandi!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _toggleSending() {
    setState(() {
      isSending = !isSending;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isSending
              ? "E'lonlar yuborilishi ${selectedGroups.isNotEmpty ? 'boshlandi!' : 'guruhlar tanlanmagan!'}"
              : "E'lonlar yuborilishi to'xtatildi!",
        ),
        backgroundColor: isSending && selectedGroups.isNotEmpty
            ? Colors.blueAccent
            : Colors.orangeAccent,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: isSending ? Colors.red : Colors.green,
        child: Icon(
          isSending ? Icons.stop : Icons.play_arrow,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        title: const Text('Asosiy Boshqaruv'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_suggest_outlined, size: 28),
            tooltip: 'Sozlamalar',
            onPressed: _goToSettings,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: InkWell(
                onTap: _editAd,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Joriy E\'lon',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Icon(
                            Icons.edit_note,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentAd,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: Icon(
                isSending
                    ? Icons.stop_circle_outlined
                    : Icons.play_circle_outline,
                size: 28,
              ),
              label: Text(
                isSending ? 'Yuborishni To\'xtatish' : 'Yuborishni Boshlash',
                style: const TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSending
                    ? Colors.redAccent[400]
                    : Colors.green[600],
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed:
                  (selectedGroups.isNotEmpty &&
                      currentAd.isNotEmpty &&
                      currentAd !=
                          "Bu sizning yagona e'loningiz matni. Tahrirlash uchun bosing.")
                  ? _toggleSending
                  : null,
            ),
            if (selectedGroups.isEmpty ||
                currentAd.isEmpty ||
                currentAd ==
                    "Bu sizning yagona e'loningiz matni. Tahrirlash uchun bosing.")
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  selectedGroups.isEmpty
                      ? "Iltimos, avval sozlamalardan guruhlarni tanlang."
                      : "Iltimos, avval e'lon matnini kiriting.",
                  style: TextStyle(color: Colors.red[700], fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 24),
            _buildInfoSection(context),
            const SizedBox(height: 16),
            if (selectedGroups.isNotEmpty) _buildSelectedGroupsList(context),
            // Balandlik cheklovi olib tashlandi
            // Pastki FloatingActionButton olib tashlandi
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Yuborish Parametrlari',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.group_work_outlined,
                  color: Colors.grey[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Tanlangan guruhlar soni: ${selectedGroups.length}',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer_outlined, color: Colors.grey[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Yuborish intervali: $sendingInterval',
                    style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedGroupsList(BuildContext context) {
    return Column(
      // SizedBox height olib tashlandi
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            'Tanlangan Guruhlar:',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ),
        selectedGroups.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    "Hozircha guruhlar tanlanmagan.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 15),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                // Muhim: SingleChildScrollView ichida ListView uchun
                physics: const NeverScrollableScrollPhysics(),
                // SingleChildScrollView skrollini ishlatish uchun
                itemCount: selectedGroups.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.1),
                        child: Text(
                          selectedGroups[index].isNotEmpty
                              ? selectedGroups[index][0].toUpperCase()
                              : "?",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      title: Text(
                        selectedGroups[index],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
