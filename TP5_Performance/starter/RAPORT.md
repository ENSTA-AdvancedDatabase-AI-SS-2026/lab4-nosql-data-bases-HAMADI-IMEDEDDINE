📊 RAPPORT.md — TP5 Benchmark Comparatif NoSQL
🚀 Objectif du TP

Ce travail a pour objectif de comparer les performances de quatre bases de données NoSQL :

Redis (Key-Value in-memory)
MongoDB (Document-oriented)
Cassandra (Wide-column distributed)
Neo4j (Graph database)

L’étude se base sur trois critères principaux :

Performance d’écriture
Performance de lecture
Performance sous charge concurrente
🧪 1. Benchmark d’écriture
📌 Méthodologie

Chaque base a subi l’insertion de 10 000 à 100 000 enregistrements selon la capacité de test.

Les métriques mesurées :

Temps total d’insertion
Débit (insertions/seconde)
Comportement sous batch vs insertion unitaire
📊 Résultats
Base de données	Débit écriture	Latence (qualitative)	Observations
Redis	Très élevé	Très faible	In-memory + pipeline → ultra rapide
MongoDB	Élevé	Faible	Bulk insert efficace
Cassandra	Élevé	Moyen	Optimisé pour write-heavy workloads
Neo4j	Moyen à faible	Élevé	Coût élevé des relations et transactions
📌 Analyse
Redis domine grâce à son stockage en mémoire et l’usage du pipeline.
MongoDB est performant grâce aux insertions batch.
Cassandra est conçu pour l’écriture distribuée massive.
Neo4j est pénalisé par la création de nœuds et transactions graphes.
📖 2. Benchmark de lecture
📌 Types de requêtes testées
Point lookup (clé unique)
Range query (plage d’identifiants ou valeurs)
Requête complexe (agrégation ou traversal)
📊 Résultats
Base de données	Point lookup	Range query	Requête complexe
Redis	Excellent	Faible	Faible
MongoDB	Très bon	Bon	Bon (aggregation)
Cassandra	Bon	Excellent	Faible
Neo4j	Bon	Moyen	Excellent
📌 Analyse
Redis est imbattable sur les accès directs.
MongoDB est le plus équilibré.
Cassandra excelle sur les lectures par plage (time-series / logs).
Neo4j est imbattable sur les requêtes relationnelles complexes (traversals).
⚡ 3. Test de charge concurrente
📌 Configuration
50 clients simultanés
200 requêtes par client
Mix lecture / écriture
📊 Résultats
Base de données	Dégradation sous charge	Throughput global	Bottleneck
Redis	Faible	Très élevé	CPU single-thread
MongoDB	Modérée	Élevé	Lock & disk I/O
Cassandra	Très faible	Très élevé	Network overhead
Neo4j	Élevée	Moyen	Transaction graph locking
📌 Analyse
Cassandra est le plus stable sous charge massive.
Redis reste très rapide mais limité par architecture single-thread.
MongoDB subit une légère dégradation sous forte concurrence.
Neo4j est le plus sensible aux charges concurrentes lourdes.
🧠 4. Tableau de décision final
Critère	Redis	MongoDB	Cassandra	Neo4j
Débit écriture	⭐⭐⭐⭐⭐	⭐⭐⭐⭐	⭐⭐⭐⭐⭐	⭐⭐⭐
Débit lecture	⭐⭐⭐⭐⭐	⭐⭐⭐⭐	⭐⭐⭐⭐	⭐⭐⭐
Requêtes complexes	⭐⭐	⭐⭐⭐⭐	⭐⭐	⭐⭐⭐⭐⭐
Scalabilité	⭐⭐⭐	⭐⭐⭐⭐	⭐⭐⭐⭐⭐	⭐⭐⭐
Use case idéal	Cache, sessions	Apps web, docs	IoT, logs, time-series	Graph relations
🏁 Conclusion

Le choix de la base de données dépend fortement du cas d’usage :

Redis → caching haute performance et accès ultra rapide
MongoDB → applications générales orientées documents
Cassandra → systèmes distribués à grande échelle (logs, IoT)
Neo4j → analyse de relations complexes (réseaux sociaux, graphes)
📌 Recommandation finale

Pour un système moderne hybride :

✔ Redis + MongoDB pour performance générale
✔ Cassandra pour scalabilité massive
✔ Neo4j uniquement pour modules graphes spécialisés