# ANNEX-B — Hello-Graph mintapélda (HU)

## 1. Cél és státusz

* **Dokumentum típusa:** Függelék (Annex-B)
* **Projekt:** CIC-Graph-Interpreter (CGI)
* **Verzió:** 0.1-draft
* **Nyelv:** Magyar (primer)
* **Státusz:** Tervezet / bővítés alatt
* **Dátum:** [kitöltendő]
* **Szerző:** [kitöltendő]

## 2. Kivonat (Abstract)

Ez a függelék egy **egyszerű mintapéldát** mutat be, amely demonstrálja a CIC-Graph-Interpreter által alkalmazott Graph-IR alapú feldolgozást. A *Hello-Graph* célja, hogy könnyen érthető bevezetést nyújtson a gráf-modellezés, a séma-követés, a policy-annotáció és a determinisztikus futtatás alapelveibe.

## 3. Célok

* Oktatási és demonstrációs segédanyag az új felhasználóknak és fejlesztőknek.
* Bizonyíték az RFC-002 (Pipeline), RFC-003 (Graph-IR) és RFC-005 (Interfészek) működésének összhangjára.
* Támogatja a TCK-README által megkövetelt alapvető konformancia-teszteket.

## 4. Példabeli felépítés

```
hello-graph/
  ├── snapshot/
  │    ├── manifest.yaml
  │    ├── schema-workflow.yaml
  │    ├── doc-hello.md
  │    └── policy-basic.yaml
  ├── expected/
  │    ├── graph-digest.txt
  │    └── traversal-result.json
  ├── scripts/
  │    └── run.sh
  └── README.md (ez a dokumentum)
```

## 5. Példabeli tartalom

### 5.1 manifest.yaml

```yaml
snapshot: hello-graph-v1
hash: sha256:1234abcd...
signature: vault:ref:sign-hello-v1
```

### 5.2 schema-workflow.yaml

```yaml
type: Schema
name: Workflow
version: v1
fields:
  - name: title
    type: string
    required: true
  - name: steps
    type: list
    items: string
    required: true
```

### 5.3 doc-hello.md

```markdown
---
type: Document
schema: Workflow:v1
---
# Hello Workflow
steps:
  - Prepare environment
  - Run pipeline
  - Review result
```

### 5.4 policy-basic.yaml

```yaml
rules:
  - match: Workflow
    action: allow
```

## 6. Futtatás

```bash
cd hello-graph/scripts
./run.sh --impl /path/to/cic-graph-interpreter
```

* A script ellenőrzi a snapshot hash-ét.
* Betölti a gráfot, validálja a sémát és alkalmazza a policy-t.
* Létrehozza az `expected/traversal-result.json`-nal egyező kimenetet.

## 7. Eredmény és tanulság

* A *Hello-Graph* bemutatja a **determinista, séma-vezérelt, auditálható pipeline** működését.
* Könnyű belépési pont a CIC-Graph-Interpreter alapjainak megértéséhez.
* Hasznos referenciaanyag a TCK alapszintű tesztjeihez.

## 8. Összegzés

Az ANNEX-B a *Hello-Graph* mintapéldával **gyakorlati illusztrációt** kínál a CIC-Graph-Interpreter koncepciójához. A példakészlet egyszerű, de bemutatja az alapvető elveket és segíti a projekttel való ismerkedést.

---

*Ez a függelék tervezet, a későbbi verziók részletesebb script-leírást és további policy-szcenáriókat tartalmazhatnak.*
