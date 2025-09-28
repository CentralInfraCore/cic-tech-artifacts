# ANNEX-A — CIC Evidences (EN)

## 1. Purpose and Status

* **Document Type:** Annex-A
* **Project:** CIC-Graph-Interpreter (CGI)
* **Version:** 0.1-draft
* **Language:** English (export layer)
* **Status:** Draft / under expansion
* **Date:** [to be filled]
* **Author:** [to be filled]

## 2. Abstract

This annex compiles the **evidence and reference materials** that support the development of the CIC-Graph-Interpreter and the principles laid out in RFCs (001–006). The goal of ANNEX-A is to provide a **comprehensive and verifiable historical and contextual foundation** for design decisions, validation steps, and reproducibility.

## 3. Historical Context

* CIC project roots: **graph-based content interpretation** → deterministic processing.
* Shift from classic RAG to **Graph-IR** for context injection and interpretation.
* Adoption of supply-chain model (tar → SHA-256 → Vault Transit signature).
* Early PoC iterations and community feedback → foundation of the RFC series.

## 4. Source Evidences

* **README.ai.md:** Early conceptual guidelines.
* **PoC repositories and commit logs:** Track development and iterations.
* **Specifications and schema files:** Basis for deterministic interpretation.
* **CIC-related conversation logs:** Document rationale for key decisions.
* **Vault Transit signing metrics:** Hash and signature log evidence.

## 5. Validation and Audit Evidences

* **Pipeline execution logs:**

    * Snapshot hash verifications
    * Schema validation reports
    * Policy enforcement statistics
* **Audit-chain samples:** Proof of hash-chain integrity.
* **TCK test results:** PASS/FAIL statistics and regression logs.
* **Security incident/test cases:** Replay, TOCTOU, injector abuse scenarios.

## 6. Annex Structure

```
docs/
  en/
    annex/
      A-cic-evidences.md   (this document)
      B-hello-graph.md     (planned example)
      ...
```

## 7. Usage and Reference

* ANNEX-A serves as a **supporting reference** for RFCs and the TCK-README.
* Listed evidences are **verifiable and reproducible**.
* Will expand over time as new PoCs and audit-log samples become available.

## 8. Summary

ANNEX-A is the **collection of project evidences and historical sources** for the CIC-Graph-Interpreter, supporting the transparency of its deterministic and auditable operations.

---

*This annex is currently a draft and will be enriched with detailed lists and reference links in future versions.*
