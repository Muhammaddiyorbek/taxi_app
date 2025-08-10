import 'dart:async'; // Timer uchun
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taxi_app/enterPhoneNumber.dart';
import 'package:taxi_app/tdlib/tdlib.dart';

class EnterOtpCodePage extends StatefulWidget {
  final String phoneNumber;

  const EnterOtpCodePage({super.key, required this.phoneNumber});

  @override
  State<EnterOtpCodePage> createState() => _EnterOtpCodePageState();
}

class _EnterOtpCodePageState extends State<EnterOtpCodePage> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  final int _otpLength = 5; // OTP kod uzunligi
  final TelegramClient _telegramClient = TelegramClient();

  late Timer _timer;
  int _start = 120; // 2 daqiqa
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
    // Sahifa ochilganda avtomatik ravishda OTP maydoniga fokuslanish
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Fokusni TextFormField ga o'tkazish
        FocusScope.of(context).requestFocus(_otpFocusNode);
      }
    });
    _otpController.addListener(() {
      if (mounted) {
        // Widget hali ham daraxtda ekanligini tekshirish
        setState(() {
          // Kontrollerdagi matn o'zgarganda UI ni yangilash (masalan, katakchalarni to'ldirish uchun)
        });
      }
    });
  }

  void startTimer() {
    setState(() {
      _canResend = false;
      _start = 120;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _canResend = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _submitOtpCode() {
    FocusScope.of(context).unfocus(); // Klaviaturani yopish
    if (_otpController.text.length == _otpLength) {
      print("Kiritilgan OTP kod: ${_otpController.text}");
      // TODO: Keyingi bosqichga o'tish logikasi (masalan, 2FA yoki asosiy sahifa)
      _telegramClient.chekCode(_otpController.text, context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Kod tasdiqlandi: ${_otpController.text} (keyingi bosqich...)',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Iltimos, $_otpLength xonali kodni to\'liq kiriting.'),
          backgroundColor: Colors.orangeAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Agar kod to'liq bo'lmasa, fokusni qaytarish
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          FocusScope.of(context).requestFocus(_otpFocusNode);
        }
      });
    }
  }

  // Klaviaturani ko'rsatish uchun maxsus funksiya
  void _showKeyboard() {
    if (mounted) {
      FocusScope.of(context).requestFocus(_otpFocusNode);
      // Agar hali ham klaviatura chiqmasa, manual ravishda show qilish
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted && !_otpFocusNode.hasFocus) {
          FocusScope.of(context).requestFocus(_otpFocusNode);
        }
      });
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    _timer.cancel();
    super.dispose();
  }

  String get _timerString {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _buildOtpInputBoxes(ThemeData theme) {
    List<Widget> otpBoxes = [];
    for (int i = 0; i < _otpLength; i++) {
      String char = "";
      if (_otpController.text.length > i) {
        char = _otpController.text[i];
      }
      otpBoxes.add(
        Container(
          width: 45,
          height: 55,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: char.isNotEmpty
                ? theme.colorScheme.primary.withOpacity(0.1)
                : Colors.grey[200],
            border: Border.all(
              color: _otpFocusNode.hasFocus && _otpController.text.length == i
                  ? theme.colorScheme.primary
                  : (char.isNotEmpty
                        ? theme.colorScheme.primary.withOpacity(0.5)
                        : Colors.grey[400]!),
              width:
                  char.isNotEmpty ||
                      (_otpFocusNode.hasFocus &&
                          _otpController.text.length == i)
                  ? 1.5
                  : 1.0,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: char.isNotEmpty
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            char,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: char.isNotEmpty
                  ? theme.colorScheme.primary
                  : Colors.grey[700],
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _showKeyboard, // Optimallashtirilgan funksiya ishlatilmoqda
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: otpBoxes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[700],
        elevation: 4,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Kodni kiriting",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GestureDetector(
          // Butun sahifaga bosganda ham klaviatura chiqsin
          onTap: _showKeyboard,
          behavior: HitTestBehavior.translucent,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    widget.phoneNumber,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                        children: <TextSpan>[
                          const TextSpan(text: "Telegramingizga yuborilgan "),
                          TextSpan(
                            text: "$_otpLength xonali ",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(text: "sms codeni quyida kiriting.\n"),
                        ],
                      ),
                    ),
                  ),
                  // YAXSHILANGAN: Stack ichida yashirin TextFormField
                  Stack(
                    children: [
                      // Ko'rinadigan OTP katakchalari
                      _buildOtpInputBoxes(theme),

                      // Yashirin input field (butun OTP katakchalar ustida)
                      Positioned.fill(
                        child: TextFormField(
                          controller: _otpController,
                          focusNode: _otpFocusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(_otpLength),
                          ],
                          maxLength: _otpLength,
                          autofocus: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: const TextStyle(
                            color:
                                Colors.transparent, // Matnni ko'rinmas qilish
                          ),
                          decoration: const InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            fillColor: Colors.transparent,
                            filled: true,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          cursorColor: Colors.transparent,
                          // Kursorni yashirish
                          showCursor: false,
                          // Kursorni butunlay yashirish
                          onChanged: (value) {
                            if (mounted) {
                              setState(() {});
                            }
                            if (value.length == _otpLength) {
                              _submitOtpCode();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    child: Text("Raqamni o'zgartirish"),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => EnterPhoneNumberPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
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
                    onPressed: _otpController.text.length == _otpLength
                        ? _submitOtpCode
                        : null,
                    child: const Text("TASDIQLASH"),
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
