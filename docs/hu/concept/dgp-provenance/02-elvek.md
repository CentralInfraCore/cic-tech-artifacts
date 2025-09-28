# DGP — Elvek (olvasható, gyakorlati szemlélettel)

> **A DGP nem eszköz, hanem fegyelem.** A lényeg: identitás a hely előtt, bizonyíték a publikálás előtt, gráf a fájlok előtt.

---

## 0) Hogyan érdemes olvasni?

Ez a fejezet a *miértből* vezet át a *hogyanba*. Először a gondolkodásmódot rendezzük: milyen egyszerű, de szigorú elvek tartják egyben a rendszert. Utána minden elvhez adunk egy mini‑példát és ellenpéldát, majd rövid **„bevezetés a gyakorlatba”** blokkot.

---

## 1) Tartalom‑címzés (content‑addressing)

**Állítás.** Egy csomópontot az határoz meg, amit a *kanonizált tartalma* hash‑el ad ki.

* **Miért?** A fájlútvonal és a formátum változékony; a hash stabil, összehasonlítható és aláírható.
* **Hogyan?** Kanonizálás → `sha256` → `hash://sha256/<digest>` horgony.
* **Példa.** A `docs/hu/concept/dgp-provenance.md` és az angol párja más útvonalon él, de az ID és a hash adja az azonosságot.
* **Anti‑példa.** „A README a gyökérben a forrás az igazságnak.” — nem skálázódik, nem bizonyítható.
* **Gyakorlat.** `make package` előtt kanonizálj; ne engedj kiadást MANIFEST nélkül.

---

## 2) Leválasztott aláírás (detached signature)

**Állítás.** A hash‑t írjuk alá, nem magát a fájl‑blobot.

* **Miért?** Formátum‑, futásidő‑ és OS‑különbségek ne törjék meg a láncot.
* **Hogyan?** `sig://vault-transit/<kulcs>`; kulcs a Transit mögött, rotációval.
* **Példa.** A `MANIFEST.sha256` aláírt; az aláírás független a fájlrendszertől.
* **Anti‑példa.** „PGP‑vel ráírtam a fájl végére.” — diff‑zajos, törékeny.
* **Gyakorlat.** `make sign` mindig a MANIFEST hash‑ére mutasson.

---

## 3) Attesztáció (könnyű SLSA)

**Állítás.** A ki *ki/mi/mikor/mivel* kérdéseire géppel olvasható választ adunk.

* **Miért?** Incidensnél nem szabad régészetbe fordulni az audit.
* **Hogyan?** `attest://…` horgony: CI run azonosító, bemenetek, builder, dátum.
* **Példa.** A release‑hez csatolt `attestation.json` a commit hash‑sel és a build inputokkal.
* **Anti‑példa.** „A pipeline logban benne van.” — volatilis, részleges, nem ellenőrzött.
* **Gyakorlat.** `make attest` kötelező protected brancheken.

---

## 4) Gráf‑első gondolkodás

**Állítás.** A tudás **csomópontok és élek** formájában él; a fájl csak hordozó.

* **Miért?** A kapcsolatok (függések, hivatkozások) adják az értelmet.
* **Hogyan?** `related_nodes` **logikai URI‑kkal** (nem path), névtér‑allowlisttel.
* **Példa.** `doc://concept/dgp-provenance@v1 → schema://provenance/manifest@v1`.
* **Anti‑példa.** „../schemas/manifest.yaml” — költöztetéskor minden törik.
* **Gyakorlat.** `make graph-check`: árva él tiltása, illegális névtér elutasítása.

---

## 5) Determinisztikus csomagolás

**Állítás.** Ugyanabból a bemenetből ugyanaz az artefakt szülessen.

* **Miért?** Reprodukálhatóság nélkül nincs erős bizonyítás.
* **Hogyan?** Rendezett tar, rögzített mtime, stabil sorrend, normalizált sorvégek.
* **Példa.** `tar --sort=name --mtime='UTC 2020-01-01' …` + `MANIFEST.sha256`.
* **Anti‑példa.** „Zip‑peltem gyorsan a laptopomon.” — OS‑függő, időbélyeg‑zajos.
* **Gyakorlat.** Tarts „golden” összehasonlítót a CI‑ban; difflámpa piros, ha eltérés.

