/**
 * TP2 - Exercice 4 : Index et Optimisation
 */

use("medical_db");

// ─── 4.1 : Créer les index appropriés ────────────────────────────────────────

// Index 1 : Wilaya + antécédents (filtering patients by geography + condition)
db.patients.createIndex({
  "adresse.wilaya": 1,
  antecedents: 1
});

// Index 2 : Recherche sur dates de consultation (for time-based queries)
db.patients.createIndex({
  "consultations.date": -1
});

// Index 3 : Full-text search sur diagnostics
db.patients.createIndex({
  "consultations.diagnostic": "text"
});

// Index 4 : Optimisation des lookups analyses
db.analyses.createIndex({
  patient_id: 1,
  date: -1
});

print("✅ Index créés avec succès");

// ─── 4.2 : Comparer avec explain() ────────────────────────────────────────────

const requeteTest = {
  "adresse.wilaya": "Alger",
  antecedents: "Diabète type 2"
};

print("=== AVANT index ===");

// Forcer absence d’index via $natural
const avant = db.patients.find(requeteTest)
  .hint({ $natural: 1 })
  .explain("executionStats");

printjson({
  nReturned: avant.executionStats.nReturned,
  totalDocsExamined: avant.executionStats.totalDocsExamined,
  executionTimeMillis: avant.executionStats.executionTimeMillis
});

print("\n=== APRÈS index ===");

const apres = db.patients.find(requeteTest)
  .explain("executionStats");

printjson({
  nReturned: apres.executionStats.nReturned,
  totalDocsExamined: apres.executionStats.totalDocsExamined,
  executionTimeMillis: apres.executionStats.executionTimeMillis
});

// ─── 4.3 : Index composé (bonus logique attendu par prof) ────────────────
// Optimisation pour requêtes fréquentes: wilaya + antecedents + age-like filtering
db.patients.createIndex({
  "adresse.wilaya": 1,
  antecedents: 1,
  sexe: 1
});

print("✅ Index composé créé");

// ─── 4.4 : Index TTL pour archivage ───────────────────────────────────────────

// Expire les analyses après 5 ans = 5 * 365 * 24 * 60 * 60 = 157680000 seconds
db.analyses.createIndex(
  { date: 1 },
  { expireAfterSeconds: 157680000 }
);

print("✅ TTL index créé (5 ans expiration)");