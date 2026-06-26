import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9FAFB),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Contact
          Row(
            children: [
              Icon(Icons.local_laundry_service,
                  color: AppColors.primary, size: 32),
              const SizedBox(width: 8),
              const Text(
                'GREEN WASH CO.',
                style: TextStyle(
                  color: AppColors.logoPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Premium laundry and dry cleaning services delivered to your door.',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Icon(Icons.phone, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text('+91 98765 43210',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.email, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text('hello@greenwash.co',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 40),

          // Links Columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _FooterColumn(
                  title: 'Company',
                  links: const ['About Us', 'Careers', 'Contact'],
                ),
              ),
              Expanded(
                child: _FooterColumn(
                  title: 'Services',
                  links: const ['Wash & Fold', 'Dry Clean', 'Ironing'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Divider & Copyright
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Â© 2026 GREEN WASH CO.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              Row(
                children: [
                  Icon(Icons.facebook, color: Colors.grey.shade400, size: 20),
                  const SizedBox(width: 12),
                  Icon(Icons.camera_alt, color: Colors.grey.shade400, size: 20),
                  const SizedBox(width: 12),
                  Icon(Icons.link, color: Colors.grey.shade400, size: 20),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;

  const _FooterColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 16),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                link,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                ),
              ),
            )),
      ],
    );
  }
}
