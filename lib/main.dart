import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

// COULEURS DE L'APPLICATION
const Color primaryBlue = Color(0xFF1565C0);
const Color darkBlue = Color(0xFF0D47A1);
const Color lightBlue = Color(0xFFE3F2FD);
const Color backgroundColor = Color(0xFFF4F7FB);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CV AKONKWA SEBAKUNGU GERMAIN',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const LoginPage(),
    );
  }
}

// OUVRIR LES APPLICATIONS EXTERNES
Future<void> openExternalLink(
  BuildContext context,
  String link,
) async {
  final Uri uri = Uri.parse(link);

  try {
    final bool opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Impossible d'ouvrir cette application."),
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Une erreur est survenue."),
        ),
      );
    }
  }
}

// PAGE DE CONNEXION
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;

  void login() {
    if (usernameController.text.trim() == 'chris' &&
        passwordController.text == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nom utilisateur ou mot de passe incorrect.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [darkBlue, primaryBlue, Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 48,
                      backgroundColor: lightBlue,
                      child: Icon(
                        Icons.person,
                        size: 55,
                        color: primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'BIENVENUE',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connectez-vous pour consulter mon CV',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: "Nom d'utilisateur",
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: passwordController,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'SE CONNECTER',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
      ),
    );
  }
}

// PAGE PRINCIPALE ET NAVIGATION
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    CVPage(),
    FamilyPage(),
    ContactPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MON ESPACE PERSONNEL',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        backgroundColor: primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: 'Déconnexion',
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Mon CV',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom),
            label: 'Famille',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_mail_outlined),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}

// TITRE DES SECTIONS
class CVSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const CVSection({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: primaryBlue, size: 25),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 25),
            child,
          ],
        ),
      ),
    );
  }
}

// PAGE CV
class CVPage extends StatelessWidget {
  const CVPage({super.key});

  Widget infoLine(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, height: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'web/icons/AKON.JPG',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const CircleAvatar(
                      radius: 75,
                      child: Icon(Icons.person, size: 75),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'AKONKWA SEBAKUNGU GERMAIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Étudiant en informatique | Développement numérique',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        CVSection(
          title: 'Profil personnel',
          icon: Icons.account_circle,
          child: infoLine(
            "Je suis une personne motivée, intéressée par l'informatique, "
            "les nouvelles technologies et le développement numérique. "
            "Je souhaite développer mes compétences et acquérir "
            "de nouvelles expériences professionnelles.",
          ),
        ),
        CVSection(
          title: 'Formation',
          icon: Icons.school,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoLine('• Formation en informatique.'),
              infoLine('• Apprentissage des outils numériques.'),
              infoLine('• Développement des compétences informatiques.'),
            ],
          ),
        ),
        CVSection(
          title: 'Expériences et projets',
          icon: Icons.work,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoLine('• Réalisation de projets informatiques.'),
              infoLine('• Création et apprentissage de sites web.'),
              infoLine('• Découverte du développement mobile.'),
            ],
          ),
        ),
        CVSection(
          title: 'Compétences techniques',
          icon: Icons.computer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoLine('• Informatique générale.'),
              infoLine('• WordPress.'),
              infoLine('• Flutter et développement mobile.'),
              infoLine('• HTML, CSS et technologies numériques.'),
            ],
          ),
        ),
        CVSection(
          title: 'Langues',
          icon: Icons.language,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoLine('• Français.'),
              infoLine('• Anglais.'),
              infoLine('• Swahili.'),
            ],
          ),
        ),
        CVSection(
          title: 'Centres d’intérêt',
          icon: Icons.favorite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoLine('• Informatique et nouvelles technologies.'),
              infoLine('• Football et sport.'),
              infoLine('• Entrepreneuriat.'),
            ],
          ),
        ),
      ],
    );
  }
}

// CARTE D'UN MEMBRE DE LA FAMILLE AVEC PHOTO
class FamilyMemberCard extends StatelessWidget {
  final String name;
  final String relationship;
  final String profession;
  final String activity;
  final String imagePath;

