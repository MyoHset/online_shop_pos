import 'dart:developer' as dev;

class AppLogger {
  AppLogger._();

  static void logRpcSuccess(String rpcName, {Map<String, dynamic>? params, dynamic result}) {
    dev.log(
      '✅ [RPC SUCCESS] Function: $rpcName | Params: $params | Result: $result',
      name: 'POS_RPC',
    );
  }

  static void logRpcError(String rpcName, dynamic error, {Map<String, dynamic>? params, StackTrace? stackTrace}) {
    dev.log(
      '❌ [RPC ERROR] Function: $rpcName | Params: $params | Error: $error',
      name: 'POS_RPC',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void logDataSuccess(String operation, {dynamic data}) {
    dev.log(
      '✅ [DATA SUCCESS] Operation: $operation | Data: $data',
      name: 'POS_DATA',
    );
  }

  static void logDataError(String operation, dynamic error, {StackTrace? stackTrace}) {
    dev.log(
      '❌ [DATA ERROR] Operation: $operation | Error: $error',
      name: 'POS_DATA',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void logEvent(String eventName, {Map<String, dynamic>? details}) {
    dev.log(
      '👆 [EVENT/CLICK] Event: $eventName | Details: $details',
      name: 'POS_EVENT',
    );
  }
}
