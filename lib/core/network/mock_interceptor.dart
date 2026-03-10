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
      if (options.method == 'PUT') {
        return handler.resolve(Response(
          requestOptions: options,
          data: {'message': 'Profile updated successfully'},
          statusCode: 200,
        ));
      }
      return handler.resolve(Response(
        requestOptions: options,
        data: {
          'restaurant_name': 'ร้านแมส มาร์แชนท์ (Mass Merchant)',
          'is_open': true,
        },
        statusCode: 200,
      ));
    }

    if (path.contains('/restaurant/withdraw') && options.method == 'POST') {
      return handler.resolve(Response(
        requestOptions: options,
        data: {'message': 'Withdrawal requested successfully'},
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
              'name': 'เมนูยอดนิยม',
              'sort_order': 1,
              'is_active': true,
              'items': [
                {
                  'id': 'item_1',
                  'category_id': 'cat_1',
                  'name': 'แกงมัสมั่นไก่',
                  'description': 'แกงมัสมั่นตำรับไทยแท้ รสชาติเข้มข้น พร้อมมันฝรั่งและถั่วลิสง',
                  'price': 150.0,
                  'is_available': true,
                  'modifiers': [
                    {'name': 'เพิ่มไข่ดาว', 'price': 15.0},
                    {'name': 'เพิ่มข้าวสวย', 'price': 20.0},
                    {'name': 'ระดับความเผ็ด: เผ็ดปกติ', 'price': 0.0},
                    {'name': 'ระดับความเผ็ด: เผ็ดมาก', 'price': 0.0}
                  ]
                },
                {
                  'id': 'item_2',
                  'category_id': 'cat_1',
                  'name': 'ผัดไทยกุ้งแม่น้ำ',
                  'description': 'ผัดไทยเส้นเหนียวนุ่ม เสิร์ฟพร้อมกุ้งแม่น้ำตัวโต',
                  'price': 250.0,
                  'is_available': true,
                  'modifiers': [
                    {'name': 'พิเศษ', 'price': 50.0},
                    {'name': 'เพิ่มกุ้ง', 'price': 80.0},
                    {'name': 'ไม่ใส่ถั่วงอก', 'price': 0.0}
                  ]
                }
              ]
            },
            {
              'id': 'cat_snack',
              'name': 'ของทานเล่น',
              'sort_order': 2,
              'is_active': true,
              'items': [
                {
                  'id': 'item_snack_1',
                  'category_id': 'cat_snack',
                  'name': 'เปาะเปี๊ยะทอด',
                  'description': 'เปาะเปี๊ยะไส้ผักทอดกรอบ ร้อนๆ เสิร์ฟพร้อมน้ำจิ้มบ๊วย',
                  'price': 85.0,
                  'is_available': true,
                  'modifiers': [
                    {'name': 'เพิ่มน้ำจิ้ม', 'price': 5.0}
                  ]
                },
                {
                  'id': 'item_snack_2',
                  'category_id': 'cat_snack',
                  'name': 'ลูกชิ้นปิ้ง',
                  'description': 'ลูกชิ้นหมูเกรดเอ ปิ้งไฟอ่อนๆ กลิ่นหอม',
                  'price': 60.0,
                  'is_available': true,
                  'modifiers': [
                    {'name': 'น้ำจิ้มเผ็ดมาก', 'price': 0.0},
                    {'name': 'น้ำจิ้มปกติ', 'price': 0.0}
                  ]
                }
              ]
            },
            {
              'id': 'cat_drink',
              'name': 'เครื่องดื่ม',
              'sort_order': 3,
              'is_active': true,
              'items': [
                {
                  'id': 'item_3',
                  'category_id': 'cat_drink',
                  'name': 'ชาไทยนมสด',
                  'description': 'ชาไทยสีส้มเข้มข้น หอมกลิ่นชา ผสมนมสดแท้',
                  'price': 50.0,
                  'is_available': true,
                  'modifiers': [
                    {'name': 'ความหวาน 0%', 'price': 0.0},
                    {'name': 'ความหวาน 25%', 'price': 0.0},
                    {'name': 'ความหวาน 50%', 'price': 0.0},
                    {'name': 'ความหวาน 100%', 'price': 0.0},
                    {'name': 'เพิ่มไข่มุก', 'price': 10.0}
                  ]
                }
              ]
            },
            {
              'id': 'cat_dessert',
              'name': 'ของหวาน',
              'sort_order': 4,
              'is_active': true,
              'items': [
                {
                  'id': 'item_dessert_1',
                  'category_id': 'cat_dessert',
                  'name': 'ข้าวเหนียวมะม่วง',
                  'description': 'มะม่วงน้ำดอกไม้หวานฉ่ำ เสิร์ฟพร้อมข้าวเหนียวมูนกะทิหอมๆ',
                  'price': 160.0,
                  'is_available': true,
                  'modifiers': [
                    {'name': 'เพิ่มกะทิ', 'price': 10.0}
                  ]
                }
              ]
            }
          ]
        },
        statusCode: 200,
      ));
    }

    if (path.contains('/restaurant/menu/categories') && options.method == 'POST') {
      final data = options.data as Map<String, dynamic>;
      return handler.resolve(Response(
        requestOptions: options,
        data: {
          'id': 'cat_new_${DateTime.now().millisecondsSinceEpoch}',
          'name': data['name'],
          'sort_order': data['sort_order'] ?? 99,
          'is_active': true,
          'items': [],
        },
        statusCode: 201,
      ));
    }

    if (path.contains('/restaurant/menu/items') && options.method == 'POST') {
      final data = options.data as Map<String, dynamic>;
      return handler.resolve(Response(
        requestOptions: options,
        data: {
          'id': 'item_new_${DateTime.now().millisecondsSinceEpoch}',
          'category_id': data['category_id'],
          'name': data['name'],
          'description': data['description'] ?? '',
          'price': data['price'],
          'is_available': true,
          'modifiers': [],
        },
        statusCode: 201,
      ));
    }

    if (path.contains('/restaurant/orders/pending')) {
      return handler.resolve(Response(
        requestOptions: options,
        data: [
          {
            'id': 'order_987654321',
            'status': 'PLACED',
            'total_amount': 415.0,
            'items': [
              {'name': 'แกงมัสมั่นไก่', 'quantity': 1, 'subtotal': 150.0, 'modifiers': ['เพิ่มไข่ดาว', 'เผ็ดปกติ']},
              {'name': 'ผัดไทยกุ้งแม่น้ำ', 'quantity': 1, 'subtotal': 250.0, 'modifiers': ['พิเศษ', 'เพิ่มกุ้ง']}
            ]
          },
          {
            'id': 'order_112233445',
            'status': 'PREPARING',
            'total_amount': 60.0,
            'items': [
              {'name': 'ชาไทยนมสด', 'quantity': 1, 'subtotal': 50.0, 'modifiers': ['ความหวาน 50%', 'เพิ่มไข่มุก']}
            ]
          },
          {
            'id': 'order_556677889',
            'status': 'PLACED',
            'total_amount': 245.0,
            'items': [
              {'name': 'เปาะเปี๊ยะทอด', 'quantity': 1, 'subtotal': 85.0, 'modifiers': ['เพิ่มน้ำจิ้ม']},
              {'name': 'ข้าวเหนียวมะม่วง', 'quantity': 1, 'subtotal': 160.0}
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
