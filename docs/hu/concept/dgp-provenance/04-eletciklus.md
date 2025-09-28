# DGP — Életciklus (HU)

> **Kérdés:** hogyan lesz a fogalmi csomópontból (doc/schema/module/policy) bizonyítható, kiadható artefakt?
> **Válasz:** egy szigorú, mégis hétköznapokban működő *hash → aláírás → attesztáció* folyamat, gráfkapukkal.

---

## 0) Gyors áttekintés (madártávlat)

1. **Szerkesztés:** csomópont és `related_nodes` frissítése (logikai URI‑k).
2. **Kanonizálás:** determinisztikus normalizálás → `sha256` hash.
3. **Csomagolás:** rendezett tar + `MANIFEST.sha256`.
4. **Aláírás:** leválasztott aláírás a MANIFEST hash‑ére (Vault Transit).
5. **Attesztáció:** CI‑meta és inputok rögzítése (`attestation.json`).
6. **Ellenőrzés:** `graph-check` + `verify` (hash/sig/attest + policy).
7. **Kiadás:** artefaktok publikálása; hivatkozás a csomópont meta‑jában.
8. **Üzemeltetés:** audit, visszagörgetés, megfelelőségmérés.

---

## 1) Szerepkörök és felelősségek

* **Szerző (Author):** tartalom és `related_nodes` szerkesztése; rövid „miért” narratíva a PR‑ban.
* **Build/CI (Runner):** kanonizálás, csomag, hash, aláírás, attesztáció gépi végrehajtása.
* **Reviewer:** gráf‑változás indoklása, árva/névtér szabályok szemrevételezése.
* **Release mérnök:** artefakt‑összeállítás ellenőrzése, kiadás publikálása.
* **Biztonság/megfelelés:** kulcs‑policy, attesztációs séma, audit.

**Szerződés (contract‑first):** egy PR csak akkor elfogadható, ha teljesül a **Definition of Done** ebben a fejezetben.

---

## 2) Szerkesztés → `related_nodes` (gráf‑első)

* **Szabály:** csak engedélyezett névterek (`schema://`, `doc://`, `module://`, `policy://`).
* **Tiltások:** szóköz, vegyes kis‑nagybetű; fájlútvonalak a `related_nodes`‑ban.
* **Jó gyakorlat:** minden új élhez 1–2 mondatos indoklás a PR‑ban (*mire hivatkozik, mi változott*).

**Minicsekklista:** link létezik? nincs körhivatkozás? verzió (`@vN`) tudatos?

---

## 3) Kanonizálás (determinista normalizálás)

* **Cél:** ugyanabból a tartalomból minden környezetben **azonos bájtfolyam** keletkezzen.
* **Tipikus lépések:** kulcsrendezett YAML, `\n` sorvég, BOM nélkül, stabil lebegő‑pontos formázás (ha releváns).
* **Kimenet:** kanonizált bájtok → `sha256` → `hash://sha256/<digest>`.

> **Megjegyzés:** a hash a **csomópont identitásának** egyik horgonya; ettől független a logikai `id` (URI).

---

## 4) Csomagolás + MANIFEST

* **Parancs‑minta:** `tar --sort=name --mtime='UTC 2020-01-01' ...`
* **Kimenet:**

    * `build/artifacts.tar` (determinista tar)
    * `build/MANIFEST.sha256` (összes komponens hash‑e)
* **DoD:** a `MANIFEST.sha256` hiánya *blokkoló* protected brancheken.

---

## 5) Aláírás (detached, Transit mögött)

* **Miért leválasztott?** hogy a bizonyíték a fájlrendszertől, OS‑től független legyen.
* **Token:** rövid lejárat, runnerhez kötött, auditált.
* **Kimenet:** `build/MANIFEST.sha256.sig` | URI: `sig://vault-transit/<kulcs>`.

**Hiba‑módok:** kulcs nincs elérhető joggal → *fail‑shut* (ne lépjen tovább a pipeline).

---

## 6) Attesztáció (light SLSA)

