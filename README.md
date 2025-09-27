# CIC Tech-Artifacts

**Description:**
The `cic-tech-artifacts` repository is a collection of **new technical concepts, proof-of-concept modules, and reference artifacts** related to the CIC ecosystem.
It is **not part of the CIC-core codebase**, but rather a sandbox where we can experiment and document ideas safely.

---

## 🎯 Purpose

* Incubator for ideas in the concept phase.
* Publish reference specifications and API definitions.
* Share proof-of-concept (PoC) code, adapters, and examples.
* Keep the main CIC-core codebase clean and focused.

---

## 📂 Structure

```
concept/              ← each new concept in its own folder
  ├─ dgp-provenance/   ← Deterministic Graph Provenance concept
  │    ├─ spec/        ← API, schema, definitions
  │    ├─ examples/    ← sample MANIFEST, audit-passport
  │    └─ notes.md
  ├─ ois-interop/      ← ideas for OIS integration
  ├─ ...
LICENSE               ← CC BY-NC-SA 4.0
README.md             ← this document
CONTRIBUTING.md       ← short guide for contributions
```

---

## 📜 Guidelines

* Each concept lives under its own folder in `concept/`.
* Documentation in **Markdown**, API definitions in **OpenAPI/Protobuf** or YAML.
* Sample data, configurations, and code should be minimal.
* Once a concept matures, it can move to a **dedicated repository** or into the CIC-core.

---

## ⚖️ License

* **CC BY-NC-SA 4.0** – content is freely available for non-commercial use with attribution and under the same terms.
* Code samples default to the same license unless otherwise noted.

---

## 🤝 Contribution

1. Fork the repository and create a new branch.
2. Add a new folder under `concept/` for your idea.
3. Write documentation and add example code if needed.
4. Open a Pull Request with a short explanation.

---

## 🌱 Examples

* **dgp-provenance** – triad-based provenance gate and audit passport.
* **ois-interop** – ideas for secure data exchange between CIC and OIS.

---

> This repository serves as an **innovation sandbox** for CIC: not production code, but the first documented stage of new ideas.