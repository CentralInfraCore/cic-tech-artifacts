# ANNEX-A — CIC Evidenciák (HU)

## 1. Cél és státusz

* **Dokumentum típusa:** Függelék (Annex-A)
* **Projekt:** CIC-Graph-Interpreter (CGI)
* **Verzió:** 0.1-draft
* **Nyelv:** Magyar (primer)
* **Státusz:** Tervezet / bővítés alatt
* **Dátum:** [kitöltendő]
* **Szerző:** [kitöltendő]

## 2. Kivonat (Abstract)

Ez a függelék a CIC-Graph-Interpreter fejlesztésének és RFC-kben (001–006) lefektetett elveknek **bizonyító és referenciális anyagait** tartalmazza. Az ANNEX-A célja, hogy **átfogó és hiteles háttéranyagot** nyújtson a projekt történetéhez, a döntések indoklásához, a validációs lépésekhez és a reprodukálhatóság biztosításához.

## 3. Történeti háttér

* A CIC-projekt gyökerei: **gráf-alapú tartalomértelmezés** → determinisztikus feldolgozás.
* A RAG helyett **Graph-IR** alkalmazása a kontextus-injektálás és értelmezés során.
* Supply-chain megközelítés (tar → SHA-256 → Vault Transit aláírás).
* A korai PoC tapasztalatok és visszajelzések → RFC-sorozat.

## 4. Forrás evidenciák

* **README.ai.md**: korai elvi irányelvek.
* **PoC repók és commit-logok**: fejlődés és iterációk nyoma.
* **Specifikációk és sémafájlok**: determinisztikus értelmezés alapjai.
* **Konverzációs naplók (CIC témájú)**: döntések indoklása.
* **Vault Transit aláírási metrikák**: hash és aláírási logok.

## 5. Validációs és audit evidenciák

* **Pipeline-futtatási naplók**:

    * snapshot hash ellenőrzések,
    * séma-validációs riportok,
    * policy enforcement statisztikák.
* **Audit-lánc minták**: hash-chain integritás proof.
* **TCK-futtatási eredmények**: PASS/FAIL statisztikák és regressziólogok.
* **Biztonsági incidensek / teszt-szcenáriók**: replay, TOCTOU, injector abuse.

## 6. Annex felépítése

```
docs/
  hu/
    annex/
      A-cic-evidences.md   (ez a dokumentum)
      B-hello-graph.md     (tervezett, mintapélda)
      ...
```

## 7. Használat és referencia

* Az ANNEX-A **támogató hivatkozás** az RFC-k és a TCK-README számára.
* Az itt felsorolt bizonyítékok **ellenőrizhetők és reprodukálhatók**.
* A projekt további fejlődése során bővülhet (pl. új PoC, új audit-log minták).

## 8. Összegzés

Az ANNEX-A a CIC-Graph-Interpreter **projektbizonyítékainak és történeti forrásainak gyűjteménye**, amely támogatja a determinisztikus és auditálható működés transzparenciáját.

---

*Ez a függelék jelenleg tervezet, a későbbi verziók részletesebb listát és hivatkozási linkeket fognak tartalmazni.*
