# RFC-004 — CIC-Graph-Interpreter — Trust-chain and Audit (EN)

## 1. Title and Status

* **ID:** RFC-004
* **Project:** CIC-Graph-Interpreter (CGI)
* **Version:** 0.1-draft
* **Language:** English (export layer)
* **Status:** Draft / under review
* **Date:** [to be filled]
* **Author:** [to be filled]

## 2. Abstract

This RFC defines the **trust-chain and auditability** principles of the CIC-Graph-Interpreter. It specifies the mechanisms that ensure **authenticity, integrity, and reproducibility** of both input content and outputs. The trust-chain spans from the source snapshot through all stages of the processing pipeline.

## 3. Background and Motivation

* Deterministic processing is meaningful only if the **input is trusted** and the entire process is **auditable**.
* CIC’s supply-chain approach (tar → SHA-256 → Vault Transit signature) guarantees source integrity.
* The built-in audit log provides traceability for all decisions made during processing.

## 4. Trust-chain Components

### 4.1 Snapshot and Manifest

* **Snapshot:** Deterministic tar archive of source files.
* **Manifest:** SHA-256 hash and metadata of the snapshot.
* **Signature:** Manifest authentication (via Vault Transit, HSM, or self-signed in dev mode).

### 4.2 Hash Verification

* Every pipeline run begins by verifying the snapshot hash.
* Mismatch → pipeline halts.

### 4.3 Schema and Policy Versioning

* Schema and policy files are part of the snapshot → any change alters the hash.
* This ties each run to the exact versions of contracts in effect.

### 4.4 Graph-IR Hash

* The graph built from the verified snapshot has its own hash.
* Any change in the graph triggers a full pipeline re-run.

### 4.5 Audit Log

* Each pipeline step records:

    * Input and output hashes
    * Decision rule identifier
    * Timestamp and runtime environment metadata
* The audit log is **append-only** and **cryptographically chained** (hash-chain / Merkle-based).

### 4.6 Response Artifact Signing

* The final response (e.g., JSON, report) embeds references to the snapshot and audit-log hashes.
* Optionally, the response itself can be signed for downstream verification.

## 5. Core Principles

1. **End-to-end Integrity:** Identical snapshots always yield identical result sets.
2. **Verifiable Provenance:** Every piece of data and decision is traceable to a specific version of a file, schema, or policy.
3. **Tamper-evident Logging:** Any manipulation or error disrupts the hash-chain and becomes visible.
4. **Reproducibility & Compliance:** Responses are auditable and compliant with regulatory requirements.

## 6. Illustration

```
[Source Files] --tar--> [Snapshot] --SHA-256--> [Manifest] --sign--> [Verified Snapshot]
        |                                             |
        |                                             v
        +--------------------------------------> [Graph-IR Build]
                                                   |
                                                   v
       [Policy/Schemas] ---------------------> [Validated Graph]
                                                   |
                                                   v
          [Pipeline Steps + Audit-Log (hash-chain)]
                                                   |
                                                   v
                                       [Signed Response (optional)]
```

## 7. Integration with Other RFCs

* Closely related to: RFC-002 (Pipeline) and RFC-003 (Graph-IR).
* Extends the pipeline steps with hash verification and audit logging.
* Prepares the foundation for addressing attack vectors described in the threat-model RFC.

## 8. Summary

This RFC defines the end-to-end **trust-chain and audit model** of the CIC-Graph-Interpreter, guaranteeing the authenticity of processed content and the reproducibility of responses. These mechanisms are critical for industrial and regulatory compliance.

---

*This RFC is a draft; further refinements and detailed implementation notes are expected during the review process.*
