# DGP — GYIK (HU)

> **Cél:** gyors, egyértelmű válaszok a bevezetés és a mindennapi használat tipikus kérdéseire. A GYIK a 02–08 fejezetekre támaszkodik, de önmagában is használható „elsősegély”.

---

## 1) Alapfogalmak röviden

**K: Mi az a DGP?**
**V:** *Determinista Gráf Eredetiség*: kanonizálás → `sha256` → leválasztott aláírás → attesztáció, **STRICT‑GRAPH** és **TRIAD‑ON** kapukkal.

**K: Miért nem elég egy PGP‑aláírt zip?**
**V:** Mert a bizonyításnak **tartalomhoz** kell kötődnie (hash), nem tetszőleges csomag‑blobhoz; a DGP a **gráf‑kapcsolatokat** is kényszeríti, nem csak a fájlt.

**K: Mi az „anchor” (horgony)?**
**V:** Verifikálható hivatkozás: `hash://…`, `sig://…`, `attest://…`.

---

## 2) Hash / Canon / MANIFEST

**K: Pontosan mit hash‑elünk?**
**V:** A **kanonizált bájtfolyamot** (determinista sorrend, `\n` sorvégek, BOM nélkül). Ugyanaz a tartalom → ugyanaz a hash.

**K: Miért `sha256`?**
**V:** Széles körben elfogadott, gyors, és elégséges ütközésállóságot ad a céljainkhoz.

**K: Mit tartalmaz a `MANIFEST.sha256`?**
**V:** A csomagolt komponensek neveit és `sha256` értékeiket **stabil sorrendben**.

---

## 3) Aláírás (detached) és kulcsok

**K: Miért leválasztott aláírás?**
**V:** Hogy a bizonyítás független legyen a fájlrendszertől/OS‑től; a `sig` a MANIFEST **hash‑ére** mutat.

**K: Hol vannak a kulcsok?**
**V:** Vault Transit/HSM mögött; a runner rövid élettartamú tokennel kér aláírást. A kulcs **nem** kerül a repo‑ba/runnerre.

**K: Mi a teendő kulcsrotációkor?**
**V:** Új Transit kulcs, fokozatos átállás; régi kiadások verifikálhatók maradnak (attest + kulcsazonosító).

---

## 4) Attesztáció

**K: Mit írunk az attesztációba?**
**V:** Commit SHA, CI run azonosító, builder/környezet, bemenetek, időbélyeg, opcionálisan PR link és rövid „miért”.

**K: JSON vagy YAML?**
**V:** Tetszőleges, a **séma** a fontos; a `verify` ezt ellenőrzi.

**K: Hogyan védjük az attesztet?**
**V:** A MANIFEST hash‑hez kötöttük a folyamathoz; verifikációkor ellenőrizzük a futási azonosítókat.

---

## 5) Gráf és `related_nodes`

**K: Miért nem írhatok fájlutat a `related_nodes`‑ba?**
**V:** A logikai URI költözés‑tűrő és policizálható; a fájlút törékeny és ellenőrizhetetlen.

**K: Mi az engedélyezett névtér?**
**V:** `schema://`, `doc://`, `module://`, `policy://` (és horgonyok: `hash://`, `sig://`, `attest://`).

**K: Lehetnek körhivatkozások?**
**V:** Alapesetben nem; kivétel csak dokumentált **waiverrel** és időzárral.

---

## 6) CI / kapuk

**K: Blokkolhat merge‑et a `graph-check`?**
**V:** Igen, **protected** branch‑en kötelezően; máshol kezdetben warning → később error.

**K: Mikor fusson a `verify`?**
**V:** Miután `package`, `sign`, `attest` lefutott; protected branch‑en **blokkoló**.

**K: Mi kerül publikálásra release‑kor?**
**V:** `artifacts.tar`, `MANIFEST.sha256`, `MANIFEST.sha256.sig`, `attestation.json`.

---

## 7) TRIAD‑ON & STRICT‑GRAPH

**K: Mit jelent a TRIAD‑ON?**
**V:** App / Infra / Tests‑Docs szétválasztásának és arányainak őrzése; a drifteket CI mérőszámok figyelik.

**K: Mi a STRICT‑GRAPH lényege?**
**V:** A `related_nodes` **logikai** és **ellenőrzött**; árvák tiltva, névterek allowlistálva.

---

## 8) Verziózás

**K: Mikor kell `@vN` emelés?**
**V:** Ha a csomópont **fogalmi szerződése** törik („breaking change”). Kisebb módosítás → `version` mező.

**K: Mi a deprecálás útja?**
**V:** `status: deprecated`, hivatkozások kifuttatása, artefaktok megőrzése.

---

## 9) Waiver / kivétel

**K: Mikor kérhetek waivert?**
**V:** Ritkán; ha üzleti kényszer van. Kötelező: indoklás, időzár (≤30 nap), legalább 2 jóváhagyó.

**K: Enyhít‑e a waiver az anchor‑kötelezettségeken?**
**V:** Nem. Hash/sig/attest **mindig** kötelező kiadásnál.

---

## 10) Hibák és megoldások

| Hiba             | Jelenség            | Teendő                                       |
| ---------------- | ------------------- | -------------------------------------------- |
| Árva él          | `graph-check` piros | Célcsomópont létrehozása vagy URI‑javítás    |
| Illegális névtér | `graph-check` piros | Policy‑allowlist bővítése vagy URI‑csere     |
| Hash mismatch    | `verify` piros      | Kanonizálás felülvizsgálata (sorvégek/mtime) |
| Sig invalid      | `verify` piros      | Transit jogosultság/rotáció ellenőrzése      |
| Attest invalid   | `verify` piros      | Séma‑lint, kötelező mezők pótlása            |

---

## 11) Metrikák

* **Árva‑ráta**, **névtér‑szabálysértés** arány, **hash‑egyezés** arány.
* Kapuk **átfutási ideje** és **hibaarány** szabályonként.

---

## 12) Governance / felelősségek

* **Tulajdonos csapat:** tartalom + `related_nodes` helyessége.
* **CI/Build:** kanonizálás, csomag, aláírás, atteszt, verifikáció.
* **Biztonság/megfelelés:** policy, waiver, audit.

---

## 13) Minták

**Jó URI‑k:**

```
doc://hu/concept/dgp-provenance@v1
schema://provenance/manifest@v1
module://cic/build/packager@v1
policy://graph/namespace-allowlist@v1
```

**Tiltott minták:** `Doc://…`, `doc://…@version1`, `../docs/x.md`

---

## 14) DoD ehhez a fejezethez

* A fenti kérdésekre **egyértelmű** válasz létezik.
* A GYIK hivatkozik a részletes fejezetekre, és **nem** ellentmondásos velük.
* Új belépő 30 perc alatt képes „zöld PR‑t” létrehozni a GYIK segítségével.
