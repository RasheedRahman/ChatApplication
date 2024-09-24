import 'package:contacts_app/pages/contacts_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'contact_provider.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final contactProvider = ContactProvider();
  // await contactProvider.loadContacts();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ContactProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ContactsPage(),
    );
  }
}
