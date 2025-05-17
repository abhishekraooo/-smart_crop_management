import 'package:flutter/material.dart';

class InsurancePage extends StatefulWidget {
  const InsurancePage({super.key});

  @override
  _InsurancePageState createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> {
  final _formKey = GlobalKey<FormState>();
  final _areaController = TextEditingController();
  String? _selectedCrop;
  String? _selectedPaymentOption;
  double _premium = 0.0;
  bool _isCalculated = false;
  bool _showTerms = false;
  bool _acceptedTerms = false;
  bool _isProcessingPayment = false;

  // Crop list with base premium rates per hectare (in Rupees)
  final Map<String, double> _cropRates = {
    'Wheat': 1200,
    'Rice': 1500,
    'Corn': 1300,
    'Soybean': 1400,
    'Cotton': 1800,
    'Potato': 1100,
    'Tomato': 1600,
    'Barley': 1000,
    'Oats': 900,
    'Sorghum': 1200,
    'Sunflower': 1500,
    'Canola': 1400,
    'Sugarcane': 2000,
    'Coffee': 2500,
    'Tea': 2300,
    'Rubber': 2800,
    'Palm Oil': 2200,
    'Coconut': 1900,
    'Banana': 1700,
    'Apple': 2100,
  };

  // Payment option multipliers
  final Map<String, double> _paymentMultipliers = {
    'Monthly': 1.1, // 10% extra for monthly
    '6-Month': 1.05, // 5% extra for 6-month
    'Annually': 1.0, // No extra for annual
  };

  @override
  void dispose() {
    _areaController.dispose();
    super.dispose();
  }

  void _calculatePremium() {
    if (_formKey.currentState!.validate()) {
      final area = double.tryParse(_areaController.text) ?? 0.0;
      final baseRate = _cropRates[_selectedCrop] ?? 0.0;
      final multiplier = _paymentMultipliers[_selectedPaymentOption] ?? 1.0;

      setState(() {
        _premium = area * baseRate * multiplier;
        _isCalculated = true;
      });
    }
  }

  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _selectedCrop = null;
      _selectedPaymentOption = null;
      _premium = 0.0;
      _isCalculated = false;
      _showTerms = false;
      _acceptedTerms = false;
      _areaController.clear();
    });
  }

  void _proceedToPayment() {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms and conditions')),
      );
      return;
    }

    setState(() {
      _isProcessingPayment = true;
    });

    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessingPayment = false;
      });
      _showPaymentDialog();
    });
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.credit_card, color: Colors.blue),
                title: const Text('Credit/Debit Card'),
                onTap: () => _navigateToPaymentGateway('Card'),
              ),
              ListTile(
                leading: const Icon(Icons.account_balance, color: Colors.green),
                title: const Text('Net Banking'),
                onTap: () => _navigateToPaymentGateway('Net Banking'),
              ),
              ListTile(
                leading: const Icon(Icons.phone_android, color: Colors.orange),
                title: const Text('UPI'),
                onTap: () => _navigateToPaymentGateway('UPI'),
              ),
              ListTile(
                leading: const Icon(Icons.wallet, color: Colors.purple),
                title: const Text('Wallet'),
                onTap: () => _navigateToPaymentGateway('Wallet'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _navigateToPaymentGateway(String method) {
    Navigator.of(context).pop(); // Close the dialog
    // In a real app, you would integrate with a payment gateway like Razorpay here
    // This is just a simulation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Processing'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text('Redirecting to $method payment...'),
            ],
          ),
        );
      },
    );

    // Simulate payment completion after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close processing dialog
      _showPaymentSuccess();
    });
  }

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Payment Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 20),
              Text('₹${_premium.toStringAsFixed(0)} paid successfully!'),
              const SizedBox(height: 10),
              const Text('Your crop insurance is now active.'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Done'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetForm();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Insurance')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Crop selection dropdown
              DropdownButtonFormField<String>(
                value: _selectedCrop,
                decoration: const InputDecoration(
                  labelText: 'Select Crop',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.agriculture),
                ),
                items:
                    _cropRates.keys.map((String crop) {
                      return DropdownMenuItem<String>(
                        value: crop,
                        child: Text(crop),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCrop = newValue;
                    _isCalculated = false;
                  });
                },
                validator:
                    (value) => value == null ? 'Please select a crop' : null,
              ),
              const SizedBox(height: 20),

              // Farm area input
              TextFormField(
                controller: _areaController,
                decoration: const InputDecoration(
                  labelText: 'Farm Area (hectares)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.square_foot),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter farm area';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Area must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Payment options
              const Text('Payment Option:', style: TextStyle(fontSize: 16)),
              ..._paymentMultipliers.keys.map((option) {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: _selectedPaymentOption,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedPaymentOption = value;
                      _isCalculated = false;
                    });
                  },
                );
              }).toList(),
              if (_selectedPaymentOption == null)
                const Text(
                  'Please select a payment option',
                  style: TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),

              // Calculate button
              ElevatedButton(
                onPressed: _calculatePremium,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Calculate Premium',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),

              // Reset button
              OutlinedButton(onPressed: _resetForm, child: const Text('Reset')),
              const SizedBox(height: 30),

              // Results display
              if (_isCalculated)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Insurance Premium Calculation',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Table(
                          border: TableBorder.all(color: Colors.grey),
                          children: [
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Crop',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(_selectedCrop ?? ''),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Area',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${_areaController.text} hectares',
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Payment Option',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(_selectedPaymentOption ?? ''),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Base Rate',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '₹${(_cropRates[_selectedCrop] ?? 0).toStringAsFixed(0)}/hectare',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Total Premium: ₹${_premium.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showTerms = !_showTerms;
                            });
                          },
                          child: Text(
                            _showTerms
                                ? 'Hide Terms'
                                : 'Show Terms & Conditions',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Terms and Conditions
              if (_showTerms)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Terms & Conditions:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '1. Premium rates are subject to change based on government policies.',
                          style: TextStyle(fontSize: 14),
                        ),
                        const Text(
                          '2. Claims must be filed within 15 days of crop damage.',
                          style: TextStyle(fontSize: 14),
                        ),
                        const Text(
                          '3. Insurance covers natural calamities like drought, flood, and cyclones.',
                          style: TextStyle(fontSize: 14),
                        ),
                        const Text(
                          '4. Documentation including land records and cultivation proof must be submitted.',
                          style: TextStyle(fontSize: 14),
                        ),
                        const Text(
                          '5. Premium paid is non-refundable once policy is active.',
                          style: TextStyle(fontSize: 14),
                        ),
                        const Text(
                          '6. Government subsidies may apply for certain crops.',
                          style: TextStyle(fontSize: 14),
                        ),
                        const Text(
                          '7. Policy validity is for one agricultural season.',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        CheckboxListTile(
                          title: const Text(
                            'I agree to the terms and conditions',
                          ),
                          value: _acceptedTerms,
                          onChanged: (bool? value) {
                            setState(() {
                              _acceptedTerms = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed:
                              _isProcessingPayment ? null : _proceedToPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[800],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child:
                              _isProcessingPayment
                                  ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        'Processing...',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  )
                                  : Text(
                                    // Removed const here
                                    'Proceed to Payment ₹${_premium.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
