import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../widgets/glass_card.dart';

class LoyaltyScreen extends StatelessWidget {
  final AppState _appState = AppState();

  LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        const Text(
          'Loyalty Programs',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Track all your rewards in one place',
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 16),
        ),
        const SizedBox(height: 24),
        ..._appState.loyaltyPrograms.map(_buildLoyaltyCard),
      ],
    );
  }

  Widget _buildLoyaltyCard(LoyaltyProgram program) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: program.color.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(program.icon, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.brand,
                      style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${program.tier} Member',
                      style: TextStyle(color: program.color, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    program.points.toString().replaceAllMapped(
                      RegExp(r'(\d)(?=(\d{3})+(?!\d))'), 
                      (match) => '${match[1]}.',
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'points',
                    style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: (program.points / 50000).clamp(0, 1),
              minHeight: 6,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(program.color),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0',
                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11),
              ),
              Text(
                'Next tier: 50.000',
                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}