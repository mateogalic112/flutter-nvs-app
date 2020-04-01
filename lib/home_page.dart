import 'package:flutter/material.dart';
import 'package:nvs_app/clip_shadow_path.dart';
import 'img_list.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Offset offset = Offset(0, 0);
  double offsetDistance = 0;
  int current = 0;
  bool isPressed = false;
  double growShadow = 60;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              offsetDistance <= 0
                  ? Image.asset(
                      imgList[current + 1],
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                    )
                  : current == 0
                      ? SizedBox()
                      : Image.asset(
                          imgList[current - 1],
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        ),
            ],
          ),
          GestureDetector(
            onHorizontalDragEnd: (DragEndDetails details) {
              if (offset.dx <= 0 && offsetDistance < -370) {
                if (current == 84) {
                  setState(() {
                    offsetDistance = 0;
                  });
                  return;
                }
                setState(() {
                  current++;
                  offsetDistance = 0;
                });
              } else if (offset.dx > 0 && offsetDistance > 370) {
                if (current == 0) {
                  setState(() {
                    offsetDistance = 0;
                  });
                  return;
                }
                setState(() {
                  current--;
                  offsetDistance = 0;
                });
              } else if (offset.dx <= 0 && offsetDistance >= -370) {
                setState(() {
                  offsetDistance = 0;
                });
              } else if (offset.dx > 0 && offsetDistance <= 370) {
                setState(() {
                  offsetDistance = 0;
                });
              }
            },
            onHorizontalDragUpdate: (DragUpdateDetails updateDetails) {
              offset = updateDetails.delta;
              setState(() {
                growShadow = (offsetDistance / 24).abs();
                offsetDistance += updateDetails.delta.distance * offset.dx / 5;
              });
            },
            onTap: () => setState(() {
              isPressed = false;
            }),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipShadowPath(
                  clipper: MyClipper(offsetDistance, current),
                  shadow: Shadow(
                    blurRadius: growShadow
                  ),
                  child: Image.asset(
                    imgList[current],
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          current > 0 && current < 84 ?
          Positioned(
            bottom: 16,
            right: MediaQuery.of(context).size.width / 6,
            child: Container(
              height: MediaQuery.of(context).size.width * 0.15,
              width: MediaQuery.of(context).size.width * 0.15,
              child: RaisedButton(
                color: Colors.black,
                onPressed: () {
                  setState(() {
                    isPressed = true;
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: Text(
                  'Page',
                  style: TextStyle(fontSize: 11, color: Colors.white),

                ),
              ),
            ),
          ) : Container(),
          isPressed
              ? Positioned(
                  top: MediaQuery.of(context).size.height / 2 - 40,
                  left: MediaQuery.of(context).size.width / 2 - 40,
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(40)),
                    child: Center(
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: "'00'",
                            ),
                            onSubmitted: (String value) {
                              int n = num.tryParse(value);
                              if (value.isEmpty) {
                                setState(() {
                                  isPressed = false;
                                });
                              } else if (n > 0 && n <= 82) {
                                setState(() {
                                  current = n + 2;
                                });
                              } else if (n > 82) {
                                return showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.teal,
                                        title: Text("Book has only 82 pages!"),
                                      );
                                    });
                              }
                              setState(() {
                                isPressed = false;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  double offsetDis;
  int current;

  MyClipper(this.offsetDis, this.current);

  @override
  Path getClip(Size size) {
    print(offsetDis);
    if (offsetDis <= 0) {
      Path path = Path();
      path.lineTo(0.0, size.height);
      path.lineTo(size.width + offsetDis / 1.5, size.height + offsetDis);
      path.lineTo(size.width, 0.0);
      path.close();
      return path;
    } else {
      if (current == 0) {
        Path path = Path();
        offsetDis = 0;
        path.lineTo(0.0, 0.0);
        path.close();
        return path;
      } 
      else {
        Path path = Path();
        path.lineTo(0.0 + offsetDis, size.height - offsetDis * 1.5);
        path.lineTo(size.width, size.height);
        path.lineTo(size.width, 0.0);
        path.close();
        return path;
      }
    }
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
