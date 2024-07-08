import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../new utils/colors.dart';
import '../Home/Employer_Home/emp_home.dart';
import '../My projects/Employer my project/emp_activity_myproject.dart';
import '../Profile/Employer_profile/emp_profilee.dart';
import '../Service_tab_screen/emp_services_screen.dart';


class EmpBottomNavBarProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
 
class EmpNavTab extends StatefulWidget {
  const EmpNavTab({super.key});

  @override
  State<EmpNavTab> createState() => _EmpNavTabState();
}

class _EmpNavTabState extends State<EmpNavTab> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Consumer<EmpBottomNavBarProvider>(
        builder: (context, bottomNavBarProvider, child) {
          return _getScreen(bottomNavBarProvider.selectedIndex);
        },
      ),
      bottomNavigationBar: Consumer<EmpBottomNavBarProvider>(
        builder: (context, bottomNavBarProvider, child) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              //  BottomNavigationBarItem(
              //   icon: Icon(Icons.design_services),
              //   label: 'Services',
                
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_activity_sharp),
                label: 'Activity',
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
        return EmpHomePage();
      case 1:
        return EmployerMyProject();
        case 2 :
        return EmpProfile();
      default:
        return EmpHomePage();
    }
  }

}

