import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/admin_login_dialog.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.warmIvory,
      body: Stack(
        children: [
          // Ambient background soft glows for frosted glass depth (matching web Next.js admin page)
          Positioned(
            top: 100,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.iceBlue.withValues(alpha: 0.35),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -60,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.warmSand.withValues(alpha: 0.8),
              ),
            ),
          ),

          // Main Centered Floating Card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AdminLoginCard(isDialog: false),
                  const SizedBox(height: 20),
                  Text(
                    'منصة Axion Digital • جلسة مشفرة عبر Supabase Auth SSL',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mochaBrown.withValues(alpha: 0.6),
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
