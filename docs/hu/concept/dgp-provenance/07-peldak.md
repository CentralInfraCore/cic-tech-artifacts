# DGP — Példák (HU)

> Ebben a fejezetben **kézzelfogható** mintákat adunk: jó/rossz `*.meta.yaml`, gráf‑élek, CI‑részletek, waiver és hibakeresés. A példák a korábbi fejezetek elveit ültetik gyakorlatba.

---

## 1) Alap meta + kapcsolatok (jó minta)

```yaml
# docs/hu/concept/dgp-provenance/dgp-provenance.meta.yaml
id: doc://hu/concept/dgp-provenance@v1
title: "Determinista Gráf Eredetiség (DGP)"
language: hu
status: review
version: 1.0.0
owner: team://cic-core
tags: [eredet, ellátásilánc, aláírás, gráf]
summary: >
  A DGP biztosítja, hogy minden csomópont hitelesíthető eredetlánccal bírjon.
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

**Miért jó?**

* `id` logikai, verziózott (`@v1`).
* `related_nodes` csak engedélyezett névtereket használ.
* `provenance.anchors` mindhárom horgonyt tartalmazza.

---

## 2) Anti‑példák (mit **ne**)

```yaml
# 2.a: fájlútvonal a related_nodes-ban (TILOS)
related_nodes:
  - ../schemas/manifest.yaml  # ❌ logikai URI helyett fájlútvonal
```

```yaml
# 2.b: kevert kis‑nagybetű, verzió nélküli, szóköz (TILOS)
id: Doc://Hu/Concept/Dgp Provenance
```

```yaml
# 2.c: hiányzó hash horgony (TILOS protected brancheken)
provenance:
  anchors:
    - sig://vault-transit/team-cic-core
```

---

## 3) Gráf: egyszerű fogalmi ábra (mermaid)

```mermaid
flowchart TD
  D[doc://hu/concept/dgp-provenance@v1]
  S[schema://provenance/manifest@v1]
  M[module://cic/verify/attest@v1]
  P[policy://graph/namespace-allowlist@v1]
  D -->|related_nodes| S
  D --> M
  D --> P
```

---

## 4) CI make‑részletek (mini, összefüggő példa)

```make
# 4.a: gyors ellenőrzés PR-ben
graph-check:
	./tools/graph_lint \
	  --allowlist infra/policy/graph-provenance.policy.yaml \
	  --fail-on=orphans,illegal-namespace

# 4.b: determinisztikus csomag
package:
	./tools/canon && \
	tar --sort=name --mtime='UTC 2020-01-01' -cf build/artifacts.tar $(ARTIFACTS)
	sha256sum build/artifacts.tar > build/MANIFEST.sha256

# 4.c: aláírás + atteszt + verifikáció
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

## 5) Waiver (kivétel) minta (időzár + jóváhagyók)

```yaml
waiver:
  id: waiver://graph/namespace-exception/2025-10-01
  rule: policy.graph.namespace-allowlist
  expires: 2025-10-31  # max 30 nap
  approvers:
    - team://cic-core
    - team://sec
  reason: "Átmeneti migráció, régi doc URI-k még élnek"
```

> Megjegyzés: a waiver léte **nem** lazítja a hash/sig/attest kötelezettséget.

---

## 6) Hibakeresés (gyakori bukások → teendők)

| Jelenség                   | Ok                           | Teendő                                  |
| -------------------------- | ---------------------------- | --------------------------------------- |
| `graph-check` fail: árva   | célcsomópont nincs indexelve | hozd létre / javítsd az URI‑t           |
| `graph-check` fail: névtér | nem engedélyezett prefix     | policy bővítés vagy URI‑csere           |
| `verify` fail: hash        | kanonizálási eltérés         | sorvég/mtime normalizálás               |
| `verify` fail: sig         | Transit jogosultság/titok    | RBAC, OIDC, rotáció ellenőrzése         |
| `verify` fail: attest      | hiányzó/hibás atteszt        | séma‑validáció, pipeline lépés kötelező |

---

## 7) Mini esettanulmány: új fogalom felvétele

1. **Szerző** létrehozza a `doc://hu/concept/x@v1` csomópontot és hozzáad 2–3 `related_nodes` URI‑t.
2. **PR**: rövid „miért” narratíva + linkek.
3. **CI**: `graph-check` azonnal visszajelez (árva/névtér/URI‑hiba esetén piros).
4. **Package → Sign → Attest → Verify** lefut; protected brancheken blokkoló.
5. **Merge** csak zöld kapuk mellett.
6. **Release**: `artifacts.tar` + `MANIFEST.sha256` + `*.sig` + `attestation.json` publikálva.

---

## 8) Jó URI‑k (gyorstár)

```
doc://hu/concept/dgp-provenance@v1
schema://provenance/manifest@v1
module://cic/build/packager@v1
policy://graph/namespace-allowlist@v1
```

**Tiltott minták:** `Doc://…`, `doc://…@version1`, `../docs/x.md`

---

## 9) PR sablon — „változás‑narratíva” blokk

```md
### Miért?
Rövid indoklás: miért kellett az új él(ek), milyen következménye van.

### Érintett csomópontok
- doc://hu/concept/dgp-provenance@v1
- schema://provenance/manifest@v1

### Ellenőrzés
- [x] graph-check zöld
- [x] verify zöld (hash/sig/attest)
```

---

## 10) Mérőszám‑minták (CI riportok)

* **Árva‑ráta (heti):** 0 → 0.2% (cél: 0%).
* **Illegális névtér:** 3 → 1 → 0 (fokozatos tisztulás).
* **Reprodukálhatóság:** azonos bemenet = azonos hash aránya: 99.8%.
* **Gate‑egészség:** protected brancheken `graph-check` pass‑rate: 99.2%, `verify`: 98.7%.

---

## 11) Kiterjesztés: modul‑ és séma‑példa

```yaml
# module példa
id: module://cic/verify/attest@v1
title: "Attesztáció ellenőrző"
related_nodes:
  - policy://graph/namespace-allowlist@v1
  - schema://provenance/attestation@v1
provenance:
  anchors:
    - hash://sha256/0011...ffee

# schema példa
id: schema://provenance/attestation@v1
title: "Attesztáció séma (light SLSA)"
related_nodes: []
provenance:
  anchors:
    - hash://sha256/bead...cafe
```

---

## 12) Definition of Done (ehhez a fejezethez)

* Van **jó** és **rossz** meta‑minta, CI‑t futtató Make‑részlet, waiver és hibalisták.
* A példák **összhangban** vannak a 02–06 fejezetek elveivel és policy‑jaival.
* Az olvasó képes egy új csomópontot **helyesen** bekötni a gráfba, zöld kapukkal.
