# RFC-006 — CIC-Graph-Interpreter — Threat Model and Security Considerations (EN)

## 1. Title and Status

* **ID:** RFC-006
* **Project:** CIC-Graph-Interpreter (CGI)
* **Version:** 0.1-draft
* **Language:** English (export layer)
* **Status:** Draft / under review
* **Date:** [to be filled]
* **Author:** [to be filled]

## 2. Abstract

This RFC defines the **threat model and security considerations** for the CIC-Graph-Interpreter. It identifies potential attack vectors, the protective layers provided by the trust-chain and audit mechanisms, and complementary controls that ensure the integrity and reproducibility of the processing pipeline.

## 3. Objectives

* Preserve the **integrity and security** of deterministic graph-based processing.
* Mitigate **TOCTOU (Time-of-Check–Time-of-Use)** attacks.
* Detect and prevent **downgrade** and **policy-bypass** attempts.
* Maintain the **trustworthiness of the audit chain** (tamper-evident).
* Ensure **verifiability and compliance** of the system.

## 4. Threat Categories

### 4.1 Input Layer

* **Malicious snapshot:** manipulated tar archive or manifest.
* **Hash-collision attack:** theoretical but long-term risk.
* **Unverified signature:** missing or invalid signature.

### 4.2 Processing Pipeline

* **TOCTOU attack:** snapshot or schema altered between verification and processing.
* **Injector abuse:** hidden or unexpected logic introduced via defaults.
* **Schema-bypass:** malformed nodes or edges slipping past validation.
* **Policy-downgrade:** unauthorized edges treated as allowed.
* **Traversal manipulation:** exploiting graph structure to alter traversal paths.

### 4.3 Output Layer

* **Response forgery:** issuing responses without proper audit logs.
* **Log tampering:** attempting to alter the audit chain to hide actions.
* **Replay attack:** reusing responses from outdated, invalid snapshots.

## 5. Defensive Controls

### 5.1 Trust-chain (RFC-004)

* Tar → SHA-256 → signature → verification before every pipeline run.
* Schemas and policies versioned as part of the snapshot.

### 5.2 Audit Chain

* Append-only and hash-chained (Merkle-based) logging.
* Any manipulation breaks the chain and becomes evident.

### 5.3 Idempotent Injection

* Injector is deterministic; given the same snapshot, produces identical results.
* All injected elements are recorded in the audit log.

### 5.4 Schema-driven Validation

* All nodes and edges must pass schema validation.
* Invalid or unknown entities halt the pipeline.

### 5.5 Policy Enforcement

* Explicit allow / degrade / deny rules.
* Annotations guide decision-based filtering during traversal.

### 5.6 Isolation and Runtime Controls

* Executed in containerized or sandboxed environments.
* Enforced reduced privileges, seccomp profiles, and W^X memory policies.

### 5.7 Replay Protection

* Responses embed snapshot and audit log hashes.
* Responses become invalid if the snapshot hash differs.

## 6. Risk Assessment

| Category         | Example                      | Impact Severity | Likelihood | Mitigation                          |
| ---------------- | ---------------------------- | --------------- | ---------- | ----------------------------------- |
| Input integrity  | Manipulated tar archive      | Critical        | Low        | Hash + signature verification       |
| TOCTOU           | Alteration post-verification | Critical        | Medium     | Re-check hashes + immutable storage |
| Injector abuse   | Hidden default field         | High            | Medium     | Policy + audit logging              |
| Schema-bypass    | Invalid but accepted node    | High            | Low        | Schema validation                   |
| Policy-downgrade | Unauthorized edge allowed    | Critical        | Low        | Annotation + traversal filtering    |
| Log tampering    | Altered audit records        | Critical        | Very low   | Append-only + hash chain            |
| Replay attack    | Reuse of old snapshot        | Medium          | Low        | Embed snapshot hash in responses    |

## 7. Integration with Other RFCs

* RFC-002 (Pipeline): covers all pipeline steps under control.
* RFC-003 (Graph-IR): provides hash stability and schema invariants.
* RFC-004 (Trust-chain): ensures end-to-end integrity.
* RFC-005 (Interfaces): defines contractual component collaboration.

## 8. Summary

This RFC defines the **threat model** for the CIC-Graph-Interpreter, forming the basis for deterministic, auditable, and regulation-compliant operation. Combined with the trust-chain and audit mechanisms, these controls eliminate most attack vectors and support secure, reproducible processing.

---

*This RFC is a draft; further refinements and illustrative examples may be added during the review process.*
