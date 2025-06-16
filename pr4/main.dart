import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ScreenModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Design',
      theme: ThemeData(primarySwatch: Colors.blue),
      onGenerateRoute: (settings) {
        if (settings.name == '/popular') {
          return MaterialPageRoute(builder: (_) => const PopularMenuScreen());
        } else if (settings.name == '/design') {
          return MaterialPageRoute(builder: (_) => const DesignScreen());
        } else if (settings.name == '/wallet') {
          return MaterialPageRoute(builder: (_) => const WalletScreen());
        } else if (settings.name == '/organizer') {
          return MaterialPageRoute(builder: (_) => const OrganizerScreen());
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Popular Menu'),
            onTap: () => Navigator.pushNamed(context, '/popular'),
          ),
          ListTile(
            title: const Text('3D Design Basic'),
            onTap: () => Navigator.pushNamed(context, '/design'),
          ),
          ListTile(
            title: const Text('My E-Wallet'),
            onTap: () => Navigator.pushNamed(context, '/wallet'),
          ),
          ListTile(
            title: const Text('Organizer'),
            onTap: () => Navigator.pushNamed(context, '/organizer'),
          ),
        ],
      ),
    );
  }
}

class PopularMenuScreen extends StatelessWidget {
  const PopularMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Menu')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 10),
          _buildMenuItem('Original Salad', 'Lowy Food', '\$8'),
          _buildMenuItem('Fresh Salad', 'Cloudy Resto', '\$10'),
          _buildMenuItem('Yummie Ice Cream', 'Circla Resto', '\$6'),
          _buildMenuItem('Vegan Special', 'Haty Food', '\$11'),
          _buildMenuItem('Mixed Pasta', 'Recto Food', '\$13'),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.home, color: Colors.red),
              Icon(Icons.shopping_cart, color: Colors.red),
              Icon(Icons.person, color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, String subtitle, String price) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.fastfood),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(price, style: const TextStyle(color: Colors.red)),
      ),
    );
  }
}

class DesignScreen extends StatelessWidget {
  const DesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3D Design Basic')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: NetworkImage('https://via.placeholder.com/300x200'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 10),
            const Text('3D Design Basic', style: TextStyle(fontSize: 20)),
            const Text('Best Seller', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            const Text(
              'In this course you will learn how to build a space to a 3-dimensional product. There are 24 premium learning videos for you.',
            ),
            const SizedBox(height: 10),
            const Text('24 Lessons (20 hours)'),
            const Text('See all', style: TextStyle(color: Colors.blue)),
            const SizedBox(height: 10),
            const Text('Introduction to 3D', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Enroll - \$24.99'),
            ),
          ],
        ),
      ),
    );
  }
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My E-Wallet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Andrew Ainsley', style: TextStyle(fontSize: 20)),
            const Text('Your balance', style: TextStyle(color: Colors.grey)),
            const Text('\$9,379', style: TextStyle(fontSize: 30, color: Colors.black)),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Top Up'),
            ),
            const SizedBox(height: 20),
            const Text('Transaction History', style: TextStyle(fontSize: 18)),
            _buildTransaction('Lawson Chair', 'Dec 15, 2024 11:00 AM', '\$120', 'Orders'),
            _buildTransaction('Top Up Wallet', 'Dec 14, 2024 16:42 PM', '\$400', 'Top Up'),
            _buildTransaction('Parabolic Reflector', 'Dec 14, 2024 11:19 AM', '\$170', 'Orders'),
            _buildTransaction('Mini Wooden Table', 'Dec 13, 2024 14:46 PM', '\$165', 'Orders'),
            _buildTransaction('Top Up Wallet', 'Dec 12, 2024 10:27 AM', '\$300', 'Top Up'),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.home),
                Icon(Icons.store),
                Icon(Icons.wallet),
                Icon(Icons.person),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransaction(String title, String date, String amount, String status) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.circle)),
      title: Text(title),
      subtitle: Text(date),
      trailing: Text(amount, style: TextStyle(color: status == 'Top Up' ? Colors.green : Colors.red)),
    );
  }
}

class OrganizerScreen extends StatelessWidget {
  const OrganizerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organizer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage('https://via.placeholder.com/80'),
            ),
            const SizedBox(height: 10),
            const Text('Albert Flores', style: TextStyle(fontSize: 20)),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('2,368', style: TextStyle(fontSize: 16)),
                Text('346', style: TextStyle(fontSize: 16)),
                Text('13', style: TextStyle(fontSize: 16)),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Followers'),
                Text('Following'),
                Text('Events'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Follow'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('Messages'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text('About', style: TextStyle(fontSize: 18)),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Events')),
                ElevatedButton(onPressed: () {}, child: const Text('Reviews')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}