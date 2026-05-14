# TP2 — MongoDB : Plateforme de Gestion de Dossiers Médicaux  
## RAPPORT — HealthCare DZ

---

# 1. Introduction

Ce TP a pour objectif de modéliser une base de données médicale avec MongoDB afin de gérer des dossiers patients complexes incluant consultations et analyses biologiques.  
L’objectif est de comparer les approches de modélisation (embedding vs referencing), d’exploiter les requêtes MongoDB avancées, les pipelines d’agrégation et les mécanismes d’indexation pour optimiser les performances.

---

# 2. Modélisation des données

## 2.1 Structure générale

La base de données contient deux collections principales :

- `patients`
- `analyses`

---

## 2.2 Embedding vs Referencing

### Embedding (patients → consultations)

Les consultations sont stockées directement dans le document patient.

**Avantages :**
- Accès rapide à tout le dossier patient
- Une seule requête pour récupérer toutes les informations
- Très performant pour les lectures fréquentes

**Inconvénients :**
- Taille des documents peut devenir importante
- Mise à jour plus complexe si beaucoup de consultations

---

### Referencing (analyses)

Les analyses sont stockées dans une collection séparée et reliées par `patient_id`.

**Avantages :**
- Réduction de la taille des documents patients
- Meilleure scalabilité
- Structure plus flexible pour données volumineuses

**Inconvénients :**
- Nécessite des `$lookup`
- Plus coûteux en lecture jointe

---

## 2.3 Justification du choix

- Les consultations sont **embedded** car elles sont fréquemment consultées avec le patient.
- Les analyses sont **referenced** car elles peuvent être nombreuses et volumineuses.

---

# 3. Requêtes MongoDB

Les requêtes réalisées permettent de :

- Filtrer les patients selon maladies et âge
- Rechercher par allergies ou tension
- Extraire la dernière consultation
- Effectuer des recherches textuelles sur les diagnostics

Un index textuel a été créé sur les diagnostics pour améliorer les performances des recherches.

---

# 4. Pipelines d’agrégation

## 4.1 Principe

Les pipelines permettent de transformer et analyser les données étape par étape :

- `$unwind` : décomposer les tableaux
- `$match` : filtrer les données
- `$group` : regrouper et calculer des statistiques
- `$project` : formater les résultats
- `$sort` : trier les résultats

---

## 4.2 Analyse des requêtes

### 3.1 Distribution des diagnostics par wilaya
Permet d’identifier les maladies les plus fréquentes par région.

---

### 3.2 Médicaments les plus prescrits
Analyse des prescriptions par spécialité médicale.

---

### 3.3 Évolution mensuelle des consultations
Permet de suivre l’activité médicale sur une période de 12 mois.

---

### 3.4 Patients à risque
Critères :
- Diabète type 2
- HTA
- âge supérieur à 60 ans

Permet d’identifier les patients à haut risque médical.

---

### 3.5 Top médecins
Analyse basée sur :
- nombre total de consultations
- taux de ré-consultation des patients

---

# 5. Indexation et optimisation

## 5.1 Index créés

- Index sur `adresse.wilaya` et `antecedents` pour filtrage rapide
- Index sur `consultations.date` pour requêtes temporelles
- Index textuel sur `consultations.diagnostic`
- Index sur `analyses.patient_id` pour optimiser les jointures

---

## 5.2 Résultats explain()

### Sans index :
- Nombre élevé de documents examinés
- Temps d’exécution élevé

### Avec index :
- Réduction des documents examinés
- Amélioration significative du temps de réponse

---

## 5.3 Index composé

Un index composé a été utilisé sur :
- `adresse.wilaya`
- `antecedents`

Cela améliore les requêtes combinant plusieurs filtres.

---

## 5.4 Index TTL

Un index TTL a été créé sur `analyses.date` afin de supprimer automatiquement les analyses après 5 ans.

---

# 6. $lookup et jointures

Les opérations `$lookup` permettent de :

- Combiner patients et analyses
- Reconstituer un dossier médical complet
- Analyser les glycémies élevées
- Générer des statistiques par wilaya

---

# 7. Conclusion

Ce TP a permis de maîtriser :

- La modélisation MongoDB (embedding et referencing)
- Les requêtes avancées
- Les pipelines d’agrégation
- L’optimisation via index
- Les jointures avec `$lookup`

MongoDB est particulièrement adapté aux systèmes médicaux grâce à sa flexibilité et ses performances sur les données semi-structurées.