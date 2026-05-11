import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/network/api_client.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends ConsumerStatefulWidget {
  const ContactUsPage({super.key});

  @override
  ConsumerState<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends ConsumerState<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;

  Future<void> _sendContactRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    try {
      final client = ref.read(apiClientProvider);
      final data = await client.post('/app/support/contact', data: {
        'type': 'Contact',
        'subject': _subjectController.text,
        'message': _messageController.text,
      }, requiresAuth: true);

      if (mounted) {
        if (data['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Message sent successfully!'),
              backgroundColor: const Color(0xFF06B6D4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            ),
          );
          _subjectController.clear();
          _messageController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Failed to send message'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Error sending message'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Contact Us',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            color: Color(0xFF1E293B),
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFF00ACC1).withOpacity(0.1),
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ContactInfoTile(
                icon: Icons.phone_android_rounded,
                title: 'Phone',
                content: '+91 8853-3893-95',
                onTap: () => _launchURL('tel:+918853389395'),
              ),
              const SizedBox(height: 16),
              _ContactInfoTile(
                icon: Icons.email_outlined,
                title: 'Email',
                content: 'difwaservices@gmail.com',
                onTap: () => _launchURL('mailto:difwaservices@gmail.com'),
              ),
              const SizedBox(height: 16),
              _ContactInfoTile(
                icon: Icons.location_on_outlined,
                title: 'Address',
                content: '4/37 Vibhav Khand, Lucknow, India',
                onTap: () => _launchURL('https://maps.apple.com/?address=4/37,Vibhav+Khand,Lucknow,India'),
              ),
              const SizedBox(height: 16),
              _ContactInfoTile(
                icon: Icons.public_rounded,
                title: 'Website',
                content: 'www.difwa.com',
                onTap: () => _launchURL('https://www.difwa.com'),
              ),
              const SizedBox(height: 32),
              const Text('Send us a message', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPremiumInput(
                      child: TextFormField(
                        controller: _subjectController,
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                        decoration: const InputDecoration(
                          labelText: 'Subject',
                          labelStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.subject_rounded, color: Color(0xFF00ACC1)),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        validator: (v) => v?.isEmpty == true ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPremiumInput(
                      child: TextFormField(
                        controller: _messageController,
                        maxLines: 4,
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                        decoration: const InputDecoration(
                          labelText: 'Message',
                          labelStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(Icons.message_rounded, color: Color(0xFF00ACC1)),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        validator: (v) => v?.isEmpty == true ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSending ? null : _sendContactRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isSending ? const CircularProgressIndicator(color: Colors.white) : const Text('Send Message', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPremiumInput({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00ACC1).withOpacity(0.2),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ContactInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final VoidCallback onTap;

  const _ContactInfoTile({required this.icon, required this.title, required this.content, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF00ACC1).withOpacity(0.2),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(content, style: const TextStyle(color: Colors.black, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 14),
          ],
        ),
      ),
    );
  }
}
