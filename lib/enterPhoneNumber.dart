import 'package:country_picker/country_picker.dart'; // country_picker paketini import qilamiz
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxi_app/tdlib/tdlib.dart';

class EnterPhoneNumberPage extends StatefulWidget {
  const EnterPhoneNumberPage({super.key});

  @override
  State<EnterPhoneNumberPage> createState() => _EnterPhoneNumberPageState();
}

class _EnterPhoneNumberPageState extends State<EnterPhoneNumberPage> {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final TelegramClient _telegramClient = TelegramClient();

  Country _selectedCountry = Country(
    phoneCode: '998',
    // Default O'zbekiston
    countryCode: 'UZ',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Uzbekistan',
    example: '998912345678',
    displayName: 'Uzbekistan (UZ) [+998]',
    displayNameNoCountryCode: 'Uzbekistan (UZ)',
    e164Key: '998-UZ-0',
    fullExampleWithPlusSign: '+998912345678',
  );

  void _openCountryPicker() {
    showCountryPicker(
      context: context,
      //Optional. Ravshan tema uchun standart qiymatlar.
      //Optional. AppBar uslubi va ko'rinishini sozlash.
      countryListTheme: CountryListThemeData(
        // Optional. O'zingizga moslab sozlang
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        // Optional. Qidiruv maydoni uchun InputDecoration.
        inputDecoration: InputDecoration(
          labelText: 'Davlatni qidirish',
          hintText: 'Qidiruvni boshlang',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
        // Optional. Har bir davlat elementi uchun text uslubi
        textStyle: const TextStyle(fontSize: 16),
        // Optional. Agar bottomSheet da ko'rsatilsa, skrollbarni ishlatish
        bottomSheetHeight:
            MediaQuery.of(context).size.height *
            0.8, // Ekran balandligining 80%
      ),
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          _phoneController
              .clear(); // Davlat o'zgarganda telefon raqamini tozalash
          _phoneFocusNode.requestFocus(); // Fokusni telefon maydoniga o'tkazish
        });
        print('Tanlangan davlat: ${country.displayName}');
      },
    );
  }

  void _submitPhoneNumber() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String fullPhoneNumber =
          "+${_selectedCountry.phoneCode}${_phoneController.text}";
      print("To'liq telefon raqami: $fullPhoneNumber");
      // TODO: Logikani qo'shing: Telefon raqamini serverga yuborish
      _telegramClient.sendCode(context, fullPhoneNumber);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Keyingi: SMS kodni kiritish ($fullPhoneNumber)'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Telefon raqamingiz"),
        // "Keyingi" tugmasini bu yerdan olib tashlaymiz, pastga qo'yamiz
      ),
      body: SafeArea(
        // Ekran chetlaridan xavfsiz joy ajratish
        child: Center(
          // Barcha kontentni markazga joylash
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // Vertikal markazlash
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // Elementlarni kengaytirish
                children: <Widget>[
                  Icon(
                    Icons.phone_android_outlined,
                    // Yoki Icons.chat_bubble_outline
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Raqamingizni tasdiqlang",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[700],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Davlat kodingizni tanlang va telefon raqamingizni kiriting.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Davlat tanlash qismi
                  Material(
                    // Ripple effect uchun
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _openCountryPicker,
                      borderRadius: BorderRadius.circular(12.0),
                      // Chegaraga moslab
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.dividerColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedCountry.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.deepPurple[700],
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              color: Colors.deepPurple[700],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Telefon raqamini kiritish maydoni
                  TextFormField(
                    controller: _phoneController,
                    focusNode: _phoneFocusNode,
                    autofocus: false,
                    // Davlat tanlashdan keyin avtofokus qilamiz
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      // LengthLimitingTextInputFormatter(15), // Vaqtincha olib turamiz
                    ],
                    decoration: InputDecoration(
                      hintText: "Telefon raqami",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          12.0,
                          13.0,
                          8.0,
                          13.0,
                        ),
                        child: Text(
                          "${_selectedCountry.flagEmoji} +${_selectedCountry.phoneCode}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: theme.dividerColor,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: theme.primaryColor,
                          width: 2.0,
                        ),
                      ),
                      // contentPadding: EdgeInsets.symmetric(vertical: 16.0), // Agar kerak bo'lsa
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Iltimos, telefon raqamingizni kiriting.';
                      }
                      if (value.length < 5) {
                        return 'Juda qisqa raqam kiritildi.';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _submitPhoneNumber(),
                  ),
                  const SizedBox(height: 32),

                  // "Keyingi" tugmasi
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: _submitPhoneNumber,
                    child: const Text("KEYINGI"),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Davom etish orqali siz bizning Xizmat ko'rsatish shartlari va Maxfiylik siyosatimizga rozilik bildirasiz.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
