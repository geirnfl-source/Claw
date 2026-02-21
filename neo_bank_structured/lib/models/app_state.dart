import 'package:flutter/material.dart';

class BankAccount {
  final String id;
  final String name;
  int balance;
  final String icon;
  final String type;

  BankAccount({
    required this.id,
    required this.name,
    required this.balance,
    required this.icon,
    required this.type,
  });
}

class BankCard {
  final String type;
  final String last4;
  final String holder;
  final List<Color> gradientColors;

  const BankCard({
    required this.type,
    required this.last4,
    required this.holder,
    required this.gradientColors,
  });
}

class LoyaltyProgram {
  final String brand;
  final int points;
  final String tier;
  final String icon;
  final Color color;

  const LoyaltyProgram({
    required this.brand,
    required this.points,
    required this.tier,
    required this.icon,
    required this.color,
  });
}

class Stock {
  final String name;
  final String ticker;
  final int price;
  final double change;
  final List<double> chart;

  const Stock({
    required this.name,
    required this.ticker,
    required this.price,
    required this.change,
    required this.chart,
  });
}

class PropertyItem {
  final String name;
  final String type;
  final int value;
  final int loan;
  final int equity;
  final String rate;
  final int monthlyPayment;

  const PropertyItem({
    required this.name,
    required this.type,
    required this.value,
    required this.loan,
    required this.equity,
    required this.rate,
    required this.monthlyPayment,
  });
}

class AssetCategory {
  final String label;
  final int value;
  final Color color;

  const AssetCategory({
    required this.label,
    required this.value,
    required this.color,
  });
}

class FamilyMember {
  final String name;
  final String relation;
  final String avatar;
  final int netWorth;
  final int assets;
  final int liabilities;

  const FamilyMember({
    required this.name,
    required this.relation,
    required this.avatar,
    required this.netWorth,
    required this.assets,
    required this.liabilities,
  });
}

class ChatMessage {
  final String role;
  final String text;

  const ChatMessage({required this.role, required this.text});
}

class AppState extends ChangeNotifier {
  final List<BankAccount> accounts = [
    BankAccount(id: 'debit', name: 'Debit Account', balance: 4250000, icon: '💳', type: 'debit'),
    BankAccount(id: 'savings', name: 'Savings Account', balance: 12750000, icon: '💰', type: 'savings'),
    BankAccount(id: 'household', name: 'Household Account', balance: 1890000, icon: '🏠', type: 'shared'),
  ];

  final List<BankCard> cards = const [
    BankCard(
      type: 'Debit',
      last4: '4521',
      holder: 'Ólafur Björnsson',
      gradientColors: [Color(0xFF6366f1), Color(0xFF3b82f6)],
    ),
    BankCard(
      type: 'Platinum',
      last4: '8834',
      holder: 'Ólafur Björnsson',
      gradientColors: [Color(0xFF8b5cf6), Color(0xFFd946ef)],
    ),
    BankCard(
      type: 'Business',
      last4: '2210',
      holder: 'Ólafur Björnsson',
      gradientColors: [Color(0xFF10b981), Color(0xFF22d3ee)],
    ),
  ];

  final List<LoyaltyProgram> loyaltyPrograms = const [
    LoyaltyProgram(
      brand: 'Hagkaup',
      points: 12450,
      tier: 'Gold',
      icon: '🛒',
      color: Color(0xFFf59e0b),
    ),
    LoyaltyProgram(
      brand: 'Costco Iceland',
      points: 8200,
      tier: 'Silver',
      icon: '🏪',
      color: Color(0xFF6b7280),
    ),
    LoyaltyProgram(
      brand: 'Icelandair Saga',
      points: 45200,
      tier: 'Platinum',
      icon: '✈️',
      color: Color(0xFF3b82f6),
    ),
    LoyaltyProgram(
      brand: 'N1 Fuel',
      points: 3100,
      tier: 'Bronze',
      icon: '⛽',
      color: Color(0xFFef4444),
    ),
  ];

  final Map<String, List<Stock>> markets = const {
    'iceland': [
      Stock(
        name: 'Marel',
        ticker: 'MAREL',
        price: 14250,
        change: 2.3,
        chart: [120, 125, 130, 128, 135, 142, 145],
      ),
      Stock(
        name: 'Arion Banki',
        ticker: 'ARION',
        price: 128500,
        change: -0.8,
        chart: [1300, 1285, 1290, 1275, 1285, 1280, 1285],
      ),
      Stock(
        name: 'Eimskip',
        ticker: 'EIM',
        price: 46800,
        change: 1.1,
        chart: [450, 455, 460, 465, 462, 468, 468],
      ),
      Stock(
        name: 'Íslandsbanki',
        ticker: 'ISB',
        price: 89200,
        change: 0.5,
        chart: [870, 880, 885, 890, 895, 892, 892],
      ),
    ],
    'global': [
      Stock(
        name: 'Apple',
        ticker: 'AAPL',
        price: 2845000,
        change: 1.5,
        chart: [27000, 27500, 28000, 28200, 28450, 28450, 28450],
      ),
      Stock(
        name: 'Tesla',
        ticker: 'TSLA',
        price: 3420000,
        change: -2.1,
        chart: [35000, 34800, 34200, 33900, 34200, 34200, 34200],
      ),
      Stock(
        name: 'Nvidia',
        ticker: 'NVDA',
        price: 8950000,
        change: 3.2,
        chart: [85000, 86000, 87500, 89000, 89500, 89500, 89500],
      ),
      Stock(
        name: 'Microsoft',
        ticker: 'MSFT',
        price: 5620000,
        change: 0.9,
        chart: [55000, 55500, 56000, 56100, 56200, 56200, 56200],
      ),
    ],
    'funds': [
      Stock(
        name: 'Landsbréf',
        ticker: 'LBF',
        price: 245000,
        change: 0.7,
        chart: [2400, 2410, 2420, 2430, 2450, 2450, 2450],
      ),
      Stock(
        name: 'Íslandssjóðir',
        ticker: 'ISS',
        price: 389000,
        change: 1.2,
        chart: [3800, 3820, 3850, 3880, 3890, 3890, 3890],
      ),
      Stock(
        name: 'Stefnir',
        ticker: 'STF',
        price: 167000,
        change: -0.3,
        chart: [1680, 1675, 1670, 1665, 1670, 1670, 1670],
      ),
    ],
  };

