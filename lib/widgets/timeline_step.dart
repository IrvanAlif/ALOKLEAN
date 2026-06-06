import 'package:flutter/material.dart';

class TimelineStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool done;
  final bool current;
  final bool isLast;

  const TimelineStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.done,
    required this.isLast,
    this.current = false,
  });

  @override
  Widget build(BuildContext context) {
    final circleColor = done
        ? const Color(0xFF0B4FA8)
        : const Color(0xFFD9DEE7);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: circleColor,
                  shape: BoxShape.circle,
                  boxShadow: current
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFF0B4FA8,
                            ).withValues(alpha: 0.22),
                            blurRadius: 10,
                            spreadRadius: 3,
                          ),
                        ]
                      : null,
                ),
                child: done
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : const Center(
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: Color(0xFF6B7280),
                        ),
                      ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 48,
                  color: done
                      ? const Color(0xFF0B4FA8)
                      : const Color(0xFFE5EAF2),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: current || done
                          ? const Color(0xFF111827)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      height: 1.4,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
