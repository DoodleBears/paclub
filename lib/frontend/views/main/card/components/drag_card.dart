import 'package:flutter/material.dart';

class DragCard extends StatelessWidget {
  final String src;
  const DragCard({Key? key, required this.src}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 400,
                  height: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.network(
                    src,
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  children: [
                    for (int i = 1; i <= 10; i++)
                      Container(
                        width: 200,
                        height: 40,
                        child: Text('123'),
                        //  color: Colors.grey,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                  ],
                )
              ],
            ),
          )
          // Positioned.fill(
          //   child: Image.network(
          //     src,
          //     fit: BoxFit.cover,
          //   ),
          // ),
          // Text(widget.src)
        ],
      ),
    );
  }
}
