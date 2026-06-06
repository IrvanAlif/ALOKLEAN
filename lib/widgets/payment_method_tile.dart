import 'package:flutter/material.dart';

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const PaymentMethodTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final selected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? const Color(0xFF0B4FA8) : const Color(0xFFE3E7EE),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFDCEAFF),
              child: Icon(icon, color: const Color(0xFF0B4FA8)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            // Ganti Radio dengan custom icon
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFF0B4FA8)
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: selected
                  ? Container(
                      margin: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF0B4FA8),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
