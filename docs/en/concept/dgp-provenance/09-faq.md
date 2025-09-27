# DGP — FAQ (EN)

> **Purpose:** crisp answers for onboarding and day‑to‑day use. This FAQ stands alone, but aligns with chapters 02–08.

---

## 1) Quick concepts

**Q: What is DGP?**
**A:** *Deterministic Graph Provenance*: canonicalize → `sha256` → detached signature → attestation, enforced by **STRICT‑GRAPH** and **TRIAD‑ON** gates.

**Q: Why isn’t a PGP‑signed zip enough?**
**A:** Proof must bind to **canonical content** (hash), not an arbitrary blob; DGP also enforces the **graph relations**, not just a file.

**Q: What’s an “anchor”?**
**A:** A verifiable reference: `hash://…`, `sig://…`, `attest://…`.

---

## 2) Hash / Canon / MANIFEST

**Q: Exactly what do we hash?**
**A:** The **canonical byte stream** (deterministic ordering, `\n` newlines, no BOM). Same content → same hash.

**Q: Why `sha256`?**
**A:** Widely trusted, fast, and collision‑resistant enough for our goals.

**Q: What’s inside `MANIFEST.sha256`?**
**A:** Stable list of packaged components and their `sha256` values.

---

## 3) Signatures (detached) & keys

**Q: Why detached signatures?**
**A:** To keep proof independent of filesystem/OS quirks; the `sig` targets the MANIFEST **hash**.

**Q: Where are the keys?**
**A:** Behind Vault Transit/HSM; the runner requests signatures via short‑lived tokens. Keys **never** land in repo or on runners.

**Q: What about key rotation?**
**A:** Issue a new Transit key, cut over gradually; old releases remain verifiable (attestation + key id).

---

## 4) Attestation

**Q: What goes into the attestation?**
**A:** Commit SHA, CI run id, builder/environment, inputs, timestamp; optionally PR link and a brief “why”.

**Q: JSON or YAML?**
**A:** Either; **schema** matters. `verify` validates it.

**Q: How is it protected?**
**A:** It’s bound to the MANIFEST hash and validated against the build’s IDs during `verify`.

---

## 5) Graph & `related_nodes`

**Q: Why can’t I put file paths into `related_nodes`?**
**A:** Logical URIs are move‑tolerant and policy‑enforceable; file paths are brittle and unverifiable.

**Q: What namespaces are allowed?**
**A:** `schema://`, `doc://`, `module://`, `policy://` (plus anchors: `hash://`, `sig://`, `attest://`).

**Q: Are cycles allowed?**
**A:** By default no; exceptions only via documented **waiver** with expiry.

---

## 6) CI / gates

**Q: Can `graph-check` block merges?**
**A:** Yes, on **protected** branches; elsewhere start as warning → later error.

**Q: When should `verify` run?**
**A:** After `package`, `sign`, and `attest`; it’s **blocking** on protected branches.

**Q: What gets published on release?**
**A:** `artifacts.tar`, `MANIFEST.sha256`, `MANIFEST.sha256.sig`, `attestation.json`.

---

## 7) TRIAD‑ON & STRICT‑GRAPH

**Q: What does TRIAD‑ON enforce?**
**A:** Clear separation and health of App / Infra / Tests‑Docs; CI metrics guard against drift.

**Q: What’s the essence of STRICT‑GRAPH?**
**A:** `related_nodes` are **logical** and **validated**; orphans denied, namespaces allow‑listed.

---

## 8) Versioning

**Q: When to bump `@vN`?**
**A:** On **concept‑breaking** changes to a node’s contract. Minor edits → use a meta‑level `version` field.

**Q: What’s the deprecation path?**
**A:** Mark `status: deprecated`, drain references, keep artifacts retained for audit.

---

## 9) Waivers / exceptions

**Q: When can I request a waiver?**
**A:** Rarely—only with business justification. Must include rationale, expiry (≤30 days), and ≥2 approvers.

**Q: Does a waiver relax anchor requirements?**
**A:** No. Hash/sig/attest are **always** required for releases.

---

## 10) Errors & fixes

| Error               | Symptom           | Action                                        |
| ------------------- | ----------------- | --------------------------------------------- |
| Orphan edge         | `graph-check` red | Create target or fix the URI                  |
| Illegal namespace   | `graph-check` red | Extend allowlist or change the URI            |
| Hash mismatch       | `verify` red      | Revisit canonicalization (line endings/mtime) |
| Invalid signature   | `verify` red      | Check Transit RBAC/rotation                   |
| Invalid attestation | `verify` red      | Schema‑lint; add required fields              |

---

## 11) Metrics

* **Orphan rate**, **namespace‑violation** rate, **hash‑match** ratio.
* Gate **latency** and **failure rate** by rule/cause.

---

## 12) Governance / ownership

* **Owning team:** content + `related_nodes` correctness.
* **CI/Build:** canonicalize, package, sign, attest, verify.
* **Security/Compliance:** policy, waivers, audit.

---

## 13) Samples

**Good URIs:**

```
doc://en/concept/dgp-provenance@v1
schema://provenance/manifest@v1
module://cic/build/packager@v1
policy://graph/namespace-allowlist@v1
```

**Forbidden:** `Doc://…`, `doc://…@version1`, `../docs/x.md`

---

## 14) Definition of Done (for this chapter)

* Each question has a **clear** answer.
* FAQ aligns with the detailed chapters and is **non‑contradictory**.
* A new joiner can craft a **green PR** in ~30 minutes with this FAQ alone.