* **Tartalom:** commit SHA, CI run azonosító, környezet, build inputok, időbélyeg.
* **Séma:** projekt‑szintű, verziózott; JSON‑ban vagy YAML‑ban.
* **Kimenet:** `build/attestation.json` | URI: `attest://slsa-light/<run>`.

**Jó gyakorlat:** a PR linkje és a „miért” rövid leírása kerüljön be az attesztációba.

---

## 7) Ellenőrzés (graph + provenance gate)

* **`make graph-check`:** árva él, illegális névtér, URI‑szabályok.
* **`make verify`:** hash újraszámolás, aláírás ellenőrzése, attesztáció validálás, policy‑ellenőrzés.
* **Végrehajtás:** protected brancheken *blokkoló*; másutt figyelmeztető → időzített átállással *blokkoló*.

**Kimenetek:** összefoglaló jelentés (CI artefakt), hibaesetek listája, javasolt javítások.

---

## 8) Kiadás (publish)

* **Publikálandó artefaktok:** `artifacts.tar`, `MANIFEST.sha256`, `MANIFEST.sha256.sig`, `attestation.json`.
* **Hivatkozás:** a csomópont `*.meta.yaml`‑jában rögzíthető a kiadás horgony‑listája.
* **Verziózás:** ha a logikai jelentés törik, `@vN` emelés (major). Kisebb módosítás meta `version` mezőben.

---

## 9) Üzemeltetés: audit & visszagörgetés

* **Audit:** egy csomópontra kérdezz rá → hash újraszám, aláírás‑ellenőrzés, atteszt megfelelés → *igen/nem*.
* **Rollback:** utolsó jó hash/kiadás visszahozható determinisztikusan.
* **Megfelelőség:** mérőszámok (árva‑ráta, gráf‑sűrűség, DoD‑pass arány) idősorban.

---

## 10) Hibamódok és kezelések

| Hiba                | Tünet              | Kezelés                                               |
| ------------------- | ------------------ | ----------------------------------------------------- |
| Árva él             | `graph-check` fail | célcsomópont hiányzik → hozd létre / javítsd az URI‑t |
| Illegális névtér    | `graph-check` fail | allowlist bővítés policy szerint vagy URI csere       |
| Hash eltérés        | `verify` fail      | kanonizálás verifikálása, sorvég/mtime normalizálás   |
| Aláírás hiány/rossz | `verify` fail      | Transit jogosultság, token, kulcsrotáció ellenőrzése  |
| Attesztáció hiány   | `verify` fail      | pipeline lépés kötelezővé tétele                      |

---

## 11) Bevezetési út (adoptálás)

1. **Nem‑blokkoló lint:** `graph-check` csak figyelmeztet → felkészülési idő.
2. **Determinista csomag:** `make package` és MANIFEST minden release‑ben.
3. **Aláírás + atteszt:** bevezetés, riportálás, oktatás.
4. **Fail‑shut kapuk:** protected brancheken kötelező `graph-check` + `verify`.
5. **Küszöbök érése:** árva‑ráta → 0, névtér szabályok szigorítása.

---

## 12) Szekvencia (szöveges)

```
Author -> Repo: módosítás + PR (miért/narratíva)
CI -> GraphLint: related_nodes ellenőrzés (árvák, névterek)
CI -> Canon: kanonizálás → bytes
CI -> Hash: sha256(bytes) → MANIFEST.sha256
CI -> Sign(Transit): MANIFEST.sha256.sig
CI -> Attest: attestation.json (commit, run, inputok)
CI -> Verify: hash+sig+attest + policy
Verify -> CI: OK/FAIL
CI -> Registry/Release: publikálás
Ops -> System: audit/rollback a horgonyok alapján
```

---

## 13) Definition of Done (ehhez a fejezethez)

* `graph-check` és `verify` **zöld** (protected brancheken blokkoló).
* Kiadható csomag: `artifacts.tar` + `MANIFEST.sha256` + `*.sig` + `attestation.json`.
* A PR tartalmaz rövid **változás‑narratívát** és a gráfváltozás magyarázatát.
* Minden új él **indokolt** és **engedélyezett névtérből** érkezik; **árvák=0**.
