import 'package:flutter/material.dart';
import 'package:mngmt_flutter/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isTagging = false;
  List<PhotoState> photoStates =
      List.of(Utils.urls.map((url) => PhotoState(url)));
  Set<String> tags = Utils.tags;

  void selectTag(String tag) {
    setState(() {
      if (isTagging) {
        if (tag != "all") {
          for (var element in photoStates) {
            if (element.selected) {
              element.tags.add(tag);
            }
          }
          toggleTagging(null);
        }
      } else {
        for (var element in photoStates) {
          element.display = tag == "all" ? true : element.tags.contains(tag);
        }
      }
    });
  }

  void toggleTagging(String? url) {
    setState(() {
      isTagging = !isTagging;
      for (var element in photoStates) {
        if (isTagging && element.url == url && url != null) {
          element.selected = true;
        } else {
          element.selected = false;
        }
      }
    });
  }

  void onPhotoSelect(String url, bool selected) {
    setState(() {
      for (var element in photoStates) {
        if (element.url == url) {
          element.selected = selected;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GalleryPage(
        title: "Image Gallery",
        photoStates: photoStates,
        tagging: isTagging,
        tags: tags,
        selectTag: selectTag,
        toggleTagging: toggleTagging,
        onPhotoSelect: onPhotoSelect,
      ),
    );
  }
}

class GalleryPage extends StatelessWidget {
  final String title;
  final List<PhotoState> photoStates;
  final bool tagging;
  final Set<String> tags;

  final Function toggleTagging;
  final Function onPhotoSelect;
  final Function selectTag;

  const GalleryPage(
      {super.key,
      required this.title,
      required this.photoStates,
      required this.tagging,
      required this.toggleTagging,
      required this.onPhotoSelect,
      required this.tags,
      required this.selectTag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: GridView.count(
          //padding: const EdgeInsets.all(8.0),
          primary: false,
          crossAxisCount: 2, // Add padding around the GridView
          children: photoStates
              .where((ps) => ps.display)
              .map((ps) => Photo(
                    state: ps,
                    selectable: tagging,
                    onLongPress: toggleTagging,
                    onSelect: onPhotoSelect,
                  ))
              .toList()),
      drawer: Drawer(
        child: ListView(
          children: List.of((tags.map((t) => ListTile(
                title: Text(t),
                onTap: () {
                  selectTag(t);
                  Navigator.of(context).pop();
                  print('drawer clicked');
                  print(photoStates);
                },
              )))),
        ),
      ),
    );
  }
}

class Photo extends StatelessWidget {
  final PhotoState state;
  final bool selectable;

  final Function onLongPress;
  final Function onSelect;

  const Photo({
    super.key,
    required this.state,
    required this.selectable,
    required this.onLongPress,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      GestureDetector(
        onLongPress: () => onLongPress(state.url),
        child: Image.network(
          state.url,
          fit: BoxFit.cover,
        ),
      )
    ];

    if (selectable) {
      children.add(Positioned(
          left: 20,
          top: 0,
          child: Theme(
            data: Theme.of(context)
                .copyWith(unselectedWidgetColor: Colors.grey[200]),
            child: Checkbox(
              onChanged: ((value) => onSelect(
                    state.url,
                    value,
                  )),
              value: state.selected,
              activeColor: Colors.white,
              checkColor: Colors.black,
            ),
          )));
    }
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Stack(
        alignment: Alignment.center,
        children: children,
      ),
    );
  }
}
