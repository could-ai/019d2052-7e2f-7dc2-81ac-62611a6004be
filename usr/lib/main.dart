import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const DinoDropApp());
}

class CaseItem {
  final String name;
  final String imageIcon;
  final Color rarityColor;
  final double price;

  CaseItem({
    required this.name,
    required this.imageIcon,
    required this.rarityColor,
    required this.price,
  });
}

class DinoDropApp extends StatelessWidget {
  const DinoDropApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DinoDrop - DOOM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F13),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A24),
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE53935), // Red for DOOM
          secondary: Color(0xFFFFB300),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CaseOpeningScreen(),
      },
    );
  }
}

class CaseOpeningScreen extends StatefulWidget {
  const CaseOpeningScreen({super.key});

  @override
  State<CaseOpeningScreen> createState() => _CaseOpeningScreenState();
}

class _CaseOpeningScreenState extends State<CaseOpeningScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isSpinning = false;
  double _balance = 150.00;
  final double _casePrice = 2.50;

  final List<CaseItem> _possibleItems = [
    CaseItem(name: "BFG 9000", imageIcon: "🔫", rarityColor: Colors.red, price: 250.0),
    CaseItem(name: "Crucible Blade", imageIcon: "🗡️", rarityColor: Colors.red, price: 180.0),
    CaseItem(name: "Super Shotgun", imageIcon: "💥", rarityColor: Colors.pinkAccent, price: 45.0),
    CaseItem(name: "Plasma Rifle", imageIcon: "⚡", rarityColor: Colors.purple, price: 15.0),
    CaseItem(name: "Chainsaw", imageIcon: "🪚", rarityColor: Colors.purple, price: 12.0),
    CaseItem(name: "Heavy Cannon", imageIcon: "🎯", rarityColor: Colors.blue, price: 4.5),
    CaseItem(name: "Combat Shotgun", imageIcon: "🔫", rarityColor: Colors.blue, price: 3.0),
    CaseItem(name: "Health Potion", imageIcon: "🧪", rarityColor: Colors.grey, price: 0.5),
    CaseItem(name: "Armor Shard", imageIcon: "🛡️", rarityColor: Colors.grey, price: 0.2),
  ];

  List<CaseItem> _rouletteItems = [];
  CaseItem? _wonItem;

  @override
  void initState() {
    super.initState();
    _generateRouletteItems();
  }

  void _generateRouletteItems() {
    final random = Random();
    _rouletteItems = List.generate(100, (index) {
      int r = random.nextInt(100);
      if (r < 2) return _possibleItems[0]; // BFG
      if (r < 5) return _possibleItems[1]; // Crucible
      if (r < 15) return _possibleItems[2]; // Super Shotgun
      if (r < 30) return _possibleItems[3]; // Plasma
      if (r < 45) return _possibleItems[4]; // Chainsaw
      if (r < 65) return _possibleItems[5]; // Heavy Cannon
      if (r < 80) return _possibleItems[6]; // Combat Shotgun
      if (r < 90) return _possibleItems[7]; // Health
      return _possibleItems[8]; // Armor
    });
  }

  void _openCase() async {
    if (_isSpinning) return;
    if (_balance < _casePrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough balance!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _balance -= _casePrice;
      _isSpinning = true;
      _wonItem = null;
    });

    _generateRouletteItems();
    
    // Reset scroll
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }

    // Winning index around 75
    final random = Random();
    int winningIndex = 70 + random.nextInt(10);
    _wonItem = _rouletteItems[winningIndex];

    // Calculate offset
    // Item width is 120 + 16 padding = 136
    double itemWidth = 136.0;
    double screenWidth = MediaQuery.of(context).size.width;
    
    // We want the winning item to be in the center
    double targetOffset = (winningIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
    
    // Add a little random offset so it doesn't land perfectly in the center every time
    targetOffset += (random.nextDouble() * itemWidth * 0.8) - (itemWidth * 0.4);

    // Animate
    await _scrollController.animateTo(
      targetOffset,
      duration: const Duration(seconds: 6),
      curve: Curves.easeOutCirc,
    );

    setState(() {
      _isSpinning = false;
      _balance += _wonItem!.price; // Automatically sell the item for demo purposes
    });

    if (mounted) {
      _showWinDialog(_wonItem!);
    }
  }

  void _showWinDialog(CaseItem item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: item.rarityColor, width: 2),
        ),
        title: const Text('You Won!', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.imageIcon,
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 16),
            Text(
              item.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: item.rarityColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.greenAccent,
              ),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: item.rarityColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('AWESOME'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.pets, color: Colors.greenAccent),
            SizedBox(width: 8),
            Text(
              'DinoDrop',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A36),
              borderRadius: BorderRadius.circular(20),
              border: BorderSide(color: Colors.greenAccent.withOpacity(0.5)),
            ),
            child: Center(
              child: Text(
                '\$${_balance.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.greenAccent,
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
          children: [
            const SizedBox(height: 40),
            // Case Image & Title
            const Text(
              'DOOM CASE',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
                shadows: [
                  Shadow(color: Colors.redAccent, blurRadius: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x55FF5252), Colors.transparent],
                  stops: [0.2, 1.0],
                ),
              ),
              child: const Center(
                child: Text(
                  '👹',
                  style: TextStyle(fontSize: 100),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Roulette Area
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 160,
                  decoration: const BoxDecoration(
                    color: Color(0xFF15151C),
                    border: Border(
                      top: BorderSide(color: Color(0xFF2A2A36), width: 2),
                      bottom: BorderSide(color: Color(0xFF2A2A36), width: 2),
                    ),
                  ),
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _rouletteItems.length,
                    itemBuilder: (context, index) {
                      final item = _rouletteItems[index];
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E28),
                          borderRadius: BorderRadius.circular(12),
                          border: Border(
                            bottom: BorderSide(color: item.rarityColor, width: 4),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item.imageIcon, style: const TextStyle(fontSize: 40)),
                            const SizedBox(height: 8),
                            Text(
                              item.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Center Line
                Container(
                  width: 4,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Open Button
            GestureDetector(
              onTap: _openCase,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.redAccent, Colors.orangeAccent],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: _isSpinning
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                      )
                    : Text(
                        'OPEN FOR \$${_casePrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 60),

            // Case Contents
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'CASE CONTENTS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _possibleItems.length,
                itemBuilder: (context, index) {
                  final item = _possibleItems[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A24),
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        bottom: BorderSide(color: item.rarityColor, width: 4),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.imageIcon, style: const TextStyle(fontSize: 40)),
                        const SizedBox(height: 12),
                        Text(
                          item.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
