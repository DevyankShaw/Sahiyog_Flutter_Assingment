import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assingment/models/swipe_list_item.dart';
import 'package:flutter_assingment/screens/map_screen.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;

class SwipeListViewScreen extends StatelessWidget {
  Future<List<SwipeListItem>> fetchNames(http.Client client) async {
    final response =
        await client.get('https://jsonplaceholder.typicode.com/users');

    return parseNames(response.body);
  }

  List<SwipeListItem> parseNames(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<SwipeListItem>((json) => SwipeListItem.fromJson(json))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Swipe ListView'),
      ),
      body: FutureBuilder<List<SwipeListItem>>(
        future: fetchNames(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? NamesList(names: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class NamesList extends StatefulWidget {
  final List<SwipeListItem> names;

  NamesList({this.names});

  @override
  _NamesListState createState() => _NamesListState();
}

class _NamesListState extends State<NamesList> {
  SlidableController slidableController;

  @protected
  void initState() {
    slidableController = SlidableController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => _getSlidableWithLists(context, index),
      itemCount: widget.names.length,
    );
  }

  Widget _getSlidableWithLists(BuildContext context, int index) {
    return Slidable(
      key: Key(widget.names[index].name),
      controller: slidableController,
      direction: Axis.horizontal,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          setState(() {
            _showSnackBar(context, '${widget.names[index].name} deleted!');
            widget.names.removeAt(index);
          });
        },
      ),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: VerticalListItem(widget.names[index]),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => share('Share ${widget.names[index].name}'),
          closeOnTap: false,
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => setState(() {
            _showSnackBar(context, '${widget.names[index].name} deleted!');
            widget.names.removeAt(index);
          }),
        ),
      ],
    );
  }

  Future<void> share(String text) async {
    await FlutterShare.share(
      title: text,
      text: text,
      chooserTitle: 'Choose Application',
    );
  }

  void _showSnackBar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class VerticalListItem extends StatelessWidget {
  VerticalListItem(this.item);
  final SwipeListItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapScreen()),
      ),
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: Text(item.id.toString()),
          title: Text(item.name),
        ),
      ),
    );
  }
}
