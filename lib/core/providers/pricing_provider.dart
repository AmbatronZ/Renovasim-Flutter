import 'package:flutter/material.dart';
import '../../data/models/pricing_plan_model.dart';
import '../../data/repositories/laravel_pricing_repository.dart';

class PricingProvider extends ChangeNotifier {
  List<PricingPlanModel> _plans = [];
  bool _isLoading = false;
  String? _error;

  List<PricingPlanModel> get plans => _plans;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadPlans() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _plans = await LaravelPricingRepository.getPricingPlans();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _plans = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
