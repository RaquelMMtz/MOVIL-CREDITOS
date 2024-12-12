import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharon/login_screen.dart';
import 'package:sharon/pago_screen.dart';
import 'package:sharon/solicitud_screen.dart';
import 'package:sharon/usuario_screen.dart';
import 'catalogo_screen.dart';
import 'consultas_screen.dart';
import 'resumen_screen.dart'; // Pantalla Resumen (creada más adelante)

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Controla qué pantalla se muestra
  String _userEmail = "Cargando..."; // Variable para almacenar el correo electrónico del usuario

  final List<Widget> _screens = [
    ResumenScreen(),
    ConsultasScreen(), // Pantalla de Consultas
    SolicitudScreen(), // Pantalla de Aumentar Crédito
    PagoScreen(), // Pantalla de Pagar Crédito
    CatalogoScreen(), // Pantalla de Catálogo
    UsuarioScreen(), // Pantalla de Perfil
    LoginScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('email') ?? 'Sin correo registrado';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Cerrar el Drawer al seleccionar
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pantalla Principal"),
        backgroundColor: Colors.blue.shade700,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.blue.shade700),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bienvenido',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    _userEmail, // Mostrar el correo del usuario
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              asset: 'lib/img/asdfgh.png', // Ruta al ícono personalizado
              text: 'Resumen',
              index: 0,
              onTap: () => _onItemTapped(0),
            ),
            _buildDrawerItem(
              asset: 'lib/img/Imagen111.png', // Ruta al ícono personalizado
              text: 'Consultas',
              index: 1,
              onTap: () => _onItemTapped(1),
            ),
            _buildDrawerItem(
              asset: 'lib/img/aume.png', // Ruta al ícono personalizado
              text: 'Aumentar Crédito',
              index: 2,
              onTap: () => _onItemTapped(2),
            ),
            _buildDrawerItem(
              asset: 'lib/img/pagarc.png', // Ruta al ícono personalizado
              text: 'Pagar Crédito',
              index: 3,
              onTap: () => _onItemTapped(3),
            ),
            _buildDrawerItem(
              asset: 'lib/img/carr.png', // Ruta al ícono personalizado
              text: 'Catálogo',
              index: 4,
              onTap: () => _onItemTapped(4),
            ),
            _buildDrawerItem(
              asset: 'lib/img/Imagen6.png', // Ruta al ícono personalizado
              text: 'Perfil',
              index: 5,
              onTap: () => _onItemTapped(5),
            ),
            Divider(),
            _buildDrawerItem(
              asset: 'lib/img/Imagen7.png', // Ruta al ícono personalizado
              text: 'Cerrar Sesión',
              index: null,
              onTap: () {
                Navigator.pop(context); // Cierra el Drawer
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), // Redirige a LoginScreen
                );
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }

  Widget _buildDrawerItem(
      {String? asset,
        IconData? icon,
        required String text,
        required int? index,
        required VoidCallback onTap}) {
    return ListTile(
      leading: asset != null
          ? Image.asset(
        asset,
        width: 24,
        height: 24,
      )
          : Icon(icon, color: Colors.blue.shade700),
      title: Text(text),
      onTap: onTap,
    );
  }
}
