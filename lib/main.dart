import 'package:flutter/material.dart';
import 'package:mngmt_flutter/utils.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AppState(),
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'viewer',
      home: GalleryPage(title: 'viewer'),
    );
  }
}

class AppState extends ChangeNotifier {
  bool isTagging = false;
  List<PhotoState> photoStates =
      List.of(Utils.urls.map((url) => PhotoState(url)));
  Set<String> tags = Utils.tags;

  void selectTag(String tag) {
    if (isTagging) {
      if (tag != "all") {
        for (var element in photoStates) {
          if (element.selected) {
            element.tags.add(tag);
          }
        }
      }
      toggleTagging(null);
    } else {
      for (var element in photoStates) {
        element.display = tag == "all" ? true : element.tags.contains(tag);
      }
    }
    notifyListeners();
  }

  void toggleTagging(String? url) {
    isTagging = !isTagging;
    for (var element in photoStates) {
      if (isTagging && element.url == url && url != null) {
        element.selected = true;
      } else {
        element.selected = false;
      }
    }
    notifyListeners();
  }

  void onPhotoSelect(String url, bool selected) {
    for (var element in photoStates) {
      if (element.url == url) {
        element.selected = selected;
      }
    }
    notifyListeners();
  }
}

class GalleryPage extends StatelessWidget {
  final String title;

  const GalleryPage({super.key, required this.title, g});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: GridView.count(
          //padding: const EdgeInsets.all(8.0),
          primary: false,
          crossAxisCount: 2, // Add padding around the GridView
          children: context
              .watch<AppState>()
              .photoStates
              .where((ps) => ps.display)
              .map((ps) => Photo(
                    state: ps,
                  ))
              .toList()),
      drawer: Drawer(
        child: ListView(
          children: List.of((context.watch<AppState>().tags.map((t) => ListTile(
                title: Text(t),
                onTap: () {
                  context.read<AppState>().selectTag(t);
                  Navigator.of(context).pop();
                },
              )))),
        ),
      ),
    );
  }
}

class Photo extends StatelessWidget {
  final PhotoState state;

  const Photo({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      GestureDetector(
        onLongPress: () => context.read<AppState>().toggleTagging(state.url),
        child: Image.network(
          state.url,
          fit: BoxFit.cover,
        ),
      )
    ];

    if (context.watch<AppState>().isTagging) {
      children.add(Positioned(
          left: 20,
          top: 0,
          child: Theme(
            data: Theme.of(context)
                .copyWith(unselectedWidgetColor: Colors.grey[200]),
            child: Checkbox(
              onChanged: (value) {
                context
                    .read<AppState>()
                    .onPhotoSelect(state.url, value ?? false);
              },
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
