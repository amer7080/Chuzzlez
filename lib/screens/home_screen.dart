// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:chuzzlez/providers/leaderboard_provider.dart';
import 'package:chuzzlez/services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chuzzlez/providers/user_provider.dart';
import 'package:chuzzlez/providers/opening_provider.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:chuzzlez/providers/puzzles_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  int _selectedIndex = 0;
  var currentLevel = 0;
  var role = false;
  loadData() async {
    try {
      String? uid = FirebaseAuth.instance.currentUser!.uid;

      await Provider.of<UserProvider>(context, listen: false).readUser();
      Provider.of<UserProvider>(context, listen: false).getUser.avatarUrl =
          await StorageRepo().getUserProfileImage(
              Provider.of<UserProvider>(context, listen: false).getUser.uid);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        currentLevel = Provider.of<UserProvider>(context, listen: false)
            .getUser
            .currentLevel;
        role =
            Provider.of<UserProvider>(context, listen: false).getUser.isAdmin;
      });
      if (Provider.of<PuzzlesProvider>(context, listen: false).read == false) {
        await Provider.of<PuzzlesProvider>(context, listen: false).readMap();
      }
      if (Provider.of<OpeningProvider>(context, listen: false).read == false) {
        await Provider.of<OpeningProvider>(context, listen: false).readMap();
      }
      Provider.of<LeaderboardProvider>(context, listen: false).readScoreBoard();
    }
  }

  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<UserProvider>(context, listen: false).getUser.isAdmin);

    // if (Provider.of<UserProvider>(context, listen: false).getUser.isAdmin ==
    //     false) {
    //   print("lol");
    // } else {
    //   print("not lol");
    // }
    return Scaffold(
      body: Stack(children: [
        if (Provider.of<UserProvider>(context, listen: false).getUser.isAdmin ==
            true) ...[
          ListView(children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                icon: Icon(Icons.person),
                color: Colors.black,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Chuzzlez',
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('The Chess Puzzlez Game',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )),
                SizedBox(
                  height: 42,
                )
              ],
            ),
          ]),
          Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Provider.of<UserProvider>(context, listen: false)
                        .setOpened();
                    Navigator.pushNamed(context, '/register',
                        arguments: {'role': true});
                  },
                  child: Column(children: [
                    Text('Add admin',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ]),
                  style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
                // OutlinedButton(
                //   onPressed: () {
                //     Provider.of<UserProvider>(context, listen: false)
                //         .setOpened();
                //     Navigator.pushNamed(
                //       context,
                //       '/delete',
                //     );
                //   },
                //   child: Column(children: [
                //     Text('Delete Users',
                //         style: TextStyle(
                //           fontSize: 30,
                //           fontWeight: FontWeight.bold,
                //           color: Colors.black,
                //         )),
                //   ]),
                //   style: OutlinedButton.styleFrom(
                //     shape: StadiumBorder(),
                //     side: BorderSide(color: Colors.black),
                //   ),
                // ),
                OutlinedButton(
                  onPressed: () {
                    Provider.of<UserProvider>(context, listen: false)
                        .setOpened();
                    Navigator.pushNamed(
                      context,
                      '/manage',
                    );
                  },
                  child: Column(children: [
                    Text('Manage Puzzles',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ]),
                  style: OutlinedButton.styleFrom(
                    shape: StadiumBorder(),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ])
        ] else ...[
          Text('Chuzzlez',
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/home_background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  icon: Icon(Icons.person),
                  color: Colors.black,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chuzzlez',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 6,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('The Chess Puzzlez Game',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 12,
                  )
                ],
              ),
              if (_selectedIndex == 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Provider.of<UserProvider>(context, listen: false)
                            .setOpened();
                        Navigator.pushNamed(context, '/puzzle').then((value) {
                          setState(() {
                            currentLevel = Provider.of<UserProvider>(context,
                                    listen: false)
                                .getUser
                                .currentLevel;
                          });
                        });
                      },
                      child: Column(children: [
                        Text('Play',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                        Text('Level ${currentLevel + 1}',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ))
                      ]),
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/puzzlelist')
                            .then((value) {
                          setState(() {
                            currentLevel = Provider.of<UserProvider>(context,
                                    listen: false)
                                .getUser
                                .currentLevel;
                          });
                        });
                      },
                      child: Text('Puzzles List',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/favourite')
                            .then((value) {
                          setState(() {
                            currentLevel = Provider.of<UserProvider>(context,
                                    listen: false)
                                .getUser
                                .currentLevel;
                          });
                        });
                      },
                      child: Text('Favourite Puzzles',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              if (_selectedIndex == 1)
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  // alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/board',
                            arguments: {'query': 'overtheboard'});
                      },
                      child: Text('Co-op Match',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/leaderboard',
                        );
                      },
                      child: Text('Leaderboard',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        side: BorderSide(color: Colors.black),
                      ),
                    )
                  ],
                ),
              if (_selectedIndex == 2)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/learning',
                            arguments: {'query': 'openings'});
                      },
                      child: Column(children: [
                        Text('Openings',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            )),
                      ]),
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                  ],
                ),
            ],
          )
        ],
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.teal,
        iconSize: MediaQuery.of(context).size.width / 8,
        selectedIconTheme: IconThemeData(
            color: Colors.white, size: MediaQuery.of(context).size.width / 8),
        selectedItemColor: Colors.amberAccent,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Puzzles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Play',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_sharp),
            label: 'Learning',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.people),
          //   label: 'Friends',
          // ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
