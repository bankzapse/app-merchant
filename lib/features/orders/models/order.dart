class OrderItem {
  final String id;
  final String menuItemId;
  final String name;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  OrderItem({required this.id, required this.menuItemId, required this.name, required this.quantity, required this.unitPrice, required this.subtotal});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      menuItemId: json['menu_item_id'],
      name: json['name'],
      quantity: json['quantity'],
      unitPrice: json['unit_price']?.toDouble() ?? 0.0,
      subtotal: json['subtotal']?.toDouble() ?? 0.0,
    );
  }
}

class Order {
  final String id;
  final String status;
  final double totalAmount;
  final String placedAt;
  final List<OrderItem> items;

  Order({required this.id, required this.status, required this.totalAmount, required this.placedAt, required this.items});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      status: json['status'] ?? 'UNKNOWN',
      totalAmount: json['total_amount']?.toDouble() ?? 0.0,
      placedAt: json['placed_at'] ?? '',
      items: (json['items'] as List?)?.map((i) => OrderItem.fromJson(i)).toList() ?? [],
    );
  }
}
