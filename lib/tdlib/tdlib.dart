import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taxi_app/endterCode.dart';
import 'package:taxi_app/enterPasswordPage.dart';
import 'package:taxi_app/enterPhoneNumber.dart';
import 'package:taxi_app/homePage.dart';
import 'package:taxi_app/tdlib/telegramCredentials.dart';
import 'package:tdlib/td_api.dart' as tda;
import 'package:tdlib/td_client.dart' as tdc;
import 'package:path/path.dart';

class TelegramClient {
  final TelegramCredentials _credentials = TelegramCredentials();

  late final int _apiId;
  late final String _apiHash;
  late final String _dbEncryptionKey;
  static late final int? myUserId;

  tdc.Client? client;
  static TelegramClient? _instance;

  TelegramClient._() {
    _apiId = _credentials.apiId;
    _apiHash = _credentials.apiHash;
    _dbEncryptionKey = _credentials.dbEncryptionKey;
  }

  factory TelegramClient() {
    _instance ??= TelegramClient._();
    return _instance!;
  }

  Future<void> initialize(BuildContext context) async {
    try {
      if (client == null) {
        client = tdc.Client.create();
        await client!.initialize();
      }
      listenAuthorizationUpdates(context);
    } catch (e) {
      print(e.toString());
    }
  }

  void listenAuthorizationUpdates(BuildContext context) {
    client!.updates.listen((event) {
      final eventType = event.toJson()['@type'];
      if (eventType == 'updateAuthorizationState') {
        tda.UpdateAuthorizationState update =
            event as tda.UpdateAuthorizationState;

        tda.AuthorizationState authorizationState = update.authorizationState;
        onAuthStateUpdated(authorizationState, context, client);
      }
    });
  }

  void onAuthStateUpdated(
    tda.AuthorizationState authorizationState,
    BuildContext context,
    tdc.Client? client,
  ) async {
    switch (authorizationState.getConstructor()) {
      case tda.AuthorizationStateWaitTdlibParameters.constructor:
        await setTdlibParameters();
        break;
      case tda.AuthorizationStateWaitPhoneNumber.constructor:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EnterPhoneNumberPage()),
        );
        break;
      case tda.AuthorizationStateWaitCode.constructor:
        tda.AuthorizationStateWaitCode waitCodeState =
            authorizationState as tda.AuthorizationStateWaitCode;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EnterOtpCodePage(
              phoneNumber: waitCodeState.codeInfo.phoneNumber,
            ),
          ),
        );
        break;
      case tda.AuthorizationStateWaitPassword.constructor:
        tda.AuthorizationStateWaitPassword waitPasswordState =
            authorizationState as tda.AuthorizationStateWaitPassword;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EnterPasswordPage(passwordHint: waitPasswordState.passwordHint),
          ),
        );
        break;
      case tda.AuthorizationStateReady.constructor:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
        break;
    }
  }

  Future<void> chekPassword(String password, BuildContext context) async {
    listenAuthorizationUpdates(context);
    await client!.send(tda.CheckAuthenticationPassword(password: password));
  }

  Future<void> chekCode(String code, BuildContext context) async {
    listenAuthorizationUpdates(context);
    await client!.send(tda.CheckAuthenticationCode(code: code));
  }

  Future<void> sendCode(BuildContext context, String phoneNumber) async {
    listenAuthorizationUpdates(context);
    await client!.send(
      tda.SetAuthenticationPhoneNumber(
        phoneNumber: phoneNumber,
        settings: tda.PhoneNumberAuthenticationSettings(
          isCurrentPhoneNumber: true,
          authenticationTokens: [],
          allowSmsRetrieverApi: false,
          allowFlashCall: false,
          allowMissedCall: false,
          firebaseAuthenticationSettings: null,
        ),
      ),
    );
  }

  Future<void> setTdlibParameters() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final downloadsDir = await getDownloadsDirectory();
    final String deviceModel = 'Samsung Galaxy S22 Ultra';
    final String systemVersion = '10';
    final parametrs = tda.SetTdlibParameters(
      apiId: _apiId,
      apiHash: _apiHash,
      useTestDc: false,
      systemLanguageCode: 'en-US',
      deviceModel: deviceModel,
      systemVersion: systemVersion,
      applicationVersion: '1.1.0',
      databaseDirectory: appDocDir.path,
      filesDirectory: downloadsDir!.path,
      databaseEncryptionKey: _dbEncryptionKey,
      enableStorageOptimizer: true,
      ignoreFileNames: false,
      useFileDatabase: true,
      useSecretChats: true,
      useMessageDatabase: true,
      useChatInfoDatabase: true,
    );
    await client!.send(parametrs);
  }
}
