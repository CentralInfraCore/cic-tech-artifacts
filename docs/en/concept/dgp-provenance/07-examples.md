# DGP — Examples (EN)

> This chapter gives **hands‑on** samples: good/bad `*.meta.yaml`, graph edges, CI snippets, waiver, and troubleshooting. These examples operationalize the previous chapters.

---

## 1) Baseline meta + relations (good sample)

```yaml
# docs/en/concept/dgp-provenance/dgp-provenance.meta.yaml
id: doc://en/concept/dgp-provenance@v1
title: "Deterministic Graph Provenance (DGP)"
language: en
status: review
version: 1.0.0
owner: team://cic-core
tags: [provenance, supply-chain, signing, graph]
summary: >
  DGP ensures every node carries a verifiable provenance chain.
related_nodes:
  - schema://provenance/manifest@v1
  - module://cic/verify/attest@v1
  - policy://graph/namespace-allowlist@v1
provenance:
  anchors:
    - hash://sha256/abc123...deadbeef
    - sig://vault-transit/team-cic-core
    - attest://slsa-light/run-2025-09-27
```

**Why is this good?**

* Logical, versioned `id` (`@v1`).
* `related_nodes` only use allowed namespaces.
* `provenance.anchors` include all three anchors.

---

## 2) Anti‑examples (don’t do this)

```yaml
# 2.a: file path inside related_nodes (FORBIDDEN)
related_nodes:
  - ../schemas/manifest.yaml  # ❌ file path instead of logical URI
```

```yaml
# 2.b: mixed case, missing version, space (FORBIDDEN)
id: Doc://En/Concept/Dgp Provenance
```

```yaml
# 2.c: missing hash anchor (FORBIDDEN on protected branches)
provenance:
  anchors:
    - sig://vault-transit/team-cic-core
```

---

## 3) Graph: simple conceptual view (mermaid)

```mermaid
flowchart TD
  D[doc://en/concept/dgp-provenance@v1]
  S[schema://provenance/manifest@v1]
  M[module://cic/verify/attest@v1]
  P[policy://graph/namespace-allowlist@v1]
  D -->|related_nodes| S
  D --> M
  D --> P
```

---

## 4) CI Make snippets (minimal, coherent example)

```make
# 4.a: fast PR feedback
graph-check:
	./tools/graph_lint \
	  --allowlist infra/policy/graph-provenance.policy.yaml \
	  --fail-on=orphans,illegal-namespace

# 4.b: deterministic package
package:
	./tools/canon && \
	tar --sort=name --mtime='UTC 2020-01-01' -cf build/artifacts.tar $(ARTIFACTS)
	sha256sum build/artifacts.tar > build/MANIFEST.sha256

# 4.c: sign + attest + verify
sign:
	./tools/sign_vault --in build/MANIFEST.sha256 --out build/MANIFEST.sha256.sig
attest:
	./tools/attest --manifest build/MANIFEST.sha256 --out build/attestation.json
verify:
	./tools/verify_all \
	  --manifest build/MANIFEST.sha256 \
	  --sig build/MANIFEST.sha256.sig \
	  --att build/attestation.json \
	  --policy infra/policy/graph-provenance.policy.yaml
```

---

## 5) Waiver (exception) sample (time‑boxed + approvers)

```yaml
waiver:
  id: waiver://graph/namespace-exception/2025-10-01
  rule: policy.graph.namespace-allowlist
  expires: 2025-10-31  # max 30 days
  approvers:
    - team://cic-core
    - team://sec
  reason: "Temporary migration; legacy doc URIs still referenced"
```

> Note: a waiver **does not** relax the hash/sig/attest requirements.

---

## 6) Troubleshooting (common failures → actions)

| Symptom                        | Likely cause                | Action                              |
| ------------------------------ | --------------------------- | ----------------------------------- |
| `graph-check` fails: orphan    | missing target node         | create it / fix the URI             |
| `graph-check` fails: namespace | disallowed prefix           | extend allowlist or correct URI     |
| `verify` fails: hash           | canonicalization drift      | normalize line endings / mtime      |
| `verify` fails: sig            | Transit permission/secret   | check RBAC, OIDC, rotation          |
| `verify` fails: attest         | missing/invalid attestation | enforce schema; make step mandatory |

---

## 7) Mini case study: adding a new concept

1. **Author** creates `doc://en/concept/x@v1` and adds 2–3 `related_nodes` URIs.
2. **PR**: short “why” narrative + links.
3. **CI**: `graph-check` provides instant feedback (red on orphan/namespace/URI errors).
4. **Package → Sign → Attest → Verify** runs; blocking on protected branches.
5. **Merge** only with green gates.
6. **Release**: publish `artifacts.tar` + `MANIFEST.sha256` + `*.sig` + `attestation.json`.

---

## 8) Good URIs (quick shelf)

```
doc://en/concept/dgp-provenance@v1
schema://provenance/manifest@v1
module://cic/build/packager@v1
policy://graph/namespace-allowlist@v1
```

**Forbidden patterns:** `Doc://…`, `doc://…@version1`, `../docs/x.md`

---

## 9) PR template — change narrative block

```md
### Why?
Short rationale: why the new edge(s), and what follows from it.

### Affected nodes
- doc://en/concept/dgp-provenance@v1
- schema://provenance/manifest@v1

### Checks
- [x] graph-check green
- [x] verify green (hash/sig/attest)
```

---

## 10) Sample metrics (CI reports)

* **Orphan rate (weekly):** 0 → 0.2% (target: 0%).
* **Illegal namespace:** 3 → 1 → 0 (progressive cleanup).
* **Reproducibility:** same input = same hash ratio: 99.8%.
* **Gate health:** on protected branches `graph-check` pass rate: 99.2%, `verify`: 98.7%.

---

## 11) Extended: module & schema samples

```yaml
# module sample
id: module://cic/verify/attest@v1
title: "Attestation Verifier"
related_nodes:
  - policy://graph/namespace-allowlist@v1
  - schema://provenance/attestation@v1
provenance:
  anchors:
    - hash://sha256/0011...ffee

# schema sample
id: schema://provenance/attestation@v1
title: "Attestation Schema (light SLSA)"
related_nodes: []
provenance:
  anchors:
    - hash://sha256/bead...cafe
```

---

## 12) Definition of Done (for this chapter)

* Contains **good** and **bad** meta samples, CI Make snippet, waiver, and troubleshooting.
* Examples are **aligned** with chapters 02–06 (principles and policies).
* A reader can add a new node to the graph **correctly**, passing gates green.
