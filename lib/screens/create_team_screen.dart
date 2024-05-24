import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateTeamScreen extends StatefulWidget {
  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _teamNameController = TextEditingController();
  final _searchController = TextEditingController();
  String? selectedAddress;

  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _searchPlace(String query) async {
    const apiKey = 'a6106d981e1c4852a3a6117830fc5ce2'; // 실제 API 키로 대체
    final url = 'https://dapi.kakao.com/v2/local/search/address.json?query=$query';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'KakaoAK $apiKey'},
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['documents'] != null) {
      setState(() {
        _searchResults = List<Map<String, dynamic>>.from(data['documents']);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('검색 결과를 찾을 수 없습니다.')),
      );
    }
  }

  Future<void> _saveTeam() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('로그인이 필요합니다.')),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      if (selectedAddress == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('주소를 선택해주세요.')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('teams').add({
        'teamName': _teamNameController.text,
        'address': selectedAddress,
        'userId': user.uid,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('팀이 생성되었습니다.')),
      );

      _teamNameController.clear();
      _searchController.clear();
      setState(() {
        _searchResults = [];
        selectedAddress = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('팀 생성')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _teamNameController,
                decoration: InputDecoration(labelText: '팀 이름'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '팀 이름을 입력해주세요.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: '주소 검색',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => _searchPlace(_searchController.text),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (_searchResults.isNotEmpty)
                Container(
                  height: 200,
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      return ListTile(
                        title: Text(result['address_name']),
                        onTap: () {
                          setState(() {
                            selectedAddress = result['address_name'];
                            _searchController.text = result['address_name'];
                            _searchResults = [];
                          });
                        },
                      );
                    },
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTeam,
                child: Text('팀 저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
