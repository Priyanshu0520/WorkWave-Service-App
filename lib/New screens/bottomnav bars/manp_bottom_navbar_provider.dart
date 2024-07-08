import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../new utils/colors.dart';
import '../Home/Manpower_Home/manp_home.dart';
import '../My projects/Manpower My project/manp_activity_myproject.dart';
import '../Profile/Manpower_profile/manp_profile.dart';


class ManBottomNavBarProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
    
  }
}
 
class ManNavTab extends StatefulWidget {
  const ManNavTab({super.key});

  @override
  State<ManNavTab> createState() => _ManNavTabState();
}

class _ManNavTabState extends State<ManNavTab>  {
  @override
  //bool get wantKeepAlive => true;
   @override
  void initState() {
    super.initState();
  Provider.of<ManBottomNavBarProvider>(context, listen: false).selectedIndex = 0;
  }
  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return  Scaffold(
      body: Consumer<ManBottomNavBarProvider>(
        builder: (context, bottomNavBarProvider, child) {
          return _getScreen(bottomNavBarProvider.selectedIndex);
        },
      ),
      bottomNavigationBar: Consumer<ManBottomNavBarProvider>(
        builder: (context, bottomNavBarProvider, child) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work),
                label: 'My Activity',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Accounts',
              ),
            ],
            currentIndex: bottomNavBarProvider.selectedIndex,
            unselectedItemColor: AppColors.blackShadow,
            iconSize: 25,
            showUnselectedLabels: true,
            selectedItemColor: AppColors.black,
            onTap: (index) {
              bottomNavBarProvider.selectedIndex = index;
            },
          );
        },
      ),
    );
  }

   Widget _getScreen(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return ManPowerHomePage();
      case 1:
        return ManMyProjects();
      case 2:
        return ManProfile();
      default:
        return ManPowerHomePage();
    }
  }

}

