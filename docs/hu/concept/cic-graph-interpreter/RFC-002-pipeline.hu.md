# RFC-002 — CIC-Graph-Interpreter — Feldolgozási folyamat (HU)

## 1. Cím és státusz

* **Azonosító:** RFC-002
* **Projekt:** CIC-Graph-Interpreter (CGI)
* **Verzió:** 0.1-draft
* **Nyelv:** Magyar (primer)
* **Státusz:** Tervezet / review alatt
* **Dátum:** [kitöltendő]
* **Szerző:** [kitöltendő]

## 2. Kivonat (Abstract)

Ez a dokumentum a CIC-Graph-Interpreter (CGI) feldolgozási folyamatát (pipeline-ját) írja le. A pipeline meghatározza azokat a lépéseket, amelyekkel a lekérdezésre adott válasz determinisztikusan, séma- és policy-vezérelten születik meg. A folyamat garantálja a *same snapshot → same answer* elvet és az auditálhatóságot.

## 3. Áttekintés

A pipeline célja, hogy a bemenetként kapott kérdést (query) és a hitelesített tartalom-snapshotot determinisztikusan összekapcsolja a következő fő lépések során:

1. **Ingest / Snapshot-verify** — a forrás tartalom betöltése, hash és aláírás ellenőrzése.
2. **Build-graph** — a snapshotból gráf felépítése (Node + Edge).
3. **Inject-defaults** — séma és policy által meghatározott alapértékek beemelése.
4. **Validate-schema** — node-ok és élek konzisztenciájának ellenőrzése.
5. **Apply-policy** — hozzáférés, engedélyezés, degradálás, tiltás.
6. **Traverse-graph** — determinisztikus gráf-bejárás a releváns csomópontok feltárására.
7. **Plan-execution** — a bejárt algráf alapján végrehajtási terv összeállítása.
8. **(Optional) Generate-response** — ha szükséges, a talált tartalmakat generatív modellnek adja át, de csak a policy által engedélyezett kontextussal.
9. **Audit-log** — minden lépés eredménye és döntési pontja naplózásra kerül.

## 4. Folyamatábra

```
        +------------------+
        | Ingest / Verify  |
        +---------+--------+
                  |
        +---------v--------+
        |   Build-Graph    |
        +---------+--------+
                  |
        +---------v--------+
        |  Inject-Defaults |
        +---------+--------+
                  |
        +---------v--------+
        |  Validate-Schema |
        +---------+--------+
                  |
        +---------v--------+
        |   Apply-Policy   |
        +---------+--------+
                  |
        +---------v--------+
        |  Traverse-Graph  |
        +---------+--------+
                  |
        +---------v--------+
        |  Plan-Execution  |
        +---------+--------+
                  |
        +---------v--------+
        | (Opt.) Generate  |
        +---------+--------+
                  |
        +---------v--------+
        |     Audit-Log    |
        +------------------+
```

## 5. Lépések részletei

### 5.1 Ingest / Snapshot-verify

* Bemenet: tarball vagy manifest + fájlkészlet.
* Ellenőrzés: SHA-256 hash egyezés, opcionális aláírás (Vault Transit vagy self-signed).
* Kimenet: megbízható snapshot-azonosító (digest) és betöltött nyers tartalom.

### 5.2 Build-graph

* Node: pl. md/yaml dokumentum, séma, policy.
* Edge: pl. `related_nodes`, séma-kapcsolat, policy-él.
* Az építés után a gráf topológia statikus.

### 5.3 Inject-defaults

* Az Injector séma és policy alapján alapértékeket, default címkéket, és derived node-okat illeszt be.
* Az injektált elemek audit-nyomon követhetők.

### 5.4 Validate-schema

* A séma-követelmények ellenőrzése minden node-on és él-útvonalon.
* Hibás tartalom → pipeline megáll, audit-logban hiba rögzül.

### 5.5 Apply-policy

* A PolicyEngine explicit szabályok szerint engedélyez / degradál / tilt.
* Kimenet: szűkített és annotált gráf a további bejáráshoz.

### 5.6 Traverse-graph

* A kérdés által érintett kezdőcsomópont(ok)ból determinisztikus gráfbejárás.
* Lépésközben figyelembe veszi a policy és séma feltételeket.

### 5.7 Plan-execution

* A releváns algráf alapján meghatározott végrehajtási terv.
* Tartalmazhat sorrendiséget, feltétel-ellenőrzéseket, válasz-összeállítási stratégiát.

### 5.8 (Optional) Generate-response

* Ha szükséges, generatív modellhez adja át a kontextust.
* Csak a determinisztikusan kiválasztott és policy-engedélyezett részt.

### 5.9 Audit-log

* Minden lépésnél: bemenet, kimenet, hash, időbélyeg, döntési szabály azonosító.
* Visszajátszható feldolgozási útvonal: **same snapshot + same query → same log → same answer**.

## 6. Fő invariánsok

* **Determinista bejárás:** az Interpreter mindig azonos útvonalat követ.
* **Reprodukálhatóság:** snapshot változatlansága garantálja a válasz azonosságát.
* **Auditálhatóság:** minden döntéshez visszakereshető policy és séma.
* **Biztonság:** hibás séma/policy vagy tiltott él esetén a folyamat megáll.

## 7. Összefoglalás

Ez az RFC a CIC-Graph-Interpreter feldolgozási folyamatát írja le, amely biztosítja a reprodukálható, auditálható és séma-vezérelt válaszadást. A pipeline a későbbi RFC-kben (IR, interfészek, trust, threat-model) részletezett komponensekre támaszkodik.

---

*Ez az RFC tervezetként szolgál; a review folyamat során pontosítás és kiegészítés várható.*
