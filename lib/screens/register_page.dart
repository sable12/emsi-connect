import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Nom complet',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              final name = (value ?? '').trim();
              if (name.isEmpty) return 'Nom obligatoire';
              if (name.length < 2) return 'Au moins 2 caractères';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              final email = (value ?? '').trim();
              if (email.isEmpty) return 'Email obligatoire';
              if (!email.contains('@')) return 'Email invalide';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: !_showPassword,
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () =>
                    setState(() => _showPassword = !_showPassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mot de passe obligatoire';
              }
              if (value.length < 8) return 'Au moins 8 caractères';
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmController,
            obscureText: !_showPassword,
            decoration: const InputDecoration(
              labelText: 'Confirmer le mot de passe',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirmez votre mot de passe';
              }
              if (value != _passwordController.text) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Formulaire valide — compte non créé'),
                  ),
                );
              }
            },
            child: const Text('Créer mon compte'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final welcome = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.person_add, size: 64, color: colors.primary),
        const SizedBox(height: 16),
        Text(
          'Rejoignez EMSI Connect',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: colors.primary),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 600;
              final form = ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: _buildForm(),
              );

              return Center(
                child: wide
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 280, child: welcome),
                          const SizedBox(width: 48),
                          Flexible(child: form),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          welcome,
                          const SizedBox(height: 24),
                          form,
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}