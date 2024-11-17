// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Razorpay _razorpay = Razorpay();
  String selectedAmount = '100'; // Default selected amount

  @override
  void initState() {
    super.initState();
    // Razorpay initialization
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle success payment response here
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Payment Successful")));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure response here
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Payment Failed")));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet selection here
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("External Wallet Selected")));
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clear Razorpay instance when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Gateway'),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Selectable Text Widgets
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAmount = '100';
                    });
                  },
                  child: const Text('100', style: TextStyle(fontSize: 18)),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAmount = '500';
                    });
                  },
                  child: Text('500', style: TextStyle(fontSize: 18)),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAmount = '1000';
                    });
                  },
                  child: const Text('1000', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: ElevatedButton(
                onPressed: () {
                  var options = {
                    'key':
                        'rzp_live_ILgsfZCZoFIKMb', // Replace with your Razorpay key
                    'amount': int.parse(selectedAmount) *
                        100, // Razorpay expects the amount in paise (100 paise = 1 INR)
                    'name': 'Code Creft.',
                    'description': 'Subscribe',
                    'prefill': {
                      'contact': '8888888888',
                      'email': 'test@razorpay.com',
                    }
                  };
                  _razorpay.open(options);
                },
                child: Text(
                  'Pay $selectedAmount Prs',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
