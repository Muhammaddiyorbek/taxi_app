import 'package:flutter/material.dart';

class AddAdPage extends StatefulWidget {
  const AddAdPage({super.key});

  @override
  State<AddAdPage> createState() => _AddAdPageState();
}

class _AddAdPageState extends State<AddAdPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _adTextController = TextEditingController();

  void _saveAd() {
    if (_formKey.currentState!.validate()) {
      // E'lonni saqlash logikasi (bu yerda biz shunchaki ortga qaytaramiz)
      Navigator.pop(context, _adTextController.text);
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
        title: const Text('Yangi E\'lon Qo\'shish'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _adTextController,
                decoration: const InputDecoration(
                  labelText: 'E\'lon Matni',
                  hintText: 'E\'loningizni shu yerga yozing...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Iltimos, e\'lon matnini kiriting';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Kelajakda rasm/fayl qo'shish tugmasi shu yerga kelishi mumkin
              // ElevatedButton.icon(
              //   icon: Icon(Icons.attach_file),
              //   label: Text('Rasm/Fayl Qo\'shish'),
              //   onPressed: () {
              //     // Rasm/fayl tanlash logikasi
              //   },
              // ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Saqlash'),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18)
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
