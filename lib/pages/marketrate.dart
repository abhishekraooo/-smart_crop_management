
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CropHistoryScreen extends StatefulWidget {
  @override
  _CropHistoryScreenState createState() => _CropHistoryScreenState();
}

class _CropHistoryScreenState extends State<CropHistoryScreen> {
  final TextEditingController _cropController = TextEditingController();
  bool _isLoading = false;
  List<PriceData> _priceHistory = [];
  final List<String> _popularCrops = [
    'Wheat',
    'Rice',
    'Maize',
    'Potato',
    'Tomato',
  ];

  /// Fetches crop price history based on the provided crop name.
  Future<void> fetchCropHistory(String cropName) async {
    setState(() {
      _isLoading = true;
      _priceHistory = [];
    });

    try {
      debugPrint('Fetching crop history for: $cropName');
      await Future.delayed(Duration(seconds: 1)); // Simulate API delay

      // Generate sample data for demonstration
      final List<PriceData> prices = _generateSamplePriceData(cropName);

      setState(() {
        _priceHistory = prices;
      });
    } catch (e) {
      debugPrint('Error fetching crop history: $e');
      setState(() {
        _priceHistory = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Generates sample price data for a given crop.
  List<PriceData> _generateSamplePriceData(String cropName) {
    List<PriceData> prices = [];
    int basePrice = 1500 + (cropName.hashCode % 1000);

    for (int year = 2014; year <= 2024; year++) {
      final variation = (year - 2014) * 100 + (cropName.hashCode % 200 - 100);
      prices.add(
        PriceData(
          year: year,
          price: (basePrice + variation).toDouble(),
          event: _getRandomEvent(year),
        ),
      );
    }
    return prices;
  }

  /// Fetches monthly price data for a specific year and crop.
  Future<void> fetchMonthlyData(int year, String cropName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('Fetching monthly data for $cropName in $year');
      await Future.delayed(Duration(seconds: 1)); // Simulate API delay

      // Generate sample monthly data for the selected year
      final List<MonthlyPriceData> monthlyPrices =
          _generateSampleMonthlyPriceData(cropName);

      // Navigate to the new screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => MonthlyPricesScreen(
                year: year,
                cropName: cropName,
                monthlyPriceData: monthlyPrices,
              ),
        ),
      );
    } catch (e) {
      debugPrint('Error fetching monthly data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Generates sample monthly price data for a given crop.
  List<MonthlyPriceData> _generateSampleMonthlyPriceData(String cropName) {
    List<MonthlyPriceData> monthlyPrices = [];
    int basePrice = 1500 + (cropName.hashCode % 1000);

    for (int month = 1; month <= 12; month++) {
      final variation = (month * 50) + (cropName.hashCode % 100 - 50);
      monthlyPrices.add(
        MonthlyPriceData(
          month: month,
          price: (basePrice + variation).toDouble(),
        ),
      );
    }
    return monthlyPrices;
  }

  /// Returns a random event description for a given year.
  String _getRandomEvent(int year) {
    final events = [
      'Normal monsoon',
      'Increased demand',
      'Export restrictions',
      'Good harvest',
      'Drought affected',
      'Global price surge',
    ];
    return '${events[year % events.length]} in $year';
  }

  @override
  void dispose() {
    _cropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Crop Price History')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 16),
            _buildPopularCrops(),
            SizedBox(height: 24),
            if (_isLoading) Center(child: CircularProgressIndicator()),
            if (_priceHistory.isNotEmpty) ...[
              Expanded(child: _buildPriceChart()),
              SizedBox(height: 20),
              Expanded(child: _buildPriceList()),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds the search bar widget.
  Widget _buildSearchBar() {
    return TextField(
      controller: _cropController,
      decoration: InputDecoration(
        labelText: 'Enter crop name',
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            final cropName = _cropController.text.trim();
            if (cropName.isNotEmpty) fetchCropHistory(cropName);
          },
        ),
      ),
      onSubmitted: (value) {
        final cropName = value.trim();
        if (cropName.isNotEmpty) fetchCropHistory(cropName);
      },
    );
  }

  /// Builds the popular crops filter chips.
  Widget _buildPopularCrops() {
    return Wrap(
      spacing: 8,
      children:
          _popularCrops
              .map(
                (crop) => FilterChip(
                  label: Text(crop),
                  selected: _cropController.text == crop,
                  onSelected: (_) {
                    _cropController.text = crop;
                    fetchCropHistory(crop);
                  },
                ),
              )
              .toList(),
    );
  }

  /// Builds the price chart widget.
  Widget _buildPriceChart() {
    return SfCartesianChart(
      primaryXAxis: NumericAxis(title: AxisTitle(text: 'Year'), interval: 1),
      primaryYAxis: NumericAxis(title: AxisTitle(text: 'Price (₹/quintal)')),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries>[
        LineSeries<PriceData, int>(
          dataSource: _priceHistory,
          xValueMapper: (PriceData data, _) => data.year,
          yValueMapper: (PriceData data, _) => data.price,
          name: 'Price',
          markerSettings: MarkerSettings(isVisible: true),
          dataLabelSettings: DataLabelSettings(isVisible: true),
          onPointTap: (ChartPointDetails details) {
            final selectedYear = _priceHistory[details.pointIndex!].year;
            fetchMonthlyData(selectedYear, _cropController.text.trim());
          },
        ),
      ],
    );
  }

  /// Builds the price list widget.
  Widget _buildPriceList() {
    return ListView.builder(
      itemCount: _priceHistory.length,
      itemBuilder: (context, index) {
        final data = _priceHistory[index];
        return ListTile(
          title: Text('${data.year}'),
          subtitle: Text(data.event),
          trailing: Text('₹${data.price.toStringAsFixed(2)}'),
          onTap: () {
            fetchMonthlyData(data.year, _cropController.text.trim());
          },
        );
      },
    );
  }
}

/// Screen to display monthly price data.
class MonthlyPricesScreen extends StatelessWidget {
  final int year;
  final String cropName;
  final List<MonthlyPriceData> monthlyPriceData;

  MonthlyPricesScreen({
    required this.year,
    required this.cropName,
    required this.monthlyPriceData,
  });

  /// Converts a month number to its abbreviated name.
  String _getMonthName(int month) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Monthly Prices for $cropName ($year)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: _buildMonthlyChart()),
            SizedBox(height: 20),
            Expanded(child: _buildMonthlyList()),
          ],
        ),
      ),
    );
  }

  /// Builds the monthly price chart widget.
  Widget _buildMonthlyChart() {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Month')),
      primaryYAxis: NumericAxis(title: AxisTitle(text: 'Price (₹/quintal)')),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries>[
        LineSeries<MonthlyPriceData, String>(
          dataSource: monthlyPriceData,
          xValueMapper: (MonthlyPriceData data, _) => _getMonthName(data.month),
          yValueMapper: (MonthlyPriceData data, _) => data.price,
          name: 'Monthly Price',
          markerSettings: MarkerSettings(isVisible: true),
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }

  /// Builds the monthly price list widget.
  Widget _buildMonthlyList() {
    return ListView.builder(
      itemCount: monthlyPriceData.length,
      itemBuilder: (context, index) {
        final data = monthlyPriceData[index];
        return ListTile(
          title: Text(_getMonthName(data.month)),
          trailing: Text('₹${data.price.toStringAsFixed(2)}'),
        );
      },
    );
  }
}

/// Model class for yearly price data.
class PriceData {
  final int year;
  final double price;
  final String event;

  PriceData({required this.year, required this.price, required this.event});
}

/// Model class for monthly price data.
class MonthlyPriceData {
  final int month;
  final double price;

  MonthlyPriceData({required this.month, required this.price});
}
