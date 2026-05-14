# RAPPORT.md — TP4 Neo4j : UniConnect DZ

## 1. Schéma du graphe

Le graphe UniConnect DZ est un graphe de propriétés composé des nœuds suivants :

- **Etudiant**(id, prenom, nom, universite, filiere, annee, ville)
- **Cours**(code, intitule, credits, departement)
- **Competence**(nom, categorie)
- **Club**(nom, universite, domaine)
- **Entreprise**(nom, secteur, ville)

### Relations :

- (Etudiant)-[:CONNAIT]->(Etudiant)
- (Etudiant)-[:SUIT {note, semestre}]->(Cours)
- (Etudiant)-[:MAITRISE {niveau}]->(Competence)

### Exemple de structure :

(Ahmed)-[:CONNAIT]->(Fatima)  
(Ahmed)-[:SUIT]->(INFO401)  
(Ahmed)-[:MAITRISE]->(Python)

---

## 2. Détection de communautés (Louvain)

L’algorithme Louvain a été appliqué sur le graphe `reseau_social`.

### Résultats :

Le graphe est partitionné en plusieurs communautés d’étudiants.

Les regroupements observés sont principalement basés sur :

- l’université
- la filière
- les connexions sociales (CONNAIT)

### Exemples de communautés :

- Communauté 1 : étudiants USTHB (Informatique)
- Communauté 2 : étudiants UMBB (GL / Informatique)
- Communauté 3 : étudiants USTO (Télécoms / GL)
- Communauté 4 : étudiants UMC (Mathématiques / Electronique)
- Communauté 5 : étudiants UBMA (Informatique / Electronique)

### Conclusion :

Les communautés détectées reflètent une structure sociale cohérente basée sur les universités et les filières.

---

## 3. Comparaison SQL vs Cypher

### Exemple : amis d’un étudiant

#### SQL :

```sql
SELECT e2.prenom
FROM Etudiant e1
JOIN CONNAIT c ON e1.id = c.id1
JOIN Etudiant e2 ON c.id2 = e2.id
WHERE e1.prenom = 'Ahmed';