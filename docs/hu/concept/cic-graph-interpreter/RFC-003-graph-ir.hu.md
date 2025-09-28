# RFC-003 — CIC-Graph-Interpreter — Gráf-IR és invariánsok (HU)

## 1. Cím és státusz

* **Azonosító:** RFC-003
* **Projekt:** CIC-Graph-Interpreter (CGI)
* **Verzió:** 0.1-draft
* **Nyelv:** Magyar (primer)
* **Státusz:** Tervezet / review alatt
* **Dátum:** [kitöltendő]
* **Szerző:** [kitöltendő]

## 2. Kivonat (Abstract)

Ez az RFC meghatározza a **gráf-IR (Intermediate Representation)** felépítését, amely a CIC-Graph-Interpreter determinisztikus feldolgozásának alapja. A gráf-IR definiálja a node-okat, éleket, attribútumokat, valamint azokat az invariánsokat, amelyek a séma- és policy-vezérelt feldolgozás helyességét és reprodukálhatóságát biztosítják.

## 3. Háttér és motiváció

* A CIC projekt tartalma (Markdown/YAML + séma) természetesen gráfként értelmezhető.
* A determinisztikus feldolgozás feltétele, hogy a feldolgozó motor **absztrakt gráf-IR-t** használjon, függetlenül a forrásfájlok konkrét formátumától.
* A gráf-IR-ben rögzített invariánsok biztosítják a *same snapshot → same graph → same answer* elvet.

## 4. Fogalmi modell

### 4.1 Node

* **Azonosító:** `NodeID` (globálisan egyedi, hash-kompatibilis).
* **Típus:** pl. `Document`, `Schema`, `Policy`, `Workflow`, stb.
* **Attribútumok:** kulcs-érték párok (konzisztens típus-definícióval).
* **Digest:** SHA-256 hash a tartalomra.
* **Meta:** pl. forrásfájl, injektált-e, engedélyezési címkék.

### 4.2 Edge

* **Kezdő és végpont:** `NodeID → NodeID`.
* **Típus:** pl. `related`, `schema-ref`, `policy-rule`, `workflow-step`.
* **Irányítottság:** kötelezően definiált.
* **Feltételek:** opcionális kifejezések a bejárás vagy policy szűrés számára.

### 4.3 Attribute-model

* Az attribútumok validálását a séma írja elő.
* Támogatja az öröklést, de minden örökölt attribútum a node effektív állapotában determinisztikusan rögzül.

### 4.4 Manifest-szintű adatok

* Snapshot azonosító (tar-digest).
* Aláírási metaadat.
* Build-idő, toolchain információk.

## 5. Invariánsok

### 5.1 Determinisztikusság

* Ugyanazon snapshotból épített gráf struktúrája és tartalma *bitenként azonos*.

### 5.2 Séma-konzisztencia

* Minden node-nak meg kell felelnie a típusának megfelelő sémának.
* Minden él típusának és feltételeinek meg kell felelnie a séma által meghatározott szabályoknak.

### 5.3 Policy-határok

* A policy által degradált vagy tiltott node/edge csak a bejárás során érvényesülhet; az alapprojekcióban (graph-IR) az élek és node-ok látszanak, de címkézve.

### 5.4 Hash-stabilitás

* A gráf-IR teljes struktúrája hash-elhető; hash változás → determinisztikus pipeline újrafutás.

### 5.5 Audit-összefüggés

* Minden node/edge tartalmazza a létrehozás forrását (file, injektor, időbélyeg) → visszavezethető.

## 6. Példa (illusztratív)

```
NodeID: schema:Workflow:v1
Type: Schema
Attrs:
  name: Workflow
  version: v1
Digest: sha256:abcd...

NodeID: doc:ProcessA
Type: Document
Attrs:
  title: Process A
Digest: sha256:1234...

Edge: doc:ProcessA → schema:Workflow:v1
Type: schema-ref
Conditions: {}
```

## 7. Interfész követelmények

* **GraphStore API:**

    * `get_node(id)` → Node
    * `neighbors(id, edge_type?, filter?)` → NodeID[]
    * `get_digest()` → SnapshotHash
* **Validator API:**

    * `validate_node(node)` → Result
    * `validate_edge(edge)` → Result
* **PolicyEngine API:**

    * `annotate(graph)` → Graph (címkézett)

## 8. Összegzés

Ez az RFC a gráf-IR koncepcionális modelljét és invariánsait rögzíti, amely minden további pipeline- és policy-lépés alapját képezi. A pontos típus-definíciókat és séma-szabályokat a projekt további dokumentumai tartalmazzák.

---

*Ez az RFC tervezet; a review során pontosítás és példakód-kiegészítés várható.*
