import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'manage_team_screen.dart';

class LoginedScreen extends StatefulWidget {
  @override
  _LoginedScreenState createState() => _LoginedScreenState();
}

class _LoginedScreenState extends State<LoginedScreen> {
  List<DocumentSnapshot> _userTeams = [];

  @override
  void initState() {
    super.initState();
    _loadUserTeams();
  }

  Future<void> _loadUserTeams() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('teams')
        .where('userId', isEqualTo: user.uid)
        .get();

    setState(() {
      _userTeams = querySnapshot.docs;
      print('User Teams: $_userTeams'); // 데이터 확인을 위한 로그
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('환영합니다!'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${user?.email ?? 'User'}님 환영합니다!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              if (_userTeams.isNotEmpty)
                ..._userTeams.map((team) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageTeamScreen(team: team),
                        ),
                      );
                    },
                    child: Text('팀 관리 (${team['teamName']})'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }).toList(),
              if (_userTeams.isEmpty)
                Text('생성된 팀이 없습니다.', textAlign: TextAlign.center),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/createTeam'),
                child: Text('팀 생성하기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/findTeam'),
                child: Text('팀 찾기'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/managePositions'),
                child: Text('내 포지션 관리'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
