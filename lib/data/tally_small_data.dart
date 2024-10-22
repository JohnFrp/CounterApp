import 'package:counter/provider/counter.provider.dart';

class TallySmallData {
  // Private constructor to prevent multiple instances
  TallySmallData._privateConstructor();

  // The single instance of TallySmallData
  static final TallySmallData _instance = TallySmallData._privateConstructor();

  // Factory constructor to return the single instance
  factory TallySmallData() {
    return _instance;
  }

  // Data storage for tally providers
  final List<CountProvider> tallyProviders = [];
}
