import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for monitoring network connectivity
class ConnectivityService extends ChangeNotifier {
  final Connectivity _connectivity;
  bool _isConnected = true;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  bool get isConnected => _isConnected;

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial status
    await _updateConnectionStatus();

    // Listen for changes
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _updateConnectionStatus();
    });
  }

  /// Update connection status from current connectivity state
  Future<void> _updateConnectionStatus() async {
    try {
      final results = await _connectivity.checkConnectivity();
      
      // Consider connected if any interface is available
      _isConnected = results.any((result) => 
        result != ConnectivityResult.none
      );
      
      notifyListeners();
    } catch (e) {
      // Assume disconnected on error
      _isConnected = false;
      notifyListeners();
    }
  }

  /// Get current connection type
  Future<String> getConnectionType() async {
    try {
      final results = await _connectivity.checkConnectivity();
      
      if (results.contains(ConnectivityResult.wifi)) {
        return 'WiFi';
      } else if (results.contains(ConnectivityResult.mobile)) {
        return 'Mobile';
      } else if (results.contains(ConnectivityResult.ethernet)) {
        return 'Ethernet';
      } else if (results.contains(ConnectivityResult.bluetooth)) {
        return 'Bluetooth';
      }
      
      return 'None';
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Manually check if device is online
  Future<bool> isConnected() async {
    await _updateConnectionStatus();
    return _isConnected;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
