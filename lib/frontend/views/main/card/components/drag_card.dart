import 'package:flutter/material.dart';

class DragCard extends StatelessWidget {
  final String src;
  const DragCard({Key? key, required this.src}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              src,
              fit: BoxFit.cover,
            ),
          ),
          // Text(widget.src)
        ],
      ),
    );
  }
}
