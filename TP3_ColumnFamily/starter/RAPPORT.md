# RAPPORT.md — TP3 Cassandra IoT (SmartGrid DZ)

## 1. Justification des Partition Keys

### Table `mesures_par_capteur`

PRIMARY KEY ((capteur_id, date_jour), timestamp)

- capteur_id permet une distribution uniforme des données entre les nœuds.
- date_jour évite les hot partitions en découpant les données par jour.
- timestamp permet le tri chronologique des mesures.
- Cette structure est optimisée pour la requête : “mesures d’un capteur entre T1 et T2”.

---

### Table `alertes_par_wilaya`

PRIMARY KEY ((wilaya, date_jour), timestamp, capteur_id)

- wilaya + date_jour permet de regrouper les alertes par zone et par jour.
- timestamp permet un tri des alertes (les plus récentes en premier).
- capteur_id évite les collisions si plusieurs alertes surviennent au même instant.

---

### Table `agregats_horaires`

PRIMARY KEY ((wilaya), date_heure)

- wilaya est la clé principale de regroupement pour le dashboard.
- date_heure permet un découpage temporel horaire.
- Structure optimisée pour lecture rapide des agrégats.

---

## 2. Pourquoi ALLOW FILTERING est dangereux

- Cassandra est conçu pour accéder aux données via la partition key.
- ALLOW FILTERING force un scan complet des partitions.
- Cela entraîne :
  - forte latence
  - surcharge réseau
  - mauvaise scalabilité

Exemple dangereux :
SELECT * FROM mesures_par_capteur WHERE tension_v > 240 ALLOW FILTERING;

Cassandra doit scanner toutes les partitions → inefficace.

Solution correcte : créer une table dédiée aux anomalies.

---

## 3. Comparaison des stratégies de compaction

### STCS (Size Tiered Compaction Strategy)
- Fusionne des SSTables de taille similaire
- Adapté aux charges mixtes
- Mauvais pour séries temporelles

### LCS (Leveled Compaction Strategy)
- Donne de bonnes performances en lecture
- Coûteux en écriture
- Pas adapté à IoT à forte ingestion

### TWCS (Time Window Compaction Strategy)
- Optimisé pour données temporelles
- Regroupe les données par fenêtres de temps
- Très efficace avec TTL
- Idéal pour IoT et séries temporelles

Choix : TWCS

---

## 4. Détection et correction des hot partitions

### Détection
- Une partition devient trop volumineuse
- Latence élevée sur une clé spécifique
- Déséquilibre de charge sur un nœud

### Cause
- Trop de données dans une seule partition (ex: capteur_id seul)

### Correction
- Ajouter un découpage temporel (date_jour)
- Éventuellement ajouter un bucket horaire
- Éviter les partitions infinies

Exemple :
PRIMARY KEY ((capteur_id, date_jour), timestamp)

---

## 5. Conclusion

Ce TP montre que Cassandra repose sur un modèle orienté requêtes.

Principes appliqués :
- conception basée sur les requêtes
- partitioning pour éviter les hot spots
- clustering key pour le tri temporel
- TTL pour la gestion automatique des données
- TWCS pour les données de type IoT