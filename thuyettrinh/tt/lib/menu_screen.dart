import 'package:flutter/material.dart';
import 'models.dart';
import 'global_data.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  static const List<Drink> drinks = [
    Drink(
      name: 'Sữa Dâu Tây',
      imagePath: 'assets/images/sua-dau-tay.png',
      price: 35000,
    ),
    Drink(
      name: 'Trà Bí Đao',
      imagePath: 'assets/images/tra-bi-dao.jpg',
      price: 40000,
    ),
    Drink(
      name: 'Trà Sữa Bí Đao',
      imagePath: 'assets/images/tra-sua-bi-dao.jpg',
      price: 25000,
    ),
    Drink(
      name: 'Trà Sữa Đài Loan',
      imagePath: 'assets/images/tra-sua-dai-loan.jpg',
      price: 30000,
    ),
    Drink(
      name: 'Trà Sữa Ô Long',
      imagePath: 'assets/images/tra-sua-o-long.png',
      price: 45000,
    ),
    Drink(
      name: 'Trà Sữa Socola',
      imagePath: 'assets/images/tra-sua-socola.png',
      price: 48000,
    ),
    Drink(
      name: 'Trà Sữa Trân Châu',
      imagePath: 'assets/images/tra-sua-tran-chau-duong-den.jpg',
      price: 35000,
    ),
    Drink(
      name: 'Trà Sữa Uyên Ương',
      imagePath: 'assets/images/tra-sua-uyen-uong.png',
      price: 50000,
    ),
    Drink(
      name: 'Trà Xanh Ngô Gia',
      imagePath: 'assets/images/tra-xanh-dao-ngo-gia.png',
      price: 38000,
    ),
    Drink(
      name: 'Trà Sữa Vải Thiều',
      imagePath: 'assets/images/tra-sua-vai-thieu.jpg',
      price: 28000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đã Khát')),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //cột
          mainAxisSpacing: 10, //dọc
          crossAxisSpacing: 10, //ngnag
          childAspectRatio: 0.8, //kích thước ô
        ),
        itemCount: drinks.length,
        itemBuilder: (context, index) {
          final drink = drinks[index];
          return Card(
            clipBehavior: Clip.antiAlias, //cắt bo tròn 2 góc trên
            child: InkWell(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true, //không bị bàn phím sẽ khuất
                builder: (c) => DrinkDetailSheet(drink: drink),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Image.asset(drink.imagePath, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          drink.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                        Text(
                          '${drink.price.toInt()} VNĐ',
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DrinkDetailSheet extends StatefulWidget {
  final Drink drink;
  const DrinkDetailSheet({super.key, required this.drink});
  @override
  State<DrinkDetailSheet> createState() => _DrinkDetailSheetState();
}

class _DrinkDetailSheetState extends State<DrinkDetailSheet> {
  String _selectedSize = 'M';
  int _quantity = 1;
  double _sugarLevel = 50.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom:
            MediaQuery.of(context).viewInsets.bottom +
            20, //khi hiển thị bàn phím sẽ tự đẩy modal lên cách 20px
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, //kh có thì modal chiếm toàn bộ màn hình
        children: [
          //name
          Text(
            widget.drink.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          //size
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'S', label: Text('S')), //value  ngầm
              ButtonSegment(value: 'M', label: Text('M')),
              ButtonSegment(value: 'L', label: Text('L')),
            ],
            selected: {_selectedSize},
            onSelectionChanged: (newSelection) =>
                setState(() => _selectedSize = newSelection.first),
          ),

          const SizedBox(height: 20),
          Text(
            "Mức đường: ${_sugarLevel.toInt()}%",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _sugarLevel,
            min: 0,
            max: 100,
            divisions: 4, // Chia thành các mức 0, 25, 50, 75, 100
            label: "${_sugarLevel.toInt()}%",
            activeColor: Colors.orange,
            onChanged: (double newValue) {
              setState(() {
                _sugarLevel = newValue;
              });
            },
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, //căn giữa quantity
            children: [
              IconButton(
                onPressed: () => setState(() {
                  if (_quantity > 1) _quantity--;
                }),
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_quantity', style: const TextStyle(fontSize: 20)),
              IconButton(
                onPressed: () => setState(() => _quantity++),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                globalCart.add(
                  CartItem(
                    drink: widget.drink,
                    size: _selectedSize,
                    quantity: _quantity,
                    sugarLevel: _sugarLevel,
                  ),
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã thêm vào giỏ hàng!')),
                );
              },
              child: const Text('THÊM VÀO GIỎ'),
            ),
          ),
        ],
      ),
    );
  }
}
