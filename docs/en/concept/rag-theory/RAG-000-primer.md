# RAG-00 — CIC-Graph-RAG — Primer (EN)

## 1. Purpose and Status

* **ID:** RAG-00
* **Project:** CIC-Graph-RAG (experimental subproject)
* **Version:** 0.1-draft
* **Language:** English (export layer)
* **Status:** Draft / introductory
* **Date:** [to be filled]
* **Author:** [to be filled]

## 2. Abstract

This document serves as the **introductory primer** for the CIC-Graph-RAG subproject. It provides context and foundational concepts to understand the graph-based deterministic RAG approach. The primer focuses on the theoretical rationale, architectural placement, and motivation within the CIC project.

## 3. Why Graph-RAG?

* Conventional RAG often relies on **ad hoc document retrieval**, which is hard to audit and non-deterministic.
* CIC already provides a **Graph-IR layer** that:

    * is built from deterministic snapshots,
    * is schema-driven, and
    * is protected by the audit chain.
* Generative AI can align with CIC’s principles only if **its context source follows the same deterministic and auditable procedure** as the rest of the pipeline.

## 4. Concept Map

* **Graph-IR:** Deterministic graph representation — the structured model of the knowledge base.
* **Context Selector:** Deterministic query mechanism extracting a subgraph for generative use.
* **RAG Adapter:** Interface to the generative model that provides controlled context delivery and ensures audit metadata capture.
* **Response Auditor:** Component linking the context hash to the response hash.
* **Trust-chain:** End-to-end integrity ensured by snapshot, manifest, and audit chain.

## 5. Motivation

* **Reproducibility:** Same snapshot → same context → same generative response.
* **Compliance:** Extends schema and policy adherence to generative AI outputs.
* **Transparency:** Every context query and delivery is audited.
* **Security:** Prevents injection of unauthorized, unverified content.

## 6. Placement in CIC Architecture

```
[CIC Snapshot + Manifest]
          ↓
     [Graph-IR Build]
          ↓
 [Context Selector → RAG Adapter]
          ↓
 [Generative Model + Response Auditor]
```

* The RAG operates **on top of the Graph-IR**, as part of the pipeline.
* It complements, rather than replaces, the deterministic processing pipeline by adding a generative response stage.

## 7. Use Cases

* **Documentation queries:** Generate summaries from policy-compliant subgraphs.
* **Technical Q&A:** Provide schema-compliant, context-bound answers.
* **Audit reporting:** Produce generative reports from deterministically selected context.

## 8. Summary

The RAG-00 primer introduces the motivation and position of generative AI in the CIC project: generative AI can be safely and compliantly used only when **its context is provided in a deterministic, graph- and schema-based manner**.

---

*This document is a draft; future versions will include more detailed examples, API sketches, and audit flow descriptions.*
