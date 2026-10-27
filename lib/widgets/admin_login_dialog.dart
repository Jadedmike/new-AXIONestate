import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'glass_container.dart';

Future<void> showAdminLoginDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: AppColors.mochaBrown.withValues(alpha: 0.40),
    builder: (context) => const Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: AdminLoginCard(isDialog: true),
    ),
  );
}

class AdminLoginCard extends StatefulWidget {
  final bool isDialog;

  const AdminLoginCard({super.key, this.isDialog = false});

  @override
  State<AdminLoginCard> createState() => _AdminLoginCardState();
}

class _AdminLoginCardState extends State<AdminLoginCard> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'admin@axiondigital.com');
  final _passwordController = TextEditingController(text: '••••••••••••');
  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Simulate authentication check
      await Future.delayed(const Duration(milliseconds: 600));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.mochaBrown,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: const Row(
              children: [
                Icon(Icons.verified, color: AppColors.iceBlue, size: 20),
                SizedBox(width: 8),
                Text(
                  'تم التحقق من هوية المشرف بنجاح. جاري الدخول...',
                  style: TextStyle(color: AppColors.warmIvory, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );

        if (widget.isDialog) {
          Navigator.of(context).pop();
        }
        Navigator.of(context).pushNamed('/admin');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: GlassContainer(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          borderRadius: BorderRadius.circular(28),
          color: AppColors.warmIvory.withValues(alpha: 0.85),
          border: Border.all(
            color: AppColors.iceBlue.withValues(alpha: 0.45),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.mochaBrown.withValues(alpha: 0.16),
              blurRadius: 50,
              offset: const Offset(0, 20),
            ),
          ],
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Close button if Dialog
                if (widget.isDialog)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.warmSand.withValues(alpha: 0.5),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.close, size: 18),
                        color: AppColors.mochaBrown,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),

                // Brand & Badge
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Axion Digital',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mochaBrown,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.iceBlue.withValues(alpha: 0.20),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.iceBlue.withValues(alpha: 0.45),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shield_outlined, size: 15, color: AppColors.mochaBrown),
                            SizedBox(width: 6),
                            Text(
                              'بوابة الدخول الآمن للمشرف',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mochaBrown,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'تسجيل دخول المشرف',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mochaBrown,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'لوحة الإدارة المركزية لمنصة Axion Digital',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mochaBrown.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                if (_errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: AppColors.error, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Email Field
                Text(
                  'البريد الإلكتروني للمشرف',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mochaBrown.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 14, color: AppColors.mochaBrown),
                  decoration: InputDecoration(
                    hintText: 'admin@axiondigital.com',
                    prefixIcon: const Icon(Icons.mail_outline, size: 18, color: AppColors.mochaBrown),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: AppColors.warmIvory.withValues(alpha: 0.95),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'يرجى إدخال البريد الإلكتروني';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password Field
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'كلمة المرور',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mochaBrown.withValues(alpha: 0.8),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم إرسال رابط إعادة تعيين كلمة المرور إلى البريد المسجل.'),
                          ),
                        );
                      },
                      child: const Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mochaBrown,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  textDirection: TextDirection.ltr,
                  obscureText: _obscurePassword,
                  style: const TextStyle(fontSize: 14, color: AppColors.mochaBrown),
                  decoration: InputDecoration(
                    hintText: '••••••••••••',
                    prefixIcon: const Icon(Icons.lock_outline, size: 18, color: AppColors.mochaBrown),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        size: 18,
                        color: AppColors.mochaBrown.withValues(alpha: 0.6),
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: AppColors.warmIvory.withValues(alpha: 0.95),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'يرجى إدخال كلمة المرور';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                // "تذكرني" Remember Me Checkbox
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: AppColors.mochaBrown,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        onChanged: (val) => setState(() => _rememberMe = val ?? false),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _rememberMe = !_rememberMe),
                      child: Text(
                        'تذكرني على هذا الجهاز',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.mochaBrown.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Full-width Mocha Brown Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mochaBrown,
                    foregroundColor: AppColors.warmIvory,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 4,
                    shadowColor: AppColors.mochaBrown.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: AppColors.iceBlue.withValues(alpha: 0.3)),
                    ),
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.warmIvory,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'تسجيل الدخول',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                ),

                const SizedBox(height: 20),
                const Divider(color: Color(0x33A0BDDB), height: 1),
                const SizedBox(height: 16),

                // Return to website link
                Center(
                  child: InkWell(
                    onTap: () {
                      if (widget.isDialog) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushReplacementNamed('/');
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            size: 15,
                            color: AppColors.mochaBrown.withValues(alpha: 0.7),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'العودة إلى الموقع الرئيسي',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mochaBrown.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