---

## 6) Fail‑shut kapuk (gates)

**Állítás.** Ha a gráf vagy a proveniencia hibás, **ne** tudjon merge‑ölni a kód.

* **Miért?** A gyorsaság nem írhatja felül a bizonyíthatóságot.
* **Hogyan?** Protected branch csak zöld `graph-check` + `verify` mellett.
* **Példa.** Új él csak akkor mehet be, ha a célja létezik és engedélyezett névtérben van.
* **Anti‑példa.** „Majd később rendbe tesszük.” — ez a „később” a kiadás napja szokott lenni.
* **Gyakorlat.** A kapuk először „warning” módban indulhatnak, de **határidőre** legyen „error”.

---

## 7) Magyarázhatóság és idempotencia

**Állítás.** A gráfváltozásokat **el tudjuk mesélni**, és a pipeline lépések ismétlése nem okoz mellékhatást.

* **Miért?** A változás célját (új él miért született) a reviewernek értenie kell; újrafuttatáskor ugyanazt várjuk.
* **Hogyan?** Commit‑üzenet + „változás‑narratíva” (rövid), `tools/*` idempotens scriptjei.
* **Példa.** „Az új `module://…` él azért kell, mert a policy‑lint átrendeződött.”
* **Anti‑példa.** „Nem tudom, miért változott.” — ez hiba, nem vélemény.
* **Gyakorlat.** Kötelező „miért” blokk a PR sablonban.

---

## 8) Bilingvális doksi mint szerződés

**Állítás.** Az EN/HU tartalom **fogalmi szinten** ugyanazt állítja.

* **Miért?** A szervezet nyelvi diverzitása nem okozhat eltérő valóságot.
* **Hogyan?** Kereszthivatkozások, egységes meta, automata link‑lint.
* **Példa.** HU „Elvek” = EN „Principles” fejezetek ugyanarra a fogalmi gráfra mutatnak.
* **Anti‑példa.** HU‑ban extra állítások, EN‑ben hiány — drift.
* **Gyakorlat.** CI‑lint: hiányzó pár‑oldal, törött link = fail.

---

## 9) Kulcsok és hozzáférés: „minimális jogosultság”

**Állítás.** Az aláíró kulcsot nem a kód birtokolja, hanem a policy.

* **Miért?** Kulcslopás = bizonyíték‑lopás.
* **Hogyan?** Vault Transit, rövid lejárat, audit, rotáció.
* **Példa.** A `sign_vault` tokenje a runner‑hez kötött, nem fejlesztői géphez.
* **Anti‑példa.** Hard‑coded titkok, lokális kísérletezésből éles kulccsal.
* **Gyakorlat.** Környezetenként külön kulcskészlet; deny‑by‑default.

---

## 10) Minták és ellenminták (gyorstár)

* **Minta:** logikai URI‑k a `related_nodes`‑ban → költözés‑tűrés.
* **Ellenminta:** relatív fájlutak → folyamatosan törik.
* **Minta:** `MANIFEST.sha256` + detached `sig` → stabil bizonyítás.
* **Ellenminta:** „feltöltöttem a zip‑et” → hash drifts.
* **Minta:** „warning→error” kapu‑evolúció → kulturális elfogadás.
* **Ellenminta:** azonnali „hard fail” → kapuk kikerülése.

---

## 11) Bevezetés a gyakorlatba

* **Napi rutin:** minden PR‑ban fusson `graph-check` és `verify`.
* **Release‑pillanat:** MANIFEST + SIG + ATTEST kötelező artefakt.
* **Visszagörgetés:** a hash‑ek miatt determinisztikus; „előző jó” visszahozható.
* **Mérés:** gráf‑sűrűség, árva‑ráta, DoD‑megfelelés; idővel szigorítsd a küszöböket.

---

## 12) Rövid DoD ehhez a fejezethez

* A fenti elvekre **példát** és **ellenpéldát** adtunk.
* A CI‑kapuk, hash/sig/attest és a névterek **összeérnek**.
* Az olvasó képes az elveket a saját moduljára alkalmazni.
