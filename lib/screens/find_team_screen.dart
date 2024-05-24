import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class FindTeamScreen extends StatefulWidget {
  @override
  _FindTeamScreenState createState() => _FindTeamScreenState();
}

class _FindTeamScreenState extends State<FindTeamScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<DocumentSnapshot> _teamResults = [];

  Future<void> _searchPlace(String query) async {
    const apiKey = 'a6106d981e1c4852a3a6117830fc5ce2';
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
        const SnackBar(content: Text('검색 결과를 찾을 수 없습니다.')),
      );
    }
  }

  Future<void> _searchTeams(String address) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('teams')
        .where('address', isEqualTo: address)
        .get();

    setState(() {
      _teamResults = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('팀 찾기')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '주소 검색',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchPlace(_searchController.text),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                        _searchController.text = result['address_name'];
                        _searchTeams(result['address_name']);
                        setState(() {
                          _searchResults = [];
                        });
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            if (_teamResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _teamResults.length,
                  itemBuilder: (context, index) {
                    final team = _teamResults[index];
                    return ListTile(
                      title: Text(team['teamName']),
                      subtitle: Text(team['address']),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
