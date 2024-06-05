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
  List<Map<String, dynamic>> _players = List.generate(12, (index) => {
    'name': '회원 ${index + 1}',
  });

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
    });
  }

  void _onFormationChanged(String? formation) {
    setState(() {
      _selectedFormation = formation!;
      _currentFormation = _formations[_selectedFormation] ?? [];
    });
  }

  Future<void> _saveFormation() async {
    await _firestoreService.updateFormation(widget.team.id, _selectedFormation, _currentFormation);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('포메이션이 저장되었습니다.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('팀 관리'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveFormation,
                    child: Text('포메이션 저장'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  double groundWidth = constraints.maxWidth;
                  double groundHeight = groundWidth * 1.3; // 세로 비율을 65%로 유지
                  return Container(
                    width: groundWidth,
                    height: groundHeight,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/ground.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Stack(
                      children: _buildFormation(groundWidth, groundHeight),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _buildPlayerIcons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormation(double groundWidth, double groundHeight) {
    return _currentFormation.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> player = entry.value;
      return Positioned(
        left: player['left'] * groundWidth / 360,
        top: (576 - player['top']) * groundHeight / 576, // 상하 반전
        child: Draggable<int>(
          data: index,
          feedback: _playerIcon(index),
          child: _playerIcon(index),
          onDraggableCanceled: (velocity, offset) {
            setState(() {
              _currentFormation[index]['left'] = offset.dx * 360 / groundWidth;
              _currentFormation[index]['top'] = 576 - (offset.dy * 576 / groundHeight);
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

  List<Widget> _buildPlayerIcons() {
    return _players.map((player) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(Icons.person, color: Colors.white),
        ),
      );
    }).toList();
  }
}
