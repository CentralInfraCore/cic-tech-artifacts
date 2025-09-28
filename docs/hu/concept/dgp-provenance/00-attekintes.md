# DGP — Áttekintés

A **Determinista Gráf Eredetiség (DGP)** célja, hogy minden gráfcsomópont (schema / doc / module) **hitelesíthető, ember- és gép által ellenőrizhető eredetlánccal** rendelkezzen. A DGP a tartalom-kanonizálás → **SHA‑256 hash** → **leválasztott aláírás** → **attesztáció** (CI-meta) lépéseit teszi elsőrendűvé, és ezeket **STRICT‑GRAPH** (gráf‑kapcsolatok) és **TRIAD‑ON** (app / infra / tests‑docs szeparáció) kapukkal kényszeríti ki.

---

## Miért van rá szükség?

* **Azonosíthatóság:** ugyanazon fogalom/kód több fájl‑ és formátumváltozata lehet; a tartalom‑hash ad stabil identitást.
* **Ellenőrizhetőség:** a leválasztott aláírás a hash‑re vonatkozik, formátumfüggetlen.
* **Auditálhatóság:** az attesztáció rögzíti a „ki/mi/mikor/mivel” metát (CI run, bemenetek).
* **Gráf‑első szemlélet:** nem csak fájlok, hanem **csomópontok és élek** ( `related_nodes` ) kapnak eredetet.
* **Reprodukálhatóság:** determinisztikus csomagolás (tar + MANIFEST) megszünteti a build‑nondeterminizmust.

---

## Alapfogalmak

* **Csomópont‑azonosítók (logikai):** `schema://…`, `doc://…`, `module://…`, `policy://…`
* **Integritás‑horgony:** `hash://sha256/<digest>`
* **Aláírás:** `sig://vault-transit/<kulcs-azonosító>`
* **Attesztáció:** `attest://<séma>/<leíró>` (könnyített SLSA‑mintát követ)
* **Kapcsolatok:** `related_nodes` (fájlutak helyett **logikai ID‑k**)

---

## Hogyan illeszkedik a jelenlegi rendszerhez?

* **STRICT‑GRAPH:** a `*.meta.yaml` fájlokban lévő `related_nodes` értékek **névtér‑allowlisttel** validálhatók; árvák tiltása.
* **TRIAD‑ON:** az app / infra / tests‑docs mappastruktúra és arányok mérhetők, CI‑kapuval védhetők.
* **Dokumentációs formátum:** EN/HU tükrözött könyvszerkezet ( `docs/en|hu/concept/dgp-provenance/*` ), meta‑szinten külön `language` mező.

---

## Életciklus (magas szint)

1. **Szerkesztés:** csomópont és `related_nodes` frissítése (logikai ID‑k).
2. **Kanonizálás:** bájt‑szinten determinisztikus normalizálás → **SHA‑256**.
3. **Aláírás:** a hash **leválasztott** aláírása (Vault Transit kulccsal).
4. **Attesztáció:** CI meta (commit, builder, inputok, idő) rögzítése.
5. **Ellenőrző kapuk:** `graph-check` (árvák/névterek), `verify` (hash+sig+attest) → PR/merge blokkolása, ha hibás.
6. **Kiadás:** MANIFEST + aláírás + atteszt JSON publikálása, verziójelölés.

---

## CI integráció (példa célok)

```make
graph-check:     # névtér-allowlist, árva kapcsolatok, tiltott ID-k
	./tools/graph_lint --allowlist infra/policy/graph-provenance.policy.yaml --fail-on=orphans,illegal-namespace

package:         # determinisztikus tar + MANIFEST
	./tools/canon && tar --sort=name --mtime='UTC 2020-01-01' -cf build/artifacts.tar $(ARTIFACTS)
	sha256sum build/artifacts.tar > build/MANIFEST.sha256

sign:            # leválasztott aláírás (Vault Transit)
	./tools/sign_vault --in build/MANIFEST.sha256 --out build/MANIFEST.sha256.sig

attest:          # CI-meta rögzítése
	./tools/attest --manifest build/MANIFEST.sha256 --out build/attestation.json

verify:          # egységes ellenőrzés
	./tools/verify_all --manifest build/MANIFEST.sha256 --sig build/MANIFEST.sha256.sig --att build/attestation.json --policy infra/policy/graph-provenance.policy.yaml
```

---

## Szabályok és policylépcsők

* **Névtér‑allowlist:** csak engedélyezett prefixek (`schema://`, `doc://`, `module://`, `policy://`, `hash://sha256/`, `sig://vault-transit/`, `attest://`).
* **Verziókötelezettség:** logikai ID‑k végén `@vN` preferált.
* **Formai korlátok:** kisbetűsítés, tiltott szóközök, szeparátorok: `-`, `/`, `:`.
* **Védett branch:** merge csak zöld `graph-check` + `verify` mellett.

---

## Példa (fogalmi ábra)

```mermaid
flowchart TD
  A[doc://concept/dgp-provenance@v1] -->|related_nodes| B(schema://provenance/manifest@v1)
  A --> C(module://cic/verify/attest@v1)
  A --> D(policy://graph/namespace-allowlist@v1)
```

---

## Definition of Done (DoD)

* Nincsenek **árva élek**; minden `related_nodes` megfelel a névtér‑szabályoknak.
* **MANIFEST.sha256** + **aláírás** + **attesztáció** elérhető és verifikálható.
* **TRIAD‑ON** arányok nem romlanak; kötelező mappák adottak.
* **EN↔HU** tartalom tükrözött; nincsenek törött hivatkozások.

---

## Kapcsolódó fejezetek

* **Elvek:** `02-elvek.md`
* **Adatmodell:** `03-adatmodell.md`
* **Életciklus részletesen:** `04-eletciklus.md`
* **CI integráció:** `05-ci-integracio.md`
* **Policy-k:** `06-policyk.md`
* **Példák:** `07-peldak.md`
* **Fenyegetési modell:** `08-fenyegetesi-modell.md`
* **GYIK:** `09-gyik.md`
