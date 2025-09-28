# DGP — Principles (reader‑friendly, practice‑oriented)

> **DGP is a discipline, not a tool.** The mantra: identity before location, proof before publication, graph before files.

---

## 0) How to read this chapter

We bridge the *why* to the *how*. Each principle states the idea, explains the motivation, gives a quick example and a counter‑example, then ends with a short **"put it in practice"** tip.

---

## 1) Content addressing

**Claim.** A node is defined by what its *canonical content* hashes to.

* **Why?** Paths and formats drift; hashes are stable, comparable, and signable.
* **How?** Canonicalize → `sha256` → anchor as `hash://sha256/<digest>`.
* **Example.** `docs/en/…/dgp-provenance.md` and its HU counterpart live at different paths, yet identity = logical ID + content hash.
* **Anti‑example.** “The root README is the source of truth.” — doesn’t scale, not provable.
* **Practice.** Run canonicalization before `make package`; refuse releases without a MANIFEST.

---

## 2) Detached signatures

**Claim.** Sign the **hash**, not the file blob.

* **Why?** Formatting/OS whims shouldn’t break trust.
* **How?** `sig://vault-transit/<key>`; keys live behind policy and rotation.
* **Example.** `MANIFEST.sha256` is signed; the signature is filesystem‑agnostic.
* **Anti‑example.** “We appended an inline PGP block to the file.” — diff‑noisy, brittle.
* **Practice.** `make sign` must always target the MANIFEST hash.

---

## 3) Attestation (light SLSA)

**Claim.** Answer who/what/when/with‑what in a machine‑readable way.

* **Why?** Audits shouldn’t turn into archaeology after incidents.
* **How?** `attest://…` anchor captures CI run id, inputs, builder, timestamp.
* **Example.** A release ships `attestation.json` with commit hash and build inputs.
* **Anti‑example.** “It’s in the pipeline logs somewhere.” — volatile, partial, unchecked.
* **Practice.** Make `make attest` mandatory on protected branches.

---

## 4) Graph‑first mindset

**Claim.** Knowledge lives as **nodes and edges**; files are just containers.

* **Why?** Relationships (dependencies, references) carry the meaning.
* **How?** `related_nodes` use **logical URIs** (not paths) with a namespace allowlist.
* **Example.** `doc://concept/dgp-provenance@v1 → schema://provenance/manifest@v1`.
* **Anti‑example.** “../schemas/manifest.yaml” — breaks on moves.
* **Practice.** `make graph-check` rejects orphans and illegal namespaces.

---

## 5) Deterministic packaging

**Claim.** Same inputs must yield the same artifact.

* **Why?** Without reproducibility there is no strong proof.
* **How?** Sorted tar, fixed mtime, stable ordering, normalized line endings.
* **Example.** `tar --sort=name --mtime='UTC 2020-01-01' …` + `MANIFEST.sha256`.
* **Anti‑example.** “Zipped it on my laptop.” — OS‑dependent, timestamp‑noisy.
* **Practice.** Keep a golden comparator in CI; fail diffs.

---

## 6) Fail‑shut gates

**Claim.** If graph or provenance is wrong, merging **must not** happen.

* **Why?** Speed can’t outrank provability.
* **How?** Protected branches require green `graph-check` + `verify`.
* **Example.** A new edge enters only if its target exists and namespace is allowed.
* **Anti‑example.** “We’ll fix it later.” — “later” equals release day.
* **Practice.** Start gates in warning mode, evolve to error on a deadline.

---

## 7) Explainability & idempotence

**Claim.** Graph changes are **narratable**, and pipeline steps are safe to repeat.

* **Why?** Reviewers need the “why this edge exists” story; reruns must be stable.
* **How?** Commit messages with a short change narrative; idempotent `tools/*` scripts.
* **Example.** “New `module://…` edge supports the policy‑lint refactor.”
* **Anti‑example.** “No idea why it changed.” — that’s a defect, not an opinion.
* **Practice.** Add a mandatory “why” block to the PR template.

---

## 8) Bilingual docs as a contract

**Claim.** EN and HU convey the same **conceptual** claims.

* **Why?** Language diversity must not yield divergent realities.
* **How?** Cross‑links, unified meta, automated link lint.
* **Example.** HU “Elvek” = EN “Principles” pointing to the same conceptual graph.
* **Anti‑example.** Extra claims in HU, omissions in EN — drift.
* **Practice.** CI lint: missing counterpart page or broken links = fail.

---

## 9) Least‑privilege keys

**Claim.** Code doesn’t own signing keys; **policy** does.

* **Why?** Key theft equals proof theft.
* **How?** Vault Transit, short‑lived tokens, audit, rotation.
* **Example.** `sign_vault` token bound to the runner, not a developer laptop.
* **Anti‑example.** Hard‑coded secrets and local experiments with prod keys.
* **Practice.** Separate keyrings per environment; deny‑by‑default.

---

## 10) Patterns vs. antipatterns (quick shelf)

* **Pattern:** logical URIs in `related_nodes` → move‑tolerant graphs.
* **Antipattern:** relative file paths → constant breakage.
* **Pattern:** `MANIFEST.sha256` + detached `sig` → stable proof.
* **Antipattern:** “I uploaded a random zip.” → hash drift.
* **Pattern:** “warning→error” gate evolution → cultural adoption.
* **Antipattern:** instant hard‑fail → people route around gates.

---

## 11) Into practice

* **Daily:** run `graph-check` and `verify` on every PR.
* **Release moment:** ship MANIFEST + SIG + ATTEST as first‑class artifacts.
* **Rollback:** content‑addressing enables deterministic rollback to last‑known‑good.
* **Metrics:** graph density, orphan rate, DoD conformance; tighten thresholds over time.

---

## 12) Short DoD for this chapter

* Each principle has **example** and **counter‑example**.
* Gates, hash/sig/attest, and namespaces **converge** into a coherent practice.
* A reader can apply these principles to their own module today.
