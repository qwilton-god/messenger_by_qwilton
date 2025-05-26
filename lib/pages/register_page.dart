import 'package:flutter/material.dart';
import 'package:messenger_by_qwilton/components/textfield.dart';
import 'package:messenger_by_qwilton/components/button.dart';
import 'package:messenger_by_qwilton/pages/home_page.dart';
import 'package:messenger_by_qwilton/services/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
    final void Function()? onTap;
    const RegisterPage({super.key, required this.onTap});

    @override
    State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    // text controllers
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    void signUp() async {
        if (passwordController.text != confirmPasswordController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Пароли не совпадают"),
                    backgroundColor: Color(0xFF8B8B8B),
                ),
            );
            return;
        }

        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Заполните все поля"),
                    backgroundColor: Color(0xFF8B8B8B),
                ),
            );
            return;
        }

        //get auth service
        final authService = Provider.of<AuthService>(context, listen: false);

        try {
            await authService.createUserWithEmailAndPassword(
                emailController.text.trim(),
                passwordController.text.trim(),
            );
            // Очищаем весь стек навигации и переходим на HomePage
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false, // Удаляем все предыдущие маршруты
            );
        } on FirebaseAuthException catch (e) {
            String errorMessage;
            switch (e.code) {
                case 'weak-password':
                    errorMessage = 'Пароль слишком слабый';
                    break;
                case 'email-already-in-use':
                    errorMessage = 'Этот email уже используется';
                    break;
                case 'invalid-email':
                    errorMessage = 'Неверный формат email';
                    break;
                default:
                    errorMessage = 'Ошибка: ${e.message}';
            }
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(errorMessage),
                    backgroundColor: const Color(0xFF8B8B8B),
                ),
            );
        } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Произошла ошибка: $e'),
                    backgroundColor: const Color(0xFF8B8B8B),
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
                                            Icons.person_add,
                                            size: 80,
                                            color: const Color(0xFF672a43),
                                        ),
                                    ),
                                    const SizedBox(height: 30),
                                    // welcome text
                                    const Text(
                                        "Создайте свой аккаунт",
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
                                    const SizedBox(height: 15),
                                    // confirm password
                                    MyTextField(
                                        controller: confirmPasswordController,
                                        obscureText: true,
                                        hintText: "Подтвердите пароль",
                                    ),
                                    const SizedBox(height: 30),
                                    // button sign up
                                    MyButton(
                                        text: "Зарегистрироваться",
                                        onTap: signUp,
                                    ),
                                    const SizedBox(height: 20),
                                    // login
                                    Column(
                                        children: [
                                            const Text(
                                                "Уже есть аккаунт?",
                                                style: TextStyle(
                                                    color: Color(0xFF672a43),
                                                    fontFamily: "Minecraft",
                                                    fontSize: 13,
                                                ),
                                            ),
                                            const SizedBox(height: 8),
                                            GestureDetector(
                                                onTap: () {
                                                    Navigator.pop(context);
                                                },
                                                child: Text(
                                                    "Войти",
                                                    style: TextStyle(
                                                        color: const Color(0xFF672a43),
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: "Minecraft",
                                                        fontSize: 13,
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
