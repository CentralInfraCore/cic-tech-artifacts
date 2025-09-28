# RFC-006 — CIC-Graph-Interpreter — Threat-model és biztonsági megfontolások (HU)

## 1. Cím és státusz

* **Azonosító:** RFC-006
* **Projekt:** CIC-Graph-Interpreter (CGI)
* **Verzió:** 0.1-draft
* **Nyelv:** Magyar (primer)
* **Státusz:** Tervezet / review alatt
* **Dátum:** [kitöltendő]
* **Szerző:** [kitöltendő]

## 2. Kivonat (Abstract)

Ez az RFC a CIC-Graph-Interpreter **fenyegetési modelljét és biztonsági megfontolásait** határozza meg. Azonosítja a potenciális támadási vektorokat, a trust-lánc és audit mechanizmusok által nyújtott védelmi rétegeket, valamint kiegészítő kontrollokat, amelyek a feldolgozási pipeline reprodukálhatóságát és integritását garantálják.

## 3. Célok

* A gráf-alapú determinisztikus feldolgozás **integritásának és biztonságának megőrzése**.
* A **TOCTOU (Time-of-Check–Time-of-Use)** jellegű támadások kizárása.
* A **downgrade** és **policy-bypass** kísérletek felismerése és megelőzése.
* Az audit-lánc **megbízhatóságának fenntartása** (tamper-evident).
* A rendszer működésének **ellenőrizhetősége és megfelelősége** (compliance).

## 4. Fenyegetési kategóriák

### 4.1 Bemeneti réteg

* **Rosszindulatú snapshot:** manipulált tar-archívum vagy manifest.
* **Hash-collision támadás:** elméleti, de hosszú távú fenyegetés.
* **Nem hitelesített aláírás:** hiányzó vagy érvénytelen signature.

### 4.2 Feldolgozási pipeline

* **TOCTOU támadás:** a snapshot vagy séma módosítása a verify és a feldolgozás között.
* **Injector abuse:** default értékekkel rejtett, váratlan logika.
* **Schema-bypass:** sémahibás, de átcsúszó node vagy él.
* **Policy-downgrade:** engedélyezettként jelölt, valójában tiltott él.
* **Traversal manipulation:** grafikus struktúra kihasználása a bejárási útvonal megváltoztatására.

### 4.3 Kimeneti réteg

* **Response forgery:** audit-log nélküli válasz kiadása.
* **Log tampering:** audit-lánc manipulálása a tények eltüntetésére.
* **Replay támadás:** régi, de érvénytelen snapshot válaszainak újrafelhasználása.

## 5. Védelmi kontrollok

### 5.1 Trust-lánc (RFC-004)

* Tar → SHA-256 → aláírás → ellenőrzés minden pipeline futás előtt.
* Séma és policy snapshot részeként verziózott.

### 5.2 Audit-lánc

* Append-only és hash-chained (Merkle) napló.
* Bármilyen manipuláció láthatóvá válik a lánc megszakadásával.

### 5.3 Idempotens injektálás

* Az Injector determinisztikus, ugyanazon snapshoton mindig ugyanazt az eredményt adja.
* Minden injektált elem auditálva van.

### 5.4 Séma-vezérelt validáció

* Minden node és él a séma ellenőrzésén megy át.
* Hibás vagy ismeretlen entitás megállítja a pipeline-t.

### 5.5 Policy enforcement

* Explicit allow / degrade / deny szabályok.
* Annotáció → bejárás során döntés-alapú szűrés.

### 5.6 Izoláció és futtatási környezet

* Container / sandbox környezetben futtatás.
* Csökkentett privilégiumok, seccomp profil, W^X memória.

### 5.7 Replay-védelem

* Válaszhoz tartozó snapshot- és audit-hash beágyazása.
* Eltérő snapshot hash → válasz érvénytelen.

## 6. Kockázatértékelés

| Kategória          | Példa                    | Hatás súlyossága | Valószínűség    | Kezelés                               |
| ------------------ | ------------------------ | ---------------- | --------------- | ------------------------------------- |
| Bemenet integritás | manipulált tar           | Kritikus         | Alacsony        | Hash + aláírás                        |
| TOCTOU             | verify és build között   | Kritikus         | Közepes         | Hash-újraellenőrzés + immutábilis tár |
| Injector abuse     | default rejtett mező     | Magas            | Közepes         | Policy + audit                        |
| Schema-bypass      | hibás, de elfogadott     | Magas            | Alacsony        | Séma-validáció                        |
| Policy-downgrade   | tiltott él átcsúszik     | Kritikus         | Alacsony        | Annotáció + traversal-filter          |
| Log tampering      | audit törlés / módosítás | Kritikus         | Nagyon alacsony | Append-only + hash-chain              |
| Replay             | régi snapshot reuse      | Közepes          | Alacsony        | Snapshot hash beágyazás               |

## 7. Integráció más RFC-kkel

* RFC-002 (Pipeline): minden pipeline-lépés kontroll alatt.
* RFC-003 (Graph-IR): hash-stabilitás és séma-invariánsok.
* RFC-004 (Trust-lánc): end-to-end integritás.
* RFC-005 (Interfészek): komponensek szerződéses együttműködése.

## 8. Összegzés

Ez az RFC a CIC-Graph-Interpreter fenyegetési modelljét rögzíti, amely a determinisztikus, auditálható és szabályozás-kompatibilis működés alapfeltétele. A védelmi kontrollok a trust-lánccal és az audit-lánccal együtt zárják ki a legtöbb támadási vektort és támogatják a biztonságos, reprodukálható működést.

---

*Ez az RFC tervezet; a review során további részletekkel és példákkal egészülhet ki.*
