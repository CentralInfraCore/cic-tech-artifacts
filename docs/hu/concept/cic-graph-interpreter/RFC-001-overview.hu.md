# RFC-001 — CIC-Graph-Interpreter — Áttekintés (HU)

## 1. Cím és státusz

* **Azonosító:** RFC-001
* **Projekt:** CIC-Graph-Interpreter (CGI)
* **Verzió:** 0.1-draft
* **Nyelv:** Magyar (primer)
* **Státusz:** Tervezet / review alatt
* **Dátum:** [kitöltendő]
* **Szerző:** [kitöltendő]

## 2. Kivonat (Abstract)

Ez a dokumentum bemutatja a CIC-Graph-Interpreter (CGI) célját, motivációját és fő fogalmait. A CGI egy **RAG-helyetti, determinisztikus gráf-alapú értelmezési modell**, amely a CIC projektben született, és a supply-chain és audit-követelmények miatt a statisztikus keresés helyett **séma-vezérelt gráf-bejárást** alkalmaz.

## 3. Háttér és motiváció

* A hagyományos Retrieval-Augmented Generation (RAG) megközelítés nem biztosítja a *reprodukálhatóságot* és *auditálhatóságot*.
* A CIC-ben a tartalom (Markdown/YAML párok) gráfba van rendezve, a kapcsolatok explicit élként vannak deklarálva.
* A lekérdezés determinisztikusan követi a gráf éleit → *same snapshot → same answer*.
* A supply-chain folyamat (tar → SHA-256 → Vault-sign) hitelesíti a feldolgozott adatot.

## 4. Scope / Hatókör

Ez az RFC leírja:

* a CGI célját és alapfogalmait,
* az architekturális elvet: **injektálás → séma-validáció → policy-filter → bejárás → plan**,
* a fő komponenseket (GraphStore, SchemaValidator, PolicyEngine, Interpreter),
* a további RFC-kben részletezendő részeket (IR, pipeline, interfészek, trust-lánc, threat-model, annexek).

Nem tartalmazza:

* a konkrét node-típusok és licenc-policyk CIC-specifikus részleteit,
* a kompatibilitási réteget a RAG-alapú rendszerek felé.

## 5. Definíciók és fogalmak

* **Node:** a tartalom (pl. dokumentum, séma) egysége, meta-adatokkal és hash-sel.
* **Edge:** kapcsolat két node között, típus és irány meghatározással.
* **GraphStore:** a snapshotból felépített gráf-tár.
* **Injector:** default értékek és kiterjesztett policyk beemelése a feldolgozás előtt.
* **SchemaValidator:** ellenőrzi a node és él konzisztenciáját a sémákhoz.
* **PolicyEngine:** engedélyez / degradál / tilt a node-ok és élek alapján.
* **Interpreter:** determinisztikus bejárást végez, execution-plant épít a gráf alapján.
* **Manifest:** a feldolgozott snapshot hash-e és aláírása.
* **Audit-log:** minden feldolgozási lépés reprodukálható és naplózott.

## 6. Alapelvek

1. **Determinista működés:** adott snapshot + adott query → mindig ugyanaz az eredmény.
2. **Séma-vezérelt feldolgozás:** a séma az elsődleges szerződés.
3. **Policy-beágyazottság:** a döntési logika explicit policykből épül fel.
4. **Audit és trust-lánc:** a forrástól a válaszig végig követhető és ellenőrizhető.
5. **Extenzibilitás:** új node-típus vagy policy hozzáadása nem töri a meglévő determinisztikát.

## 7. Kapcsolódó RFC-k

* RFC-002 — Pipeline és feldolgozási folyamat
* RFC-003 — Gráf-IR és invariánsok
* RFC-004 — Trust-lánc és audit
* RFC-005 — Interfészek és komponens-API
* RFC-006 — Threat-model és biztonsági megfontolások
* ANNEX-A — CIC-ből származó evidencia-példák
* ANNEX-B — Hello-Graph referencia implementáció

## 8. Összegzés

A CIC-Graph-Interpreter a CIC tapasztalataiból született, de általánosítható koncepciót kínál minden olyan környezetnek, ahol **reprodukálható és auditálható gráf-értelmezésre** van szükség a RAG-alapú megközelítések helyett.

---

*Ez az RFC tervezetként szolgál; a review folyamat során pontosítás és kiegészítés várható.*
