import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
    final String text;
    final void Function() onTap;
    final Color? color;
    final double? width;
    final double? height;

    const MyButton({
        super.key,
        required this.text,
        required this.onTap,
        this.color,
        this.width,
        this.height,
    });

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: onTap,
            child: Container(
                width: width ?? double.infinity,
                height: height ?? 50,
                decoration: BoxDecoration(
                    color: color ?? const Color(0xFFF6FEFF),
                    borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                    child: Text(
                        text,
                        style: const TextStyle(
                            color: Color(0xFF672a43),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Minecraft",
                        ),
                    ),
                ),
            ),
        );
    }
}
