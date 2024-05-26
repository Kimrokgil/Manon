import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:man_on/firestore_service.dart';
import 'package:man_on/widgets/polygon_chart.dart';

class ManagePositionScreen extends StatefulWidget {
  @override
  _ManagePositionScreenState createState() => _ManagePositionScreenState();
}

class _ManagePositionScreenState extends State<ManagePositionScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  String selectedPosition = "CM";
  List<double> attackingSkills = [0.8, 0.7, 0.6, 0.9, 0.5, 0.7];
  List<double> defendingSkills = [0.6, 0.8, 0.7, 0.5, 0.9, 0.6];
  List<String> attackingLabels = ["드리블", "슛", "패스", "스피드", "체력", "포지셔닝"];
  List<String> defendingLabels = ["태클", "마크", "힘", "스피드", "체력", "포지셔닝"];
  List<String> positions = ["GK", "LB", "CB", "RB", "LM", "CM", "RM", "LW", "CF", "RW"];

  final FirestoreService _firestoreService = FirestoreService();

  void _savePlayerSkills() {
    String playerId = "player_id"; // 실제 플레이어 ID로 대체 필요
    _firestoreService.savePlayerSkills(playerId, attackingSkills, defendingSkills);
  }

  void _showSkillEditDialog(List<double> skills, int index, String label, bool isAttacking) {
    TextEditingController _controller = TextEditingController(text: skills[index].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$label 수정'),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(hintText: "값을 입력하세요 (0 ~ 1)"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('저장'),
              onPressed: () {
                setState(() {
                  skills[index] = double.tryParse(_controller.text) ?? skills[index];
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('포지션 관리'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _savePlayerSkills,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(user?.email ?? '이메일 없음', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedPosition,
              items: positions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedPosition = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('공격 능력', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: PolygonChart(values: attackingSkills, labels: attackingLabels),
                        ),
                        ...attackingSkills.asMap().entries.map((entry) {
                          int idx = entry.key;
                          return TextButton(
                            onPressed: () => _showSkillEditDialog(attackingSkills, idx, attackingLabels[idx], true),
                            child: Text('${attackingLabels[idx]}: ${attackingSkills[idx].toStringAsFixed(1)}'),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('수비 능력', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: PolygonChart(values: defendingSkills, labels: defendingLabels),
                        ),
                        ...defendingSkills.asMap().entries.map((entry) {
                          int idx = entry.key;
                          return TextButton(
                            onPressed: () => _showSkillEditDialog(defendingSkills, idx, defendingLabels[idx], false),
                            child: Text('${defendingLabels[idx]}: ${defendingSkills[idx].toStringAsFixed(1)}'),
                          );
                        }).toList(),
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
}
