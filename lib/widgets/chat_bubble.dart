import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime time;

  const ChatBubble({super.key, required this.text, required this.isUser, required this.time});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color userBg = isDark ? const Color(0xFF00C27A) : const Color(0xFF25D366);
    final Color userText = Colors.white;

    final Color botBg = isDark ? const Color(0xFF142235) : Colors.white;
    final Color botText = isDark ? const Color(0xFFE6EEF6) : const Color(0xFF0D1B2A);

    final bg = isUser ? userBg : botBg;
    final textColor = isUser ? userText : botText;

    final radius = BorderRadius.only(
      topLeft: const Radius.circular(18),
      topRight: const Radius.circular(18),
      bottomLeft: Radius.circular(isUser ? 18 : 6),
      bottomRight: Radius.circular(isUser ? 6 : 18),
    );

    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: radius,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, 3))],
          ),
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              SelectableText(
                text,
                style: TextStyle(fontSize: 16, color: textColor, height: 1.3),
              ),
              const SizedBox(height: 6),
              Text(
                _formatTime(time),
                style: TextStyle(fontSize: 12, color: textColor.withAlpha((0.75 * 255).round())),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
