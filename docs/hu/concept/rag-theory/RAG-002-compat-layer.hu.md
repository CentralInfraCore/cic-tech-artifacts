# RAG-002 — Kompatibilitási réteg és adapter (HU)

## 1. Cél és státusz

* **Azonosító:** RAG-002
* **Projekt:** CIC-Graph-RAG
* **Verzió:** 0.1-draft
* **Nyelv:** Magyar (primer)
* **Státusz:** Tervezet / technikai
* **Dátum:** [kitöltendő]
* **Szerző:** [kitöltendő]

## 2. Kivonat (Abstract)

Ez a dokumentum a **CIC-Graph-RAG** kompatibilitási rétegének és adapterének célját és felépítését írja le. A réteg lehetővé teszi, hogy a generatív motorok (LLM-ek) determinisztikus, auditált módon férjenek hozzá a Graph-IR által szolgáltatott kontextushoz, miközben megőrzik a CIC trust-lánc által megkövetelt következetességet és biztonságot.

## 3. Motiváció

* A generatív motorok (pl. LLM-ek) általában **nyers szöveges bemenetet** várnak.
* A CIC-ben a kontextus determinisztikus és séma-vezérelt, ezért szükség van egy **adapter rétegre**, amely a gráfban validált adatokat konzisztens, ellenőrzött formában továbbítja.
* A kompatibilitási réteg minimalizálja az eltéréseket és biztosítja az auditálhatóságot.

## 4. Architektúra áttekintés

```
[Snapshot + Manifest]
        ↓
  [Graph-IR Engine]
        ↓
  [Context Selector]
        ↓
  [Compat Layer + RAG Adapter]
        ↓
  [Generatív Modell (LLM)]
        ↓
  [Response Auditor]
```

## 5. Fő komponensek

### 5.1 Compat Layer

* **Input Normalizer:** a Graph-IR kimenetét LLM-barát szöveges formátumba alakítja.
* **Metadata Embedder:** a kontextushoz tartozó hash-eket és audit-információkat strukturált metaadatként továbbítja.
* **Policy Guard:** ellenőrzi, hogy a modellhez csak engedélyezett tartalom kerüljön.

### 5.2 RAG Adapter

* **Interface Handler:** kommunikációs API a generatív motorhoz.
* **Audit Hook:** biztosítja, hogy a generált válasz összekapcsolódjon a felhasznált kontextus hash-ével.
* **Rate & Size Control:** szabályozza az átadott kontextus mennyiségét és feldolgozási ütemét.

## 6. Kompatibilitási stratégiák

* **Séma-központú normalizálás:** minden kontextus-csomópont sémán alapuló címkékkel és sorrenddel kerül átadásra.
* **Determinista kontextus-szelekció:** azonos snapshot és lekérdezés → azonos kontextus → azonos input a modellnek.
* **Verifikált adatút:** minden átvitt kontextus-elem hash-el ellenőrzött.

## 7. Integráció más RFC-kkel

* Illeszkedik az RFC-002 (Pipeline) által meghatározott lépések közé.
* Követi az RFC-004 (Trust-lánc) és RFC-006 (Threat-model) biztonsági követelményeit.
* Kiterjeszti az RFC-005 (Interfészek) specifikációit a generatív adapterrel.

## 8. Példa folyamat

1. A Context Selector kiválasztja a szükséges csomópontokat a Graph-IR-ből.
2. A Compat Layer normalizálja és audit-metaadatokkal látja el a kontextust.
3. A RAG Adapter átadja a kontextust a modellnek, és regisztrálja a folyamatot az audit-logban.
4. A Response Auditor rögzíti a válasz hash-ét és összekapcsolja a kontextus hash-ával.

## 9. Összegzés

A RAG-002 által meghatározott **kompatibilitási réteg és adapter** kulcsfontosságú a generatív AI determinisztikus és auditált integrációjához a CIC-Graph-Interpreter környezetében. Biztosítja, hogy a generatív modellek ne bontsák meg a pipeline konzisztenciáját, és a kontextus-átadás transzparens, ellenőrizhető módon történjen.

---

*Ez a dokumentum tervezet; a későbbi verziók részletesebb API-leírást, adatfolyam-diagramokat és tesztelési szcenáriókat fognak tartalmazni.*
