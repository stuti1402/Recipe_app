import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:recipe_app/recipe_model.dart';
import 'package:recipe_app/views/recipe.dart';
import 'package:url_launcher/url_launcher.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Recipemodel> recipes= new List <Recipemodel>();
  String ingredients;
  bool _loading = false;
  String query = "";
  TextEditingController textEditingController = new TextEditingController
    ();
  @override
  void initState() {
    super.initState();
  }

  String applicationId="f767e21f";
  String applicationKey="9f7ceb864e82d3e486219436c9ada697";

  getrecipes(String query)
  async {
    String url="https://api.edamam.com/search?q=$query&app_id=f767e21f&app_key=9f7ceb864e82d3e486219436c9ada697&from=0&to=3&calories=591-722&health=alcohol-free";
    var response = await http.get(url);
    Map<String,dynamic> jsonData=jsonDecode(response.body);

    jsonData["hits"].forEach((element)
    {
      print(element.toString());
      Recipemodel recipemodel= new Recipemodel();
      recipemodel=Recipemodel.fromMap(element["recipe"]);
      recipes.add(recipemodel);
    });
    print("${recipes.toString()}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
          child:Container(
            padding: EdgeInsets.only(top: 50, left:10),
            height:MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.indigo
            ]
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row( mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Yummy", style: TextStyle(
                fontSize: 22,fontWeight: FontWeight.bold,
              ),),
              Text("Recipes",style: TextStyle(
                fontSize: 22,fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),),
            ],
          ),
            SizedBox(height: 30,),
            Text("What you want to cook today?", style: TextStyle(
              fontSize: 22, color: Colors.white,fontFamily: 'Comic Sans'
            ),),
            SizedBox(height: 14,),
            Text("Enter the ingredients you have and we will show best recipe recommendations for you",
                style: TextStyle(
                  fontSize: 16, color: Colors.white),),
            SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width,
            child:Row(
              children:[
              Expanded(
              child:TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText:"Enter Ingredients",
                  hintStyle:TextStyle(
                  color: Colors.white,)

                ),
              style: TextStyle(fontSize: 18, color: Colors.yellow, ),

              ),),
              SizedBox(width: 10,),
            InkWell(
              onTap: () async {
                if(textEditingController.text.isNotEmpty){
                  setState(() {
                    _loading = true;
                  });
                  recipes = new List();
                  String url =
                      "https://api.edamam.com/search?q=${textEditingController.text}&app_id=0f21d949&app_key=8bcdd93683d1186ba0555cb95e64ab26";
                  var response = await http.get(url);
                  print(" $response this is response");
                  Map<String, dynamic> jsonData =
                  jsonDecode(response.body);
                  print("this is json Data $jsonData");
                  jsonData["hits"].forEach((element) {
                    print(element.toString());
                    Recipemodel recipeModel = new Recipemodel();
                    recipeModel =
                        Recipemodel.fromMap(element['recipe']);
                    recipes.add(recipeModel);
                    print(recipeModel.url);
                  });
                  setState(() {
                    _loading = false;
                  });
                    print("Just do it");
                  }
                else
                  {
                  print("Enter a value");
              }},
              child: Container(
                padding: EdgeInsets.only(right: 25),
              child: Icon(Icons.search,color: Colors.white,),
              ),
            ),],

            ),
          ),
          SizedBox(
          height: 10,
          ),
      Container(
        height:MediaQuery.of(context).size.height -272,
       width: MediaQuery.of(context).size.width,
       child: GridView(
       gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        mainAxisSpacing: 10.0, maxCrossAxisExtent: 200.0),
       shrinkWrap: true,
       scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        children: List.generate(recipes.length, (index) {
      return GridTile(
          child: RecipeTile(
            title: recipes[index].label,
            imgUrl: recipes[index].image,
            desc: recipes[index].source,
            url: recipes[index].url,
          ),
      );
    })
    ),
    )],

        ),
       ),),
    ],),
    );
  }
}
class RecipeTile extends StatefulWidget {
  final String title, desc, imgUrl, url;

  RecipeTile({this.title, this.desc, this.imgUrl, this.url});

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (kIsWeb) {
              _launchURL(widget.url);
            } else {
              print(widget.url + " this is what we are going to see");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Recipe(
                        postUrl: widget.url,
                      )));
            }
          },
          child: Container(
            margin: EdgeInsets.all(8),
            child: Stack(
              children: <Widget>[
                Image.network(
                  widget.imgUrl,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                              fontFamily: 'Comic Sans'),
                        ),
                        Text(
                          widget.desc,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black54,
                              fontFamily: 'Comic Sans'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class GradientCard extends StatelessWidget {
  final Color topColor;
  final Color bottomColor;
  final String topColorCode;
  final String bottomColorCode;

  GradientCard(
      {this.topColor,
        this.bottomColor,
        this.topColorCode,
        this.bottomColorCode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: 160,
                  width: 180,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [topColor, bottomColor],
                          begin: FractionalOffset.topLeft,
                          end: FractionalOffset.bottomRight)),
                ),
                Container(
                  width: 180,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white30, Colors.white],
                          begin: FractionalOffset.centerRight,
                          end: FractionalOffset.centerLeft)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          topColorCode,
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          bottomColorCode,
                          style: TextStyle(fontSize: 16, color: bottomColor),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
