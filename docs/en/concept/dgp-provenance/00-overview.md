# DGP — Overview (Philosophy‑first)

> Deterministic Graph Provenance (DGP) is not a tool; it is a discipline: **identity before location, proof before publication, graph before files.**

---

## 1) Premise

Modern systems are graphs of meaning (schemas, docs, modules) that outlive any single repository layout. When the graph is ungoverned, releases drift, signatures are ornamental, and audits become archaeology. DGP proposes a small set of **invariants** that make the graph **provable**.

**Core claim.** A node is what its canonical content hashes to; everything else is commentary.

---

## 2) What DGP is (and is not)

* **Is:** a minimal grammar for provenance over graphs: `hash → signature → attestation`, enforced by policy gates.
* **Is not:** a packaging format, a specific CI vendor recipe, or a file‑path convention.

DGP binds **logical nodes** and **edges** (not raw files) to verifiable anchors.

---

## 3) Design tenets

1. **Content‑addressing first.** Canonicalize → `sha256` → this becomes the node’s identity.
2. **Detached signatures.** Sign the hash, not the file blob; keys live behind policy (e.g., Vault Transit).
3. **Attestations (light SLSA).** Capture who/what/when/inputs; make it machine‑checkable.
4. **Graph‑first discipline.** `related_nodes` are logical URIs, not paths; namespaces are allow‑listed.
5. **Deterministic packaging.** Reproducible tar + MANIFEST; zero non‑determinism by construction.
6. **Fail‑shut gates.** Merges to protected branches require green **graph** and **provenance** checks.

---

## 4) Mental model

Think of the codebase as a **knowledge graph**:

* **Nodes:** `schema://…`, `doc://…`, `module://…`, `policy://…`
* **Edges:** `related_nodes` (semantic references)
* **Anchors:** `hash://sha256/<digest>`, `sig://vault-transit/<key>`, `attest://<scheme>/<desc>`

The node’s **logical ID** and its **hash anchor** must agree at review time; disagreements are defects, not opinions.

---

## 5) Identity & provenance grammar

```text
logical-id  := (schema|doc|module|policy) "://" path [ "@v" integer ]
anchor      := hash|sig|attest
hash        := "hash://sha256/" 64-hex
sig         := "sig://vault-transit/" token
attest      := "attest://" scheme "/" descriptor
```

**Rules.** IDs are lowercase, space‑free; separators are `-` `/` `:`; versions explicit (`@vN`).

---

## 6) Lifecycle (as contracts)

1. **Author** updates node & `related_nodes` (URIs only).
2. **Canon** normalizes bytes and computes `sha256`.
3. **Sign** produces a detached signature for the hash.
4. **Attest** records CI metadata and inputs.
5. **Verify** rejects: orphan edges, illegal namespaces, missing/invalid anchors.
6. **Release** publishes MANIFEST + signature + attestation.

Each step is **idempotent** and **machine‑verifiable**.

---

## 7) Policy surface

* **Namespace allowlist:** only approved prefixes in `related_nodes`.
* **Version policy:** prefer explicit `@vN` on logical nodes.
* **Edge hygiene:** no orphans; keep density within thresholds; forbid self‑loops unless justified.
* **Branch gate:** protected branches require `graph-check` and `verify` to pass.

---

## 8) Threats & counters (informal)

* **Tampering.** Countered by content hashes + detached signatures.
* **Supply‑chain injection.** Attestations bind inputs and runners.
* **Config/code/doc drift.** Graph gates fail merges on semantic disconnects.
* **Key misuse.** Keys live behind policy (HSM/Transit), rotated and least‑privileged.

---

## 9) Proof obligations (DoD)

* No orphan edges; namespaces conform.
* `MANIFEST.sha256` present; signature and attestation verify.
* Graph changes are **explainable**: a reviewer can narrate why new edges exist.
* Bilingual docs (EN/HU) are aligned; links resolve.

---

## 10) CI sketch (vendor‑agnostic)

```make
graph-check:
	./tools/graph_lint --allowlist infra/policy/graph-provenance.policy.yaml \
	  --fail-on=orphans,illegal-namespace

package:
	./tools/canon && tar --sort=name --mtime='UTC 2020-01-01' -cf build/artifacts.tar $(ARTIFACTS)
	sha256sum build/artifacts.tar > build/MANIFEST.sha256

sign:
	./tools/sign_vault --in build/MANIFEST.sha256 --out build/MANIFEST.sha256.sig

attest:
	./tools/attest --manifest build/MANIFEST.sha256 --out build/attestation.json

verify:
	./tools/verify_all --manifest build/MANIFEST.sha256 \
	  --sig build/MANIFEST.sha256.sig --att build/attestation.json \
	  --policy infra/policy/graph-provenance.policy.yaml
```

---

## 11) Adoption path

1. Introduce logical IDs + `related_nodes` in `*.meta.yaml`.
2. Add namespace allowlist policy; run `graph-check` in CI (non‑blocking → blocking).
3. Canonicalize + hash + detached sign; publish MANIFEST.
4. Add light attestation; gate merges with `verify`.
5. Evolve thresholds (edge density, required anchors) as maturity grows.

---

## 12) FAQ (brief)

* **Why not sign files directly?** File paths are unstable; hashes of canonical content are not.
* **Is DGP SLSA‑level strict?** No. It starts **light** to encourage adoption.
* **Do we need new repos?** No. DGP overlays your existing tree with graph‑first invariants.
