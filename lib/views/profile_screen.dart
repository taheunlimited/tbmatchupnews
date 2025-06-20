import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matchupnews/views/utils/helper.dart';
import 'package:go_router/go_router.dart'; // ✅ Tambahkan package go_router
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Tambahkan shared_preferences
import 'package:matchupnews/routes/routes_name.dart'; // ✅ Tambahkan route names

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // ✅ Hapus token
    context.goNamed(RouteNames.login); // ✅ Kembali ke login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBgDc,
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Text("Profil", style: headline3.copyWith(color: cWhite, fontWeight: bold)),
                SizedBox(height: 50),
                Container(
                  padding: REdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: cBoxDc,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundColor: cBgDc,
                          radius: 70,
                          backgroundImage: AssetImage('assets/images/logo Ai no bg-01.png'),
                        ),
                      ),
                      vsLarge,
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('Name', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(': Abdullah', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold)),
                          ),
                        ],
                      ),
                      vsLarge,
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('Email', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(': abdullah@gmail.com', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold)),
                          ),
                        ],
                      ),
                      vsLarge,
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('Number', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(': 08211232323', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold)),
                          ),
                        ],
                      ),
                      vsLarge,
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('Address', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(': Jl. Cangkring Maleer, Kec.Batununggal, Kota Bandung, Jawa Barat 40274', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Divider(color: cBgDc, height: 4),
                ListTile(
                  onTap: () => _logout(context), // ✅ Logout action
                  leading: Icon(Icons.logout),
                  trailing: Icon(Icons.keyboard_arrow_right_outlined),
                  title: Text('Logout', style: subtitle1.copyWith(fontWeight: semibold, color: cWhite)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}