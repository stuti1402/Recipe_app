class Recipemodel
{
  String label;
  String image;
  String source;
  String url;
  Recipemodel({this.image,this.label,this.source,this.url});

  factory Recipemodel.fromMap(Map<String, dynamic> parsedJson){
    return Recipemodel(
      url: parsedJson["url"],
      label: parsedJson["label"],
      image: parsedJson["image"],
      source: parsedJson["source"]
    );
  }

}