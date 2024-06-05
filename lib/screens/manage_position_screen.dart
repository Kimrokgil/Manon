import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:man_on/firestore_service.dart';
import 'package:man_on/models/player_model.dart';
import 'package:man_on/widgets/polygon_chart.dart';

class ManagePositionScreen extends StatefulWidget {
  @override
  _ManagePositionScreenState createState() => _ManagePositionScreenState();
}

class _ManagePositionScreenState extends State<ManagePositionScreen> {
  String _selectedPosition = 'CM';
  double _speed = 50;
  double _shot = 50;
  double _pass = 50;
  double _dribble = 50;
  double _defense = 50;
  double _stamina = 50;

  final _firestoreService = FirestoreService();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('내 포지션 관리'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('이메일: ${user?.email ?? ''}'),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedPosition,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPosition = newValue!;
                });
              },
              items: <String>['GK', 'LB', 'CB', 'RB', 'LM', 'CM', 'RM', 'LW', 'CF', 'RW']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            PolygonChart(
              values: [_speed, _shot, _pass, _dribble, _defense, _stamina],
              labels: ['스피드', '슛', '패스', '드리블', '수비', '활동량'],
              maxValue: 100,
            ),
            SizedBox(height: 16),
            _buildSlider('스피드', _speed, (value) {
              setState(() {
                _speed = value;
              });
            }),
            _buildSlider('슛', _shot, (value) {
              setState(() {
                _shot = value;
              });
            }),
            _buildSlider('패스', _pass, (value) {
              setState(() {
                _pass = value;
              });
            }),
            _buildSlider('드리블', _dribble, (value) {
              setState(() {
                _dribble = value;
              });
            }),
            _buildSlider('수비', _defense, (value) {
              setState(() {
                _defense = value;
              });
            }),
            _buildSlider('활동량', _stamina, (value) {
              setState(() {
                _stamina = value;
              });
            }),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final player = Player(
                  id: user!.uid, // 플레이어 ID를 사용자 ID로 설정
                  name: user.email ?? 'Unknown', // 예시로 이메일을 이름으로 사용
                  position: _selectedPosition,
                  speed: _speed.toInt(),
                  shot: _shot.toInt(),
                  pass: _pass.toInt(),
                  dribble: _dribble.toInt(),
                  defense: _defense.toInt(),
                  stamina: _stamina.toInt(),
                );
                await _firestoreService.updatePlayerData(user.uid, player.toJson());
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('저장되었습니다.')));
              },
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, ValueChanged<double> onChanged) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label),
        ),
        Expanded(
          flex: 5,
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 100,
            label: value.round().toString(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
