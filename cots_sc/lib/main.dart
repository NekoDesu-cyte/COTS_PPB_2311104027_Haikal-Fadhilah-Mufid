import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Wajib import ini
import 'package:supabase_flutter/supabase_flutter.dart';


import '/cots/controllers/task_controller.dart';
import '/cots/presentation/pages/beranda.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase
  await Supabase.initialize(
    url: 'https://rpblbedyqmnzpowbumzd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJwYmxiZWR5cW1uenBvd2J1bXpkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgxMjcxMjYsImV4cCI6MjA3MzcwMzEyNn0.QaMJlyqhZcPorbFUpImZAynz3o2l0xDfq_exf2wUrTs',
  );

  //  Jalankan Aplikasi (Ini yang tadi hilang)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskController()..fetchTasks()), 
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Manajemen Tugas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const BerandaPage(),
      ),
    );
  }
}