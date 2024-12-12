import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  File? _ineFile;
  File? _addressProofFile;

  final _formKey = GlobalKey<FormState>();
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _ineFileError;
  String? _addressProofFileError;

  void _register() async {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    final phoneRegex = RegExp(r'^\d{10}$');
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _emailError = null;
      _phoneError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _ineFileError = null;
      _addressProofFileError = null;
    });

    if (_ineFile == null) {
      setState(() {
        _ineFileError = "Por favor, sube la foto de tu INE.";
      });
    }

    if (_addressProofFile == null) {
      setState(() {
        _addressProofFileError = "Por favor, sube el comprobante de domicilio en formato PDF.";
      });
    }

    if (!emailRegex.hasMatch(_emailController.text)) {
      setState(() {
        _emailError = "Por favor, introduce un correo electrónico válido.";
      });
    }

    if (!phoneRegex.hasMatch(_phoneController.text)) {
      setState(() {
        _phoneError = "El número de teléfono debe tener 10 dígitos y contener solo números.";
      });
    }

    if (password.length < 6) {
      setState(() {
        _passwordError = "La contraseña debe tener al menos 6 caracteres.";
      });
    }

    if (password != confirmPassword) {
      setState(() {
        _confirmPasswordError = "Las contraseñas no coinciden.";
      });
    }

    if (_emailError == null && _phoneError == null && _passwordError == null && _confirmPasswordError == null && _ineFileError == null && _addressProofFileError == null) {
      // Guardar datos en almacenamiento local
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text);
      await prefs.setString('lastName', _lastNameController.text);
      await prefs.setString('email', _emailController.text);
      await prefs.setString('phone', _phoneController.text);
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('password', password);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro exitoso')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _pickFile({required bool isINE}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: isINE ? FileType.custom : FileType.custom,
      allowedExtensions: isINE ? ['jpg', 'jpeg', 'png'] : ['pdf'],
    );

    if (result != null) {
      setState(() {
        if (isINE) {
          _ineFile = File(result.files.single.path!);
        } else {
          _addressProofFile = File(result.files.single.path!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade600],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'lib/img/imagen8.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Crea una cuenta',
                    style: TextStyle(
                      color: Color(0xFFF5F5DC), // Beige color
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildTextField(controller: _nameController, hint: 'Nombre', icon: Icons.person),
                  SizedBox(height: 15),
                  _buildTextField(controller: _lastNameController, hint: 'Apellido', icon: Icons.person_outline),
                  SizedBox(height: 15),
                  _buildTextField(
                      controller: _emailController,
                      hint: 'Correo electrónico',
                      icon: Icons.email,
                      errorText: _emailError
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                      controller: _phoneController,
                      hint: 'Teléfono',
                      icon: Icons.phone,
                      errorText: _phoneError
                  ),
                  SizedBox(height: 15),
                  _buildTextField(controller: _usernameController, hint: 'Usuario', icon: Icons.account_circle),
                  SizedBox(height: 15),
                  _buildTextField(
                      controller: _passwordController,
                      hint: 'Contraseña',
                      icon: Icons.lock,
                      obscure: true,
                      errorText: _passwordError
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    hint: 'Confirmar contraseña',
                    icon: Icons.lock_outline,
                    obscure: true,
                    errorText: _confirmPasswordError,
                  ),
                  SizedBox(height: 20),
                  _buildFileUploadButton(
                      label: 'Subir foto INE',
                      file: _ineFile,
                      onPressed: () => _pickFile(isINE: true),
                      errorText: _ineFileError
                  ),
                  SizedBox(height: 15),
                  _buildFileUploadButton(
                      label: 'Subir comprobante de domicilio (PDF)',
                      file: _addressProofFile,
                      onPressed: () => _pickFile(isINE: false),
                      errorText: _addressProofFileError
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                    ),
                    child: Text(
                      'Registrarse',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      '¿Ya tienes cuenta? Inicia Sesión',
                      style: TextStyle(color: Color(0xFFF5F5DC)), // Beige color
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.blue),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red.shade50, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildFileUploadButton({
    required String label,
    required File? file,
    required VoidCallback onPressed,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: Icon(Icons.upload_file, color: Colors.white),
          label: Text(label, style: TextStyle(color: Colors.white)),
        ),
        if (file != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              'Archivo seleccionado: ${file.path.split('/').last}',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red.shade50, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
