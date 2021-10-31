import 'package:flutter/material.dart';
import 'package:paclub/frontend/constants/colors.dart';

class DragCard extends StatelessWidget {
  final String src;
  const DragCard({Key? key, required this.src}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.brown[50],
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 400,
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.network(
                    src,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  //上下左右各添加16像素补白
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    //显式指定对齐方式为左对齐，排除对齐干扰
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.account_circle_rounded,
                              size: 60,
                              color: Colors.blue[600],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Container(
                                child: Row(
                                  mainAxisSize:
                                      MainAxisSize.min, //讓底色的色塊能夠跟隨字數變化
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.amber[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "Author name",
                                        style: new TextStyle(
                                          fontSize: 25.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          width: 385,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.pink[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Pack name",
                            textAlign: TextAlign.center, //字行置中
                            maxLines: 1, //最多顯示行數
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontSize: 30.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.lightGreen[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Tag 1",
                                textAlign: TextAlign.center, //字行置中
                                maxLines: 1, //最多顯示行數
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 2),
                            Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.lightGreen[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Tag 2",
                                textAlign: TextAlign.center, //字行置中
                                maxLines: 1, //最多顯示行數
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 2),
                            Container(
                              width: 100,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.lightGreen[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Tag 3",
                                textAlign: TextAlign.center, //字行置中
                                maxLines: 1, //最多顯示行數
                                overflow: TextOverflow.ellipsis,
                                style: new TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          width: 385,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            "Package Description",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              fontSize: 20.0, //描述內容，故字體較小
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 90,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.orange[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    print('按讚');
                                  }),
                            ),
                            SizedBox(width: 5.0),
                            Container(
                              width: 90,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.orange[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.comment,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    print('留言');
                                  }),
                            ),
                            SizedBox(width: 5.0),
                            Container(
                              width: 90,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.orange[200],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: IconButton(
                                  icon: Icon(
                                    Icons.bookmark_add,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    print('收藏人數');
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
