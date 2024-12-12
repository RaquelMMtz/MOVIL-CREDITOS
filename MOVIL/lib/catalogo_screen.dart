import 'package:flutter/material.dart';

class CatalogoScreen extends StatefulWidget {
  @override
  _CatalogoScreenState createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final List<Product> _products = [
    Product("Laptop Dell XPS", "Laptop potente y elegante", 1200.0, "lib/img/item1.webp"),
    Product("iPhone 13 Pro", "Smartphone de alta gama", 999.0, "lib/img/item2.png"),
    Product("Smart TV LG", "Televisor 4K UHD", 650.0, "lib/img/item3.jpg"),
    Product("Audífonos Sony WH-1000XM4", "Cancelación de ruido", 300.0, "lib/img/item4.webp"),
    Product("Bicicleta Trek", "Ideal para montaña", 850.0, "lib/img/item5.webp"),
  ];

  final List<Product> _cart = [];

  void _addToCart(Product product) {
    setState(() {
      _cart.add(product);
    });

    // Mostrar un SnackBar para notificar que el producto se ha añadido al carrito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.name} añadido al carrito"),
        duration: Duration(seconds: 2), // El mensaje durará 2 segundos
        backgroundColor: Colors.green,
      ),
    );
  }

  void _proceedToPurchase() {
    setState(() {
      _cart.clear();
    });
    Navigator.pop(context);
    _showAlertDialog("Compra realizada", "Gracias por tu compra.");
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  void _showCartModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Carrito de Compras",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              if (_cart.isEmpty)
                Text(
                  "Tu carrito está vacío",
                  style: TextStyle(fontSize: 16),
                )
              else
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      final product = _cart[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
                      );
                    },
                  ),
                ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _proceedToPurchase,
                child: Text(
                  "Proceder a la compra",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Catálogo de productos",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return GestureDetector(
                    onTap: () => _addToCart(product), // Agregar al carrito al hacer clic
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              product.imagePath,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 10),
                            Text(
                              product.name,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(product.description),
                            Spacer(),
                            Row(
                              children: [
                                Image.asset(
                                  'lib/img/carrito.png',
                                  width: 30,
                                  height: 30,
                                ),
                                Spacer(),
                                Text("\$${product.price.toStringAsFixed(2)}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton.icon(
                onPressed: _showCartModal,
                icon: Icon(Icons.shopping_cart),
                label: Text("Ver carrito"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white, // Cambia el color del texto a blanco
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Product {
  final String name;
  final String description;
  final double price;
  final String imagePath; // Ruta de la imagen

  Product(this.name, this.description, this.price, this.imagePath);
}
