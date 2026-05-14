// MongoDB initialization script

db = db.getSiblingDB('medical_db');

// ─── Create database user ─────────────────────────────────────────
db.createUser({
  user: 'medical_user',
  pwd: 'medical123',
  roles: [
    { role: 'readWrite', db: 'medical_db' }
  ]
});

// ─── Create collections (safe initialization) ─────────────────────

// Patients collection
db.createCollection('patients');

// Analyses collection
db.createCollection('analyses');

print('✅ medical_db initialized successfully');