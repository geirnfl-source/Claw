import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const NeoBankApp());
}

class NeoBankApp extends StatelessWidget {
  const NeoBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundGradient = LinearGradient(
      colors: [Color(0xFF2d080d), Color(0xFF050505)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NeoBank Wealth Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFFD946EF),
        ),
        fontFamily: 'Inter, -apple-system, BlinkMacSystemFont, sans-serif',
      ),
      home: DecoratedBox(
        decoration: const BoxDecoration(gradient: backgroundGradient),
        child: const NeoBankHome(),
      ),
    );
  }
}

class NeoBankHome extends StatefulWidget {
  const NeoBankHome({super.key});

  @override
  State<NeoBankHome> createState() => _NeoBankHomeState();
}

class _NeoBankHomeState extends State<NeoBankHome> with TickerProviderStateMixin {
  static const neonIndigo = Color(0xFF6366F1);
  static const neonFuchsia = Color(0xFFD946EF);
  static const neonGreen = Color(0xFF34d399);
  static const neonRed = Color(0xFFf87171);

  int _currentNavIndex = 0;
  bool _isPersonalView = true;
  String _selectedMarket = 'Iceland';
  bool _transferLoading = false;
  bool _transferSuccess = false;

  late List<BankAccount> _accounts = [
    BankAccount(name: 'Debit Account', balance: 1850000, icon: Icons.account_balance_wallet, color: neonIndigo),
    BankAccount(name: 'Savings Account', balance: 1900000, icon: Icons.savings, color: neonGreen),
    BankAccount(name: 'Household Account', balance: 500000, icon: Icons.home, color: neonFuchsia),
  ];

  final List<ChatMessage> _chatMessages = [
    ChatMessage(
      sender: ChatSender.ai,
      text: 'Happy to help! Based on your spending trend, allocating 200.000 ISK monthly keeps you on track for your cabin fund.',
      timestamp: '11:02',
    ),
    ChatMessage(
      sender: ChatSender.user,
      text: 'Can you watch my liquidity levels and alert me if they drop?',
      timestamp: '11:05',
    ),
    ChatMessage(
      sender: ChatSender.ai,
      text: 'Absolutely. I will ping you when liquidity falls below 3.000.000 ISK and propose replenishment moves.',
      timestamp: '11:06',
    ),
  ];

  final TextEditingController _aiController = TextEditingController();

  final Map<String, List<Stock>> _markets = {
    'Iceland': const [
      Stock(symbol: 'Marel', price: 612.4, change: 1.4),
      Stock(symbol: 'Arion', price: 126.9, change: -0.7),
      Stock(symbol: 'Eimskip', price: 422.6, change: 0.9),
    ],
    'Global': const [
      Stock(symbol: 'Apple', price: 198.2, change: 0.8),
      Stock(symbol: 'Tesla', price: 212.3, change: -1.2),
      Stock(symbol: 'Nvidia', price: 912.5, change: 2.1),
    ],
    'Funds': const [
      Stock(symbol: 'Landsbréf', price: 118.0, change: 0.4),
      Stock(symbol: 'Íslandssjóðir', price: 143.5, change: 0.6),
      Stock(symbol: 'Green Arctic', price: 87.1, change: -0.2),
    ],
  };

  final WealthData _personalWealth = WealthData(
    assets: 32750000,
    liabilities: 12450000,
    equity: 20300000,
    property: PropertyData(
      totalValue: 45000000,
      loanBalance: 28000000,
      equity: 17000000,
      properties: [
        Property(name: 'Apartment — Reykjavík', value: 32000000, loan: 20000000),
        Property(name: 'Summer House — Akureyri', value: 13000000, loan: 8000000),
      ],
    ),
    stocks: 8200000,
    crypto: 4900000,
    cash: 4250000,
  );

  final WealthData _familyWealth = WealthData(
    assets: 98500000,
    liabilities: 38200000,
    equity: 60300000,
    property: PropertyData(
      totalValue: 125000000,
      loanBalance: 72000000,
      equity: 53000000,
      properties: [
        Property(name: 'Apartment — Reykjavík (Ragnar)', value: 32000000, loan: 20000000),
        Property(name: 'Summer House — Akureyri (Ragnar)', value: 13000000, loan: 8000000),
        Property(name: 'Family Home — Kópavogur (Parents)', value: 52000000, loan: 30000000),
        Property(name: 'Studio — Hafnarfjörður (Sibling)', value: 28000000, loan: 14000000),
      ],
    ),
    stocks: 22100000,
    crypto: 8400000,
    cash: 12500000,
  );

