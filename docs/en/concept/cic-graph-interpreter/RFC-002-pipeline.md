# RFC-002 — CIC-Graph-Interpreter — Processing Pipeline (EN)

## 1. Title and Status

* **ID:** RFC-002
* **Project:** CIC-Graph-Interpreter (CGI)
* **Version:** 0.1-draft
* **Language:** English (export layer)
* **Status:** Draft / under review
* **Date:** [to be filled]
* **Author:** [to be filled]

## 2. Abstract

This document describes the **processing pipeline** of the CIC-Graph-Interpreter (CGI). The pipeline defines the deterministic, schema- and policy-driven steps that produce reproducible and auditable responses to queries. It guarantees the *same snapshot → same answer* principle.

## 3. Overview

The pipeline connects a given query to a verified content snapshot through the following major steps:

1. **Ingest / Snapshot-verify** — Load content, verify hash and signature.
2. **Build-graph** — Construct the graph (Nodes + Edges) from the snapshot.
3. **Inject-defaults** — Insert defaults defined by schema and policy.
4. **Validate-schema** — Ensure node and edge consistency.
5. **Apply-policy** — Apply allow / degrade / deny rules.
6. **Traverse-graph** — Deterministically traverse the graph to locate relevant subgraphs.
7. **Plan-execution** — Build an execution plan from the traversed subgraph.
8. **(Optional) Generate-response** — Provide curated context to a generative model if required.
9. **Audit-log** — Record all processing steps and decisions.

## 4. Flow Diagram

```
        +------------------+
        | Ingest / Verify  |
        +---------+--------+
                  |
        +---------v--------+
        |   Build-Graph    |
        +---------+--------+
                  |
        +---------v--------+
        |  Inject-Defaults |
        +---------+--------+
                  |
        +---------v--------+
        |  Validate-Schema |
        +---------+--------+
                  |
        +---------v--------+
        |   Apply-Policy   |
        +---------+--------+
                  |
        +---------v--------+
        |  Traverse-Graph  |
        +---------+--------+
                  |
        +---------v--------+
        |  Plan-Execution  |
        +---------+--------+
                  |
        +---------v--------+
        | (Opt.) Generate  |
        +---------+--------+
                  |
        +---------v--------+
        |     Audit-Log    |
        +------------------+
```

## 5. Step Details

### 5.1 Ingest / Snapshot-verify

* Input: tarball or manifest + file set.
* Verification: SHA-256 hash match, optional signature (Vault Transit or self-signed).
* Output: trusted snapshot identifier (digest) and loaded raw content.

### 5.2 Build-graph

* Nodes: e.g., md/yaml documents, schemas, policies.
* Edges: e.g., `related_nodes`, schema links, policy edges.
* Graph topology becomes fixed after build.

### 5.3 Inject-defaults

* Injector applies defaults, labels, and derived nodes as defined by schema and policy.
* Injected elements are tracked in the audit log.

### 5.4 Validate-schema

* Verify compliance of all nodes and edges with schemas.
* Errors stop the pipeline; logged in the audit log.

### 5.5 Apply-policy

* PolicyEngine enforces explicit rules to allow / degrade / deny.
* Output: filtered and annotated graph for traversal.

### 5.6 Traverse-graph

* Deterministic graph traversal starting from query-relevant nodes.
* Respects policy and schema constraints during traversal.

### 5.7 Plan-execution

* Builds an execution plan based on the relevant subgraph.
* May include ordering, conditional checks, and response assembly strategy.

### 5.8 (Optional) Generate-response

* Supplies only deterministically selected and policy-approved context to generative models.

### 5.9 Audit-log

* Each step records: input, output, hash, timestamp, decision rule reference.
* Enables replayable processing path: **same snapshot + same query → same log → same answer**.

## 6. Key Invariants

* **Deterministic traversal:** Interpreter follows the same graph path every time.
* **Reproducibility:** Fixed snapshot guarantees identical answers.
* **Auditability:** Every decision links back to explicit policy and schema.
* **Safety:** Pipeline halts on invalid schema/policy or disallowed edges.

## 7. Summary

This RFC specifies the processing pipeline of the CIC-Graph-Interpreter, enabling reproducible, auditable, schema-driven responses. The pipeline relies on components detailed in later RFCs (IR, interfaces, trust, threat-model).

---

*This RFC is a draft and subject to refinement during the review process.*
