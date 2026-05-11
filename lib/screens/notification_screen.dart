import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.techWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.metallicBlack),
        title: Text(
          "Notifications",
          style: TextStyle(
            fontFamily: 'PPEditorialNew',
            fontWeight: FontWeight.w700,
            color: AppColors.metallicBlack,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _NotificationItem(
            title: "Project Updated",
            subtitle: "Scandinavian Room budget has been updated.",
            time: "2h ago",
            isNew: true,
          ),
          _NotificationItem(
            title: "AI Suggestion Ready",
            subtitle: "New design recommendation available.",
            time: "Yesterday",
            isNew: false,
          ),
          _NotificationItem(
            title: "Payment Success",
            subtitle: "Your transaction was completed.",
            time: "2 days ago",
            isNew: false,
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final bool isNew;

  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.metallicBlack.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isNew)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6, right: 10),
              decoration: const BoxDecoration(
                color: AppColors.coconutGreen,
                shape: BoxShape.circle,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'PPNeueMontrealMedium',
                    fontWeight: FontWeight.w700,
                    color: AppColors.metallicBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'PPNeueMontrealMedium',
                    fontSize: 12,
                    color: AppColors.zenGray,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.zenGray.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}