import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => AppState(), child: MyApp()));
}

class ScreenItem {
  final String title;
  final IconData icon;
  ScreenItem(this.title, this.icon);
}

class AppState extends ChangeNotifier {
  int _bottomNavIndex;

  ScreenItem _selectedHomeScreenItem;
  String _selectedSettingItem;

  AppState() : _bottomNavIndex = 0;
  int get bottomNavIndex => _bottomNavIndex;
  set bottomNavIndex(int i) {
    _bottomNavIndex = i;
    _selectedHomeScreenItem = null;
    _selectedSettingItem = null;
    notifyListeners();
  }

  ScreenItem get homeScreenItem => _selectedHomeScreenItem;
  set homeScreenItem(ScreenItem i) {
    _selectedHomeScreenItem = i;
    notifyListeners();
  }

  String get selectedSettingItem => _selectedSettingItem;

  set selectedSettingItem(String item) {
    _selectedSettingItem = item;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.deepPurpleAccent[400],
      ),
      home: Shell(),
    );
  }
}

class Shell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Headline'),
      ),
      body: Navigator(
        onPopPage: (route, result) {
          return route.didPop(result);
        },
        pages: [
          if (state.bottomNavIndex == 0)
            MaterialPage(key: ValueKey('HomeTab'), child: HomeTab())
          else
            MaterialPage(key: ValueKey('SettingTab'), child: SettingTab()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        fixedColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
        ],
        currentIndex: state.bottomNavIndex,
        onTap: (i) {
          Provider.of<AppState>(context, listen: false).bottomNavIndex = i;
        },
      ),
    );
  }
}

// ホームTab
class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onPopPage: (route, result) {
        return route.didPop(result);
      },
      pages: [
        MaterialPage(child: HomeScreen()),
        if (Provider.of<AppState>(context).homeScreenItem != null)
          MaterialPage(
              child: DetailScreen(
            item: Provider.of<AppState>(context).homeScreenItem,
          ))
      ],
    );
  }
}

//ホーム画面
class HomeScreen extends StatelessWidget {
  final items = <ScreenItem>[
    ScreenItem('Airplane Mode', Icons.airplanemode_active),
    ScreenItem('Wifi', Icons.wifi),
    ScreenItem('Bluetooth', Icons.bluetooth)
  ];
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var item in items)
          ListTile(
            leading: Icon(item.icon),
            title: Text(item.title),
            onTap: () {
              Provider.of<AppState>(context, listen: false).homeScreenItem =
                  item;
            },
          )
      ],
    );
  }
}

//ホームの詳細画面
class DetailScreen extends StatelessWidget {
  final ScreenItem item;
  DetailScreen({@required this.item});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(item.icon), Text(item.title)],
    );
  }
}

//設定Tab
class SettingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
        onPopPage: (route, result) {
          return route.didPop(result);
        },
        pages: [
          MaterialPage(child: SettingScreen()),
          if (Provider.of<AppState>(context).selectedSettingItem != null)
            MaterialPage(
                child: SettingDetailScreen(
              item: Provider.of<AppState>(context).selectedSettingItem,
            ))
        ]);
  }
}

//設定画面
class SettingScreen extends StatelessWidget {
  final items = <String>[
    'Airplane Mode',
    'Wifi',
    'Bluetooth',
    'Airplane Mode',
    'Wifi',
    'Bluetooth',
  ];
  SettingScreen();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var item in items)
          ListTile(
              title: Text(item),
              onTap: () {
                Provider.of<AppState>(context, listen: false)
                    .selectedSettingItem = item;
              })
      ],
    );
  }
}

//設定の詳細画面
class SettingDetailScreen extends StatelessWidget {
  final String item;
  SettingDetailScreen({@required this.item});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(this.item),
    );
  }
}
