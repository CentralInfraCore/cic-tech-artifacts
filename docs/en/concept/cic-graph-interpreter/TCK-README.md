# TCK-README — CIC-Graph-Interpreter — Test Compatibility Kit (EN)

## 1. Purpose and Status

* **Document Type:** TCK (Test Compatibility Kit) guide
* **Project:** CIC-Graph-Interpreter (CGI)
* **Version:** 0.1-draft
* **Language:** English (export layer)
* **Status:** Draft / under review
* **Date:** [to be filled]
* **Author:** [to be filled]

## 2. Abstract

This document describes the purpose, structure, and usage of the **Test Compatibility Kit (TCK)** for the CIC-Graph-Interpreter. The TCK verifies **implementation compliance with the contracts and invariants defined in RFCs (001–006)**, especially in terms of deterministic, auditable behavior and schema/policy conformance.

## 3. Background

* Successful adoption of CGI and third-party implementations requires **objective, automated compliance testing**.
* The TCK ensures that any implementation behaves consistently according to the principle: **same snapshot → same answer**.
* It also validates supply-chain and audit requirements (e.g., hash verification, detection of log inconsistencies).

## 4. Testing Principles

1. **Deterministic behavior:** Given input → predictable output.
2. **Reproducibility:** Matching hashes and audit logs.
3. **Schema compliance:** Correct validation of nodes and edges.
4. **Policy enforcement:** Proper application of allow / degrade / deny rules.
5. **Trust-chain compliance:** Verified snapshots and manifests.
6. **Security controls:** TCK includes scenarios simulating key threat vectors.

## 5. TCK Structure

```
tck/
  ├── cases/
  │    ├── valid/
  │    │    ├── snapshot-basic.tar
  │    │    ├── snapshot-with-policies.tar
  │    │    └── ...
  │    ├── invalid/
  │    │    ├── bad-schema.tar
  │    │    ├── tampered-hash.tar
  │    │    └── ...
  │    └── security/
  │         ├── replay-attack-case.tar
  │         ├── injector-abuse-case.tar
  │         └── ...
  ├── scripts/
  │    ├── run_all.sh
  │    ├── verify_snapshot.sh
  │    ├── check_audit_log.sh
  │    └── ...
  ├── expected/
  │    ├── valid/
  │    ├── invalid/
  │    └── security/
  └── README.md (this document)
```

## 6. Usage

### 6.1 Preparation

* Install the reference implementation or the target interpreter to test.
* Ensure `tck/cases` is accessible.

### 6.2 Running Tests

```bash
cd tck/scripts
./run_all.sh --impl /path/to/cic-graph-interpreter
```

### 6.3 Output

* The script reports for each test case:

    * **PASS / FAIL** status
    * Reason for deviation (e.g., schema error, incorrect audit hash, wrong policy decision)
* Detailed logs are stored in the `tck/logs` directory.

## 7. Requirements

* TCK-provided snapshots and manifests are **deterministically generated**.
* Tested implementation must provide interfaces as defined in RFC-005.
* Tests should run in an isolated environment (e.g., container or sandbox).

## 8. Interpreting Results

* **100% PASS:** Implementation fully conforms to expected behavior.
* **Partial FAIL:** Requires further investigation, especially on security and audit cases.
* **FAIL on security tests:** Implementation cannot be considered reliable.

## 9. Summary

The TCK serves as an **objective and automated verification tool** for the contractual behavior of the CIC-Graph-Interpreter. It is essential for validating third-party implementations and regression testing during version upgrades.

---

*This README is a draft and may be extended with additional sample tests and execution guidance during the review process.*
