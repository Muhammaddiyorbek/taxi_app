import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  final List<String> initialSelectedGroups;
  final String initialInterval;

  const SettingsPage({
    super.key,
    required this.initialSelectedGroups,
    required this.initialInterval,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // --- Guruhlar Ro'yxati ---
  final List<String> _allAvailableGroups = [
    "Dasturchilar Klubi", "Flutter O'zbekistan", "Marketing Guruhlari",
    "Sotuvchilar Forumi", "Dizaynerlar Hamjamiyati", "Test Guruxi Beta",
    "Guruh Alpha", "Yangi Loyihalar", "Frilanserlar UZB",
    // Ko'proq guruhlar qo'shishingiz mumkin test uchun
  ];
  late List<String> _selectedGroups;
  final ScrollController _groupListScrollController =
      ScrollController(); // ScrollController guruhlar uchun

  // --- Interval Sozlamalari ---
  String? _selectedPredefinedInterval;
  final TextEditingController _customIntervalController =
      TextEditingController();
  final List<String> _predefinedIntervalOptions = [
    "Har 5 daqiqada",
    "Har 15 daqiqada",
    "Har 30 daqiqada",
    "Har 1 soatda",
    "Har 2 soatda",
  ];

  @override
  void initState() {
    super.initState();
    _selectedGroups = List<String>.from(widget.initialSelectedGroups);

    if (_predefinedIntervalOptions.contains(widget.initialInterval)) {
      _selectedPredefinedInterval = widget.initialInterval;
    } else {
      final match = RegExp(
        r'Har (\d+) daqiqada',
      ).firstMatch(widget.initialInterval);
      if (match != null && match.group(1) != null) {
        _customIntervalController.text = match.group(1)!;
      } else {
        _selectedPredefinedInterval =
            _predefinedIntervalOptions[2]; // Default: Har 30 daqiqada
      }
    }
  }

  void _saveSettings() {
    String finalInterval;

    if (_customIntervalController.text.isNotEmpty) {
      final customMinutes = int.tryParse(_customIntervalController.text);
      if (customMinutes != null && customMinutes > 0) {
        finalInterval = "Har $customMinutes daqiqada";
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Maxsus interval uchun to'g'ri daqiqa kiriting (0 dan katta raqam).",
            ),
            backgroundColor: Colors.orangeAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }
    } else if (_selectedPredefinedInterval != null) {
      finalInterval = _selectedPredefinedInterval!;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Yuborish intervalini tanlang yoki kiriting."),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedGroups.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Iltimos, kamida bitta guruh tanlang."),
          backgroundColor: Colors.orangeAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.pop(context, {
      'selectedGroups': _selectedGroups,
      'interval': finalInterval,
    });
  }

  @override
  void dispose() {
    _customIntervalController.dispose();
    _groupListScrollController.dispose(); // ScrollController'ni dispose qilish
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sozlamalar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save), // Ikonka o'zgartirildi
            tooltip: 'Saqlash',
            onPressed: _saveSettings,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
        // Pastki qismda joy qoldirish (agar pastda tugma bo'lsa)
        children: [
          SizedBox(height: 8),
          _buildSectionTitle(
            context,
            'Yuboriladigan Guruhlar', // Sarlavha qisqartirildi
            Icons.dynamic_feed_outlined, // Ikonka o'zgartirildi
          ),
          const SizedBox(height: 12),
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "E'lonlar yuborilishi kerak bo'lgan guruhlarni belgilang.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 300, // Guruhlar ro'yxati maksimal balandligi
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _allAvailableGroups.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24.0),
                            child: Text("Hozircha guruhlar mavjud emas."),
                          ),
                        )
                      : Scrollbar(
                          thumbVisibility: true,
                          controller: _groupListScrollController,
                          // Controller bog'landi
                          child: ListView.builder(
                            controller: _groupListScrollController,
                            // Controller bog'landi
                            shrinkWrap: true,
                            // Kerak, chunki BoxConstraints va Column ichida
                            itemCount: _allAvailableGroups.length,
                            itemBuilder: (context, index) {
                              final groupName = _allAvailableGroups[index];
                              final isSelected = _selectedGroups.contains(
                                groupName,
                              );
                              return CheckboxListTile(
                                title: Text(
                                  groupName,
                                  style: theme.textTheme.titleMedium,
                                ),
                                value: isSelected,
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      if (!_selectedGroups.contains(
                                        groupName,
                                      )) {
                                        _selectedGroups.add(groupName);
                                      }
                                    } else {
                                      _selectedGroups.remove(groupName);
                                    }
                                  });
                                },
                                activeColor: theme.colorScheme.primary,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                dense: true,
                                checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                              );
                            },
                          ),
                        ),
                ),
                if (_selectedGroups.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    "${_selectedGroups.length} ta guruh tanlandi.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 28),
          _buildSectionTitle(
            context,
            'Yuborish Intervali', // Sarlavha qisqartirildi
            Icons.timer_outlined, // Ikonka o'zgartirildi
          ),
          const SizedBox(height: 12),
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tayyor intervallardan birini tanlang:",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple[700],
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  dropdownColor: Colors.white,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.hourglass_empty_outlined,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                  value: _selectedPredefinedInterval,
                  hint: const Text("Intervalni tanlang..."),
                  icon: Icon(
                    Icons.arrow_drop_down_rounded,
                    color: Colors.deepPurple[700],
                    size: 28,
                  ),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPredefinedInterval = newValue;
                      if (newValue != null) {
                        _customIntervalController.clear();
                      }
                    });
                  },
                  items: _predefinedIntervalOptions
                      .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.deepPurple[700]),
                          ),
                        );
                      })
                      .toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  "Yoki o'zingiz daqiqalarda kiriting:",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple[700],
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  style: TextStyle(color: Colors.deepPurple[700]),
                  controller: _customIntervalController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color: Colors.deepPurple[700]),
                    labelText: 'Maxsus interval (daqiqa)',
                    hintText: 'Masalan: 5',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: Icon(
                      Icons.edit_note_outlined,
                      color: Colors.deepPurple[700],
                    ),
                    suffixText: "daqiqa",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty &&
                        _selectedPredefinedInterval != null) {
                      setState(() {
                        _selectedPredefinedInterval = null;
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.done_all_outlined),
            label: const Text('Sozlamalarni Saqlash'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
            onPressed: _saveSettings,
          ),
        ],
      ),
    );
  }

  // Bo'limlar uchun umumiy karta (Card) stilini yaratish uchun yordamchi vidjet
  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 2.0, // Soyani biroz kamaytirdim
      margin: EdgeInsets.zero, // ListView padding hal qiladi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[300]!, width: 0.5), // Yupqa chegara
      ),
      child: Padding(padding: const EdgeInsets.all(10.0), child: child),
    );
  }

  // Bo'lim sarlavhasi uchun yordamchi vidjet
  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      // SizedBox bilan almashtirildi
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.deepPurple[700], size: 24),
          const SizedBox(width: 10),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.deepPurple[700],
              // color: theme.colorScheme.onSurfaceVariant, // Yoki primary
            ),
          ),
        ],
      ),
    );
  }
}
