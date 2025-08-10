import 'package:flutter/material.dart';

class EditAdPage extends StatefulWidget {
  final String initialAdText;

  const EditAdPage({super.key, required this.initialAdText});

  @override
  State<EditAdPage> createState() => _EditAdPageState();
}

class _EditAdPageState extends State<EditAdPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _adTextController;

  @override
  void initState() {
    super.initState();
    _adTextController = TextEditingController(text: widget.initialAdText);
  }

  void _saveAd() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, _adTextController.text.trim());
    }
  }

  @override
  void dispose() {
    _adTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E\'lonni Tahrirlash'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt_outlined),
            tooltip: 'Saqlash',
            onPressed: _saveAd,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'E\'lon matnini bu yerda o\'zgartirishingiz mumkin:',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _adTextController,
                decoration: InputDecoration(
                  labelText: 'E\'lon Matni',
                  hintText: 'E\'loningizni shu yerga yozing...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.article_outlined, color: Colors.grey[600]),
                ),
                maxLines: 8, // Ko'proq joy
                minLines: 5,
                style: const TextStyle(fontSize: 16, height: 1.5),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Iltimos, e\'lon matnini kiriting';
                  }
                  if (value.trim().length < 10) {
                    return 'E\'lon matni kamida 10 belgidan iborat bo\'lishi kerak';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('O\'zgarishlarni Saqlash'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _saveAd,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