  final List<FamilyMember> _familyMembers = [
    FamilyMember(name: 'Ragnar', initial: 'R', color: neonIndigo),
    FamilyMember(name: 'Sigrid', initial: 'S', color: neonFuchsia),
    FamilyMember(name: 'Ólafur', initial: 'Ó', color: neonGreen),
    FamilyMember(name: 'Helga', initial: 'H', color: Color(0xFFfbbf24)),
  ];

  WealthData get _activeWealth => _isPersonalView ? _personalWealth : _familyWealth;
  double get _totalLiquidity => _accounts.fold(0.0, (sum, account) => sum + account.balance);

  @override
  void dispose() {
    _aiController.dispose();
    super.dispose();
  }

  void _openTransferSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TransferSheet(
        accounts: _accounts,
        onTransferComplete: (fromIndex, toIndex, amount) {
          setState(() {
            _accounts[fromIndex].balance -= amount;
            _accounts[toIndex].balance += amount;
          });
        },
      ),
    );
  }

  void _openAssetDetail(String assetType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AssetDetailSheet(
        assetType: assetType,
        wealthData: _activeWealth,
        isPersonalView: _isPersonalView,
        accounts: _accounts,
      ),
    );
  }

  void _submitChat() {
    if (_aiController.text.trim().isEmpty) return;
    final text = _aiController.text.trim();
    setState(() {
      _chatMessages.add(
        ChatMessage(sender: ChatSender.user, text: text, timestamp: 'Now'),
      );
    });
    _aiController.clear();
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _chatMessages.add(
            ChatMessage(
              sender: ChatSender.ai,
              text: 'Logged it. I will recompute your savings target and keep liquidity above threshold automatically.',
              timestamp: 'Now',
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _buildHomeScreen(),
      _buildWealthScreen(),
      _buildLoyaltyScreen(),
      _buildAIScreen(),
      _buildMoreScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: screens[_currentNavIndex],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentNavIndex,
              onTap: (index) => setState(() => _currentNavIndex = index),
              backgroundColor: Colors.transparent,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: neonIndigo,
              unselectedItemColor: Colors.white38,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              elevation: 0,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.show_chart_rounded), label: 'Wealth'),
                BottomNavigationBarItem(icon: Icon(Icons.card_giftcard_rounded), label: 'Loyalty'),
                BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_rounded), label: 'AI'),
                BottomNavigationBarItem(icon: Icon(Icons.menu_rounded), label: 'More'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good afternoon, Ragnar',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Here is your liquidity snapshot',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
                ),
                onBackgroundImageError: (_, __) {},
                child: Text('R', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your liquidity',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _formatISK(_totalLiquidity),
                    key: ValueKey(_totalLiquidity),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _trendChip('+12% vs last month', neonGreen),
                    const SizedBox(width: 12),
                    _trendChip('Family total', Colors.cyanAccent),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: _openTransferSheet,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.swap_horiz, size: 16, color: Colors.white54),
                          const SizedBox(width: 6),
                          Text(
                            'Transfer',
                            style: TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GlassContainer(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Assistant',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your savings grew 12% last quarter. Ready to divert 200.000 ISK to the wealth sleeve?',
                        style: TextStyle(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _currentNavIndex = 3),
                  icon: const Icon(Icons.navigate_next),
                  color: Colors.white70,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Accounts',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 12),
          ..._accounts.map((account) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassContainer(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: account.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(account.icon, color: account.color, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account.name,
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Text(
                                _formatISK(account.balance),
                                key: ValueKey(account.balance),
                                style: TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.white60),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildWealthScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wealth & Trading',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildViewToggle(),
            ],
          ),
          if (!_isPersonalView) ...[
            const SizedBox(height: 16),
            _buildFamilyAvatars(),
          ],
          const SizedBox(height: 16),
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isPersonalView ? 'Personal net worth' : 'Family net worth',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 6),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _formatISK(_activeWealth.equity),
                    key: ValueKey('${_isPersonalView}_${_activeWealth.equity}'),
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Assets with AI guard + liability tracking',
                  style: TextStyle(color: Colors.white60),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            child: Column(
              children: [
                SizedBox(
                  height: 220,
                  child: CustomPaint(
                    painter: DonutChartPainter(
                      property: _activeWealth.property.equity,
                      stocks: _activeWealth.stocks,
                      crypto: _activeWealth.crypto,
                      cash: _activeWealth.cash,
                    ),
                    size: const Size(220, 220),
                  ),
                ),
                const SizedBox(height: 16),
                _buildAssetLegend(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildMarketsSection(),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleOption('Personal', true),
          _buildToggleOption('Family', false),
        ],
      ),
    );
  }

  Widget _buildToggleOption(String label, bool isPersonal) {
    final isSelected = _isPersonalView == isPersonal;
    return GestureDetector(
      onTap: () => setState(() => _isPersonalView = isPersonal),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? neonIndigo.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildFamilyAvatars() {
    return Row(
      children: _familyMembers.map((member) => Padding(
        padding: const EdgeInsets.only(right: 12),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: member.color.withOpacity(0.2),
          child: Text(
            member.initial,
            style: TextStyle(color: member.color, fontWeight: FontWeight.bold),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildAssetLegend() {
    final assets = [
      ('Property', _activeWealth.property.equity, Color(0xFF7C3AED)),
      ('Stocks', _activeWealth.stocks, Color(0xFFFB7185)),
      ('Crypto', _activeWealth.crypto, neonGreen),
      ('Cash', _activeWealth.cash, Color(0xFFB5BBCF)),
    ];

    return Column(
      children: assets.map((asset) {
        final (name, value, color) = asset;
        return GestureDetector(
          onTap: () => _openAssetDetail(name),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(name, style: TextStyle(color: Colors.white)),
                ),
                Text(
                  _formatISK(value),
                  style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, color: Colors.white60, size: 16),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMarketsSection() {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Markets',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: _markets.keys.map((market) {
                  final isSelected = market == _selectedMarket;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMarket = market),
                    child: Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? neonIndigo.withOpacity(0.3) : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? neonIndigo.withOpacity(0.5) : Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: Text(
                        market,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._markets[_selectedMarket]!.map((stock) => _buildStockTile(stock)),
        ],
      ),
    );
  }

  Widget _buildStockTile(Stock stock) {
    return GestureDetector(
      onTap: () => _openStockSheet(stock),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white12,
              child: Text(
                stock.symbol.substring(0, min(2, stock.symbol.length)).toUpperCase(),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock.symbol,
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  Text(
                    'ISK ${stock.price.toStringAsFixed(1)}',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              '${stock.change >= 0 ? '+' : ''}${stock.change.toStringAsFixed(1)}%',
              style: TextStyle(
                color: stock.change >= 0 ? neonGreen : neonRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoyaltyScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loyalty & Rewards',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Points',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '12.450 points',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: neonFuchsia,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: neonFuchsia.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.card_giftcard_rounded, color: neonFuchsia, size: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Platinum Member',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.75,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [neonIndigo, neonFuchsia]),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '750 points to Diamond',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Current Perks',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 12),
          ...[
            ('5% cashback at Hagkaup', 'Active until Dec 2026', Icons.local_grocery_store),
            ('Airport lounge access', 'Keflavík & Copenhagen', Icons.flight),
            ('Free currency exchange', 'No fees on FX trades', Icons.currency_exchange),
            ('Birthday bonus — 2x points', 'Valid for 30 days', Icons.cake),
          ].map((perk) {
            final (title, subtitle, icon) = perk;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: GlassContainer(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: neonGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: neonGreen, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: neonGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Active',
                        style: TextStyle(color: neonGreen, fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAIScreen() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: _chatMessages.length,
            itemBuilder: (context, index) {
              final message = _chatMessages[index];
              final isUser = message.sender == ChatSender.user;
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: GlassContainer(
                    color: isUser
                        ? neonIndigo.withOpacity(0.2)
                        : Colors.white.withOpacity(0.05),
                    child: Column(
                      crossAxisAlignment: isUser
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(fontSize: 15, height: 1.4, color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          message.timestamp,
                          style: TextStyle(fontSize: 12, color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _aiController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ask the AI to set financial goals...',
                    hintStyle: TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FloatingActionButton(
                onPressed: _submitChat,
                backgroundColor: neonFuchsia,
                child: const Icon(Icons.send_rounded, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoreScreen() {
    final menuItems = [
      ('Profile & Settings', Icons.person, 'Manage your account preferences'),
      ('Statements & Documents', Icons.description, 'Download account statements'),
      ('Notifications', Icons.notifications, 'Configure alerts and notices'),
      ('Security & Privacy', Icons.security, 'Two-factor auth and privacy'),
      ('Help & Support', Icons.help, 'Contact support or browse help'),
      ('About', Icons.info, 'App version and legal information'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 20),
          GlassContainer(
            padding: EdgeInsets.zero,
            child: Column(
              children: menuItems.map((item) {
                final (title, icon, subtitle) = item;
                return GestureDetector(
                  onTap: () => _showSnack('$title - Coming soon'),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: item != menuItems.last
                          ? Border(bottom: BorderSide(color: Colors.white.withOpacity(0.08)))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(icon, color: Colors.white38, size: 20),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                subtitle,
                                style: TextStyle(color: Colors.white60, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: Colors.white38),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _trendChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatISK(double value) {
    final isNegative = value < 0;
    final abs = value.abs().round();
    final str = abs.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return '${isNegative ? '-' : ''}${buffer.toString()} ISK';
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
      ),
    );
  }

  void _openStockSheet(Stock stock) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StockTradingSheet(stock: stock),
    );
  }
}

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: (color ?? Colors.white).withOpacity(0.06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class TransferSheet extends StatefulWidget {
  const TransferSheet({
    super.key,
    required this.accounts,
    required this.onTransferComplete,
  });

  final List<BankAccount> accounts;
  final Function(int fromIndex, int toIndex, double amount) onTransferComplete;

  @override
  State<TransferSheet> createState() => _TransferSheetState();
}

class _TransferSheetState extends State<TransferSheet> {
  int _fromIndex = 0;
  int _toIndex = 1;
  bool _loading = false;
  bool _success = false;
  String _error = '';
  final TextEditingController _amountController = TextEditingController(text: '100000');

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _swapAccounts() {
    setState(() {
      final temp = _fromIndex;
      _fromIndex = _toIndex;
      _toIndex = temp;
    });
  }

  Future<void> _confirmTransfer() async {
    final amount = _parseAmount(_amountController.text);
    
    setState(() {
      _error = '';
    });

    if (amount <= 0) {
      setState(() => _error = 'Enter a positive amount');
      return;
    }
    
    if (_fromIndex == _toIndex) {
      setState(() => _error = 'Select different accounts');
      return;
    }
    
    if (widget.accounts[_fromIndex].balance < amount) {
      setState(() => _error = 'Insufficient funds');
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    
    widget.onTransferComplete(_fromIndex, _toIndex, amount);
    
    setState(() {
      _loading = false;
      _success = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);
  }

  double _parseAmount(String text) {
    final cleaned = text.replaceAll('.', '').replaceAll(',', '');
    return double.tryParse(cleaned) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Color(0xFF050505).withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Transfer Funds',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                if (_success) ...[
                  Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Color(0xFF34d399).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(0xFF34d399).withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFF34d399).withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: Color(0xFF34d399),
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Transfer Complete!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Successfully transferred ${_formatISK(_parseAmount(_amountController.text))}',
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          _buildAccountDropdown('From account', _fromIndex, (value) {
                            setState(() => _fromIndex = value!);
                          }),
                          const SizedBox(height: 16),
                          Center(
                            child: GestureDetector(
                              onTap: _swapAccounts,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Color(0xFFd946ef).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Color(0xFFd946ef).withOpacity(0.3)),
                                ),
                                child: Icon(
                                  Icons.swap_vert,
                                  color: Color(0xFFd946ef),
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildAccountDropdown('To account', _toIndex, (value) {
                            setState(() => _toIndex = value!);
                          }),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: 'Amount (ISK)',
                              hintStyle: TextStyle(color: Colors.white54),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          if (_error.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              _error,
                              style: TextStyle(color: Color(0xFFf87171), fontSize: 14),
                            ),
                          ],
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: (_loading || _fromIndex == _toIndex) ? null : _confirmTransfer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _loading
                                    ? Colors.white24
                                    : (_fromIndex == _toIndex)
                                        ? Colors.white12
                                        : null,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ).copyWith(
                                backgroundColor: WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return Colors.white12;
                                  }
                                  return _loading ? Colors.white24 : Color(0xFF6366f1);
                                }),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF6366f1), Color(0xFFd946ef)],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Confirm Transfer',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountDropdown(String label, int selectedIndex, Function(int?) onChanged) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 8),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedIndex,
              isExpanded: true,
              dropdownColor: Color(0xFF1a1a1a),
              style: TextStyle(color: Colors.white),
              items: widget.accounts.asMap().entries.map((entry) {
                final index = entry.key;
                final account = entry.value;
                return DropdownMenuItem(
                  value: index,
                  child: Row(
                    children: [
                      Icon(account.icon, color: account.color, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              account.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _formatISK(account.balance),
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  String _formatISK(double value) {
    final isNegative = value < 0;
    final abs = value.abs().round();
    final str = abs.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return '${isNegative ? '-' : ''}${buffer.toString()} ISK';
  }
}

class AssetDetailSheet extends StatelessWidget {
  const AssetDetailSheet({
    super.key,
    required this.assetType,
    required this.wealthData,
    required this.isPersonalView,
    required this.accounts,
  });

  final String assetType;
  final WealthData wealthData;
  final bool isPersonalView;
  final List<BankAccount> accounts;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: Color(0xFF050505).withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '$assetType Portfolio',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _buildAssetContent(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAssetContent() {
    switch (assetType) {
      case 'Property':
        return _buildPropertyContent();
      case 'Stocks':
        return _buildStocksContent();
      case 'Crypto':
        return _buildCryptoContent();
      case 'Cash':
        return _buildCashContent();
      default:
        return Container();
    }
  }

  Widget _buildPropertyContent() {
    return Column(
      children: [
        GlassContainer(
          child: Column(
            children: [
              _buildSummaryRow('Total Value', wealthData.property.totalValue, Colors.white),
              const SizedBox(height: 8),
              _buildSummaryRow('Total Loans', -wealthData.property.loanBalance, Color(0xFFf87171)),
              const SizedBox(height: 8),
              _buildSummaryRow('Net Equity', wealthData.property.equity, Color(0xFF34d399)),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...wealthData.property.properties.map((property) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPropertyRow('Value', property.value, Colors.white),
                const SizedBox(height: 6),
                _buildPropertyRow('Loan', -property.loan, Color(0xFFf87171)),
                const SizedBox(height: 6),
                _buildPropertyRow('Equity', property.equity, Color(0xFF34d399)),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Paid off',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          '${(property.equityPercent * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: Color(0xFF34d399),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: property.equityPercent,
                      backgroundColor: Colors.white12,
                      color: Color(0xFF34d399),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildStocksContent() {
    final stocks = [
      ('Marel Holdings', 2100000.0),
      ('Arion Bank', 1800000.0),
      ('Eimskip Transport', 1400000.0),
      ('Other Holdings', 2900000.0),
    ];

    return Column(
      children: [
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Stock Value',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 6),
              Text(
                _formatISK(wealthData.stocks),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...stocks.map((stock) {
          final (name, value) = stock;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: GlassContainer(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFFB7185).withOpacity(0.2),
                    child: Icon(Icons.trending_up, color: Color(0xFFFB7185), size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    _formatISK(value),
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCryptoContent() {
    final cryptos = [
      ('Bitcoin', 3200000.0, '0.87 BTC'),
      ('Ethereum', 1700000.0, '12.3 ETH'),
    ];

    return Column(
      children: [
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Crypto Value',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 6),
              Text(
                _formatISK(wealthData.crypto),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...cryptos.map((crypto) {
          final (name, value, amount) = crypto;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: GlassContainer(
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF34d399).withOpacity(0.2),
                    child: Icon(Icons.currency_bitcoin, color: Color(0xFF34d399), size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          amount,
                          style: TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatISK(value),
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCashContent() {
    return Column(
      children: [
        GlassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Cash Balance',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 6),
              Text(
                _formatISK(accounts.fold(0.0, (sum, account) => sum + account.balance)),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...accounts.map((account) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: GlassContainer(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: account.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(account.icon, color: account.color, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    account.name,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
                Text(
                  _formatISK(account.balance),
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildSummaryRow(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white70)),
        Text(
          _formatISK(value.abs()),
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildPropertyRow(String label, double value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 14)),
        Text(
          _formatISK(value.abs()),
          style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }

  String _formatISK(double value) {
    final isNegative = value < 0;
    final abs = value.abs().round();
    final str = abs.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return '${isNegative ? '-' : ''}${buffer.toString()} ISK';
  }
}

class StockTradingSheet extends StatefulWidget {
  const StockTradingSheet({super.key, required this.stock});

  final Stock stock;

  @override
  State<StockTradingSheet> createState() => _StockTradingSheetState();
}

class _StockTradingSheetState extends State<StockTradingSheet> {
  String _side = 'Buy';
  final TextEditingController _quantityController = TextEditingController(text: '25');

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Color(0xFF050505).withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stock.symbol,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'ISK ${widget.stock.price.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Change ${widget.stock.change > 0 ? '+' : ''}${widget.stock.change.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: widget.stock.change >= 0
                        ? Color(0xFF34d399)
                        : Color(0xFFf87171),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildSideChip('Buy', Color(0xFF6366f1)),
                    const SizedBox(width: 12),
                    _buildSideChip('Sell', Color(0xFFd946ef)),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    labelStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _side == 'Buy' ? Color(0xFF6366f1) : Color(0xFFd946ef),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$_side order for ${_quantityController.text} ${widget.stock.symbol} scheduled.',
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.black87,
                        ),
                      );
                    },
                    child: Text(
                      '$_side ${widget.stock.symbol}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSideChip(String label, Color color) {
    final isSelected = _side == label;
    return GestureDetector(
      onTap: () => setState(() => _side = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final double property;
  final double stocks;
  final double crypto;
  final double cash;

  DonutChartPainter({
    required this.property,
    required this.stocks,
    required this.crypto,
    required this.cash,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    final innerRadius = radius * 0.6;

    final total = property + stocks + crypto + cash;
    if (total == 0) return;

    final colors = [
      Color(0xFF7C3AED), // Property
      Color(0xFFFB7185), // Stocks
      Color(0xFF34d399), // Crypto
      Color(0xFFB5BBCF), // Cash
    ];

    final values = [property, stocks, crypto, cash];
    double startAngle = -pi / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * pi;
      
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      final path = Path();
      path.moveTo(center.dx, center.dy);
      path.arcTo(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
      );
      path.arcTo(
        Rect.fromCircle(center: center, radius: innerRadius),
        startAngle + sweepAngle,
        -sweepAngle,
        false,
      );
      path.close();

      canvas.drawPath(path, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Data Models
class BankAccount {
  final String name;
  double balance;
  final IconData icon;
  final Color color;

  BankAccount({
    required this.name,
    required this.balance,
    required this.icon,
    required this.color,
  });
}

class WealthData {
  final double assets;
  final double liabilities;
  final double equity;
  final PropertyData property;
  final double stocks;
  final double crypto;
  final double cash;

  WealthData({
    required this.assets,
    required this.liabilities,
    required this.equity,
    required this.property,
    required this.stocks,
    required this.crypto,
    required this.cash,
  });
}

class PropertyData {
  final double totalValue;
  final double loanBalance;
  final double equity;
  final List<Property> properties;

  PropertyData({
    required this.totalValue,
    required this.loanBalance,
    required this.equity,
    required this.properties,
  });
}

class Property {
  final String name;
  final double value;
  final double loan;

  double get equity => value - loan;
  double get equityPercent => value == 0.0 ? 0.0 : (equity / value).clamp(0.0, 1.0);

  Property({
    required this.name,
    required this.value,
    required this.loan,
  });
}

class Stock {
  final String symbol;
  final double price;
  final double change;

  const Stock({
    required this.symbol,
    required this.price,
    required this.change,
  });
}

class FamilyMember {
  final String name;
  final String initial;
  final Color color;

  FamilyMember({
    required this.name,
    required this.initial,
    required this.color,
  });
}

enum ChatSender { user, ai }

class ChatMessage {
  final ChatSender sender;
  final String text;
  final String timestamp;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
  });
}