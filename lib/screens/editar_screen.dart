import 'package:flutter/material.dart';
import 'package:seminari_flutter/models/user.dart';
//import 'package:go_router/go_router.dart';
import 'package:seminari_flutter/provider/users_provider.dart';
import 'package:provider/provider.dart';
import 'package:seminari_flutter/widgets/Layout.dart';

class EditarScreen extends StatefulWidget {
  final User? user;
  const EditarScreen({required this.user, super.key});

  @override
  State<EditarScreen> createState() => _EditarScreenState();
}

class _EditarScreenState extends State<EditarScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nomController = TextEditingController();
  final edatController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nomController.dispose();
    edatController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: true);

    nomController.text = widget.user == null ? "" : widget.user!.name;
    edatController.text = widget.user == null ? "" : widget.user!.age.toString();
    emailController.text = widget.user == null ? "" : widget.user!.email;

    return LayoutWrapper(
      title: widget.user == null ? "Crear nou usuari" : "Editar usuari",
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user == null ? "Crear nou usuari" : "Editar usuari",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.user == null ?
                              'Omple el formulari a continuació per afegir un nou usuari al sistema.' :
                              'Omple el formulari a continuació per editar un usuari.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildFormField(
                              controller: nomController,
                              label: 'Nom',
                              icon: Icons.person,
                              validator: (value) => value == null || value.isEmpty 
                                  ? 'Cal omplir el nom' 
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            _buildFormField(
                              controller: edatController,
                              label: 'Edat',
                              icon: Icons.cake,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Cal omplir l\'edat';
                                }
                                final age = int.tryParse(value);
                                if (age == null || age < 0) {
                                  return 'Si us plau, insereix una edat vàlida';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildFormField(
                              controller: emailController,
                              label: 'Correu electrònic',
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El correu electrònic no pot estar buit';
                                }
                                if (!value.contains('@')) {
                                  return 'Si us plau insereix una adreça vàlida';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildFormField(
                              controller: passwordController,
                              label: 'Contrasenya',
                              icon: Icons.lock,
                              obscureText: true,
                              validator: (value) {
                                if (widget.user != null && (value == null || value.isEmpty)) return null;

                                if (value == null || value.isEmpty) {
                                  return 'La contrasenya no pot estar buida';
                                }
                                if (value.length < 6) {
                                  return 'La contrasenya ha de tenir almenys 6 caràcters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {

                                  if (widget.user == null) {
                                    provider.crearUsuari(
                                      nomController.text,
                                      int.tryParse(edatController.text) ?? 0,
                                      emailController.text,
                                      passwordController.text,
                                    );
                                  } else {
                                    provider.editarUsuari(
                                      widget.user!.id!,
                                      User(
                                        name: nomController.text,
                                        age: int.tryParse(edatController.text) ?? 0,
                                        email: emailController.text, 
                                        password: passwordController.text
                                      ),
                                      );
                                  }


                                  nomController.clear();
                                  edatController.clear();
                                  emailController.clear();
                                  passwordController.clear();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(widget.user == null ? 'Usuari creat correctament!' : 'Usuari editat correctament!'),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.save),
                              label: Text(
                                widget.user == null ? 'CREAR USUARI' : 'EDITAR USUARI',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}