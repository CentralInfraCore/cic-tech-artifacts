# RAG-00 — CIC-Graph-RAG — Primer (HU)

## 1. Cél és státusz

* **Azonosító:** RAG-00
* **Projekt:** CIC-Graph-RAG (kísérleti alprojekt)
* **Verzió:** 0.1-draft
* **Nyelv:** Magyar (primer)
* **Státusz:** Tervezet / bevezető
* **Dátum:** [kitöltendő]
* **Szerző:** [kitöltendő]

## 2. Kivonat (Abstract)

Ez a dokumentum a **CIC-Graph-RAG** alprojekt bevezető (primer) leírása. Célja, hogy kontextust és alapvető fogalmi keretet nyújtson a Graph-IR-re épülő determinisztikus RAG-megközelítés megértéséhez. A primer az elméleti indoklásra, az architekturális helyére és a CIC-projekten belüli motivációra fókuszál.

## 3. Miért Graph-RAG?

* A hagyományos RAG sokszor **ad hoc dokumentum-visszakeresést** végez, ami nehezen auditálható és nem determinisztikus.
* A CIC már kialakított egy **Graph-IR réteget**, amely:

    * determinisztikus snapshotból épül,
    * séma-vezérelt, és
    * audit-lánc által védett.
* A generatív AI csak akkor illeszkedik a CIC elveihez, ha **a kontextusforrása ugyanazt a determinisztikus és auditálható eljárást követi**, mint a pipeline többi része.

## 4. Fogalmi térkép

* **Graph-IR:** a determinisztikus gráf-reprezentáció, a teljes tudásbázis strukturált modellje.
* **Context Selector:** a gráfból determinisztikusan kiválasztott, lekérdezett részhalmaz.
* **RAG Adapter:** interfész a generatív modellhez, amely átadja a kontextust és biztosítja az audit-metadata rögzítését.
* **Response Auditor:** a kontextus hash-ét és a válasz hash-ét összekapcsoló komponens.
* **Trust-lánc:** a snapshot, manifest, és audit-lánc által biztosított end-to-end integritás.

## 5. Motiváció

* **Reprodukálhatóság:** ugyanazon snapshotból ugyanazon kontextus épül fel → ugyanazon generatív válaszok.
* **Megfelelőség:** a séma- és policy-követés kiterjesztése a generatív AI kimeneteire.
* **Átláthatóság:** minden kontextus-lekérdezés és -átadás auditált.
* **Biztonság:** nincs lehetőség nem engedélyezett, ellenőrizetlen tartalom injektálására.

## 6. Helye a CIC architektúrában

```
[CIC Snapshot + Manifest]
          ↓
     [Graph-IR Build]
          ↓
 [Context Selector → RAG Adapter]
          ↓
 [Generatív Modell + Response Auditor]
```

* A RAG a Graph-IR felett működik, a pipeline szerves részeként.
* Nem helyettesíti a feldolgozási pipeline-t, hanem kiegészíti azt a generatív válaszkészítés szakaszában.

## 7. Használati forgatókönyvek

* **Dokumentációs lekérdezések:** policy-kompatibilis részhalmazból adható generatív összefoglaló.
* **Műszaki Q&A:** séma-követő, pontos kontextushoz kapcsolt válaszok.
* **Audit-jelentések:** generatív módon kinyert, de determinisztikusan válogatott kontextusból készített beszámolók.

## 8. Összegzés

A RAG-00 primer bemutatja a motivációt és a helyét a CIC-projektben: a generatív AI csak akkor használható biztonságosan és szabályozás-kompatibilisen, ha a **kontextust determinisztikus, gráf- és sémaalapú módon szolgáltatjuk**.

---

*Ez a dokumentum tervezet; a további verziók részletesebb példákat, API-vázlatokat és audit-folyamatleírást fognak tartalmazni.*
