import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          
        ),
        actions: [
          // Theme toggle button
          Obx(() => IconButton(
                icon: Icon(
                  controller.isDarkMode.value
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: Colors.white,
                ),
                onPressed: controller.toggleTheme,
              )),
          // Settings button
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () => Get.toNamed('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Header
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                  children: [
                    // Profile Picture
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Obx(() => CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.green,
                          backgroundImage: controller.currentUser.value.photoUrl != null
                              ? NetworkImage(controller.currentUser.value.photoUrl!)
                              : null,
                          child: controller.currentUser.value.photoUrl == null
                              ? Icon(Icons.person, size: 50, color: Colors.white)
                              : null,
                        )),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.green,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                            onPressed: controller.updateProfileImage,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // User Name
                    Obx(() => Text(
                      controller.currentUser.value.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    const SizedBox(height: 8),
                    // User Email
                    Obx(() => Text(
                      controller.currentUser.value.email,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )),

              const SizedBox(height: 24),
              // Quick Stats
              Row(
                children: [
                  _buildStatCard(
                    context,
                    'Total Orders',
                    '${controller.totalOrders}',
                    Icons.shopping_bag,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Active Orders',
                    '${controller.activeOrders}',
                    Icons.pending_actions,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Profile Actions
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildActionTile(
                    context,
                    'Personal Information',
                    Icons.person,
                    () => Get.toNamed('/personal-info'),
                  ),
                  _buildActionTile(
                    context,
                    'Shop Settings',
                    Icons.store,
                    () => Get.toNamed('/shop-settings'),
                  ),
                  _buildActionTile(
                    context,
                    'Notifications',
                    Icons.notifications,
                    () => Get.toNamed('/notifications'),
                  ),
                  _buildActionTile(
                    context,
                    'Security',
                    Icons.security,
                    () => Get.toNamed('/security'),
                  ),
                  _buildActionTile(
                    context,
                    'Help & Support',
                    Icons.help,
                    () => Get.toNamed('/support'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Logout Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: controller.logout,
                ),
              ),
            ],
          ),
        ),
      ),
            ]
          )
        )
      )
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 24,
                color: Colors.green, // Warna hijau untuk ikon
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.green, // Warna hijau untuk ikon
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).iconTheme.color,
      ),
      onTap: onTap,
    );
  }
}
