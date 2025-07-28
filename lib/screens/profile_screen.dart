import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final currentUser = userService.currentUser;
    
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Matching app background
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ACC1), // App primary color
        title: const Text("Wasifu Wangu", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const ProfilePic(),
            const SizedBox(height: 20),
            
            // User Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUser?.name ?? "Jina la Mtumiaji",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00695C),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(Icons.email, currentUser?.email ?? "baruapepe@example.com"),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.phone, currentUser?.phone ?? "+255 000 000000"),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on, currentUser?.location ?? "Eneo lako"),
                ],
              ),
            ),
            const SizedBox(height: 30),
            
            // Menu Items
            ProfileMenu(
              text: "Akaunti Yangu",
              icon: "assets/icons/User Icon.svg",
              press: () => _showEditAccount(context),
            ),
            ProfileMenu(
              text: "Mabadiliko ya Hotspot",
              icon: "assets/icons/Location.svg",
              press: () => _showHotspotChanges(context),
            ),
            ProfileMenu(
              text: "Mipangilio",
              icon: "assets/icons/Settings.svg",
              press: () => _showSettings(context),
            ),
            ProfileMenu(
              text: "Msaada",
              icon: "assets/icons/Question mark.svg",
              press: () => _showHelp(context),
            ),
            ProfileMenu(
              text: "Toka",
              icon: "assets/icons/Log out.svg",
              press: () => _logout(context),
              isLogout: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF00ACC1)),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  void _showEditAccount(BuildContext context) {
    // Implement account edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Akaunti itafunguliwa hivi punde..."))
    );
  }

  void _showHotspotChanges(BuildContext context) {
    // Implement hotspot changes view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Inaonyesha mabadiliko ya Hotspot..."))
    );
  }

  void _showSettings(BuildContext context) {
    // Implement settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Mipangilio inafunguliwa..."))
    );
  }

  void _showHelp(BuildContext context) {
    // Implement help center
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kituo cha msaada kinafunguliwa..."))
    );
  }

  void _logout(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);
    userService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00ACC1).withOpacity(0.1),
            ),
            child: const Icon(
              Icons.person,
              size: 60,
              color: Color(0xFF00ACC1),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00ACC1),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: IconButton(
                icon: SvgPicture.string(cameraIcon),
                onPressed: () {},
                padding: EdgeInsets.zero,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.text,
    required this.icon,
    this.press,
    this.isLogout = false,
  });

  final String text, icon;
  final VoidCallback? press;
  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: SvgPicture.asset(
          icon,
          colorFilter: ColorFilter.mode(
            isLogout ? Colors.red : const Color(0xFF00ACC1),
            BlendMode.srcIn,
          ),
          width: 24,
        ),
        title: Text(
          text,
          style: TextStyle(
            color: isLogout ? Colors.red : const Color(0xFF00695C),
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: isLogout 
            ? null 
            : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: press,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

const cameraIcon = '''<svg width="20" height="16" viewBox="0 0 20 16" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M10 12.0152C8.49151 12.0152 7.26415 10.8137 7.26415 9.33902C7.26415 7.86342 8.49151 6.6619 10 6.6619C11.5085 6.6619 12.7358 7.86342 12.7358 9.33902C12.7358 10.8137 11.5085 12.0152 10 12.0152ZM10 5.55543C7.86698 5.55543 6.13208 7.25251 6.13208 9.33902C6.13208 11.4246 7.86698 13.1217 10 13.1217C12.133 13.1217 13.8679 11.4246 13.8679 9.33902C13.8679 7.25251 12.133 5.55543 10 5.55543ZM18.8679 13.3967C18.8679 14.2226 18.1811 14.8935 17.3368 14.8935H2.66321C1.81887 14.8935 1.13208 14.2226 1.13208 13.3967V5.42346C1.13208 4.59845 1.81887 3.92664 2.66321 3.92664H4.75C5.42453 3.92664 6.03396 3.50952 6.26604 2.88753L6.81321 1.41746C6.88113 1.23198 7.06415 1.10739 7.26604 1.10739H12.734C12.9358 1.10739 13.1189 1.23198 13.1877 1.41839L13.734 2.88845C13.966 3.50952 14.5755 3.92664 15.25 3.92664H17.3368C18.1811 3.92664 18.8679 4.59845 18.8679 5.42346V13.3967ZM17.3368 2.82016H15.25C15.0491 2.82016 14.867 2.69466 14.7972 2.50917L14.2519 1.04003C14.0217 0.418041 13.4113 0 12.734 0H7.26604C6.58868 0 5.9783 0.418041 5.74906 1.0391L5.20283 2.50825C5.13302 2.69466 4.95094 2.82016 4.75 2.82016H2.66321C1.19434 2.82016 0 3.98846 0 5.42346V13.3967C0 14.8326 1.19434 16 2.66321 16H17.3368C18.8057 16 20 14.8326 20 13.3967V5.42346C20 3.98846 18.8057 2.82016 17.3368 2.82016Z" fill="white"/>
</svg>''';