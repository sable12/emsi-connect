import 'package:flutter/material.dart';

class _Rubrique {
  final String titre;
  final IconData icone;
  const _Rubrique(this.titre, this.icone);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _rubriques = [
    _Rubrique('Mes cours', Icons.menu_book),
    _Rubrique('Planning', Icons.calendar_month),
    _Rubrique('Mon profil', Icons.person),
    _Rubrique('Mes tâches', Icons.task_alt),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EMSI Connect',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => debugPrint('Notifications consultées'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => debugPrint('Paramètres bientôt disponibles'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => debugPrint('Fonctionnalité bientôt disponible'),
        child: const Icon(Icons.edit),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                children: [
                  Text(
                    'Bienvenue sur EMSI Connect',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Votre espace universitaire pour accéder à vos cours, '
                    'votre planning et vos informations personnelles.',
                    style: textTheme.bodyLarge
                        ?.copyWith(color: colors.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Apprendre, organiser, réussir !',
                    style: textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: colors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Image.asset(
                    'assets/images/emsi_logo.png',
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth < 600 ? 2 : 3;
                      return GridView.count(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (final r in _rubriques)
                            Card(
                              margin: EdgeInsets.zero,
                              color: colors.primaryContainer,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => debugPrint('${r.titre} ouvert'),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      r.icone,
                                      size: 40,
                                      color: colors.onPrimaryContainer,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      r.titre,
                                      style: TextStyle(
                                        color: colors.onPrimaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}