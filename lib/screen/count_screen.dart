import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:stock_counting_app/screen/bu_screen.dart';
import 'package:stock_counting_app/screen/counting_view.dart';
import 'package:stock_counting_app/screen/scanItem.dart';

import 'package:stock_counting_app/utility/alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrscan/qrscan.dart' as scanner;

import 'package:motion_tab_bar_v2/motion-badge.widget.dart';
import 'package:motion_tab_bar_v2/motion-tab-bar.dart';
import 'package:motion_tab_bar_v2/motion-tab-item.dart';

class CountScan extends StatefulWidget {
  const CountScan({super.key, required this.token, required this.userName});
  final String? token;
  final String? userName;

  @override
  State<CountScan> createState() => _CountScanState();
}

class _CountScanState extends State<CountScan> with TickerProviderStateMixin {
  TextEditingController textController = TextEditingController();
  TabController? _tabController;
  TextEditingController? _textEditingController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; //ป้องการกดปุ่มยอนกลับบน mobile
      },
      child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              title: Text(
                "Stock Counting",
                style: GoogleFonts.prompt(fontSize: 25, color: Colors.white),
              ),
              automaticallyImplyLeading: false,
              leading: PopupMenuButton(
                  elevation: 0,
                  color: Color.fromARGB(255, 1, 68, 122),
                  shadowColor: Colors.black,
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 35,
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person_2,
                              color: Colors.white,
                              size: 25,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("${widget.userName}",
                                style: GoogleFonts.prompt(
                                    fontSize: 20, color: Colors.white)),
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.home,
                              color: Colors.white,
                              size: 25,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Home",
                                style: GoogleFonts.prompt(
                                    fontSize: 20, color: Colors.white)),
                          ],
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Colors.white,
                              size: 25,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Logout",
                                style: GoogleFonts.prompt(
                                    fontSize: 20, color: Colors.white)),
                          ],
                        ),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 1) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return BU_Screen(
                          token: widget.token,
                          userName: widget.userName,
                        );
                      }));
                    } else if (value == 2) {
                      showLogout_AlertDialog(context);
                    }
                  })),
          bottomNavigationBar: MotionTabBar(
            initialSelectedTab: "Count",
            useSafeArea: true, // default: true, apply safe area wrapper
            labels: const ["Count", "View"],
            icons: const [
              Icons.library_add_rounded,
              Icons.format_list_bulleted_rounded,
            ],
            tabIconColor: Colors.white,
            tabIconSize: 28.0,
            tabIconSelectedSize: 26.0,
            tabSelectedColor: Colors.black,
            tabIconSelectedColor: Colors.white,
            tabBarColor: Color.fromARGB(255, 5, 169, 239),
            onTabItemSelected: (int value) {
              setState(() {
                _tabController!.index = value;
              });
            },
          ),
          body: TabBarView(
              physics:
                  NeverScrollableScrollPhysics(), // swipe navigation handling is not supported
              controller: _tabController,
              children: <Widget>[
                Scan_Item(),
                Counting_View(
                  Name: _textEditingController?.text,
                )
              ])),
    );
  }
}
