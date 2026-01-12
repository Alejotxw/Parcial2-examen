import 'package:flutter/material.dart';
import 'galeria_sqlite.dart'; // Asegúrate de que el archivo anterior se llame así

void main() async {
  // 1. Obligatorio al usar código asíncrono (como SQLite) en el main
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prueba SQLite Flujo Completo',
      theme: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true, // Habilita Material 3 para un diseño más moderno
      ),
      // 2. Definimos nuestra pantalla de Galería como la principal
      home: GaleriaSQLite(),
    );
  }
}