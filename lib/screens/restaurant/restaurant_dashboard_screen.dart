import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/food_listing_model.dart';

class RestaurantDashboardScreen extends StatefulWidget {
  const RestaurantDashboardScreen({Key? key}) : super(key: key);

  @override
  State<RestaurantDashboardScreen> createState() => _RestaurantDashboardScreenState();
}

class _RestaurantDashboardScreenState extends State<RestaurantDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const RestaurantHomePage(),
    const AddFoodPage(),
    const RestaurantOrdersPage(),
    const RestaurantProfilePage(),
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
            icon: Icon(Icons.add_circle),
            label: 'إضافة طعام',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'الطلبات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الملف الشخصي',
          ),
        ],
      ),
    );
  }
}

class RestaurantHomePage extends StatelessWidget {
  const RestaurantHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة المطعم'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: _StatisticCard(
                    title: 'الطعام المتاح',
                    value: '12',
                    icon: Icons.restaurant,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatisticCard(
                    title: 'الطلبات المعلقة',
                    value: '5',
                    icon: Icons.pending_actions,
                    color: AppColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatisticCard(
                    title: 'المستفيدين',
                    value: '45',
                    icon: Icons.people,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatisticCard(
                    title: 'الكمية الموزعة',
                    value: '120',
                    icon: Icons.local_shipping,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'الطعام الحالي',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (context, index) {
                return FoodListingCard();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FoodListingCard extends StatelessWidget {
  const FoodListingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.fastfood,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'طعام طازج',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'الكمية: 10 حصص',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'متاح الآن',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.success,
                        ),
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  child: Text('تعديل'),
                ),
                const PopupMenuItem(
                  child: Text('حذف'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({Key? key}) : super(key: key);

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _foodTypeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  FoodCategory _selectedCategory = FoodCategory.cooked;
  DateTime? _expiryTime;

  @override
  void dispose() {
    _foodTypeController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _selectExpiryTime() async {
    final picked = await showDateTimePicker(context);
    if (picked != null) {
      setState(() => _expiryTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة طعام جديد'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image Upload
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.image_outlined,
                    size: 50,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('رفع صورة'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Food Type
            TextField(
              controller: _foodTypeController,
              decoration: InputDecoration(
                labelText: 'نوع الطعام',
                prefixIcon: const Icon(Icons.fastfood),
              ),
            ),
            const SizedBox(height: 16),
            // Category
            DropdownButtonFormField<FoodCategory>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'الفئة',
                prefixIcon: const Icon(Icons.category),
              ),
              items: FoodCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value ?? FoodCategory.cooked);
              },
            ),
            const SizedBox(height: 16),
            // Description
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'وصف الطعام',
                prefixIcon: const Icon(Icons.description),
              ),
            ),
            const SizedBox(height: 16),
            // Quantity
            TextField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'الكمية (حصص)',
                prefixIcon: const Icon(Icons.numbers),
              ),
            ),
            const SizedBox(height: 16),
            // Expiry Time
            ListTile(
              title: const Text('وقت انتهاء الصلاحية'),
              subtitle: _expiryTime != null
                  ? Text(_expiryTime.toString())
                  : const Text('اختر الوقت'),
              trailing: const Icon(Icons.access_time),
              onTap: _selectExpiryTime,
            ),
            const SizedBox(height: 24),
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('إضافة الطعام'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantOrdersPage extends StatelessWidget {
  const RestaurantOrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلبات'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: const Text('طلب رقم #001'),
              subtitle: const Text('حالة: قيد الانتظار'),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text('قبول'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RestaurantProfilePage extends StatelessWidget {
  const RestaurantProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'اسم المطعم',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    'restaurant@example.com',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('تعديل البيانات'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('الإحصائيات'),
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
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatisticCard({
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
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: color,
                  ),
            ),
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

Future<DateTime?> showDateTimePicker(BuildContext context) async {
  final date = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365)),
  );

  if (date != null) {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      return DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    }
  }
  return null;
}
