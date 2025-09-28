# RAG-001 — Why Classic RAG Is Not Enough (EN)

## 1. Purpose and Status

* **ID:** RAG-001
* **Project:** CIC-Graph-RAG
* **Version:** 0.1-draft
* **Language:** English (export layer)
* **Status:** Draft / analytical
* **Date:** [to be filled]
* **Author:** [to be filled]

## 2. Abstract

This document explains **why traditional Retrieval-Augmented Generation (RAG) approaches are insufficient** for the goals of the CIC project. It outlines the limitations of conventional RAG in terms of auditability, determinism, and schema compliance, and motivates the need for a Graph-IR–based RAG approach.

## 3. Background

* Traditional RAG typically relies on **vector-based document retrieval** (e.g., embeddings + nearest neighbor search).
* While effective for free-text data, it is **hard to guarantee reproducibility and security**.
* The CIC architecture requires **deterministic, schema-driven processing** as a foundational principle.

## 4. Limitations of Classic RAG

### 4.1 Lack of Determinism

* Vector search is **database- and parameter-dependent**.
* The top-k results often fluctuate due to minor changes.
* The same input does not always produce the same output.

### 4.2 Poor Auditability

* The **context selection process is opaque**.
* Difficult to record exactly which documents and their versions contributed to a generated response.
* No unified hash or manifest chain for context.

### 4.3 Missing Schema and Policy Compliance

* Traditional RAG typically feeds **raw documents** to the model.
* It does not align with CIC’s **Graph-IR + schema-validation pipeline**.
* Lacks controlled, type-safe queries.

### 4.4 Security Risks

* **Ad hoc context injection** is risky, especially in regulated environments.
* No guarantees that the model’s context is verified, authorized, or immutable.

## 5. CIC Requirements

* **Reproducibility:** Snapshot → deterministic query → generative response.
* **Integrity and Audit:** Context sources protected and verified by hash chain.
* **Schema-based Interpretation:** All context graphs validated against schemas.
* **Policy Enforcement:** Only authorized nodes and edge types can reach the model.

## 6. Why Graph-IR–based RAG?

* The Graph-IR layer already provides:

    * Deterministic, audited data sources.
    * Type-safe, schema-validated context queries.
    * Compatibility with the broader CIC processing pipeline.
* This enables generative AI to operate **within the CIC trust-chain**.

## 7. Summary

Classic RAG does not meet CIC’s requirements for **auditability, determinism, and schema compliance**. A Graph-IR–based RAG approach ensures that generative AI applications are **securely, consistently, and reproducibly integrated** into the CIC architecture.

---

*This document is a draft; future versions will include detailed examples, benchmarks, and security comparisons.*
