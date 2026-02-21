import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class TransferScreen extends StatefulWidget {
  final AppState appState;
  final VoidCallback onTransferComplete;

  const TransferScreen({super.key, required this.appState, required this.onTransferComplete});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  late String _fromId;
  late String _toId;
  String _amount = '';
  String _state = 'idle'; // idle, loading, success

  @override
  void initState() {
    super.initState();
    _fromId = widget.appState.accounts[0].id;
    _toId = widget.appState.accounts[1].id;
  }

  void _swapAccounts() {
    setState(() {
      final temp = _fromId;
      _fromId = _toId;
      _toId = temp;
    });
  }

  void _handleTransfer() {
    final raw = _amount.replaceAll('.', '');
    final amt = int.tryParse(raw) ?? 0;
    if (amt <= 0 || _fromId == _toId) return;

    final from = widget.appState.accounts.firstWhere((a) => a.id == _fromId);
    if (from.balance < amt) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Insufficient funds'),
          backgroundColor: AppTheme.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _state = 'loading');
    Future.delayed(const Duration(milliseconds: 1500), () {
      widget.appState.transferMoney(_fromId, _toId, amt);
      widget.onTransferComplete();
      setState(() => _state = 'success');
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _state = 'idle';
            _amount = '';
          });
        }
      });
    });
  }

  String _formatInput(String value) {
    final raw = value.replaceAll(RegExp(r'\D'), '');
    if (raw.isEmpty) return '';
    final num = int.parse(raw);
    return num.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
                  ),
                  const Text('Transfer', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 24),
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildDropdown('From', _fromId, (v) => setState(() => _fromId = v!)),
                    const SizedBox(height: 12),
                    Center(
                      child: GestureDetector(
                        onTap: _swapAccounts,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.indigo.withOpacity(0.2),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: const Icon(Icons.swap_vert, color: AppTheme.indigo, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildDropdown('To', _toId, (v) => setState(() => _toId = v!)),
                    const SizedBox(height: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Amount (ISK)', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16)),
                        const SizedBox(height: 8),
                        TextField(
                          onChanged: (v) => setState(() => _amount = _formatInput(v)),
                          controller: TextEditingController(text: _amount)
                            ..selection = TextSelection.collapsed(offset: _amount.length),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(color: AppTheme.indigo),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: ElevatedButton(
                          onPressed: _state == 'idle' ? _handleTransfer : null,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: _state == 'success'
                                  ? const LinearGradient(colors: [AppTheme.green, Color(0xFF059669)])
                                  : AppTheme.primaryGradient,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: _state == 'loading'
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : _state == 'success'
                                      ? const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.check_circle, color: Colors.white, size: 20),
                                            SizedBox(width: 8),
                                            Text('Transfer Complete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                          ],
                                        )
                                      : const Text('Transfer Money', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              dropdownColor: const Color(0xFF1a1a1a),
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.white.withOpacity(0.5)),
              items: widget.appState.accounts.map((account) {
                return DropdownMenuItem<String>(
                  value: account.id,
                  child: Row(
                    children: [
                      Text(account.icon, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              account.name,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              AppTheme.formatISK(account.balance),
                              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}