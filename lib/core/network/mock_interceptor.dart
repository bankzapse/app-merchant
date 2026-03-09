import 'package:dio/dio.dart';

class MockInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check path and return mock response
    final path = options.path;

    if (path.contains('/auth/login')) {
      return handler.resolve(Response(
        requestOptions: options,
        data: {'token': 'mock_jwt_token_12345'},
        statusCode: 200,
      ));
    }

    if (path.contains('/restaurant/profile')) {
      return handler.resolve(Response(
        requestOptions: options,
        data: {
          'restaurant_name': 'Mass Merchant Mock Shop',
          'is_open': true,
        },
        statusCode: 200,
      ));
    }

    if (path.contains('/customer/restaurants/') && path.endsWith('/menu')) {
      return handler.resolve(Response(
        requestOptions: options,
        data: {
          'categories': [
            {
              'id': 'cat_1',
              'name': 'Signature Dishes',
              'sort_order': 1,
              'is_active': true,
              'items': [
                {
                  'id': 'item_1',
                  'category_id': 'cat_1',
                  'name': 'Massman Curry with Chicken',
                  'description': 'Delicious Thai curry with peanuts and potatoes',
                  'price': 150.0,
                  'is_available': true,
                },
                {
                  'id': 'item_2',
                  'category_id': 'cat_1',
                  'name': 'Pad Thai Kung Mae Nam',
                  'description': 'Classic Pad Thai with giant river prawn',
                  'price': 250.0,
                  'is_available': true,
                }
              ]
            },
            {
              'id': 'cat_2',
              'name': 'Drinks',
              'sort_order': 2,
              'is_active': true,
              'items': [
                {
                  'id': 'item_3',
                  'category_id': 'cat_2',
                  'name': 'Thai Milk Tea',
                  'description': 'Authentic orange Thai tea with milk',
                  'price': 50.0,
                  'is_available': true,
                }
              ]
            }
          ]
        },
        statusCode: 200,
      ));
    }

    if (path.contains('/restaurant/orders/pending')) {
      return handler.resolve(Response(
        requestOptions: options,
        data: [
          {
            'id': 'order_987654321',
            'status': 'PLACED',
            'total_amount': 400.0,
            'items': [
              {'name': 'Massman Curry with Chicken', 'quantity': 1, 'subtotal': 150.0},
              {'name': 'Pad Thai Kung Mae Nam', 'quantity': 1, 'subtotal': 250.0}
            ]
          },
          {
            'id': 'order_112233445',
            'status': 'PREPARING',
            'total_amount': 50.0,
            'items': [
              {'name': 'Thai Milk Tea', 'quantity': 1, 'subtotal': 50.0}
            ]
          }
        ],
        statusCode: 200,
      ));
    }

    if (path.contains('/restaurant/ads')) {
      return handler.resolve(Response(
        requestOptions: options,
        data: {
          'id': 'ad_current',
          'daily_budget': 500.0,
          'current_spend': 120.50,
          'bid_per_click': 2.5,
          'is_active': true,
        },
        statusCode: 200,
      ));
    }

    // Default: Continue with real request or 404
    super.onRequest(options, handler);
  }
}
