class Drink {
  final String name;
  final String imagePath;
  final double price;
  const Drink({
    required this.name,
    required this.imagePath,
    required this.price,
  });
}

class CartItem {
  final Drink drink;
  final String size;
  final int quantity;
  final double sugarLevel;
  bool isSelected;
  DateTime? scheduledTime;
  String note;

  CartItem({
    required this.drink,
    required this.size,
    required this.quantity,
    this.sugarLevel = 50.0,
    this.isSelected = false,
    this.scheduledTime,
    this.note = "",
  });
}
