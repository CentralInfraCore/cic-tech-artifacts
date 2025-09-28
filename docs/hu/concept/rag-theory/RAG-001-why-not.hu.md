# RAG-001 — Miért nem elég a klasszikus RAG? (HU)

## 1. Cél és státusz

* **Azonosító:** RAG-001
* **Projekt:** CIC-Graph-RAG
* **Verzió:** 0.1-draft
* **Nyelv:** Magyar (primer)
* **Státusz:** Tervezet / elemző
* **Dátum:** [kitöltendő]
* **Szerző:** [kitöltendő]

## 2. Kivonat (Abstract)

Ez a dokumentum bemutatja, hogy **miért nem elegendő a hagyományos Retrieval-Augmented Generation (RAG) megközelítés** a CIC-projekt céljaihoz. Részletezi a klasszikus RAG korlátait auditálhatóság, determinisztikusság, és séma-követés szempontjából, valamint indokolja a Graph-IR–alapú RAG szükségességét.

## 3. Háttér

* A klasszikus RAG elsősorban **vektoralapú dokumentum-visszakeresést** alkalmaz (pl. embedding + nearest neighbor).
* Ez jól működik szabad szöveges tartalmaknál, de **nehezen garantálható a reprodukálhatóság és a biztonság**.
* A CIC architektúrában a **determinista, séma-vezérelt feldolgozás** alapkövetelmény.

## 4. Klasszikus RAG korlátai

### 4.1 Determinizmus hiánya

* A vektoros keresés **adatbázis- és beállításfüggő**.
* A visszaadott top-k dokumentumok gyakran változnak, akár kis változások miatt.
* Ugyanazon input nem mindig ugyanazt az eredményt adja.

### 4.2 Auditálhatatlanság

* A lekérdezésekhez tartozó **kontextusválasztás nem átlátható**.
* Nehéz rögzíteni, hogy pontosan mely dokumentumok és mely változataik járultak hozzá a generált válaszhoz.
* Nincs egységes hash- és manifest-lánc.

### 4.3 Séma- és policy-követés hiánya

* A hagyományos RAG gyakran nyers dokumentumokat szolgáltat a modellnek.
* Nem illeszkedik a CIC **Graph-IR + séma-validáció** alapú pipeline-jához.
* Nem biztosít kontrollált, típusbiztos lekérdezéseket.

### 4.4 Biztonsági kockázatok

* **Ad hoc kontextus-injektálás** kockázatos, különösen szabályozott környezetben.
* Nincs garancia arra, hogy a modellhez kerülő tartalom hiteles, engedélyezett és változatlan.

## 5. CIC követelményei

* **Reprodukálhatóság:** snapshot → determinisztikus lekérdezés → generatív válasz.
* **Integritás és audit:** kontextusforrások hash-lánccal védettek és ellenőrizhetők.
* **Sémaalapú értelmezés:** minden kontextus-gráf sémának megfelelően validált.
* **Policy enforcement:** csak engedélyezett csomópontok és él-típusok kerülhetnek a generatív modell kontextusába.

## 6. Miért Graph-IR–alapú RAG?

* A Graph-IR réteg már biztosítja:

    * determinisztikus, auditált adatforrást,
    * típusbiztos és sémával validált kontextus-lekérdezést,
    * kompatibilitást a CIC pipeline további szakaszaival.
* Ez lehetővé teszi, hogy a generatív AI a **CIC trust-láncába illeszkedve** működjön.

## 7. Összegzés

A klasszikus RAG nem felel meg a CIC követelményeinek az **auditálhatóság, determinisztikus viselkedés, és séma-követés** terén. A Graph-IR–alapú RAG biztosítja, hogy a generatív AI alkalmazások **biztonságos, szabályozott és reprodukálható módon** integrálódjanak a CIC architektúrájába.

---

*Ez a dokumentum tervezet; a későbbi verziók részletesebb példákat, benchmarkokat és biztonsági összehasonlításokat fognak tartalmazni.*
