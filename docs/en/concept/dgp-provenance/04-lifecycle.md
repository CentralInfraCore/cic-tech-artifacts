# DGP — Lifecycle (EN)

> **Question:** How does a conceptual node (doc/schema/module/policy) become a provable, releasable artifact?
> **Answer:** With a strict yet everyday‑practical pipeline of *hash → signature → attestation*, guarded by graph gates.

---

## 0) Bird’s‑eye overview

1. **Authoring:** update the node and its `related_nodes` (logical URIs).
2. **Canonicalization:** deterministic normalization → `sha256` content hash.
3. **Packaging:** sorted tar + `MANIFEST.sha256`.
4. **Signing:** detached signature over the MANIFEST hash (Vault Transit).
5. **Attestation:** capture CI metadata and inputs (`attestation.json`).
6. **Verification:** run `graph-check` + `verify` (hash/sig/attest + policy).
7. **Release:** publish artifacts; link anchors in the node’s meta.
8. **Operations:** audit, rollback, and compliance metrics.

---

## 1) Roles & responsibilities

* **Author:** edits content and `related_nodes`; provides a short "why" narrative in the PR.
* **Build/CI runner:** performs canonicalization, package, hash, sign, and attest.
* **Reviewer:** challenges graph changes, validates orphan/namespace rules.
* **Release engineer:** validates artifact set and publishes the release.
* **Security/Compliance:** key policy, attestation schema, audits.

**Contract‑first:** a PR is mergeable only if the **Definition of Done** in this chapter is satisfied.

---

## 2) Authoring → `related_nodes` (graph‑first)

* **Rule:** only allow‑listed namespaces (`schema://`, `doc://`, `module://`, `policy://`).
* **Disallow:** spaces, mixed case; file paths inside `related_nodes`.
* **Good practice:** each new edge gets a 1–2 sentence rationale in the PR (**what it references and why**).

**Mini‑checklist:** does the link exist? any cycles? versioning (`@vN`) intentional?

---

## 3) Canonicalization (deterministic normalization)

* **Goal:** identical content yields the **same bytes** across environments.
* **Typical steps:** YAML key ordering, `\n` line endings, no BOM, stable floating‑point formatting (if applicable).
* **Output:** canonical bytes → `sha256` → `hash://sha256/<digest>`.

> **Note:** the hash is one provenance **anchor** for identity; the logical `id` (URI) remains separate.

---

## 4) Packaging + MANIFEST

* **Command sketch:** `tar --sort=name --mtime='UTC 2020-01-01' ...`
* **Outputs:**

    * `build/artifacts.tar` (deterministic tar)
    * `build/MANIFEST.sha256` (hashes for all included components)
* **DoD:** absence of `MANIFEST.sha256` is *blocking* on protected branches.

---

## 5) Signing (detached, behind Transit)

* **Why detached?** To keep proof independent of filesystem/OS quirks.
* **Token:** short‑lived, runner‑scoped, auditable.
* **Output:** `build/MANIFEST.sha256.sig` | URI: `sig://vault-transit/<key>`.

**Failure modes:** no permission to access the key → *fail‑shut* (pipeline must not proceed).

---

## 6) Attestation (light SLSA)

* **Content:** commit SHA, CI run id, environment, build inputs, timestamp.
* **Schema:** project‑level, versioned; JSON or YAML.
* **Output:** `build/attestation.json` | URI: `attest://slsa-light/<run>`.

**Good practice:** include PR link and a short "why" narrative in the attestation.

---

## 7) Verification (graph + provenance gate)

* **`make graph-check`:** orphan edges, illegal namespaces, URI grammar.
* **`make verify`:** recompute hash, check signature, validate attestation, enforce policy.
* **Execution:** *blocking* on protected branches; warning‑only elsewhere → scheduled cutover to *blocking*.

**Outputs:** summary report (CI artifact), list of failures, suggested fixes.

---

## 8) Release (publish)

* **Must‑ship artifacts:** `artifacts.tar`, `MANIFEST.sha256`, `MANIFEST.sha256.sig`, `attestation.json`.
* **Linkage:** record anchor URIs in the node’s `*.meta.yaml` if desired.
* **Versioning:** bump `@vN` for conceptual breaks; use meta‑level `version` for minor updates.

---

## 9) Operations: audit & rollback

* **Audit:** query a node → recompute hash, verify signature, validate attestation → *yes/no* answer.
* **Rollback:** restore last‑known‑good by content address (deterministic).
* **Compliance:** track metrics (orphan rate, graph density, DoD pass rate) over time.

---

## 10) Failure modes & remediations

| Failure                   | Symptom             | Remediation                                     |
| ------------------------- | ------------------- | ----------------------------------------------- |
| Orphan edge               | `graph-check` fails | create the missing target / fix the URI         |
| Illegal namespace         | `graph-check` fails | extend allowlist per policy or change the URI   |
| Hash mismatch             | `verify` fails      | inspect canonicalization, line endings, mtime   |
| Missing/invalid signature | `verify` fails      | check Transit rights, token scope, key rotation |
| Missing attestation       | `verify` fails      | make the pipeline step mandatory                |

---

## 11) Adoption path

1. **Non‑blocking lint:** run `graph-check` in warning mode → preparation period.
2. **Deterministic package:** add `make package` and MANIFEST to every release.
3. **Sign + attest:** introduce, report, educate.
4. **Fail‑shut gates:** require `graph-check` + `verify` on protected branches.
5. **Tighten thresholds:** drive orphan rate to zero; strengthen namespace rules.

---

## 12) Sequence (text narrative)

```
Author -> Repo: change + PR (why/narrative)
CI -> GraphLint: validate related_nodes (orphans, namespaces)
CI -> Canon: canonicalize → bytes
CI -> Hash: sha256(bytes) → MANIFEST.sha256
CI -> Sign(Transit): MANIFEST.sha256.sig
CI -> Attest: attestation.json (commit, run, inputs)
CI -> Verify: hash+sig+attest + policy
Verify -> CI: OK/FAIL
CI -> Registry/Release: publish artifacts
Ops -> System: audit/rollback via anchors
```

---

## 13) Definition of Done (for this chapter)

* `graph-check` and `verify` are **green** (blocking on protected branches).
* Release bundle contains: `artifacts.tar` + `MANIFEST.sha256` + `*.sig` + `attestation.json`.
* PR includes a short **change narrative** and explains graph changes.
* Every new edge is **justified**, comes from an **allowed namespace**, and **orphans=0**.
