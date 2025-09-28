# RAG-002 — Compatibility Layer and Adapter (EN)

## 1. Purpose and Status

* **ID:** RAG-002
* **Project:** CIC-Graph-RAG
* **Version:** 0.1-draft
* **Language:** English (export layer)
* **Status:** Draft / technical
* **Date:** [to be filled]
* **Author:** [to be filled]

## 2. Abstract

This document describes the purpose and design of the **compatibility layer and adapter** for the CIC-Graph-RAG. This layer enables generative engines (LLMs) to access context provided by the Graph-IR in a deterministic, audited manner, maintaining consistency and security required by the CIC trust-chain.

## 3. Motivation

* Generative engines (e.g., LLMs) typically expect **raw text input**.
* In CIC, the context is deterministic and schema-driven, requiring an **adapter layer** to pass validated graph data in a consistent and auditable way.
* The compatibility layer minimizes discrepancies and ensures end-to-end auditability.

## 4. Architecture Overview

```
[Snapshot + Manifest]
        ↓
  [Graph-IR Engine]
        ↓
  [Context Selector]
        ↓
  [Compat Layer + RAG Adapter]
        ↓
  [Generative Model (LLM)]
        ↓
  [Response Auditor]
```

## 5. Key Components

### 5.1 Compat Layer

* **Input Normalizer:** Converts Graph-IR output into LLM-friendly text format.
* **Metadata Embedder:** Attaches hashes and audit information as structured metadata.
* **Policy Guard:** Ensures that only authorized content is passed to the model.

### 5.2 RAG Adapter

* **Interface Handler:** Provides the communication API with the generative engine.
* **Audit Hook:** Ensures that the generated response is linked to the hash of the context used.
* **Rate & Size Control:** Regulates the volume of context transferred and its processing cadence.

## 6. Compatibility Strategies

* **Schema-centric Normalization:** Every context node is presented with schema-based labels and deterministic ordering.
* **Deterministic Context Selection:** Same snapshot and query → same context → same input for the model.
* **Verified Data Path:** Every transferred context element is verified by hash.

## 7. Integration with Other RFCs

* Fits into the steps defined by RFC-002 (Pipeline).
* Adheres to the security requirements of RFC-004 (Trust-chain) and RFC-006 (Threat-model).
* Extends RFC-005 (Interfaces) to define the generative adapter.

## 8. Example Workflow

1. The Context Selector retrieves the required subgraph from Graph-IR.
2. The Compat Layer normalizes it and attaches audit metadata.
3. The RAG Adapter delivers it to the generative model and registers the event in the audit log.
4. The Response Auditor records the hash of the response and links it to the context hash.

## 9. Summary

The **compatibility layer and adapter** defined by RAG-002 is essential for deterministic and audited integration of generative AI into the CIC-Graph-Interpreter ecosystem. It ensures that generative models do not break pipeline consistency and that context transfer is transparent and verifiable.

---

*This document is a draft; future versions will include detailed API specifications, dataflow diagrams, and test scenarios.*