  final List<PropertyItem> properties = const [
    PropertyItem(
      name: 'Laugavegur 42, 101 Reykjavík',
      type: 'Primary Residence',
      value: 85000000,
      loan: 42000000,
      equity: 43000000,
      rate: '4.2%',
      monthlyPayment: 285000,
    ),
    PropertyItem(
      name: 'Akureyri Sumarhús',
      type: 'Summer House',
      value: 28000000,
      loan: 12000000,
      equity: 16000000,
      rate: '3.8%',
      monthlyPayment: 95000,
    ),
    PropertyItem(
      name: 'Kópavogur 15, Studio',
      type: 'Rental Property',
      value: 32000000,
      loan: 18000000,
      equity: 14000000,
      rate: '5.1%',
      monthlyPayment: 145000,
    ),
  ];

  final Map<String, AssetCategory> assetBreakdown = const {
    'property': AssetCategory(label: 'Property', value: 145000000, color: Color(0xFF6366f1)),
    'stocks': AssetCategory(label: 'Stocks', value: 18500000, color: Color(0xFFd946ef)),
    'crypto': AssetCategory(label: 'Crypto', value: 6200000, color: Color(0xFFf59e0b)),
    'cash': AssetCategory(label: 'Cash', value: 18890000, color: Color(0xFF22d3ee)),
    'funds': AssetCategory(label: 'Funds', value: 8400000, color: Color(0xFF10b981)),
  };

  final List<FamilyMember> familyMembers = const [
    FamilyMember(
      name: 'Ólafur',
      relation: 'You',
      avatar: '👨‍💼',
      netWorth: 98500000,
      assets: 145000000,
      liabilities: 46500000,
    ),
    FamilyMember(
      name: 'Sigríður',
      relation: 'Spouse',
      avatar: '👩‍💼',
      netWorth: 72000000,
      assets: 98000000,
      liabilities: 26000000,
    ),
    FamilyMember(
      name: 'Bjarki',
      relation: 'Son',
      avatar: '👦',
      netWorth: 4500000,
      assets: 5200000,
      liabilities: 700000,
    ),
    FamilyMember(
      name: 'Hekla',
      relation: 'Daughter',
      avatar: '👧',
      netWorth: 2800000,
      assets: 3200000,
      liabilities: 400000,
    ),
  ];

  final List<ChatMessage> chatHistory = [
    ChatMessage(
      role: 'assistant',
      text: 'Good afternoon! I see your liquidity grew 12% this quarter. Would you like to discuss your cabin fund allocation?',
    ),
    ChatMessage(
      role: 'user',
      text: 'Yes, how much should I allocate monthly?',
    ),
    ChatMessage(
      role: 'assistant',
      text: 'Based on your savings rate, I recommend 200.000 ISK monthly to reach your goal by November. This keeps your emergency fund intact.',
    ),
  ];

  // Wealth view toggle (true = personal, false = family)
  bool _personalWealthView = true;
  bool get personalWealthView => _personalWealthView;

  void toggleWealthView() {
    _personalWealthView = !_personalWealthView;
    notifyListeners();
  }

  // Computed values
  int get totalLiquidity => accounts.fold(0, (sum, a) => sum + a.balance);
  int get totalAssets => assetBreakdown.values.fold(0, (sum, a) => sum + a.value);
  int get totalLiabilities => properties.fold(0, (sum, p) => sum + p.loan);
  int get netWorth => totalAssets - totalLiabilities;

  int get familyNetWorth => familyMembers.fold(0, (sum, member) => sum + member.netWorth);
  int get familyAssets => familyMembers.fold(0, (sum, member) => sum + member.assets);
  int get familyLiabilities => familyMembers.fold(0, (sum, member) => sum + member.liabilities);

  // Transfer functionality
  void transferMoney(String fromAccountId, String toAccountId, int amount) {
    final fromAccount = accounts.firstWhere((a) => a.id == fromAccountId);
    final toAccount = accounts.firstWhere((a) => a.id == toAccountId);
    
    if (fromAccount.balance >= amount) {
      fromAccount.balance -= amount;
      toAccount.balance += amount;
      notifyListeners();
    }
  }

  // Chat functionality
  void addChatMessage(String role, String text) {
    chatHistory.add(ChatMessage(role: role, text: text));
    notifyListeners();
  }
}