import 'dart:math';
import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../theme/app_theme.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [
    const ChatMessage(role: 'assistant', text: 'Góðan daginn, Ólafur! I\'m your AI financial advisor. How can I help you today?'),
    const ChatMessage(role: 'user', text: 'I want to set a savings goal for a new car.'),
    const ChatMessage(role: 'assistant', text: 'Great idea! Based on your spending patterns, I recommend saving 500.000 ISK monthly. This would get you a nice Tesla Model Y in about 18 months. Shall I set this up?'),
    const ChatMessage(role: 'user', text: 'Yes, let\'s do 500.000 ISK per month.'),
    const ChatMessage(role: 'assistant', text: 'Done! I\'ve set up a recurring transfer of 500.000 ISK from your debit account to a new "Tesla Fund" every 15th of the month. You\'ll reach your goal by December 2025. 🚗'),
  ];

  final _responses = [
    'Based on your portfolio, I\'d recommend diversifying into international index funds. You currently have 73% in Icelandic assets - consider adding some global exposure.',
    'I\'ve analyzed your spending: groceries average 185.000 ISK/month, which is 15% above the Reykjavík average. Want me to find some optimization tips?',
    'Your mortgage rate of 4.2% is competitive, but refinancing could save you ~45.000 ISK/month. I can connect you with Landsbankinn\'s mortgage specialist.',
    'Looking at your family\'s combined net worth trajectory, you\'re growing at 8.5% annually - that\'s excellent! Keep up the current investment strategy.',
    'Your property portfolio is strong. The Kópavogur studio rental is generating a 5.2% yield. Consider a second rental property in Hafnarfjörður?',
    'I notice your emergency fund covers about 3.2 months of expenses. Consider building it to 6 months - that\'s about 2.8 million ISK total.',
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(role: 'user', text: text));
    });
    _controller.clear();
    _scrollToBottom();

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _messages.add(ChatMessage(
            role: 'assistant',
            text: _responses[Random().nextInt(_responses.length)],
          ));
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [AppTheme.indigo, AppTheme.fuchsia]),
                ),
                child: const Center(child: Text('🤖', style: TextStyle(fontSize: 18))),
              ),
              const SizedBox(width: 12),
              const Text('AI Assistant', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              final isUser = msg.role == 'user';
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    gradient: isUser ? AppTheme.primaryGradient : null,
                    color: isUser ? null : Colors.white.withOpacity(0.08),
                  ),
                  child: Text(
                    msg.text,
                    style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _sendMessage(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Ask your AI advisor...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppTheme.indigo),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: AppTheme.primaryGradient,
                  ),
                  child: const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 22),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}