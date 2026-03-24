import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const DinoDropApp());
}

class DinoDropApp extends StatelessWidget {
  const DinoDropApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DinoDrop Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0E14), // Dark background
        primaryColor: const Color(0xFF00FF66), // Neon green
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF66),
          secondary: Color(0xFFFFAA00),
          surface: Color(0xFF151A22),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF151A22),
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double balance = 150.50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.pets, color: Color(0xFF00FF66)),
            const SizedBox(width: 8),
            const Text(
              'DINODROP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E242D),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2A323D)),
            ),
            child: Center(
              child: Text(
                '\$${balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFF00FF66),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF151A22),
                    Theme.of(context).primaryColor.withOpacity(0.2),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'FEATURED CASE',
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'DOOM',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.redAccent,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CaseOpeningScreen(
                            caseName: 'DOOM',
                            price: 15.00,
                            onBalanceChange: (cost) {
                              setState(() {
                                balance -= cost;
                              });
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FF66),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'OPEN CASE - \$15.00',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Other Cases Grid
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'POPULAR CASES',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final cases = [
                        {'name': 'BEAST', 'price': 5.50, 'color': Colors.purple},
                        {'name': 'NINJA', 'price': 12.00, 'color': Colors.blue},
                        {'name': 'DRAGON', 'price': 25.00, 'color': Colors.orange},
                        {'name': 'CYBER', 'price': 8.99, 'color': Colors.cyan},
                        {'name': 'TOXIC', 'price': 3.50, 'color': Colors.green},
                        {'name': 'GALAXY', 'price': 50.00, 'color': Colors.deepPurple},
                      ];
                      
                      return CaseCard(
                        name: cases[index]['name'] as String,
                        price: cases[index]['price'] as double,
                        color: cases[index]['color'] as Color,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CaseOpeningScreen(
                                caseName: cases[index]['name'] as String,
                                price: cases[index]['price'] as double,
                                onBalanceChange: (cost) {
                                  setState(() {
                                    balance -= cost;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CaseCard extends StatelessWidget {
  final String name;
  final double price;
  final Color color;
  final VoidCallback onTap;

  const CaseCard({
    super.key,
    required this.name,
    required this.price,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF151A22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A323D)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2,
              size: 64,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFF00FF66),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CaseOpeningScreen extends StatefulWidget {
  final String caseName;
  final double price;
  final Function(double) onBalanceChange;

  const CaseOpeningScreen({
    super.key,
    required this.caseName,
    required this.price,
    required this.onBalanceChange,
  });

  @override
  State<CaseOpeningScreen> createState() => _CaseOpeningScreenState();
}

class _CaseOpeningScreenState extends State<CaseOpeningScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool isOpening = false;
  bool showResult = false;
  Map<String, dynamic>? wonItem;

  final List<Map<String, dynamic>> possibleItems = [
    {'name': 'Common Skin', 'color': Colors.grey, 'value': 1.50},
    {'name': 'Uncommon Skin', 'color': Colors.blue, 'value': 5.00},
    {'name': 'Rare Skin', 'color': Colors.purple, 'value': 15.00},
    {'name': 'Mythical Skin', 'color': Colors.pink, 'value': 45.00},
    {'name': 'Legendary Item', 'color': Colors.orange, 'value': 150.00},
    {'name': 'Ancient Relic', 'color': Colors.red, 'value': 500.00},
  ];

  List<Map<String, dynamic>> rouletteItems = [];

  @override
  void initState() {
    super.initState();
    _generateRouletteItems();
  }

  void _generateRouletteItems() {
    final random = Random();
    rouletteItems.clear();
    // Generate 100 random items for the visual roulette
    for (int i = 0; i < 100; i++) {
      // Weighted random (more common items)
      int rand = random.nextInt(100);
      int itemIndex = 0;
      if (rand > 50) itemIndex = 0; // 50% common
      else if (rand > 20) itemIndex = 1; // 30% uncommon
      else if (rand > 5) itemIndex = 2; // 15% rare
      else if (rand > 1) itemIndex = 3; // 4% mythical
      else if (rand > 0) itemIndex = 4; // 1% legendary
      else itemIndex = 5; // <1% ancient
      
      rouletteItems.add(possibleItems[itemIndex]);
    }
  }

  void _openCase() {
    if (isOpening) return;

    setState(() {
      isOpening = true;
      showResult = false;
    });

    widget.onBalanceChange(widget.price);

    // The winning item is around index 75
    final winningIndex = 75;
    final itemWidth = 120.0; // Width of each item card
    
    // Calculate scroll position (center the winning item)
    final screenWidth = MediaQuery.of(context).size.width;
    final targetOffset = (winningIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
    
    // Add some randomness to where it stops exactly on the card
    final randomOffset = targetOffset + (Random().nextDouble() * 80 - 40);

    _scrollController.animateTo(
      randomOffset,
      duration: const Duration(seconds: 5),
      curve: Curves.easeOutCubic,
    ).then((_) {
      setState(() {
        isOpening = false;
        showResult = true;
        wonItem = rouletteItems[winningIndex];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.caseName} CASE'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Roulette Container
          Container(
            height: 150,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0B0E14),
              border: Border(
                top: BorderSide(color: Color(0xFF2A323D), width: 2),
                bottom: BorderSide(color: Color(0xFF2A323D), width: 2),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rouletteItems.length,
                  itemBuilder: (context, index) {
                    final item = rouletteItems[index];
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF151A22),
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                          bottom: BorderSide(
                            color: item['color'] as Color,
                            width: 4,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hardware,
                            color: item['color'] as Color,
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['name'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                // Center Line Indicator
                Container(
                  width: 4,
                  height: double.infinity,
                  color: const Color(0xFF00FF66),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF00FF66),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 48),
          
          // Result or Action Button
          if (showResult && wonItem != null) ...[
            Text(
              'YOU WON!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: wonItem!['color'] as Color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${wonItem!['name']} - \$${wonItem!['value'].toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showResult = false;
                  _scrollController.jumpTo(0);
                  _generateRouletteItems();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A323D),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('TRY AGAIN'),
            ),
          ] else ...[
            ElevatedButton(
              onPressed: isOpening ? null : _openCase,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FF66),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isOpening ? 'OPENING...' : 'OPEN FOR \$${widget.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
