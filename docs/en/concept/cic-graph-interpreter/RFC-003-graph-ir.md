# RFC-003 — CIC-Graph-Interpreter — Graph-IR and Invariants (EN)

## 1. Title and Status

* **ID:** RFC-003
* **Project:** CIC-Graph-Interpreter (CGI)
* **Version:** 0.1-draft
* **Language:** English (export layer)
* **Status:** Draft / under review
* **Date:** [to be filled]
* **Author:** [to be filled]

## 2. Abstract

This RFC defines the **Graph Intermediate Representation (Graph-IR)**, the foundation of the deterministic processing in the CIC-Graph-Interpreter. The Graph-IR specifies nodes, edges, attributes, and the invariants that guarantee schema- and policy-driven correctness and reproducibility.

## 3. Background and Motivation

* CIC’s content (Markdown/YAML + schemas) is naturally represented as a graph.
* Deterministic processing requires that the interpreter operate on an **abstract Graph-IR**, decoupled from the raw file formats.
* The invariants of Graph-IR ensure the principle: *same snapshot → same graph → same answer*.

## 4. Conceptual Model

### 4.1 Node

* **Identifier:** `NodeID` (globally unique, hash-compatible).
* **Type:** e.g., `Document`, `Schema`, `Policy`, `Workflow`, etc.
* **Attributes:** key-value pairs with consistent type definitions.
* **Digest:** SHA-256 hash of the node’s content.
* **Meta:** e.g., source file reference, injected flag, policy labels.

### 4.2 Edge

* **Endpoints:** `NodeID → NodeID`.
* **Type:** e.g., `related`, `schema-ref`, `policy-rule`, `workflow-step`.
* **Directionality:** always explicitly defined.
* **Conditions:** optional expressions for traversal or policy filtering.

### 4.3 Attribute Model

* Attribute validation is schema-defined.
* Supports inheritance, but all inherited attributes are deterministically resolved in the node’s effective state.

### 4.4 Manifest-level Metadata

* Snapshot identifier (tar-digest).
* Signature metadata.
* Build-time and toolchain info.

## 5. Invariants

### 5.1 Determinism

* A graph built from the same snapshot is **bitwise identical**.

### 5.2 Schema Consistency

* Every node must conform to its schema-defined type.
* Every edge must meet schema-defined rules and constraints.

### 5.3 Policy Scoping

* Policy-denied or degraded nodes/edges remain visible in the base Graph-IR but are annotated and excluded during traversal.

### 5.4 Hash Stability

* The entire Graph-IR is hashable; any hash change triggers deterministic reprocessing.

### 5.5 Audit Traceability

* Every node/edge includes provenance data (file, injector, timestamp), ensuring traceability.

## 6. Example (Illustrative)

```
NodeID: schema:Workflow:v1
Type: Schema
Attrs:
  name: Workflow
  version: v1
Digest: sha256:abcd...

NodeID: doc:ProcessA
Type: Document
Attrs:
  title: Process A
Digest: sha256:1234...

Edge: doc:ProcessA → schema:Workflow:v1
Type: schema-ref
Conditions: {}
```

## 7. Interface Requirements

* **GraphStore API:**

    * `get_node(id)` → Node
    * `neighbors(id, edge_type?, filter?)` → NodeID[]
    * `get_digest()` → SnapshotHash
* **Validator API:**

    * `validate_node(node)` → Result
    * `validate_edge(edge)` → Result
* **PolicyEngine API:**

    * `annotate(graph)` → Graph (with policy labels)

## 8. Summary

This RFC establishes the conceptual model and invariants of the Graph-IR, serving as the foundation for all subsequent pipeline and policy steps. Detailed type definitions and schema rules are specified in other project documents.

---

*This RFC is a draft; further refinements and illustrative code samples are expected during the review process.*
