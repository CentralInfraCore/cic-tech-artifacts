# RFC-005 — CIC-Graph-Interpreter — Interfészek és komponensek (HU)

## 1. Cím és státusz

* **Azonosító:** RFC-005
* **Projekt:** CIC-Graph-Interpreter (CGI)
* **Verzió:** 0.1-draft
* **Nyelv:** Magyar (primer)
* **Státusz:** Tervezet / review alatt
* **Dátum:** [kitöltendő]
* **Szerző:** [kitöltendő]

## 2. Kivonat (Abstract)

Ez az RFC a CIC-Graph-Interpreter **komponenseit és interfészeit** írja le, amelyek a determinisztikus gráf-értelmezést, a séma- és policy-vezérelt feldolgozást, valamint a trust-lánc alapú auditálást megvalósítják. Az interfészek tiszta szerződésként szolgálnak a különálló komponensek között, támogatva a moduláris implementációt és a tesztelhetőséget.

## 3. Fő komponensek

A CGI architektúra logikai komponensei:

* **SnapshotManager:** forrásfájlok betöltése, hash-ellenőrzés, aláírás-ellenőrzés.
* **GraphBuilder:** gráf felépítése a snapshotból.
* **Injector:** default értékek, derived node-ok, és policy-annotációk beillesztése.
* **SchemaValidator:** node-ok és élek séma-követelményeinek ellenőrzése.
* **PolicyEngine:** explicit szabályok végrehajtása (allow / degrade / deny).
* **Interpreter:** determinisztikus gráfbejárás, execution plan előállítása.
* **AuditLogger:** minden feldolgozási lépés rögzítése, hash-láncolt audit-log.
* **ResponseAssembler:** opcionálisan a generatív modellnek szánt kontextus vagy végső válasz összeállítása.

## 4. Interfész specifikációk

### 4.1 SnapshotManager

```go
Verify(manifestPath string) (SnapshotDigest, error)
Load(snapshotPath string) (Fileset, error)
```

* Biztosítja a bemeneti snapshot hitelességét.

### 4.2 GraphBuilder

```go
Build(fileset Fileset) (Graph, error)
GetDigest(graph Graph) (GraphDigest, error)
```

* Felépíti a Graph-IR-t a snapshotból.
* A teljes gráfra egyértelmű digestet számít.

### 4.3 Injector

```go
Inject(graph Graph, defaults []DefaultRule) (Graph, error)
Annotate(graph Graph, policies []Policy) (Graph, error)
```

* Default értékeket és derived node-okat injektál.
* Policy által vezérelt címkézést végez.

### 4.4 SchemaValidator

```go
ValidateNode(node Node, schema Schema) error
ValidateEdge(edge Edge, schema Schema) error
ValidateGraph(graph Graph, schemaSet []Schema) error
```

* Biztosítja a séma-konformitást.

### 4.5 PolicyEngine

```go
Evaluate(node Node, context Context) Decision
EvaluateEdge(edge Edge, context Context) Decision
AnnotateGraph(graph Graph) (Graph, error)
```

* Explicit szabályok alapján döntést hoz.
* Címkézi a node-okat és éleket (allow / degrade / deny).

### 4.6 Interpreter

```go
Traverse(graph Graph, query Query) (Subgraph, error)
Plan(subgraph Subgraph) (ExecutionPlan, error)
Execute(plan ExecutionPlan) (Result, error)
```

* Determinisztikusan bejárja a gráfot és végrehajtási tervet készít.

### 4.7 AuditLogger

```go
RecordStep(stepName string, inputDigest string, outputDigest string, ruleID string, timestamp time.Time) error
Seal() (AuditDigest, error)
```

* Append-only logot vezet, hash-láncolással.

### 4.8 ResponseAssembler

```go
Assemble(subgraph Subgraph, plan ExecutionPlan) (Response, error)
SignResponse(response Response, keyRef KeyReference) (SignedResponse, error)
```

* Opcionálisan összekészíti a végső választ.
* Igény esetén aláírja.

## 5. Komponensdiagram (logikai)

```
[SnapshotManager] --load--> [GraphBuilder] --graph--> [Injector] --graph-->
[SchemaValidator] --validated graph--> [PolicyEngine] --annotated graph-->
[Interpreter] --subgraph/plan--> [ResponseAssembler]
                      |                                  |
                      +------------> [AuditLogger] <----+
```

## 6. Tervezési elvek

1. **Tiszta szerződések:** minden komponens explicit interfészt kínál.
2. **Determinista viselkedés:** adott bemenet → adott kimenet.
3. **Auditálhatóság:** minden fontos lépés rögzítve, hash-láncolva.
4. **Bővíthetőség:** új séma vagy policy minimális hatással bővíthető.
5. **Tesztelhetőség:** komponensek külön-külön tesztelhetők (mock / stub).

## 7. Összegzés

Ez az RFC a CGI komponenseinek és interfészeinek szerződéses leírását adja, amely lehetővé teszi a moduláris implementációt és biztosítja a determinisztikus, auditálható működést. A komponensek további részleteit a projekt implementációs dokumentumai és a TCK határozzák meg.

---

*Ez az RFC tervezet; a review során pontosítás és további példakód várható.*
