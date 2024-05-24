import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManagePositionScreen extends StatefulWidget {
  @override
  _ManagePositionScreenState createState() => _ManagePositionScreenState();
}

class _ManagePositionScreenState extends State<ManagePositionScreen> {
  final List<int> ages = List<int>.generate(80, (i) => i + 1); // 1세부터 80세까지
  final List<String> feet = ['오른발', '왼발'];
  final List<String> positions = [
    '골키퍼 (GK)', '센터백 (CB)', '풀백 (LB/RB)', '윙백 (LWB/RWB)', '수비형 미드필더 (CDM)',
    '중앙 미드필더 (CM)', '공격형 미드필더 (CAM)', '윙어 (LW/RW)', '센터 포워드 (CF)',
    '윙 포워드 (LF/RF)', '스트라이커 (ST)'
  ];

  int? selectedAge;
  String? selectedFoot;
  String? selectedPosition;

  @override
  void initState() {
    super.initState();
    _loadPlayerInfo();
  }

  void _loadPlayerInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final playerDoc = FirebaseFirestore.instance.collection('players').doc(user.uid);
    final docSnapshot = await playerDoc.get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      setState(() {
        selectedAge = data?['age'];
        selectedFoot = data?['foot'];
        selectedPosition = data?['position'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('내 포지션 관리')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: '나이'),
              value: selectedAge,
              items: ages.map((age) => DropdownMenuItem<int>(
                value: age,
                child: Text('$age 세'),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedAge = value;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: '주발'),
              value: selectedFoot,
              items: feet.map((foot) => DropdownMenuItem<String>(
                value: foot,
                child: Text(foot),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFoot = value;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: '선호 포지션'),
              value: selectedPosition,
              items: positions.map((position) => DropdownMenuItem<String>(
                value: position,
                child: Text(position),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPosition = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateInfo,
              child: Text('정보 업데이트'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateInfo() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인이 필요합니다.'),
        ),
      );
      return;
    }

    if (selectedAge != null && selectedFoot != null && selectedPosition != null) {
      FirebaseFirestore.instance.collection('players').doc(user.uid).set({
        'age': selectedAge,
        'foot': selectedFoot,
        'position': selectedPosition,
        'uid': user.uid,
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('정보가 업데이트되었습니다.')));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('업데이트 중 오류가 발생했습니다: $error')));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('모든 필드를 입력해주세요.')));
    }
  }
}
