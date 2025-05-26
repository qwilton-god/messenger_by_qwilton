import 'package:flutter/material.dart';
import 'package:messenger_by_qwilton/components/textfield.dart';
import 'package:messenger_by_qwilton/components/button.dart';
import 'package:messenger_by_qwilton/pages/register_page.dart';
import 'package:messenger_by_qwilton/services/auth/auth_service.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {
    final void Function()? onTap;
    const LoginPage({super.key, this.onTap});

    @override
    State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
    // text controller 
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    void signIn() async{
      final authService = Provider.of<AuthService>(context, listen: false);

      try {
        await authService.signInWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: const Color(0xFFE5EEF4),
            body: SafeArea(
                child: Center(
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    // logo
                                    Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFC8E4CA),
                                            borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Icon(
                                            Icons.message,
                                            size: 80,
                                            color: const Color(0xFF672a43),
                                        ),
                                    ),
                                    const SizedBox(height: 30),
                                    // welcome text
                                    const Text(
                                        "Добро пожаловать вновь!",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF672a43),
                                            fontFamily: "Minecraft",
                                        ),
                                    ),
                                    const SizedBox(height: 30),
                                    // email text
                                    MyTextField(
                                        controller: emailController,
                                        obscureText: false,
                                        hintText: "Почта",
                                    ),
                                    const SizedBox(height: 15),
                                    // password
                                    MyTextField(
                                        controller: passwordController,
                                        obscureText: true,
                                        hintText: "Пароль",
                                    ),
                                    const SizedBox(height: 30),
                                    // button sign
                                    MyButton(
                                        text: "Войти",
                                        onTap: signIn,
                                    ),
                                    const SizedBox(height: 20),
                                    // register
                                    Column(
                                        children: [
                                            const Text(
                                                "Нет аккаунта?",
                                                style: TextStyle(
                                                    color: Color(0xFF672a43),
                                                    fontFamily: "Minecraft",
                                                ),
                                            ),
                                            const SizedBox(height: 8),
                                            GestureDetector(
                                                onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => RegisterPage(
                                                                onTap: () {},
                                                            ),
                                                        ),
                                                    );
                                                },
                                                child: Text(
                                                    "Зарегистрироваться",
                                                    style: TextStyle(
                                                        color: const Color(0xFF672a43),
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "Minecraft",
                                                    ),
                                                ),
                                            ),
                                        ],
                                    ),
                                ],
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}
