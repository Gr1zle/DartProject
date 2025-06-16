import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(MovieAdapter());
  await Hive.openBox<Movie>('moviesBox');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Box<Movie> movieBox;
  bool isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    movieBox = Hive.box<Movie>('moviesBox');
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    });
  }

  Future<void> _saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', value);
    setState(() {
      isDarkTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorite Movies',
      theme: isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: const HomeScreen(),
    );
  }
}

class Movie {
  String title;
  int year;
  String genre;
  String? imageUrl;

  Movie({required this.title, required this.year, required this.genre, this.imageUrl});

  Map<String, dynamic> toMap() => {
    'title': title,
    'year': year,
    'genre': genre,
    'imageUrl': imageUrl,
  };
}

class MovieAdapter extends TypeAdapter<Movie> {
  @override
  final int typeId = 0;

  @override
  Movie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movie(
      title: fields[0] as String,
      year: fields[1] as int,
      genre: fields[2] as String,
      imageUrl: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.year)
      ..writeByte(2)
      ..write(obj.genre)
      ..writeByte(3)
      ..write(obj.imageUrl);
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();
  final _genreController = TextEditingController();
  final _imageUrlController = TextEditingController();
  late Box<Movie> movieBox;

  @override
  void initState() {
    super.initState();
    movieBox = Hive.box<Movie>('moviesBox');
  }

  void _addOrEditMovie({Movie? movie}) {
    if (movie != null) {
      _titleController.text = movie.title;
      _yearController.text = movie.year.toString();
      _genreController.text = movie.genre;
      _imageUrlController.text = movie.imageUrl ?? '';
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(movie == null ? 'Add Movie' : 'Edit Movie'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: _yearController, decoration: const InputDecoration(labelText: 'Year'), keyboardType: TextInputType.number),
            TextField(controller: _genreController, decoration: const InputDecoration(labelText: 'Genre')),
            TextField(controller: _imageUrlController, decoration: const InputDecoration(labelText: 'Image URL')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _titleController.clear();
              _yearController.clear();
              _genreController.clear();
              _imageUrlController.clear();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newMovie = Movie(
                title: _titleController.text,
                year: int.parse(_yearController.text),
                genre: _genreController.text,
                imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
              );
              if (movie == null) {
                movieBox.add(newMovie);
              } else {
                final index = movieBox.values.toList().indexOf(movie);
                movieBox.putAt(index, newMovie);
              }
              Navigator.pop(context);
              _titleController.clear();
              _yearController.clear();
              _genreController.clear();
              _imageUrlController.clear();
              setState(() {});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteMovie(int index) {
    movieBox.deleteAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettings(context),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: movieBox.listenable(),
        builder: (context, Box<Movie> box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('No movies added yet.'));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final movie = box.getAt(index)!;
              return ListTile(
                leading: movie.imageUrl != null
                    ? Image.network(movie.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.movie, size: 50),
                title: Text(movie.title),
                subtitle: Text('${movie.year} - ${movie.genre}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteMovie(index),
                ),
                onTap: () => _addOrEditMovie(movie: movie),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditMovie(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Dark Theme'),
              value: (context.findAncestorWidgetOfExactType<MyApp>() as _MyAppState).isDarkTheme,
              onChanged: (value) => (context.findAncestorWidgetOfExactType<MyApp>() as _MyAppState)._saveTheme(value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}