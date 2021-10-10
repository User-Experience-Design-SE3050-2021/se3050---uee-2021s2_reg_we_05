import 'package:flutter/material.dart';
import 'package:etraffic/rating.dart';
import 'package:etraffic/homepage.dart';


class RatingPage extends StatefulWidget {
  @override
  _RatingPage createState() => _RatingPage();
}

class _RatingPage extends State<RatingPage> {
  int _rating = 1;

homepage() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
          title: Text('User Feedback'),
          centerTitle: true,
          foregroundColor: Colors.white,
          backwardsCompatibility: false,
      ),
        body: Stack(
          children: <Widget>[
            new Container(
              constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/background.png"),
                        fit: BoxFit.cover)),   
          ),    
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height:15),
              Padding(
                padding: const EdgeInsets.all(20.0),
              child: Container(child: Text("Rate on how much are you satisfied with the eTraffic App?",
                style: TextStyle(color: Colors.black, fontSize: 22.0,fontWeight:FontWeight.bold),)),
            ),
              SizedBox(height:30),
              Rating((rating) {
                setState(() {
                  _rating = rating;
                });
              }, 5),
              SizedBox(
                  height: 44,
                  child: (_rating != null && _rating != 0)
                      ? Text("You selected $_rating rating",
                          style: TextStyle(fontSize: 18))
                      : SizedBox.shrink()),
              SizedBox(height:10),
              Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Container(child: TextField(
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.blueGrey)),
                              hintText: 'Add Comment',
                            ),
                            style: TextStyle(height: 3.0),
                          ),
                          ),
                        ),
            SizedBox(height:10),
             ElevatedButton(
                      onPressed: homepage,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          )),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue.shade800),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.fromLTRB(50, 10, 50, 10))),
                    ),
            ],
          ),
        )]
    ),
  ),);
  }
}