import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../modell/Data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  late Data model;
  Map val = {};
  TextEditingController controller = TextEditingController();
  getData(String value) async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse('https://filepursuit.p.rapidapi.com/?q=$value');
    var response = await http.get(url, headers: {
      'X-RapidAPI-Key': '1b329f922fmsh08155341c6a639ep154e6fjsn6e721e5c5c0c',
      'X-RapidAPI-Host': 'filepursuit.p.rapidapi.com',
    });
    final dataBody = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body.toString());
      setState(() {
        val = dataBody;
        model = Data.fromJson(json.decode(response.body));
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print(response.body.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {});
    getData(controller.text.isEmpty ? "Films" : controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black26,
        centerTitle: true,
        title: const Text('Search Anything'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: SizedBox(
                height: 50,
                child: TextFormField(
                  controller: controller,
                  maxLines: 1,
                  onChanged: (value) {
                    setState(() {
                      getData(value);
                    });
                  },
                  keyboardAppearance: Brightness.dark,
                  decoration: InputDecoration(
                    fillColor: Colors.white10,
                    filled: true,
                    disabledBorder: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 21,
                    ),
                    hintStyle: const TextStyle(fontSize: 20),
                    label: Text('Search'),
                  ),
                ),
              ),
            ),
            isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : model.filesFound.isEmpty
                    ? SizedBox()
                    : Expanded(
                        child: ListView.builder(
                            itemCount: model.filesFound.length,
                            itemBuilder: (_, index) {
                              if (model.filesFound.isEmpty) {
                                return Card(
                                  child: ListTile(
                                    leading: Text('$index'),
                                    title: const Text(
                                      'Data',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: const Text(
                                      'Details',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      leading: Text('$index'),
                                      title: Text(
                                        model.filesFound[index].fileName
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Text(
                                        model.filesFound[index].fileId
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () async {
                                        final Uri url = Uri.parse(model
                                            .filesFound[index].fileLink
                                            .toString());
                                        if (await launchUrl(
                                          url,
                                          webViewConfiguration:
                                              const WebViewConfiguration(
                                            enableJavaScript: true,
                                          ),
                                        )) {
                                          throw Exception(
                                              'Could not launch $url');
                                        }
                                      }),
                                );
                              }
                            }),
                      ),
          ],
        ),
      ),
    );
  }
}
