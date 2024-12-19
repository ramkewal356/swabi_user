import 'package:flutter/material.dart';
import 'package:flutter_cab/utils/color.dart';
import 'package:flutter_cab/view/dashboard/account_Pages/profile_page_screen.dart';
import 'package:flutter_cab/view/dashboard/rental/rental_form.dart';
import 'package:flutter_cab/view/dashboard/tourPackage/package_screen.dart';
import 'package:flutter_cab/view/starting_screen/landing_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  List<Widget> widgetOptions = [
    LandingScreen(),
    Packages(
      ursID: '2',
      // country: '',
      // state: '',
    ),
    RentalForm(userId: '2'),
    ProfilePage(user: '2')
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: btnColor),
        child: BottomNavigationBar(
          unselectedItemColor: Colors.white70,
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconSize: 28,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.white24),
            BottomNavigationBarItem(
                icon: Icon(Icons.content_paste_outlined),
                label: 'Package',
                backgroundColor: Color.fromRGBO(255, 255, 255, 1)),
            BottomNavigationBarItem(
              icon: Icon(Icons.car_rental),
              label: 'Rental',
              // backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'user',
              // backgroundColor: Colors.white,s
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
