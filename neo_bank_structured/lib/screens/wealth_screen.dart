import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/donut_chart.dart';
import '../widgets/mini_chart.dart';

class WealthScreen extends StatefulWidget {
  final AppState appState;

  const WealthScreen({super.key, required this.appState});

  @override
  State<WealthScreen> createState() => _WealthScreenState();
}

class _WealthScreenState extends State<WealthScreen> {
  String _wealthView = 'mine';
  String? _activeSlice;
  String _marketTab = 'iceland';

  @override
  Widget build(BuildContext context) {
    final isFamily = _wealthView == 'family';
    final displayAssets = isFamily ? widget.appState.familyAssets : widget.appState.totalAssets;
    final displayLiabilities = isFamily ? widget.appState.familyLiabilities : widget.appState.totalLiabilities;
    final displayNetWorth = isFamily ? widget.appState.familyNetWorth : widget.appState.netWorth;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        const Text('Wealth', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        _buildViewToggle(),
        const SizedBox(height: 20),
        if (isFamily) ..._buildFamilyMembers(),
        _buildNetWorthCard(displayNetWorth, displayAssets, displayLiabilities, isFamily),
        const SizedBox(height: 20),
        if (!isFamily) ...[
          _buildSectionTitle('Asset Allocation'),
          const SizedBox(height: 12),
          _buildAssetAllocationCard(),
          const SizedBox(height: 12),
          if (_activeSlice != null && _activeSlice != 'property') _buildSliceDetail(),
          if (_activeSlice == 'property') ..._buildPropertyDetails(),
          const SizedBox(height: 20),
          _buildSectionTitle('Markets'),
          const SizedBox(height: 12),
          _buildMarketTabs(),
          const SizedBox(height: 12),
          ..._buildMarketList(),
        ],
      ],
    );
  }

  Widget _buildViewToggle() {
    return Row(
      children: ['mine', 'family'].map((v) {
        final isActive = _wealthView == v;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() {
              _wealthView = v;
              _activeSlice = null;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: EdgeInsets.only(right: v == 'mine' ? 4 : 0, left: v == 'family' ? 4 : 0),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: isActive ? AppTheme.primaryGradient : null,
                border: isActive ? null : Border.all(color: Colors.white.withOpacity(0.15)),
                color: isActive ? null : Colors.white.withOpacity(0.05),
              ),
              child: Center(
                child: Text(
                  v == 'mine' ? 'My Wealth' : 'Family',
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildFamilyMembers() {
    return [
      ...widget.appState.familyMembers.map((m) => GlassCard(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Text(m.avatar, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(m.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                  Text(m.relation, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(AppTheme.formatISK(m.netWorth), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                Text('net worth', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11)),
              ],
            ),
          ],
        ),
      )),
      const SizedBox(height: 12),
    ];
  }

  Widget _buildNetWorthCard(int netWorth, int assets, int liabilities, bool isFamily) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${isFamily ? "Family " : ""}Net Worth', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16)),
          const SizedBox(height: 4),
          Text(AppTheme.formatISK(netWorth), style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Assets', style: TextStyle(color: AppTheme.green, fontSize: 12)),
                  Text(AppTheme.formatISK(assets), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Liabilities', style: TextStyle(color: AppTheme.red, fontSize: 12)),
                  Text(AppTheme.formatISK(liabilities), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1),
    );
  }

  Widget _buildAssetAllocationCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          DonutChartWidget(
            data: widget.appState.assetBreakdown,
            size: 160,
            activeSlice: _activeSlice,
            onSliceTap: (key) => setState(() => _activeSlice = _activeSlice == key ? null : key),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: widget.appState.assetBreakdown.entries.map((entry) {
                final isActive = _activeSlice == entry.key;
                return GestureDetector(
                  onTap: () => setState(() => _activeSlice = _activeSlice == entry.key ? null : entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    margin: const EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isActive ? entry.value.color.withOpacity(0.2) : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: entry.value.color,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(entry.value.label, style: const TextStyle(color: Colors.white, fontSize: 13))),
                        Text(AppTheme.formatISK(entry.value.value), style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12)),
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

  Widget _buildSliceDetail() {
    if (_activeSlice == null) return const SizedBox.shrink();
    final asset = widget.appState.assetBreakdown[_activeSlice!]!;
    
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(color: asset.color, borderRadius: BorderRadius.circular(3)),
              ),
              const SizedBox(width: 8),
              Text(asset.label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Text('Total Value: ${AppTheme.formatISK(asset.value)}', style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 8),
          Text('${((asset.value / widget.appState.totalAssets) * 100).toStringAsFixed(1)}% of total assets', 
               style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
        ],
      ),
    );
  }

  List<Widget> _buildPropertyDetails() {
    return [
      GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(color: AppTheme.indigo, borderRadius: BorderRadius.circular(3)),
                ),
                SizedBox(width: 8),
                Text('Property Portfolio', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 16),
            ...widget.appState.properties.map((property) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(property.name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(property.type, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Value', style: TextStyle(color: AppTheme.green, fontSize: 11)),
                          Text(AppTheme.formatISK(property.value), style: const TextStyle(color: Colors.white, fontSize: 13)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Loan', style: TextStyle(color: AppTheme.red, fontSize: 11)),
                          Text(AppTheme.formatISK(property.loan), style: const TextStyle(color: Colors.white, fontSize: 13)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Equity', style: TextStyle(color: AppTheme.cyan, fontSize: 11)),
                          Text(AppTheme.formatISK(property.equity), style: const TextStyle(color: Colors.white, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: property.equity / property.value,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation(AppTheme.green),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    ];
  }

  Widget _buildMarketTabs() {
    final tabs = ['iceland', 'global', 'funds'];
    return Row(
      children: tabs.map((tab) {
        final isActive = _marketTab == tab;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _marketTab = tab),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.indigo.withOpacity(0.2) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: isActive ? Border.all(color: AppTheme.indigo.withOpacity(0.3)) : null,
              ),
              child: Center(
                child: Text(
                  tab.toUpperCase(),
                  style: TextStyle(
                    color: isActive ? AppTheme.indigo : Colors.white.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildMarketList() {
    final stocks = widget.appState.markets[_marketTab] ?? [];
    return stocks.map((stock) => GlassCard(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      onTap: () => _showStockDetail(stock),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stock.name, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(stock.ticker, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          MiniChartWidget(
            data: stock.chart,
            color: stock.change >= 0 ? AppTheme.green : AppTheme.red,
            width: 60,
            height: 30,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(AppTheme.formatISK(stock.price), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              Text(
                '${stock.change >= 0 ? '+' : ''}${stock.change.toStringAsFixed(1)}%',
                style: TextStyle(color: stock.change >= 0 ? AppTheme.green : AppTheme.red, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    )).toList();
  }

  void _showStockDetail(Stock stock) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stock.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      Text(stock.ticker, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14)),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(AppTheme.formatISK(stock.price), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 12),
                  Text(
                    '${stock.change >= 0 ? '+' : ''}${stock.change.toStringAsFixed(1)}%',
                    style: TextStyle(color: stock.change >= 0 ? AppTheme.green : AppTheme.red, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Buy order placed!'), backgroundColor: AppTheme.green),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Buy', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Sell order placed!'), backgroundColor: AppTheme.red),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Sell', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}