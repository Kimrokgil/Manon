import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firestore_service.dart';

class ManageTeamScreen extends StatefulWidget {
  final DocumentSnapshot team;

  ManageTeamScreen({required this.team});

  @override
  _ManageTeamScreenState createState() => _ManageTeamScreenState();
}

class _ManageTeamScreenState extends State<ManageTeamScreen> {
  String _selectedFormation = '4-4-2';
  List<Map<String, dynamic>> _currentFormation = [];
  FirestoreService _firestoreService = FirestoreService();
  Map<String, List<Map<String, dynamic>>> _formations = {};
  Map<int, Offset> _playerPositions = {};

  @override
  void initState() {
    super.initState();
    _loadFormations();
  }

  void _loadFormations() async {
    await _firestoreService.addFormations();
    _formations = await _firestoreService.getFormations();
    setState(() {
      _currentFormation = _formations[_selectedFormation] ?? [];
      _initializePlayerPositions();
    });
  }

  void _initializePlayerPositions() {
    for (int i = 0; i < _currentFormation.length; i++) {
      _playerPositions[i] = Offset(_currentFormation[i]['left'].toDouble(), _currentFormation[i]['top'].toDouble());
    }
  }

  void _onFormationChanged(String? formation) {
    setState(() {
      _selectedFormation = formation!;
      _currentFormation = _formations[_selectedFormation] ?? [];
      _initializePlayerPositions();
    });
  }

  void _updatePlayerPosition(int index, Offset newPosition) {
    setState(() {
      _playerPositions[index] = newPosition;
      _currentFormation[index]['left'] = newPosition.dx;
      _currentFormation[index]['top'] = newPosition.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('팀 관리')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // 그라운드 이미지
            Expanded(
              flex: 3,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double groundWidth = constraints.maxWidth;
                  double groundHeight = groundWidth * 4 / 3; // 세로 비율을 유지
                  return Container(
                    width: groundWidth,
                    height: groundHeight,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/ground.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: _buildFormation(groundWidth, groundHeight),
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 20),
            // 회원 리스트
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: _selectedFormation,
                    onChanged: _onFormationChanged,
                    items: _formations.keys.map((formation) {
                      return DropdownMenuItem<String>(
                        value: formation,
                        child: Text(formation),
                      );
                    }).toList(),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text('회원 관리'),
                          onTap: () => _navigateToFeature('member_management'),
                        ),
                        ListTile(
                          title: Text('출석 관리'),
                          onTap: () => _navigateToFeature('attendance_management'),
                        ),
                        ListTile(
                          title: Text('역할 관리'),
                          onTap: () => _navigateToFeature('role_management'),
                        ),
                        ListTile(
                          title: Text('팀 일정 관리'),
                          onTap: () => _navigateToFeature('schedule_management'),
                        ),
                        ListTile(
                          title: Text('팀 통계'),
                          onTap: () => _navigateToFeature('team_statistics'),
                        ),
                        ListTile(
                          title: Text('경기 일정'),
                          onTap: () => _navigateToFeature('match_schedule'),
                        ),
                        ListTile(
                          title: Text('경기 결과'),
                          onTap: () => _navigateToFeature('match_results'),
                        ),
                        ListTile(
                          title: Text('포메이션 관리'),
                          onTap: () => _navigateToFeature('lineup_management'),
                        ),
                        ListTile(
                          title: Text('공지사항'),
                          onTap: () => _navigateToFeature('announcements'),
                        ),
                        ListTile(
                          title: Text('사진 및 비디오 공유'),
                          onTap: () => _navigateToFeature('media_sharing'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFormation(double groundWidth, double groundHeight) {
    return _currentFormation.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> player = entry.value;
      return Positioned(
        left: _playerPositions[index]!.dx * groundWidth / 360,
        top: _playerPositions[index]!.dy * groundHeight / 576,
        child: Draggable<int>(
          data: index,
          feedback: _playerIcon(index),
          child: _playerIcon(index),
          onDraggableCanceled: (velocity, offset) {
            setState(() {
              _playerPositions[index] = Offset(
                offset.dx * 360 / groundWidth,
                offset.dy * 576 / groundHeight,
              );
            });
          },
        ),
      );
    }).toList();
  }

  Widget _playerIcon(int index) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _currentFormation[index]['name'][0],
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void _navigateToFeature(String feature) {
    // Feature navigation logic here
  }
}
