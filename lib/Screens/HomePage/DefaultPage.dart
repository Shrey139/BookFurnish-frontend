import 'dart:convert';
import 'dart:ui';
import 'package:basic_utils/basic_utils.dart';
import 'package:http/http.dart' as http;
import 'package:BookFurnish/Screens/bookDetails.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class DefaultPage extends StatefulWidget {
  @override
  _DefaultPageState createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = true;
  List book;
  final url = "https://fast-everglades-73327.herokuapp.com/api/v1/book";
  getBooks() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    Map<String, dynamic> map = json.decode(res.body);
    List<dynamic> data = map["data"]["book"];
    setState(() {
      book = data;
      isLoading = false;
      print(book.length);
      print(book);
    });

    // var res = await http
    //     .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    // Map<String, dynamic> map = json.decode(res.body);
    // List<dynamic> data = map["data"]["book"];
    // setState(() {
    //   book = data;
    //   isLoading = false;
    //   print(book.length);
    //   print(book);
    // });
    // final String urlSearch =
    //     "https://fast-everglades-73327.herokuapp.com/api/v1/book/search";
    // Map<String, String> header = {"Content-type": "application/json"};
    // String json = '{"search": "' + widget.search + '"}';
    // Response response = await post(urlSearch, headers: header, body: json);
    // Map<String, dynamic> map = json.decode(response.body);
    // List<dynamic> data = map["data"]["book"];
    // setState(() {
    //   book = data;
    //   isLoading = false;
    //   print(book.length);
    //   print(book);
    // });
  }

  initState() {
    super.initState();
    getBooks();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    //final double itemHeight = (size.height - kToolbarHeight) / 2;
    final double itemWidth = (size.width / 2);
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                itemCount: book.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: (itemWidth / 320)),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookDetails(
                                    imageUrl: book[index]['bookImage'],
                                    id: book[index]['_id'],
                                    name: book[index]['bookName'],
                                    author: book[index]['author'],
                                    bookType: book[index]['bookType'],
                                    department: book[index]['department'],
                                    subject: book[index]['subject'],
                                  )));
                    },
                    child: Card(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: <Widget>[
                          FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: book[index]['bookImage'],
                            fit: BoxFit.fill,
                            height: 220,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text: StringUtils.capitalize(
                                      book[index]['bookName']),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  )),
                              maxLines: 2,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
