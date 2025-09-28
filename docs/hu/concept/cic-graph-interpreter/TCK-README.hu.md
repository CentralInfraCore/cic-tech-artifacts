# TCK-README — CIC-Graph-Interpreter — Tesztkonformancia-készlet (HU)

## 1. Cél és státusz

* **Dokumentum típusa:** TCK (Test Compatibility Kit) leírás
* **Projekt:** CIC-Graph-Interpreter (CGI)
* **Verzió:** 0.1-draft
* **Nyelv:** Magyar (primer)
* **Státusz:** Tervezet / review alatt
* **Dátum:** [kitöltendő]
* **Szerző:** [kitöltendő]

## 2. Kivonat (Abstract)

Ez a dokumentum leírja a CIC-Graph-Interpreter **Tesztkonformancia-készletének (TCK)** célját, felépítését és használatát. A TCK célja, hogy **verifikálja az implementációk megfelelőségét az RFC-kben (001–006) meghatározott szerződéseknek és invariánsoknak**, különösen a determinisztikus, auditálható működés és a séma/policy-követés tekintetében.

## 3. Háttér

* A CGI sikeres bevezetéséhez és harmadik felek általi implementációjához elengedhetetlen az **objektív, automatizált megfelelőségi tesztelés**.
* A TCK biztosítja, hogy bármely implementáció **ugyanazon snapshot → ugyanazon válasz** elvet követve működjön.
* A TCK a supply-chain és audit követelményeket is lefedi (pl. hash-ellenőrzés, log-inkonzisztencia felismerése).

## 4. Tesztelési elvek

1. **Determinista viselkedés:** adott bemenet → adott kimenet.
2. **Reprodukálhatóság:** hash és auditlog egyezés.
3. **Sémaalapú megfelelés:** node-ok és élek validációja.
4. **Policy enforcement:** allow/degrade/deny helyes alkalmazása.
5. **Trust-lánc tiszteletben tartása:** snapshot és manifest hitelesítése.
6. **Biztonsági kontrollok:** TCK szimulálja a legfontosabb fenyegetési helyzeteket.

## 5. TCK felépítése

```
tck/
  ├── cases/
  │    ├── valid/
  │    │    ├── snapshot-basic.tar
  │    │    ├── snapshot-with-policies.tar
  │    │    └── ...
  │    ├── invalid/
  │    │    ├── bad-schema.tar
  │    │    ├── tampered-hash.tar
  │    │    └── ...
  │    └── security/
  │         ├── replay-attack-case.tar
  │         ├── injector-abuse-case.tar
  │         └── ...
  ├── scripts/
  │    ├── run_all.sh
  │    ├── verify_snapshot.sh
  │    ├── check_audit_log.sh
  │    └── ...
  ├── expected/
  │    ├── valid/
  │    ├── invalid/
  │    └── security/
  └── README.md (ez a dokumentum)
```

## 6. Használat

### 6.1 Előkészítés

* Telepítsd a referencia-implementációt vagy a tesztelni kívánt motort.
* Győződj meg róla, hogy a `tck/cases` elérhető.

### 6.2 Tesztek futtatása

```bash
cd tck/scripts
./run_all.sh --impl /path/to/cic-graph-interpreter
```

### 6.3 Kimenet

* A script minden tesztesetre kiírja:

    * **PASS / FAIL** státuszt,
    * az eltérés jellegét (pl. sémahiba, rossz audit-hash, hibás policy-döntés).
* A részletes logokat a `tck/logs` könyvtár tartalmazza.

## 7. Követelmények

* A TCK-hoz tartozó snapshotok és manifestek **determinista módon előállított**.
* A tesztelt implementáció biztosítja az RFC-k szerinti interfészeket (ld. RFC-005).
* A futtatási környezet izolált (container/sandbox).

## 8. Eredmények értelmezése

* **100% PASS:** implementáció megfelel az elvárt működésnek.
* **Részleges FAIL:** további vizsgálat szükséges, különösen a biztonsági és audit tesztek esetén.
* **FAIL biztonsági teszteknél:** implementáció nem tekinthető megbízhatónak.

## 9. Összegzés

A TCK a CIC-Graph-Interpreter meghatározott szerződéses viselkedésének **objektív és automatizált verifikációs eszköze**. Elengedhetetlen a harmadik féltől származó implementációk, valamint a verziófrissítések ellenőrzéséhez.

---

*Ez a README tervezetként szolgál; a review során további példatesztek és futtatási útmutató kerülhet be.*
