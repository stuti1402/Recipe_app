import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class Recipe extends StatefulWidget {
  final String postUrl;
 Recipe({@required this.postUrl});
  @override
  _RecipeState createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  String finalUrl ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    finalUrl = widget.postUrl;
    if(widget.postUrl.contains('http://')){
      finalUrl = widget.postUrl.replaceAll("http://","https://");
      print(finalUrl + "this is final url");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 40,left: 24,bottom: 16),

                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent,
                          Colors.indigo
                        ],
                       )),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Yummy",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Comic Sans'),
                    ),
                    Text(
                      "Recipes",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.yellow,
                          fontFamily: 'Comic Sans'),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height -100,
                width: MediaQuery.of(context).size.width,
                child: WebView(
                  onPageFinished: (val){
                    print(val);
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: finalUrl,
                  onWebViewCreated: (WebViewController webViewController){
                    setState(() {
                      _controller.complete(webViewController);
                    });
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}