  const FamilyMemberCard({
    super.key,
    required this.name,
    required this.relationship,
    required this.profession,
    required this.activity,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                width: 155,
                height: 155,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 155,
                  height: 155,
                  color: lightBlue,
                  child: const Icon(
                    Icons.person,
                    color: primaryBlue,
                    size: 80,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 13),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              relationship,
              style: const TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profession,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(
              activity,
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

// PAGE FAMILLE
class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Padding(
          padding: EdgeInsets.only(bottom: 18),
          child: Text(
            'MA FAMILLE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
        ),
        FamilyMemberCard(
          name: 'SADIKI SEBAKUNGU',
          relationship: 'PÈRE',
          profession: 'Commerçant et entrepreneur',
          activity: 'Commerce des minerais, pierres précieuses et diamants.',
          imagePath: 'web/family/pere.JPG',
        ),
        FamilyMemberCard(
          name: 'ESPÉRANCE BARUNGU',
          relationship: 'MÈRE',
          profession: 'Commerçante',
          activity: 'Commerce général et vente de marchandises.',
          imagePath: 'web/family/mere.JPG',
        ),
        FamilyMemberCard(
          name: 'BENISSE SEBAKUNGU',
          relationship: 'FRÈRE',
          profession: 'Commerçant',
          activity: 'Vente et distribution de marchandises.',
          imagePath: 'web/family/frere.JPG',
        ),
        FamilyMemberCard(
          name: 'FLORANCE',
          relationship: 'SŒUR',
          profession: 'Commerçante',
          activity: 'Commerce général.',
          imagePath: 'web/family/soeur.JPG',
        ),
      ],
    );
  }
}

// ÉLÉMENT DE CONTACT CLIQUABLE
class ContactItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String link;
  final Color color;

  const ContactItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.link,
    this.color = primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 13),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        subtitle: Text(value),
        trailing: const Icon(
          Icons.open_in_new,
          color: primaryBlue,
        ),
        onTap: () => openExternalLink(context, link),
      ),
    );
  }
}

// PAGE CONTACT
class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 10),
        const Icon(
          Icons.contact_mail,
          color: primaryBlue,
          size: 65,
        ),
        const SizedBox(height: 12),
        const Text(
          'MES COORDONNÉES',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Vous pouvez me contacter en cliquant sur les éléments ci-dessous.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 25),

        ContactItem(
          icon: Icons.person,
          title: 'Nom complet',
          value: 'AKONKWA SEBAKUNGU GERMAIN',
          link: 'https://github.com/akonkwachristian151-stack/cv_flutter_chris',
        ),

        ContactItem(
          icon: Icons.phone,
          title: 'Téléphone 1',
          value: '+243 986 724 371',
          link: 'tel:+243986724371',
          color: Colors.green,
        ),

        ContactItem(
          icon: Icons.phone_android,
          title: 'Téléphone 2',
          value: '+243 840 834 298',
          link: 'tel:+243840834298',
          color: Colors.green,
        ),

        ContactItem(
          icon: Icons.email,
          title: 'Adresse e-mail',
          value: 'akonkwachristian151@gmail.com',
          link: 'mailto:akonkwachristian151@gmail.com',
          color: Colors.red,
        ),

        ContactItem(
          icon: Icons.location_on,
          title: 'Adresse',
          value: 'Avenue de la Mission, quartier Himbi, Goma, RDC',
          link: 'https://www.google.com/maps/search/?api=1&query=Himbi%2C+Goma%2C+RDC',
          color: Colors.orange,
        ),

        ContactItem(
          icon: Icons.code,
          title: 'GitHub',
          value: 'Mon dépôt GitHub',
          link: 'https://github.com/akonkwachristian151-stack/cv_flutter_chris',
          color: Colors.black,
        ),

        ContactItem(
          icon: Icons.work,
          title: 'LinkedIn',
          value: 'Visiter LinkedIn',
          link: 'https://www.linkedin.com/',
          color: Colors.blue,
        ),

        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Merci de votre visite !',
            style: TextStyle(
              color: darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
