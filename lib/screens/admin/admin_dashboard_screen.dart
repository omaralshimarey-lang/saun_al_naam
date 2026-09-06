import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminHomePage(),
    const VerificationPage(),
    const ReportsPage(),
    const AdminSettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified),
            label: 'التحقق',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'التقارير',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم - الإدارة'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Key Metrics
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _MetricCard(
                  title: 'إجمالي المستخدمين',
                  value: '1,245',
                  icon: Icons.people,
                  color: AppColors.primary,
                ),
                _MetricCard(
                  title: 'المطاعم المسجلة',
                  value: '87',
                  icon: Icons.restaurant,
                  color: AppColors.secondary,
                ),
                _MetricCard(
                  title: 'إجمالي الطلبات',
                  value: '3,456',
                  icon: Icons.receipt,
                  color: AppColors.info,
                ),
                _MetricCard(
                  title: 'الطعام الموزع (كج)',
                  value: '2,345',
                  icon: Icons.local_shipping,
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'النشاطات الأخيرة',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              itemBuilder: (context, index) {
                final activities = [
                  ('تسجيل حساب جديد', 'قبل 5 دقائق', Icons.person_add),
                  ('طلب جديد', 'قبل 15 دقيقة', Icons.shopping_bag),
                  ('مطعم موثق', 'قبل ساعة', Icons.verified),
                  ('تقييم جديد', 'قبل ساعتين', Icons.star),
                ];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      activities[index].$3,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(activities[index].$1),
                  subtitle: Text(activities[index].$2),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class VerificationPage extends StatelessWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التحقق من الحسابات'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        child: Icon(Icons.restaurant),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مطعم الشرقية',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Text('قيد الانتظار'),
                          ],
                        ),
                      ),
                      Chip(
                        label: const Text('جديد'),
                        backgroundColor: AppColors.warningLight,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('الموافقة'),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('رفض'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ReportsPage extends StatelessWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير والإحصائيات'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التقارير الشهرية',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سبتمبر 2026',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _ReportRow(
                      label: 'إجمالي الطلبات',
                      value: '456',
                      change: '+12%',
                    ),
                    _ReportRow(
                      label: 'الطعام الموزع (كج)',
                      value: '3,450',
                      change: '+18%',
                    ),
                    _ReportRow(
                      label: 'المستفيدين الجدد',
                      value: '234',
                      change: '+8%',
                    ),
                    _ReportRow(
                      label: 'متوسط التقييم',
                      value: '4.7/5',
                      change: '+0.2',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download),
              label: const Text('تنزيل التقرير'),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminSettingsPage extends StatelessWidget {
  const AdminSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.system_security_update),
            title: const Text('إدارة النظام'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.mail),
            title: const Text('إعدادات البريد الإلكتروني'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text('الحسابات المحظورة'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: AppColors.error),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  final String label;
  final String value;
  final String change;

  const _ReportRow({
    required this.label,
    required this.value,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  change,
                  style: const TextStyle(
                    color: AppColors.success,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
