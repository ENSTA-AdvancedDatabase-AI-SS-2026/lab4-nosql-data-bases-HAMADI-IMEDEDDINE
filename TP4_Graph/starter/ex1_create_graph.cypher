// TP4 - Exercice 1 : Création du graphe UniConnect DZ
MATCH (n) DETACH DELETE n;

// ─── 1.1 : Contraintes d'unicité ─────────────────────────────────────────────
CREATE CONSTRAINT etudiant_id IF NOT EXISTS FOR (e:Etudiant) REQUIRE e.id IS UNIQUE;
CREATE CONSTRAINT cours_code IF NOT EXISTS FOR (c:Cours) REQUIRE c.code IS UNIQUE;
CREATE CONSTRAINT competence_nom IF NOT EXISTS FOR (c:Competence) REQUIRE c.nom IS UNIQUE;

// ─── 1.2 : Créer les compétences ──────────────────────────────────────────────
UNWIND [
  {nom: "Python", categorie: "Programmation"},
  {nom: "Java", categorie: "Programmation"},
  {nom: "SQL", categorie: "Bases de Données"},
  {nom: "NoSQL", categorie: "Bases de Données"},
  {nom: "Machine Learning", categorie: "IA"},
  {nom: "Deep Learning", categorie: "IA"},
  {nom: "React", categorie: "Web"},
  {nom: "Docker", categorie: "DevOps"},
  {nom: "Linux", categorie: "Systèmes"},
  {nom: "Réseaux", categorie: "Infrastructure"}
] AS comp
MERGE (:Competence {nom: comp.nom, categorie: comp.categorie});

// ─── 1.3 : Créer les cours ────────────────────────────────────────────────────
UNWIND [
  {code: "INFO401", intitule: "Bases de Données Avancées", credits: 6, dept: "Informatique"},
  {code: "INFO402", intitule: "Intelligence Artificielle", credits: 6, dept: "Informatique"},
  {code: "INFO403", intitule: "Développement Web", credits: 4, dept: "Informatique"},
  {code: "INFO404", intitule: "Systèmes Distribués", credits: 5, dept: "Informatique"},
  {code: "INFO405", intitule: "Cloud Computing", credits: 4, dept: "Informatique"}
] AS cours
MERGE (:Cours {code: cours.code, intitule: cours.intitule,
               credits: cours.credits, departement: cours.dept});

