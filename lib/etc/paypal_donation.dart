import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:what_the_banana/common/logger.dart';

void moveToDonationPage(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true,
        clientId: dotenv.get('PAYPAL_CLIENT_ID'),
        secretKey: dotenv.get('PAYPAL_SECRET_KEY'),
        transactions: const [
          {
            'amount': {
              'total': '70',
              'currency': 'USD',
              'details': {
                'subtotal': '70',
                'shipping': '0',
                'shipping_discount': 0,
              },
            },
            'description': 'The payment transaction description.',
            // "payment_options": {
            //   "allowed_payment_method":
            //       "INSTANT_FUNDING_SOURCE"
            // },
            'item_list': {
              'items': [
                {
                  'name': 'Apple',
                  'quantity': 4,
                  'price': '5',
                  'currency': 'USD',
                },
                {
                  'name': 'Pineapple',
                  'quantity': 5,
                  'price': '10',
                  'currency': 'USD',
                }
              ],

              // shipping address is not required though
              //   "shipping_address": {
              //     "recipient_name": "tharwat",
              //     "line1": "Alexandria",
              //     "line2": "",
              //     "city": "Alexandria",
              //     "country_code": "EG",
              //     "postal_code": "21505",
              //     "phone": "+00000000",
              //     "state": "Alexandria"
              //  },
            },
          }
        ],
        note: 'Contact us for any questions on your order.',
        onSuccess: (Map params) async {
          Log.i('onSuccess: $params');
        },
        onError: (error) {
          Log.e('onError: $error');
          Navigator.pop(context);
        },
        onCancel: () {
          Log.w('cancelled:');
        },
      ),
    ),
  );
}
