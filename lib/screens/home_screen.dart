import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:spamfilter/constants.dart';
class HomePage extends StatefulWidget {
  static const String id = "home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool checkedSpam = false;
  double percentage = 0.0;
  bool isLoading = false;
  void getSpamPercentage() async{
      String url = kSpamFilterUrl;
      try{
        var response = await http.post(Uri.parse(url+"/post_message?message=1"));
        if(response.statusCode == 200){
          var jsonResponse = convert.jsonDecode(response.body);

          percentage = jsonResponse['is_spam'];
          Future.delayed(const Duration(milliseconds: 1000), (){
            setState(() {
              checkedSpam = true;
              isLoading = false;
            });
          });
          print(percentage);

        }
      }catch(e){
        print(e);
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 100, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [

            Text("Spam Filter", style: Theme.of(context).textTheme.headline1!.copyWith(
              color: Colors.teal,
              fontSize: 40,
            ),),

            isLoading ? Center(child: CircularProgressIndicator(),): Container(),
            checkedSpam ? Center(
              child: Text(percentage.toString(), style: Theme.of(context).textTheme.displaySmall
              !.copyWith(fontSize: 30),),
            ) : Container(height: 30,),

            ElevatedButton(onPressed: (){
              setState(() {
                isLoading = true;
              });
                getSpamPercentage();
            }, child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Text("Check Spam"),
            ))


          ],
        ),
      ),
    );
  }
}
