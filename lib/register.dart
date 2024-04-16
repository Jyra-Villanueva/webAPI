import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class register extends StatefulWidget {
register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {

    final api = 'psgc.gitlab.io';
    Map<String, String> regions = {};
    Map<String, String> province = {};
    Map<String, String> city = {};
      bool isRegionsLoaded = false;
      bool isProvLoaded = false;
      bool isCityLoaded = false;
      var provCon = TextEditingController();
      var cityCon = TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRegions();
  }

void callAPI() async{
  var url = Uri.https("psgc.gitlab.io","api/island-groups/");
  var response = await http.get(url); //get req
print(response.statusCode);
print(response.body);
if(response.statusCode == 200){
  List data = jsonDecode(response.body);
  print(data[0]['name']);
}
}

Future<void> loadRegions() async{
  var url = Uri.https(api,"api/regions/");
  var response = await http.get(url); //get req
// print(response.statusCode);
// print(response.body);
if(response.statusCode == 200){
  List data = jsonDecode(response.body);
  // print(data[0]['name']);
data.forEach((element) { 
  // print(element);
  var map = element as Map;
  print(map['regionName']);
  regions.addAll({map["code"] : map['regionName']});
});
}
setState((){
isRegionsLoaded = true;
});
}

Future<void> loadProvinces(String regionCode) async{
  province.clear();
  var url = Uri.https(api,"api/regions/$regionCode/provinces/");
  var response = await http.get(url); //get req
// print(response.statusCode);
// print(response.body);
if(response.statusCode == 200){
  List data = jsonDecode(response.body);
  // print(data[0]['name']);
data.forEach((element) { 
  // print(element);
  var map = element as Map;
  print(map['provName']);
  province.addAll({map["code"] : map['provnName']});
});
}
setState((){
isCityLoaded = true;
});
}

Future<void> loadCities(String provCode) async{
  city.clear();
  cityCon.clear();
  var url = Uri.https(api,"api/provinces/$provCode/municipalities/");
  var response = await http.get(url); //get req
// print(response.statusCode);
// print(response.body);
if(response.statusCode == 200){
  List data = jsonDecode(response.body);
  // print(data[0]['name']);
data.forEach((element) { 
  // print(element);
  var map = element as Map;
  print(map['cityName']);
  city.addAll({map["code"] : map['cityName']});
});
}
setState((){
isProvLoaded = true;
});
}
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    const padding = 12.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(padding),
        child: Column(
          children: [
            if(isRegionsLoaded)
                DropdownMenu(
                  width: width - padding * 2,
                  dropdownMenuEntries: regions.entries.map((entry){
                  return DropdownMenuEntry(value: entry.key, label: entry.value);
                }).toList(),
                onSelected: (value){
                print(value);
                provCon.clear();
                loadProvinces(value ?? '');
              }
              ) else
              Center(child: CircularProgressIndicator()
              ),
              if(isProvLoaded)
                DropdownMenu(
                  controller: provCon,
                width: width - padding * 2,
                dropdownMenuEntries: province.entries.map((entry) => 
                DropdownMenuEntry(value: entry.key, label: entry.value) ).toList(),
                onSelected: (value){
                print(value);
                loadCities(value ?? '');
              }
              ),
              if(isCityLoaded)
                DropdownMenu(
                  controller: cityCon,
                width: width - padding * 2,
                dropdownMenuEntries: city.entries.map((entry) => 
                DropdownMenuEntry(value: entry.key, label: entry.value) ).toList()
              ),
          ],
        ),
      ),
    );
  }
}