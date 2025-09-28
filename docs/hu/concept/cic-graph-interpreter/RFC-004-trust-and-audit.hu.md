# RFC-004 — CIC-Graph-Interpreter — Trust-lánc és audit (HU)

## 1. Cím és státusz

* **Azonosító:** RFC-004
* **Projekt:** CIC-Graph-Interpreter (CGI)
* **Verzió:** 0.1-draft
* **Nyelv:** Magyar (primer)
* **Státusz:** Tervezet / review alatt
* **Dátum:** [kitöltendő]
* **Szerző:** [kitöltendő]

## 2. Kivonat (Abstract)

Ez az RFC a **trust-lánc és auditálhatóság** alapelveit rögzíti a CIC-Graph-Interpreterben. Meghatározza azokat a mechanizmusokat, amelyek biztosítják a feldolgozott tartalom és a válaszok **hitelességét, integritását és reprodukálhatóságát**. A trust-lánc a forrásfájlok snapshotjától kezdve a pipeline minden lépésén átível.

## 3. Háttér és motiváció

* A determinisztikus feldolgozás csak akkor értékes, ha a **bemenet hiteles** és a teljes feldolgozási út **auditálható**.
* A CIC projekt supply-chain követelményei (tar → SHA-256 → Vault Transit aláírás) biztosítják a forrás integritását.
* A beépített audit-log lehetővé teszi a döntési folyamatok visszakövethetőségét.

## 4. Trust-lánc komponensek

### 4.1 Snapshot és manifest

* **Snapshot:** a forrásfájlok determinisztikus tar-archívuma.
* **Manifest:** a snapshot hash-e (SHA-256) és metaadatai.
* **Aláírás:** a manifest hitelesítése (Vault Transit, HSM vagy self-signed dev módban).

### 4.2 Hash-ellenőrzés

* Minden pipeline-futás előtt ellenőrzi a snapshot hash-ét.
* Ha eltérés van → a pipeline nem indul.

### 4.3 Séma és policy verziózás

* A séma- és policy-fájlok is a snapshot részei → változásuk új hash-t eredményez.
* Így minden futás az adott pillanatban érvényes szerződésekhez kötött.

### 4.4 Gráf-IR hash

* A betöltött snapshotból épített gráf hash-e biztosítja, hogy ugyanaz a bemenet → ugyanaz a gráf.
* Változás esetén a pipeline teljes újrafutása kötelező.

### 4.5 Audit-log

* A pipeline minden lépésénél rögzíti:

    * a bemenet és kimenet hash-ét,
    * a döntési szabály azonosítóját,
    * az időbélyeget és futtatási környezet metaadatait.
* Az audit-log csak hozzáfűrhető (append-only) és kriptográfiailag láncolt (hash-chain / Merkle).

### 4.6 Válasz-artefaktum hitelesítése

* A pipeline végén a válasz (pl. JSON, report) tartalmazza a használt snapshot és audit-log referencia hash-ét.
* Igény esetén a válasz is aláírásra kerülhet.

## 5. Fő elvek

1. **End-to-end integritás:** ugyanaz a snapshot mindig ugyanazt a válaszkészletet eredményezi.
2. **Verifiable provenance:** minden adat és döntés visszavezethető az adott verziójú fájlra, sémára, policyre.
3. **Tamper-evident log:** minden beavatkozás vagy hiba láthatóvá válik a hash-lánc megszakadásával.
4. **Reproducibility & Compliance:** a válasz auditálható, megfelel a szabályozási követelményeknek.

## 6. Illusztráció

```
[Source Files] --tar--> [Snapshot] --SHA-256--> [Manifest] --sign--> [Verified Snapshot]
        |                                             |
        |                                             v
        +--------------------------------------> [Graph-IR Build]
                                                   |
                                                   v
       [Policy/Schemas] ---------------------> [Validated Graph]
                                                   |
                                                   v
          [Pipeline Steps + Audit-Log (hash-chain)]
                                                   |
                                                   v
                                       [Signed Response (optional)]
```

## 7. Integráció más RFC-kkel

* Kapcsolódik: RFC-002 (Pipeline) és RFC-003 (Graph-IR).
* Kiterjeszti a pipeline minden lépését a hash- és audit-felügyelettel.
* Előkészíti a threat-modelben tárgyalt támadási vektorok elleni védelmet.

## 8. Összegzés

Ez az RFC meghatározza a CIC-Graph-Interpreter end-to-end trust-láncát és audit-modelljét, amely garantálja a feldolgozott tartalom hitelességét és a válaszok reprodukálhatóságát. A mechanizmus kulcsfontosságú az ipari és szabályozási megfelelőség elérésében.

---

*Ez az RFC tervezet; a review során pontosítás és implementációs részletek kiegészítése várható.*
