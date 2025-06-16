import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScreenModel()),
        ChangeNotifierProvider(create: (_) => ItemListModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draggable Navigation App',
      theme: ThemeData(primarySwatch: Colors.blue),
      onGenerateRoute: (settings) {
        if (settings.name == '/add') {
          return MaterialPageRoute(builder: (_) => const AddScreen());
        } else if (settings.name == '/edit') {
          return MaterialPageRoute(builder: (_) => const EditScreen());
        }
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      },
      initialRoute: '/',
    );
  }
}

class ScreenModel extends ChangeNotifier {
  int selectedIndex = 0;

  void updateIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

class ItemListModel extends ChangeNotifier {
  final List<String> _items = List<String>.generate(3, (i) => 'Item ${i + 1}');

  List<String> get items => _items;

  void reorderItems(int oldIndex, int newIndex) {
    final item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item);
    notifyListeners();
  }

  void addItem() {
    _items.add('Item ${_items.length + 1}');
    notifyListeners();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final itemListModel = Provider.of<ItemListModel>(context);
    final model = Provider.of<ScreenModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ReorderableListView.builder(
        itemCount: itemListModel.items.length,
        itemBuilder: (context, index) {
          final item = itemListModel.items[index];
          return ListTile(
            key: Key(item),
            title: Text(item),
            trailing: ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle),
            ),
            onTap: () {
              if (item.contains('Add')) {
                Navigator.pushNamed(context, '/add');
              } else if (item.contains('Edit')) {
                Navigator.pushNamed(context, '/edit');
              }
            },
          );
        },
        onReorder: (int oldIndex, int newIndex) {
          itemListModel.reorderItems(oldIndex, newIndex);
          model.updateIndex(newIndex);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          itemListModel.addItem();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is Add Screen'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditScreen extends StatelessWidget {
  const EditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('This is Edit Screen'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}