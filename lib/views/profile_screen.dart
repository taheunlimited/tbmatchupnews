import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matchupnews/views/utils/helper.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBgDc,
      body: Column(
        children: [
          vsTiny,
          Padding(padding: REdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Text("Profil", style: headline3.copyWith(color: cWhite, fontWeight: bold),
                ),
                vsTiny,
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
                      vsTiny,
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('Name', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(': Abdullah', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
                            ),
                          ),
                        ],
                      ),
                      vsTiny,
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('Email', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(': abdullah@gmail.com', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
                            ),
                          ),
                        ],
                      ),
                      vsTiny,
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('Number', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(': 08211232323', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
                            ),
                          ),
                        ],
                      ),
                      vsTiny,
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text('Address', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(': Jl. Cangkring Maleer, Kec.Batununggal, Kota Bandung, Jawa Barat 40274', style: subtitle1.copyWith(color: cWhite, fontWeight: semibold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                    log('Edit Profile');
                  },
                  leading: Icon(Icons.edit_square),
                  trailing: Icon(Icons.keyboard_arrow_right_outlined),
                  title: Text('Edit Profile', style: subtitle1.copyWith(fontWeight: semibold, color: cWhite),
                  ),
                ),
                Divider(color: cBgDc, height: 4),
                ListTile(
                  onTap: () {
                    log('Edit Password');
                  },
                  leading: Icon(Icons.password),
                  trailing: Icon(Icons.keyboard_arrow_right_outlined),
                  title: Text('Edit Password', style: subtitle1.copyWith(fontWeight: semibold, color: cWhite),
                  ),
                ),
                Divider(color: cBgDc, height: 4),
                ListTile(
                  onTap: () {
                    log('Logout');
                  },
                  leading: Icon(Icons.logout),
                  trailing: Icon(Icons.keyboard_arrow_right_outlined),
                  title: Text('Logout', style: subtitle1.copyWith(fontWeight: semibold, color: cWhite),
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