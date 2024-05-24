import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 이메일 입력 필드
              FormBuilderTextField(
                name: 'email',
                decoration: const InputDecoration(
                  labelText: '이메일',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.email(),
                ]),
              ),
              const SizedBox(height: 20),
              // 비밀번호 입력 필드
              FormBuilderTextField(
                name: 'password',
                decoration: const InputDecoration(
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 20),
              // 로그인 버튼
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    final formData = _formKey.currentState!.value;
                    signInWithEmailAndPassword(formData['email'], formData['password'], context);
                  }
                },
                child: const Text('로그인'),
              ),
              const SizedBox(height: 20),
              // 회원가입 버튼
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text('회원가입'),
              ),
              const SizedBox(height: 20),
              // 카카오 로그인 예정
              IconButton(
                icon: const Icon(Icons.account_circle, color: Colors.yellow),
                onPressed: () {
                  // 카카오 로그인 로직 구현 예정
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 로그인 함수
  Future<void> signInWithEmailAndPassword(String email, String password, BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 로그인 성공 시 LoginedScreen으로 이동
      Navigator.pushReplacementNamed(context, '/main');
      print('로그인 성공: ${credential.user}');
    } catch (e) {
      print('로그인 에러: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인 실패: $e'),
        ),
      );
    }
  }
}
