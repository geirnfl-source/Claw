import 'dart:async';
import 'dart:ui';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const NeoBankApp());
}

class NeoBankApp extends StatelessWidget {
  const NeoBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundGradient = LinearGradient(
      colors: [Color(0xFF050505), Color(0xFF2D080D)],
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
        textTheme: GoogleFonts.interTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
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

class _NeoBankHomeState extends State<NeoBankHome> {
  int _selectedIndex = 0;
  final ValueNotifier<bool> _showSuccess = ValueNotifier<bool>(false);
  final TextEditingController _amountController =
      TextEditingController(text: '250000');
  String _fromAccount = 'Liquidity';
  String _toAccount = 'Household';
  bool _processingTransfer = false;

  static const neonIndigo = Color(0xFF6366F1);
  static const neonFuchsia = Color(0xFFD946EF);

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      sender: ChatSender.ai,
      text:
          'Happy to help! Based on your spending trend, allocating 200.000 ISK monthly keeps you on track for your cabin fund.',
      timestamp: '11:02',
    ),
    _ChatMessage(
      sender: ChatSender.user,
      text: 'Can you watch my liquidity levels and alert me if they drop?',
      timestamp: '11:05',
    ),
    _ChatMessage(
      sender: ChatSender.ai,
      text:
          'Absolutely. I will ping you when liquidity falls below 3.000.000 ISK and propose replenishment moves.',
      timestamp: '11:06',
    ),
  ];

  final TextEditingController _aiController = TextEditingController();

