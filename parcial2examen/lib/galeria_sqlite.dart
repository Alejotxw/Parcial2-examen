import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'database_helper.dart';

class GaleriaSQLite extends StatefulWidget {
  @override
  _GaleriaSQLiteState createState() => _GaleriaSQLiteState();
}

class _GaleriaSQLiteState extends State<GaleriaSQLite> {
  // VARIACIÓN INDIVIDUAL: D = 4
  final String miIdentificador = "Alejo-4"; 
  late Future<List<Map<String, dynamic>>> _futureDatos;

  @override
  void initState() {
    super.initState();
    // Leemos de SQLite pasando nuestro identificador
    _futureDatos = DatabaseHelper.instance.getMisRegistros(miIdentificador);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Galería desde SQLite")),
      body: Column(
        children: [
          // TEXTO OBLIGATORIO EN LA PARTE SUPERIOR
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20),
            color: const Color.fromARGB(255, 0, 234, 255),
            child: Text(
              "Autor: $miIdentificador",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureDatos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                
                final lista = snapshot.data ?? [];

                if (lista.isEmpty) {
                  return Center(child: Text("No hay datos para el autor $miIdentificador"));
                }

                // LISTVIEW.BUILDER EFICIENTE
                return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, index) {
                    final item = lista[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: item['imageUrl'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        title: Text(item['titulo']),
                        subtitle: Text("Autor en DB: ${item['autor']}"),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
