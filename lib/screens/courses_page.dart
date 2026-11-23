import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Défi A : Liste de données riche sous forme de liste de Map
    // Contient plus de 6 modules avec nom, enseignant, heures et icône
    final List<Map<String, dynamic>> modules = [
      {
        'nom': 'Développement Multi-Plateforme',
        'enseignant': 'Mme Aouraghe',
        'heures': 32,
        'code': 'DEV501',
        'icon': Icons.menu_book,
      },
      {
        'nom': 'Bases de données avancées',
        'enseignant': 'M. Benjelloun',
        'heures': 28,
        'code': 'BDA502',
        'icon': Icons.storage,
      },
      {
        'nom': 'Cybersécurité & Audit',
        'enseignant': 'M. El Idrissi',
        'heures': 30,
        'code': 'SEC503',
        'icon': Icons.security,
      },
      {
        'nom': 'Intelligence Artificielle & Data',
        'enseignant': 'Mme Tazi',
        'heures': 36,
        'code': 'IA504',
        'icon': Icons.psychology,
      },
      {
        'nom': 'Réseaux informatiques & Télécoms',
        'enseignant': 'M. Chraibi',
        'heures': 26,
        'code': 'RES505',
        'icon': Icons.network_check,
      },
      {
        'nom': 'Gestion de projet & Méthodes Agiles',
        'enseignant': 'Mme Bennani',
        'heures': 24,
        'code': 'MGT506',
        'icon': Icons.computer,
      },
      {
        'nom': 'Architectures Cloud & Microservices',
        'enseignant': 'M. Alami',
        'heures': 32,
        'code': 'CLD507',
        'icon': Icons.cloud,
      },
      {
        'nom': 'DevOps & Intégration Continue',
        'enseignant': 'M. Mansouri',
        'heures': 28,
        'code': 'DEV508',
        'icon': Icons.terminal,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mes cours',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
      ),
      // Section : Comprendre les contraintes de hauteur
      // Utilisation d'une Column avec un titre fixe et un Expanded pour la ListView défilante
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre fixe en haut de la page (ne défile pas)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Modules du semestre',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.shade200),
                  ),
                  child: Text(
                    '${modules.length} cours',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Consultez vos matières, enseignants et volumes horaires :',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),

          // Expanded indispensable dans une Column pour contraindre la hauteur de la ListView
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: modules.length,
              itemBuilder: (context, index) {
                final module = modules[index];

                return Card(
                  // Élévation de 2 (testée également à 0 et 6)
                  elevation: 2,
                  // Marge inférieure de 12 entre les cartes
                  margin: const EdgeInsets.only(bottom: 12),
                  // Coins arrondis avec un rayon de 14
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    // Défi B : CircleAvatar affichant le numéro du module à gauche
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal.shade100,
                      foregroundColor: Colors.teal.shade900,
                      radius: 20,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // Titre avec le nom du module (Défi D : TextOverflow.ellipsis pour petits écrans)
                    title: Text(
                      module['nom'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Sous-titre avec enseignant et volume horaire
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '${module['enseignant']} • ${module['heures']} heures (${module['code']})',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Flèche à droite
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.teal,
                    ),
                    // Interaction au clic (onTap) : console + SnackBar personnalisé (Défi C)
                    onTap: () {
                      // Message dans la console de débogage
                      debugPrint('Module sélectionné : ${module['nom']}');

                      // Affichage d'un SnackBar informatif
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Module sélectionné : ${module['nom']}'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.teal.shade800,
                          action: SnackBarAction(
                            label: 'OK',
                            textColor: Colors.amberAccent,
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
         /* // Bouton de retour explicite (Navigator.pop)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Retour'),
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
