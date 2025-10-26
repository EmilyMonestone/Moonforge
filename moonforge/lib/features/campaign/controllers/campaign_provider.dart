import 'package:flutter/material.dart';
import 'package:moonforge/core/models/data/campaign.dart';

class CampaignProvider with ChangeNotifier {
  Campaign? _currentCampaign;

  Campaign? get currentCampaign => _currentCampaign;

  void setCurrentCampaign(Campaign? campaign) {
    _currentCampaign = campaign;
    notifyListeners();
  }
}
