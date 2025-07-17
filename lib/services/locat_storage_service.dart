import 'package:paywise/models/pay_req.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _keyPayoutRequests = 'payoutRequests';

  Future<void> savePayoutRequest(PayoutRequest request) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> payoutRequestsJson = prefs.getStringList(_keyPayoutRequests) ?? [];
    payoutRequestsJson.add(request.toRawJson());
    await prefs.setStringList(_keyPayoutRequests, payoutRequestsJson);
  }

  Future<List<PayoutRequest>> getPayoutRequests() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> payoutRequestsJson = prefs.getStringList(_keyPayoutRequests) ?? [];
    return payoutRequestsJson
        .map((jsonString) => PayoutRequest.fromRawJson(jsonString))
        .toList();
  }

  Future<void> clearAllPayoutRequests() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPayoutRequests);
  }
}