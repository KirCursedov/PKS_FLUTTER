import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'product_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> products = [
    {
      'name': 'Lorem ipsum dolor sit amet consectetur',
      'price': 17.00,
      'image': 'assets/images/card1.png',
      'isFavorite': false,
      'description': 'High-quality product with excellent features. Perfect for everyday use.',
    },
    {
      'name': 'Lorem ipsum dolor sit amet consectetur',
      'price': 17.00,
      'image': 'assets/images/card2.png',
      'isFavorite': false,
      'description': 'Comfortable and stylish design. Made from premium materials.',
    },
    {
      'name': 'Lorem ipsum dolor sit amet consectetur',
      'price': 17.00,
      'image': 'assets/images/card3.png',
      'isFavorite': false,
      'description': 'Durable and reliable product with modern design.',
    },
    {
      'name': 'Lorem ipsum dolor sit amet consectetur',
      'price': 17.00,
      'image': 'assets/images/card4.png',
      'isFavorite': false,
      'description': 'Eco-friendly materials with exceptional quality.',
    },
    {
      'name': 'Lorem ipsum dolor sit amet consectetur',
      'price': 17.00,
      'image': 'assets/images/card5.png',
      'isFavorite': false,
      'description': 'Versatile product suitable for various occasions.',
    },
    {
      'name': 'Lorem ipsum dolor sit amet consectetur',
      'price': 17.00,
      'image': 'assets/images/card6.png',
      'isFavorite': false,
      'description': 'Premium quality with attention to detail in every aspect.',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Навигация между экранами
    if (index == 1) {
      Navigator.pushNamed(context, '/wishlist');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/cart');
    }
  }

  void _toggleFavorite(int index) {
    setState(() {
      products[index]['isFavorite'] = !products[index]['isFavorite'];
    });
  }

  void _addToCart(int index) {
    // Здесь будет логика добавления в корзину
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${products[index]['name']} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _navigateToProduct(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(
          product: products[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with title only
            _buildHeader(),
            // Products Grid
            Expanded(
              child: _buildProductsGrid(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Shop',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(index);
        },
      ),
    );
  }

  Widget _buildProductCard(int index) {
    final product = products[index];
    
    return GestureDetector(
      onTap: () => _navigateToProduct(index),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image (Square)
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    color: AppColors.lightGrey,
                    image: DecorationImage(
                      image: AssetImage(product['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Product Info
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${product['price']}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Heart icon (top left)
            Positioned(
              top: 8,
              left: 8,
              child: GestureDetector(
                onTap: () => _toggleFavorite(index),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    product['isFavorite'] ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: product['isFavorite'] ? Colors.red : Colors.grey,
                  ),
                ),
              ),
            ),
            
            // Add to cart icon (bottom left)
            Positioned(
              top: 100,
              left: 8,
              child: GestureDetector(
                onTap: () => _addToCart(index),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.white,
        
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(Icons.home, '', 0),
          _buildBottomNavItem(Icons.favorite, '', 1),
          _buildBottomNavItem(Icons.shopping_bag, '', 2),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}