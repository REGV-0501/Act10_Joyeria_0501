import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF382F32),
        fontFamily: 'Georgia',
      ),
      home: const AdminProductsPage(),
    ));

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  _AdminProductsPageState createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF382F32),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Row(
          children: [
            Icon(Icons.diamond, color: Color(0xFFCB8933)),
            SizedBox(width: 10),
            Text("Panel Admin - Joyería B", style: TextStyle(fontSize: 18, color: Colors.white)),
          ],
        ),
      ),
      drawer: isDesktop ? null : _buildSidebar(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Alinea el contenido al tope (arriba)
        children: [
          if (isDesktop) _buildSidebar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding ajustado
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Asegura que empiece arriba
                children: [
                  _productsTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE SOPORTE ---

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: const Color(0xFF2A2224),
      child: ListView(
        children: [
          _sidebarItem(Icons.analytics, "Dashboard", 0),
          _sidebarItem(Icons.diamond, "Productos", 1),
          _sidebarItem(Icons.sell, "Categorías", 2),
          _sidebarItem(Icons.shopping_cart, "Pedidos", 3),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String title, int itemIndex) {
    bool isActive = itemIndex == _selectedIndex;
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      tileColor: isActive ? const Color(0xFF7E1739) : Colors.transparent,
      onTap: () {
        setState(() => _selectedIndex = itemIndex);
        if (MediaQuery.of(context).size.width <= 900) Navigator.pop(context);
      },
    );
  }

  // --- TABLA DE PRODUCTOS ---

  Widget _productsTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(const Color(0xFF382F32)),
          columns: const [
            DataColumn(label: Text('Imagen', style: TextStyle(color: Colors.white))),
            DataColumn(label: Text('Nombre', style: TextStyle(color: Colors.white))),
            DataColumn(label: Text('Precio', style: TextStyle(color: Colors.white))),
            DataColumn(label: Text('Ver', style: TextStyle(color: Colors.white))),
          ],
          rows: [
            // Ejemplo con una URL de imagen real
            _productRow(
              "https://images.unsplash.com/photo-1605100804763-247f67b3557e?q=80&w=200&auto=format&fit=crop", 
              "Anillo Diamante", 
              "1,200.00"
            ),
            _productRow(
              "https://images.unsplash.com/photo-1523170335258-f5ed11844a49?q=80&w=200&auto=format&fit=crop", 
              "Reloj Oro", 
              "2,500.00"
            ),
          ],
        ),
      ),
    );
  }

  DataRow _productRow(String imageUrl, String name, String price) {
    return DataRow(cells: [
      DataCell(
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              // Esto muestra un icono de carga mientras baja la imagen
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.grey),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(width: 50, height: 50, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
              },
            ),
          ),
        ),
      ),
      DataCell(Text(name, style: const TextStyle(fontWeight: FontWeight.bold))),
      DataCell(Text("\$$price")),
      DataCell(
        IconButton(
          icon: const Icon(Icons.visibility, color: Colors.green), // El ojo verde
          onPressed: () {
            print("Ver detalles de $name");
          },
        ),
      ),
    ]);
  }
}