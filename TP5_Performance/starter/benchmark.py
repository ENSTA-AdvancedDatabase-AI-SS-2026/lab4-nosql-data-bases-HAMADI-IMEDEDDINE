"""
TP5 - Benchmark Comparatif NoSQL
Mesurer les performances de Redis, MongoDB, Cassandra, Neo4j
"""
import time
import statistics
from typing import Callable, List
import threading

import redis
from pymongo import MongoClient
from cassandra.cluster import Cluster
from neo4j import GraphDatabase


# ─── Utilitaires de mesure ────────────────────────────────────────────────────

def measure_latency(fn: Callable, iterations: int = 1000) -> dict:
    latencies = []

    for _ in range(iterations):
        start = time.perf_counter()
        fn()
        latencies.append((time.perf_counter() - start) * 1000)

    latencies.sort()

    return {
        "mean_ms": statistics.mean(latencies),
        "p50_ms": latencies[int(0.50 * len(latencies))],
        "p95_ms": latencies[int(0.95 * len(latencies))],
        "p99_ms": latencies[int(0.99 * len(latencies))],
        "max_ms": max(latencies),
        "throughput_rps": 1000 / statistics.mean(latencies)
    }


def print_results(name: str, results: dict):
    print(f"\n{'='*50}")
    print(f" {name}")
    print(f"{'='*50}")
    for k, v in results.items():
        print(f"  {k:20s}: {v:.2f}")


# ─── Ex1 : WRITE BENCHMARK ───────────────────────────────────────────────────

def benchmark_write_redis(n: int = 100_000):
    r = redis.Redis(host='localhost', port=6379, decode_responses=True)
    pipe = r.pipeline()

    start = time.perf_counter()

    for i in range(n):
        pipe.set(f"user:{i}", f"value:{i}")

        if i % 1000 == 0:
            pipe.execute()

    pipe.execute()

    duration = time.perf_counter() - start
    print_results("Redis WRITE", {
        "throughput_rps": n / duration,
        "total_time_s": duration
    })


def benchmark_write_mongodb(n: int = 100_000):
    client = MongoClient("mongodb://admin:admin123@localhost:27017/")
    db = client["benchmark"]
    col = db["users"]

    batch = []
    batch_size = 1000

    start = time.perf_counter()

    for i in range(n):
        batch.append({"_id": i, "value": f"value:{i}"})

        if len(batch) == batch_size:
            col.insert_many(batch, ordered=False)
            batch = []

    if batch:
        col.insert_many(batch, ordered=False)

    duration = time.perf_counter() - start
    print_results("MongoDB WRITE", {
        "throughput_rps": n / duration,
        "total_time_s": duration
    })


def benchmark_write_cassandra(n: int = 100_000):
    cluster = Cluster(['localhost'])
    session = cluster.connect('benchmark')

    insert_stmt = session.prepare(
        "INSERT INTO users (id, value) VALUES (?, ?)"
    )

    start = time.perf_counter()

    for i in range(n):
        session.execute(insert_stmt, (i, f"value:{i}"))

    duration = time.perf_counter() - start
    print_results("Cassandra WRITE", {
        "throughput_rps": n / duration,
        "total_time_s": duration
    })


def benchmark_write_neo4j(n: int = 100_000):
    driver = GraphDatabase.driver("bolt://localhost:7687", auth=("neo4j", "neo4j"))

    def create(tx, i):
        tx.run("CREATE (:User {id:$id, value:$value})", id=i, value=f"value:{i}")

    start = time.perf_counter()

    with driver.session() as session:
        for i in range(n):
            session.execute_write(create, i)

    duration = time.perf_counter() - start
    print_results("Neo4j WRITE", {
        "throughput_rps": n / duration,
        "total_time_s": duration
    })


# ─── Ex2 : READ BENCHMARK ───────────────────────────────────────────────────

def benchmark_read_redis():
    r = redis.Redis(host='localhost', port=6379, decode_responses=True)

    def point_lookup():
        r.get("user:1")

    results = measure_latency(point_lookup, 1000)
    print_results("Redis READ (GET)", results)


def benchmark_read_mongodb():
    client = MongoClient("mongodb://admin:admin123@localhost:27017/")
    col = client["benchmark"]["users"]

    def point_lookup():
        col.find_one({"_id": 1})

    results = measure_latency(point_lookup, 1000)
    print_results("MongoDB READ (find_one)", results)


# ─── Ex3 : CONCURRENCY TEST ─────────────────────────────────────────────────

def benchmark_concurrent(db_fn: Callable, n_clients: int = 50, requests_per_client: int = 200):
    latencies = []

    def worker():
        for _ in range(requests_per_client):
            start = time.perf_counter()
            db_fn()
            latencies.append(time.perf_counter() - start)

    threads = []

    start = time.perf_counter()

    for _ in range(n_clients):
        t = threading.Thread(target=worker)
        threads.append(t)
        t.start()

    for t in threads:
        t.join()

    total_time = time.perf_counter() - start

    latencies_ms = [l * 1000 for l in latencies]

    print_results("CONCURRENCY TEST", {
        "total_requests": len(latencies),
        "total_time_s": total_time,
        "throughput_rps": len(latencies) / total_time,
        "mean_latency_ms": statistics.mean(latencies_ms)
    })


# ─── MAIN ────────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    print("🚀 Benchmark NoSQL - Comparatif des 4 technologies")
    print("=" * 60)

    N = 10_000  # safe default

    print("\n📝 WRITE BENCHMARK")
    benchmark_write_redis(N)
    benchmark_write_mongodb(N)
    benchmark_write_cassandra(N)
    benchmark_write_neo4j(N)

    print("\n📖 READ BENCHMARK")
    benchmark_read_redis()
    benchmark_read_mongodb()

    print("\n⚡ CONCURRENCY TEST")

    # example function
    def test_fn():
        r = redis.Redis(host='localhost', port=6379)
        r.get("user:1")

    benchmark_concurrent(test_fn)

    print("\n✅ Benchmark terminé")