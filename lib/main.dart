import 'package:antaragnitask/contact/addContact.dart';
import 'package:antaragnitask/contact/contactProvider.dart';
import 'package:antaragnitask/contact/contactwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBcDJ9LP8X6ND7gfvLw1Ye8OyN22L-zJQI',
      appId: '1:604557329295:android:780a886c28357b531241fa',
      messagingSenderId: '604557329295',
      projectId: 'antaragniapp',
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContactsProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xffADEFD1FF)),
            useMaterial3: true,
            fontFamily: "NG",
            inputDecorationTheme: InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff00203F)),
              ),
              labelStyle: TextStyle(color: Color(0xff00203F)),
            ),
            textSelectionTheme:
                TextSelectionThemeData(cursorColor: Color(0xff00203F)),
            appBarTheme: AppBarTheme(
                backgroundColor: Color(0xff333333),
                foregroundColor: Colors.white),
            scaffoldBackgroundColor: Color(0xffADEFd1),
            textTheme: TextTheme(bodyMedium: TextStyle()).apply(
                bodyColor: Color(0xff00203F), displayColor: Color(0xFF00203F))),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddContact()));
                },
                icon: Icon(Icons.add))
          ],
        ),
        body: Consumer<ContactsProvider>(
            builder: (context, contactsProvider, child) {
          return StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('Contact').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final contacts = snapshot.data!.docs
                  .map((doc) => Contact.fromFirestore(doc))
                  .toList();
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(contact.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(contact.email),
                          Text(contact.phoneNumber)
                        ],
                      ),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: contact.image != null
                            ? FileImage(contact.image!)
                            : AssetImage('assets/images/default.png')
                                as ImageProvider,
                      ),
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xFF00203F)),
                          borderRadius: BorderRadius.circular(6)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddContact(
                                    contact:
                                        contact, // Pass the contact to edit
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              contactsProvider.removeContact(contact.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }));
  }
}
