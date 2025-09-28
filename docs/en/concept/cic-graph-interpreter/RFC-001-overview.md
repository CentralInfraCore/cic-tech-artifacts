# RFC-001 — CIC-Graph-Interpreter — Overview (EN)

## 1. Title and Status

* **ID:** RFC-001
* **Project:** CIC-Graph-Interpreter (CGI)
* **Version:** 0.1-draft
* **Language:** English (export layer)
* **Status:** Draft / under review
* **Date:** [to be filled]
* **Author:** [to be filled]

## 2. Abstract

This document introduces the purpose, motivation, and key concepts of the CIC-Graph-Interpreter (CGI). CGI is a **deterministic, graph-based interpretation model replacing RAG**, originally developed within the CIC project. It adopts a **schema-driven graph traversal** approach instead of probabilistic retrieval to meet **supply-chain and audit requirements**.

## 3. Background and Motivation

* Conventional Retrieval-Augmented Generation (RAG) lacks *reproducibility* and *auditability*.
* In CIC, content (Markdown/YAML pairs) is organized as a graph with explicit edges.
* Queries deterministically follow graph edges → *same snapshot → same answer*.
* The supply-chain pipeline (tar → SHA-256 → Vault-sign) ensures integrity of processed data.

## 4. Scope

This RFC describes:

* The goal and core concepts of CGI,
* The architectural principle: **inject → schema-validate → policy-filter → traverse → plan**,
* The main components (GraphStore, SchemaValidator, PolicyEngine, Interpreter),
* The topics delegated to other RFCs (IR, pipeline, interfaces, trust-chain, threat-model, annexes).

It does **not** cover:

* CIC-specific node types and licensing policies,
* The compatibility layer towards RAG-based systems.

## 5. Definitions

* **Node:** A unit of content (e.g., document, schema) with metadata and hash.
* **Edge:** A relation between nodes with defined type and direction.
* **GraphStore:** Graph storage built from the verified snapshot.
* **Injector:** Applies default values and extended policies before processing.
* **SchemaValidator:** Verifies node and edge consistency against schemas.
* **PolicyEngine:** Allows / degrades / denies actions based on nodes and edges.
* **Interpreter:** Performs deterministic traversal and builds an execution plan from the graph.
* **Manifest:** The hash and signature of the processed snapshot.
* **Audit-log:** Records each step for reproducibility and traceability.

## 6. Principles

1. **Deterministic behavior:** Given snapshot + given query → always the same result.
2. **Schema-driven processing:** Schemas define the primary contract.
3. **Policy embedding:** Decision logic is explicitly defined by policies.
4. **Audit and trust-chain:** Every step is traceable and verifiable from source to response.
5. **Extensibility:** Adding new node types or policies does not break determinism.

## 7. Related RFCs

* RFC-002 — Pipeline and processing flow
* RFC-003 — Graph-IR and invariants
* RFC-004 — Trust-chain and audit
* RFC-005 — Interfaces and component APIs
* RFC-006 — Threat-model and security considerations
* ANNEX-A — CIC-derived evidence examples
* ANNEX-B — Hello-Graph reference implementation

## 8. Summary

The CIC-Graph-Interpreter, born within CIC, offers a generalizable paradigm for any environment requiring **reproducible and auditable graph-based interpretation** as an alternative to RAG-based approaches.

---

*This RFC is a draft and subject to refinement during the review process.*