  final List<_BankCard> _cards = const [
    _BankCard(
      label: 'Debit Liquidity',
      holder: 'Geir NFL',
      number: '•••• 2389',
      balance: 4250000,
      gradient: LinearGradient(
        colors: [Color(0xFF2A2A72), Color(0xFF009FFD)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    _BankCard(
      label: 'Platinum Yield',
      holder: 'Geir NFL',
      number: '•••• 9931',
      balance: 6120000,
      gradient: LinearGradient(
        colors: [Color(0xFF41295A), Color(0xFF2F0743)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];

  final List<_Account> _accounts = const [
    _Account(name: 'Liquidity', balance: 4250000),
    _Account(name: 'Savings', balance: 3200000),
    _Account(name: 'Household', balance: 890000),
    _Account(name: 'FX Reserve', balance: 1240000),
  ];

  final Map<String, List<_Stock>> _markets = {
    'Iceland': const [
      _Stock(symbol: 'Marel', change: 1.4, price: 612.4),
      _Stock(symbol: 'Arion', change: -0.7, price: 126.9),
      _Stock(symbol: 'Eimskip', change: 0.9, price: 422.6),
    ],
    'Global': const [
      _Stock(symbol: 'Apple', change: 0.8, price: 198.2),
      _Stock(symbol: 'Tesla', change: -1.2, price: 212.3),
      _Stock(symbol: 'Nvidia', change: 2.1, price: 912.5),
    ],
    'Funds': const [
      _Stock(symbol: 'Landsbréf', change: 0.4, price: 118.0),
      _Stock(symbol: 'Íslandssjóðir', change: 0.6, price: 143.5),
      _Stock(symbol: 'Green Arctic', change: -0.2, price: 87.1),
    ],
  };

  String _selectedMarket = 'Iceland';

  @override
  void dispose() {
    _amountController.dispose();
    _aiController.dispose();
    _showSuccess.dispose();
    super.dispose();
  }

  void _confirmTransfer() async {
    if (_processingTransfer) return;
    setState(() => _processingTransfer = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    _showSuccess.value = true;
    setState(() => _processingTransfer = false);
    Timer(const Duration(seconds: 3), () => _showSuccess.value = false);
  }

  void _submitChat() {
    if (_aiController.text.trim().isEmpty) return;
    final text = _aiController.text.trim();
    setState(() {
      _messages.add(
        _ChatMessage(sender: ChatSender.user, text: text, timestamp: 'Now'),
      );
    });
    _aiController.clear();
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _messages.add(
          _ChatMessage(
            sender: ChatSender.ai,
            text:
                'Logged it. I will recompute your savings target and keep liquidity above threshold automatically.',
            timestamp: 'Now',
          ),
        );
      });
    });
  }

  void _openStockSheet(_Stock stock) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withOpacity(0.7),
      barrierColor: Colors.black54,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final TextEditingController quantity = TextEditingController(text: '25');
        String side = 'Buy';
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${stock.symbol} ${stock.price.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          )),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Change ${stock.change > 0 ? '+' : ''}${stock.change.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: stock.change >= 0
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Buy'),
                        selected: side == 'Buy',
                        onSelected: (_) => setModalState(() => side = 'Buy'),
                        selectedColor: neonIndigo.withOpacity(0.3),
                      ),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: const Text('Sell'),
                        selected: side == 'Sell',
                        onSelected: (_) => setModalState(() => side = 'Sell'),
                        selectedColor: neonFuchsia.withOpacity(0.3),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: quantity,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
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
                        backgroundColor: side == 'Buy'
                            ? neonIndigo
                            : neonFuchsia,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$side order for ${quantity.text} ${stock.symbol} scheduled.',
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.black87,
                          ),
                        );
                      },
                      child: Text('$side ${stock.symbol}'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _buildHome(),
      _buildTransfer(),
      _buildWealth(),
      _buildAssistant(),
    ];

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: tabs[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
              backgroundColor: Colors.white.withOpacity(0.05),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: neonIndigo,
              unselectedItemColor: Colors.white60,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Transfer'),
                BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Wealth'),
                BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: 'AI'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHome() {
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
                  Text('Good afternoon, Geir',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 6),
                  Text('Here is your liquidity snapshot',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white70,
                      )),
                ],
              ),
              const CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white12,
                child: Icon(Icons.person),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Liquidity',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white70,
                    )),
                const SizedBox(height: 8),
                Text('4.250.000 ISK',
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    )),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _trendChip('+12% vs last month', Colors.greenAccent),
                    const SizedBox(width: 12),
                    _trendChip('AI guard active', Colors.cyanAccent),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _QuickAction(
                      label: 'Top Up',
                      icon: Icons.add_circle,
                      onTap: () => _showSnack('Top-up workflow coming soon'),
                    ),
                    _QuickAction(
                      label: 'Transfer',
                      icon: Icons.sync_alt,
                      onTap: () => setState(() => _selectedIndex = 1),
                    ),
                    _QuickAction(
                      label: 'Scan',
                      icon: Icons.qr_code_scanner,
                      onTap: () => _showSnack('Scan and pay activated'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GlassContainer(
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Icon(Icons.smart_toy, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI Assistant',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(
                        'Your savings grew 12% last quarter. Ready to divert 200.000 ISK to the wealth sleeve?',
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => _selectedIndex = 3),
                  icon: const Icon(Icons.navigate_next),
                  color: Colors.white70,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Cards',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _cards.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final card = _cards[index];
                return _BankCardWidget(card: card);
              },
            ),
          ),
          const SizedBox(height: 24),
          Text('Accounts',
              style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ..._accounts.map((account) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(account.name,
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          Text('${_formatISK(account.balance)} ISK',
                              style: GoogleFonts.inter(
                                  color: Colors.white70, fontSize: 14)),
                        ],
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

  Widget _buildTransfer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Move Money',
              style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          GlassContainer(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _transferDropdown(
                  label: 'From account',
                  value: _fromAccount,
                  onChanged: (value) =>
                      setState(() => _fromAccount = value ?? _fromAccount),
                ),
                const SizedBox(height: 16),
                _transferDropdown(
                  label: 'To account',
                  value: _toAccount,
                  onChanged: (value) =>
                      setState(() => _toAccount = value ?? _toAccount),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount (ISK)',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _confirmTransfer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _processingTransfer
                          ? Colors.white24
                          : neonIndigo,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: _processingTransfer
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2.5),
                          )
                        : Text('Confirm Transfer',
                            style: GoogleFonts.inter(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<bool>(
                  valueListenable: _showSuccess,
                  builder: (_, visible, __) => AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: visible ? 1 : 0,
                    child: visible
                        ? GlassContainer(
                            color: Colors.greenAccent.withOpacity(0.1),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: Colors.greenAccent),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Success! ${_formatISK(int.tryParse(_amountController.text) ?? 0)} ISK moved from $_fromAccount to $_toAccount.',
                                    style: GoogleFonts.inter(),
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWealth() {
    final totalAssets = 18750000.0;
    final allocations = [
      _Allocation(label: 'Property', value: 0.42, color: neonIndigo.withOpacity(0.9)),
      _Allocation(label: 'Stocks', value: 0.28, color: neonFuchsia.withOpacity(0.9)),
      _Allocation(label: 'Crypto', value: 0.12, color: Colors.tealAccent),
      _Allocation(label: 'Cash', value: 0.18, color: Colors.white70),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Wealth & Trading',
              style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Net Worth', style: GoogleFonts.inter(color: Colors.white70)),
                const SizedBox(height: 6),
                Text('${_formatISK(totalAssets.toInt())} ISK',
                    style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('Assets 19.8M · Liabilities 1.1M',
                    style: GoogleFonts.inter(color: Colors.white60)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GlassContainer(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 50,
                      sections: allocations
                          .map(
                            (allocation) => PieChartSectionData(
                              color: allocation.color,
                              value: allocation.value * 100,
                              radius: 70,
                              title: '${(allocation.value * 100).round()}%',
                              titleStyle: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: allocations
                      .map((alloc) => Chip(
                            backgroundColor: Colors.white.withOpacity(0.08),
                            label: Text('${alloc.label} ${(alloc.value * 100).round()}%'),
                          ))
                      .toList(),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Markets',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        )),
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white54,
                      selectedColor: Colors.white,
                      fillColor: neonIndigo.withOpacity(0.3),
                      isSelected: _markets.keys
                          .map((market) => market == _selectedMarket)
                          .toList(),
                      onPressed: (index) => setState(
                        () => _selectedMarket = _markets.keys.elementAt(index),
                      ),
                      children: _markets.keys
                          .map((market) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(market),
                              ))
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._markets[_selectedMarket]!
                    .map(
                      (stock) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () => _openStockSheet(stock),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white12,
                          child: Text(stock.symbol.substring(0, 2).toUpperCase()),
                        ),
                        title: Text(stock.symbol,
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('ISK ${stock.price.toStringAsFixed(1)}'),
                        trailing: Text(
                          '${stock.change >= 0 ? '+' : ''}${stock.change.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: stock.change >= 0
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAssistant() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isUser = message.sender == ChatSender.user;
              return Align(
                alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
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
                        Text(message.text,
                            style: const TextStyle(fontSize: 15, height: 1.4)),
                        const SizedBox(height: 6),
                        Text(message.timestamp,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white54)),
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
                  decoration: InputDecoration(
                    hintText: 'Ask the AI to set financial goals...',
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
                child: const Icon(Icons.send_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _trendChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          )),
    );
  }

  DropdownButtonFormField<String> _transferDropdown({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: _accounts
          .map(
            (account) => DropdownMenuItem(
              value: account.name,
              child: Text('${account.name} (${_formatISK(account.balance)} ISK)'),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  String _formatISK(int value) {
    return value.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        );
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
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                (color ?? Colors.white).withOpacity(0.08),
                (color ?? Colors.white).withOpacity(0.02),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _QuickAction extends StatefulWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_QuickAction> createState() => _QuickActionState();
}

class _QuickActionState extends State<_QuickAction> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: _hovered ? Colors.white.withOpacity(0.18) : Colors.white12,
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            children: [
              Icon(widget.icon, size: 28, color: Colors.white),
              const SizedBox(height: 8),
              Text(widget.label,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BankCardWidget extends StatelessWidget {
  const _BankCardWidget({required this.card});

  final _BankCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        gradient: card.gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(card.label,
              style: const TextStyle(fontSize: 16, color: Colors.white70)),
          const Spacer(),
          Text('${card.balance ~/ 1000 / 10} M ISK',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(card.number,
              style: const TextStyle(letterSpacing: 2, fontSize: 14)),
          const SizedBox(height: 10),
          Text(card.holder,
              style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _BankCard {
  const _BankCard({
    required this.label,
    required this.holder,
    required this.number,
    required this.balance,
    required this.gradient,
  });

  final String label;
  final String holder;
  final String number;
  final double balance;
  final Gradient gradient;
}

class _Account {
  const _Account({required this.name, required this.balance});
  final String name;
  final int balance;
}

class _Allocation {
  const _Allocation({required this.label, required this.value, required this.color});
  final String label;
  final double value;
  final Color color;
}

class _Stock {
  const _Stock({required this.symbol, required this.change, required this.price});
  final String symbol;
  final double change;
  final double price;
}

enum ChatSender { user, ai }

class _ChatMessage {
  _ChatMessage({required this.sender, required this.text, required this.timestamp});
  final ChatSender sender;
  final String text;
  final String timestamp;
}
