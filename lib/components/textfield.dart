import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
    final TextEditingController controller;
    final bool obscureText;
    final String hintText;
    const MyTextField({
        super.key,
        required this.controller,
        required this.obscureText,
        required this.hintText,
    });
    
    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                color: const Color(0xFFC8E4CA),
                borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
                controller: controller,
                obscureText: obscureText,
                style: const TextStyle(
                    fontFamily: "Minecraft",
                    color: Color(0xFF672a43),
                    fontSize: 16,
                ),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(4),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: const Color(0xFF672a43), width: 2),
                        borderRadius: BorderRadius.circular(4),
                    ),
                    hintText: hintText,
                    hintStyle: TextStyle(
                        color: const Color(0xFF672a43).withOpacity(0.5),
                        fontFamily: "Minecraft",
                        fontSize: 16,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: const Color(0xFFC8E4CA),
                ),
            ),
        );
    }
}
