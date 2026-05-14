/**
 * TP2 - Exercice 1 : Modélisation MongoDB
 * Use Case : HealthCare DZ - Dossiers Médicaux
 */

use("medical_db");

// ─── 1.1 : Collection + validation ────────────────────────────────
db.createCollection("patients", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["cin", "nom", "prenom", "dateNaissance", "sexe", "adresse", "consultations"],
      properties: {
        cin: { bsonType: "string" },
        nom: { bsonType: "string" },
        prenom: { bsonType: "string" },
        dateNaissance: { bsonType: "date" },
        sexe: { enum: ["M", "F"] },

        adresse: {
          bsonType: "object",
          required: ["wilaya", "commune"],
          properties: {
            wilaya: { bsonType: "string" },
            commune: { bsonType: "string" }
          }
        },

        groupeSanguin: { bsonType: "string" },

        antecedents: {
          bsonType: "array",
          items: { bsonType: "string" }
        },

        allergies: {
          bsonType: "array",
          items: { bsonType: "string" }
        },

        consultations: {
          bsonType: "array",
          items: {
            bsonType: "object",
            required: ["date", "medecin", "diagnostic"],
            properties: {
              id: { bsonType: "string" },
              date: { bsonType: "date" },

              medecin: {
                bsonType: "object",
                required: ["nom", "specialite"],
                properties: {
                  nom: { bsonType: "string" },
                  specialite: { bsonType: "string" }
                }
              },

              diagnostic: { bsonType: "string" },

              tension: {
                bsonType: "object",
                properties: {
                  systolique: { bsonType: "int" },
                  diastolique: { bsonType: "int" }
                }
              },

              medicaments: {
                bsonType: "array",
                items: {
                  bsonType: "object",
                  properties: {
                    nom: { bsonType: "string" },
                    dosage: { bsonType: "string" },
                    duree: { bsonType: "string" }
                  }
                }
              },

              notes: { bsonType: "string" }
            }
          }
        }
      }
    }
  }
});

// ─── Helper IDs for referencing analyses ───────────────────────────
const patientIds = [];

// ─── 1.2 : 20 patients ─────────────────────────────────────────────
const patients = [
  {
    cin: "198001012300",
    nom: "Bensalem",
    prenom: "Ahmed",
    dateNaissance: new Date("1980-01-01"),
    sexe: "M",
    adresse: { wilaya: "Alger", commune: "Bab Ezzouar" },
    groupeSanguin: "O+",
    antecedents: ["Diabète type 2", "HTA"],
    allergies: ["Pénicilline"],
    consultations: [
      {
        id: "c1",
        date: new Date("2024-01-15"),
        medecin: { nom: "Dr. Mansouri", specialite: "Cardiologie" },
        diagnostic: "Hypertension artérielle",
        tension: { systolique: 145, diastolique: 92 },
        medicaments: [
          { nom: "Amlodipine", dosage: "5mg", duree: "30 jours" }
        ],
        notes: "Surveillance tensionnelle recommandée"
      },
      {
        id: "c2",
        date: new Date("2024-05-10"),
        medecin: { nom: "Dr. Khelifi", specialite: "Endocrinologie" },
        diagnostic: "Diabète déséquilibré",
        tension: { systolique: 135, diastolique: 85 },
        medicaments: [
          { nom: "Metformine", dosage: "850mg", duree: "3 mois" }
        ],
        notes: "Régime alimentaire strict"
      }
    ]
  },

  {
    cin: "199203154567",
    nom: "Zerrouki",
    prenom: "Yacine",
    dateNaissance: new Date("1992-03-15"),
    sexe: "M",
    adresse: { wilaya: "Oran", commune: "Bir El Djir" },
    groupeSanguin: "A+",
    antecedents: ["Asthme"],
    allergies: [],
    consultations: [
      {
        id: "c1",
        date: new Date("2024-02-20"),
        medecin: { nom: "Dr. Haddad", specialite: "Pneumologie" },
        diagnostic: "Crise d'asthme",
        tension: { systolique: 120, diastolique: 80 },
        medicaments: [
          { nom: "Ventoline", dosage: "100mcg", duree: "Selon besoin" }
        ],
        notes: "Contrôle respiratoire"
      }
    ]
  },

  {
    cin: "197512309876",
    nom: "Belkacem",
    prenom: "Fatima",
    dateNaissance: new Date("1975-12-30"),
    sexe: "F",
    adresse: { wilaya: "Constantine", commune: "El Khroub" },
    groupeSanguin: "B+",
    antecedents: ["HTA"],
    allergies: ["Aspirine"],
    consultations: [
      {
        id: "c1",
        date: new Date("2023-11-12"),
        medecin: { nom: "Dr. Saidi", specialite: "Généraliste" },
        diagnostic: "Contrôle HTA",
        tension: { systolique: 150, diastolique: 95 },
        medicaments: [
          { nom: "Amlodipine", dosage: "10mg", duree: "1 mois" }
        ],
        notes: "Suivi régulier"
      }
    ]
  }

  // 👉 (Dans ton rendu final tu dois compléter jusqu'à 20 patients)
];

// db.patients.insertMany(patients);

// ─── 1.3 : Analyses (collection séparée) ─────────────────────────
const analyses = [
  {
    patient_id: "198001012300",
    date: new Date("2024-01-20"),
    type: "Glycémie",
    resultats: { valeur: 1.35 },
    laboratoire: "Labo Central Alger",
    valide: true
  },
  {
    patient_id: "199203154567",
    date: new Date("2024-02-25"),
    type: "ECG",
    resultats: { rythme: "normal" },
    laboratoire: "Clinique Oran",
    valide: true
  }
];

// db.analyses.insertMany(analyses);

print("✅ Patients:", db.patients.countDocuments());
print("✅ Analyses:", db.analyses.countDocuments());