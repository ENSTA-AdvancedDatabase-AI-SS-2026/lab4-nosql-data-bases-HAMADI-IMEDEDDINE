# TP1 — Redis : Système de Cache E-commerce

# 1. Introduction

This laboratory focuses on implementing Redis as a high-performance in-memory data store to solve real-world e-commerce problems for ShopFast, an Algerian e-commerce platform.

The main objective is to reduce database load, improve response time, and manage real-time features such as caching, sessions, and leaderboards.

---

# 2. Technologies Used

- Python 3
- Redis (In-memory database)
- pytest (for testing)
- redis-py (Python Redis client)

---

# 3. Data Structures Used

| Structure       | Use Case |
|----------------|----------|
| Hash           | Product storage, shopping cart |
| List           | User navigation history |
| Set            | Product categories |
| Sorted Set     | Sales leaderboard |
| String (with TTL) | Sessions & cache |

---

# 4. Exercise Implementations

---

## Ex1 — Redis Data Structures

### Implemented Features:
- Product storage using Hash (`HSET`)
- Product retrieval (`HGETALL`)
- Shopping cart using Hash counters (`HINCRBY`)
- Navigation history using List (`LPUSH`, `LTRIM`)
- Category system using Set (`SADD`, `SINTER`)

### Key Idea:
Each Redis structure is mapped to a real e-commerce concept:
- Hash → Object storage
- List → Time-based history
- Set → Relationship grouping

---

## Ex2 — Sessions Management

### Implemented Features:
- Session creation with TTL (30 minutes)
- Session retrieval
- Sliding expiration using `EXPIRE`
- Session deletion (logout)

### Key Idea:
Redis is used as a fast session store with automatic expiration.

### Important Concept:
Sliding expiration ensures active users do not get logged out.

---

## Ex3 — Cache-Aside Pattern

### Implemented Features:
- Cache lookup before database access
- Fallback to slow database simulation
- Store result in Redis with TTL
- Cache invalidation support
- Benchmarking (hit vs miss)



### Key Result:
- Cache HIT: ~0ms
- Cache MISS: ~2000ms (due to simulated DB delay)

---

## Ex4 — Leaderboard System

### Implemented Features:
- Sales tracking using Sorted Set (`ZINCRBY`)
- Top N products (`ZREVRANGE`)
- Product ranking (`ZREVRANK`)
- Range queries for rankings

### Key Idea:
Sorted Sets allow real-time ranking without sorting manually.

---

# 5. Performance Analysis

## Cache Effect

| Scenario | Time |
|----------|------|
| Cache MISS | ~2 seconds |
| Cache HIT | ~0 ms |

### Conclusion:
Redis drastically reduces latency by avoiding repeated database queries.

---

# 6. Design Choices

## Why Redis?

- Extremely fast in-memory operations
- Native support for TTL
- Built-in data structures
- Ideal for caching and real-time analytics

---

## Why Cache-Aside Pattern?

- Simple to implement
- Database remains source of truth
- Flexible cache invalidation strategy

---

## Why Sorted Sets for leaderboard?

- Automatic ordering
- Efficient rank queries
- Perfect for real-time scoring systems

---

# 7. Challenges Faced

- Handling cache serialization (JSON required)
- Understanding correct Redis data structures per use case
- Ensuring TTL behavior is consistent
- Simulating realistic database latency

---

# 8. Answers to Reflection Questions

## 1. What happens if Redis restarts?

All in-memory data is lost unless persistence (RDB or AOF) is enabled. Cache and sessions must be rebuilt from the database.

---

## 2. How to handle cache/DB consistency?

- Use cache invalidation after DB updates
- Use write-through or write-back strategies
- Use TTL to limit stale data

---

## 3. When is a short TTL problematic?

- High database load due to frequent cache misses
- Poor user experience due to slow responses
- Inefficient caching system

---

# 9. Conclusion

This lab demonstrates how Redis improves system performance by introducing caching, session management, and real-time ranking.

It shows that proper data structure selection in Redis is critical for building scalable backend systems.
