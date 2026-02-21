import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _MenuItem(icon: Icons.settings_rounded, label: 'Settings', desc: 'Preferences & security options'),
      _MenuItem(icon: Icons.bar_chart_rounded, label: 'Reports', desc: 'Monthly & annual statements'),
      _MenuItem(icon: Icons.notifications_rounded, label: 'Notifications', desc: 'Alerts & messages'),
      _MenuItem(icon: Icons.lock_rounded, label: 'Security', desc: '2FA, biometrics, limits'),
      _MenuItem(icon: Icons.phone_android_rounded, label: 'Connected Apps', desc: 'Third-party integrations'),
      _MenuItem(icon: Icons.help_outline_rounded, label: 'Help & Support', desc: 'FAQ & contact options'),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        const Text('More', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
        const SizedBox(height: 24),
        ...items.map((item) => GlassCard(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${item.label} - Coming soon!'),
                backgroundColor: AppTheme.indigo,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.indigo.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: AppTheme.indigo, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(item.desc, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.3)),
            ],
          ),
        )),
        const SizedBox(height: 32),
        Center(
          child: Text('Neo Bank Iceland v2.1.0', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String desc;

  const _MenuItem({required this.icon, required this.label, required this.desc});
}