// ─── 1.4 : Créer les étudiants ────────────────────────────────────────────────
UNWIND [
  {id: "E001", prenom: "Ahmed", nom: "Bensalem", universite: "USTHB", filiere: "Informatique", annee: 3, ville: "Alger"},
  {id: "E002", prenom: "Fatima", nom: "Ouali", universite: "USTHB", filiere: "Informatique", annee: 3, ville: "Alger"},
  {id: "E003", prenom: "Yacine", nom: "Kaci", universite: "USTHB", filiere: "GL", annee: 2, ville: "Blida"},
  {id: "E004", prenom: "Imene", nom: "Zerrouki", universite: "UMBB", filiere: "Informatique", annee: 4, ville: "Boumerdes"},
  {id: "E005", prenom: "Nassim", nom: "Haddad", universite: "USTO", filiere: "Telecoms", annee: 3, ville: "Oran"},
  {id: "E006", prenom: "Salma", nom: "Bouzid", universite: "UMC", filiere: "Mathematiques", annee: 2, ville: "Constantine"},
  {id: "E007", prenom: "Karim", nom: "Meziane", universite: "UBMA", filiere: "Electronique", annee: 3, ville: "Annaba"},
  {id: "E008", prenom: "Lina", nom: "Cherif", universite: "USTHB", filiere: "Informatique", annee: 1, ville: "Alger"},
  {id: "E009", prenom: "Omar", nom: "Djebbar", universite: "USTO", filiere: "GL", annee: 4, ville: "Oran"},
  {id: "E010", prenom: "Sara", nom: "Benali", universite: "UMBB", filiere: "Informatique", annee: 2, ville: "Boumerdes"},
  {id: "E011", prenom: "Rania", nom: "Khelifi", universite: "UMC", filiere: "Informatique", annee: 3, ville: "Constantine"},
  {id: "E012", prenom: "Mehdi", nom: "Tahar", universite: "USTHB", filiere: "Telecoms", annee: 4, ville: "Alger"},
  {id: "E013", prenom: "Anis", nom: "Farah", universite: "USTO", filiere: "Informatique", annee: 2, ville: "Oran"},
  {id: "E014", prenom: "Houda", nom: "Ait", universite: "UBMA", filiere: "GL", annee: 3, ville: "Annaba"},
  {id: "E015", prenom: "Bilal", nom: "Saidi", universite: "UMBB", filiere: "Informatique", annee: 1, ville: "Boumerdes"},
  {id: "E016", prenom: "Sofiane", nom: "Mokrani", universite: "USTHB", filiere: "Mathematiques", annee: 4, ville: "Alger"},
  {id: "E017", prenom: "Aya", nom: "Chergui", universite: "UMC", filiere: "Informatique", annee: 2, ville: "Constantine"},
  {id: "E018", prenom: "Walid", nom: "Bachir", universite: "USTO", filiere: "Electronique", annee: 3, ville: "Oran"},
  {id: "E019", prenom: "Dina", nom: "Hamadi", universite: "USTHB", filiere: "Informatique", annee: 4, ville: "Alger"},
  {id: "E020", prenom: "Amine", nom: "Rachedi", universite: "UBMA", filiere: "Informatique", annee: 2, ville: "Annaba"},

  {id: "E021", prenom: "Hichem", nom: "Larbi", universite: "UMBB", filiere: "GL", annee: 3, ville: "Boumerdes"},
  {id: "E022", prenom: "Nour", nom: "Belaid", universite: "USTO", filiere: "Informatique", annee: 1, ville: "Oran"},
  {id: "E023", prenom: "Zineb", nom: "Fekir", universite: "UMC", filiere: "Mathematiques", annee: 2, ville: "Constantine"},
  {id: "E024", prenom: "Youssef", nom: "Boussaad", universite: "USTHB", filiere: "Telecoms", annee: 3, ville: "Alger"},
  {id: "E025", prenom: "Meriem", nom: "Ghezali", universite: "UBMA", filiere: "Informatique", annee: 4, ville: "Annaba"},
  {id: "E026", prenom: "Reda", nom: "Kouachi", universite: "USTO", filiere: "GL", annee: 2, ville: "Oran"},
  {id: "E027", prenom: "Chahinez", nom: "Dali", universite: "UMBB", filiere: "Informatique", annee: 3, ville: "Boumerdes"},
  {id: "E028", prenom: "Fares", nom: "Ziani", universite: "USTHB", filiere: "Informatique", annee: 1, ville: "Alger"},
  {id: "E029", prenom: "Sana", nom: "Belkacem", universite: "UMC", filiere: "Electronique", annee: 4, ville: "Constantine"},
  {id: "E030", prenom: "Adel", nom: "Messaoud", universite: "UBMA", filiere: "Informatique", annee: 2, ville: "Annaba"},
  {id: "E031", prenom: "Ilyes", nom: "Saad", universite: "USTO", filiere: "Telecoms", annee: 3, ville: "Oran"},
  {id: "E032", prenom: "Nadia", nom: "Amrane", universite: "USTHB", filiere: "GL", annee: 4, ville: "Alger"},
  {id: "E033", prenom: "Khaled", nom: "Bendjebbar", universite: "UMBB", filiere: "Informatique", annee: 2, ville: "Boumerdes"},
  {id: "E034", prenom: "Mounir", nom: "Tayeb", universite: "UMC", filiere: "Mathematiques", annee: 3, ville: "Constantine"},
  {id: "E035", prenom: "Hiba", nom: "Sahraoui", universite: "UBMA", filiere: "Informatique", annee: 1, ville: "Annaba"},
  {id: "E036", prenom: "Rachid", nom: "Guerfi", universite: "USTHB", filiere: "Informatique", annee: 4, ville: "Alger"},
  {id: "E037", prenom: "Lydia", nom: "Benkhelifa", universite: "USTO", filiere: "GL", annee: 2, ville: "Oran"},
  {id: "E038", prenom: "Islem", nom: "Derradji", universite: "UMBB", filiere: "Informatique", annee: 3, ville: "Boumerdes"},
  {id: "E039", prenom: "Mohamed", nom: "Kaci", universite: "UMC", filiere: "Electronique", annee: 4, ville: "Constantine"},
  {id: "E040", prenom: "Yasmine", nom: "Haddadi", universite: "UBMA", filiere: "Informatique", annee: 2, ville: "Annaba"},
  {id: "E041", prenom: "Tarek", nom: "Belhoucine", universite: "USTHB", filiere: "Telecoms", annee: 3, ville: "Alger"},
  {id: "E042", prenom: "Sofiane", nom: "Mehdi", universite: "USTO", filiere: "Informatique", annee: 1, ville: "Oran"},
  {id: "E043", prenom: "Asma", nom: "Bouarif", universite: "UMBB", filiere: "GL", annee: 2, ville: "Boumerdes"},
  {id: "E044", prenom: "Zakaria", nom: "Hamza", universite: "UMC", filiere: "Informatique", annee: 3, ville: "Constantine"},
  {id: "E045", prenom: "Nabil", nom: "Kherrazi", universite: "UBMA", filiere: "Electronique", annee: 4, ville: "Annaba"},
  {id: "E046", prenom: "Imad", nom: "Boudiaf", universite: "USTHB", filiere: "Informatique", annee: 2, ville: "Alger"},
  {id: "E047", prenom: "Kenza", nom: "Rebbah", universite: "USTO", filiere: "GL", annee: 3, ville: "Oran"},
  {id: "E048", prenom: "Anes", nom: "Mansouri", universite: "UMBB", filiere: "Informatique", annee: 4, ville: "Boumerdes"},
  {id: "E049", prenom: "Marwa", nom: "Bensaber", universite: "UMC", filiere: "Mathematiques", annee: 2, ville: "Constantine"},
  {id: "E050", prenom: "Hamza", nom: "Dahmani", universite: "UBMA", filiere: "Informatique", annee: 3, ville: "Annaba"}
] AS data
MERGE (e:Etudiant {id: data.id})
SET e += data;