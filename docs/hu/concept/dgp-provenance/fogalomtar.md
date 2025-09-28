# DGP — Fogalomtár (HU)

> Gyors, egyértelmű magyarázatok a DGP szakkifejezéseire. Minden címszóhoz rövid magyar definíció és (zárójelben) angol megfelelő.

---

## A

* **Anchor (horgony)** — Verifikálható hivatkozás egy csomóponthoz vagy artefaktumhoz: `hash://…`, `sig://…`, `attest://…` (EN: *anchor*).
* **Attesztáció** — Géppel olvasható bizonyíték *ki/mi/mikor/mivel* metaadatokkal a buildről; `attestation.json`. (EN: *attestation*).
* **Artefaktum** — Kiadáskor előálló csomag vagy fájl (pl. `artifacts.tar`). (EN: *artifact*).
* **Archíválás** — Régi csomópontok/kiadások bizonyítékainak hosszú távú megőrzése. (EN: *archival*).
* **Allowlist (névtér‑)** — Engedélyezett URI‑prefixek listája `related_nodes` ellenőrzéséhez. (EN: *namespace allowlist*).

## B

* **BOM (Byte Order Mark)** — Tiltott a kanonizált szövegek elején; nondeterminizmust okoz. (EN: *BOM*).

## C

* **Canonicalization (kanonizálás)** — Determinisztikus normalizálás (sorrend, sorvégek, formátum) a stabil hash érdekében. (EN: *canonicalization*).
* **CI Runner** — A pipeline lépéseit futtató végrehajtó környezet. (EN: *CI runner*).
* **Content Addressing (tartalom‑címzés)** — Azonosítás hash alapján, nem útvonal szerint. (EN: *content addressing*).

## D

* **DGP** — Determinista Gráf Eredetiség; hash → aláírás → attesztáció triád, gráfkapukkal. (EN: *Deterministic Graph Provenance*).
* **Determinista csomag** — Stabil sorrenddel és időbélyeggel készülő tar/zip; `MANIFEST.sha256` kíséri. (EN: *deterministic package*).
* **DoD (Definition of Done)** — Elfogadási kritériumok egy fejezetre/PR‑ra. (EN: *Definition of Done*).

## E

* **Edge (él)** — Kapcsolat két csomópont között; `related_nodes` elem. (EN: *edge*).

## F

* **Fail‑shut** — Hiba esetén *álljon meg* a folyamat (merge/kiadás ne történjen meg). (EN: *fail‑shut*).

## G

* **GATE / Kapu** — Kötelező ellenőrzés a CI‑ban (pl. `graph-check`, `verify`). (EN: *gate*).
* **Graph‑check** — Gráflint: árva él, névtér, URI‑grammatika ellenőrzése. (EN: *graph check*).
* **Gráf sűrűség** — Be‑/kimenő fokszámok mértéke; túl nagy érték spagettit jelez. (EN: *graph density*).

## H

* **Hash** — `sha256` a kanonizált tartalomról; `hash://sha256/<digest>`. (EN: *hash*).
* **HSM / Transit** — Kulcs‑műveletek védett szolgáltatásban; a kulcs sosem hagyja el. (EN: *HSM / Vault Transit*).

## I

* **Idempotencia** — Ugyanaz a futtatás ugyanazt az eredményt adja mellékhatás nélkül. (EN: *idempotence*).
* **In/Out‑degree** — Egy csomópont bejövő/kimenő éleinek száma. (EN: *in/out degree*).

## J

* **JSON‑/YAML‑séma** — Attesztáció és meta ellenőrzési szerződése. (EN: *schema*).

## K

* **Key Rotation (kulcsrotáció)** — Aláíró kulcs cseréje, visszamenőleges verifikálhatóság fenntartásával. (EN: *key rotation*).

## L

* **Leválasztott aláírás** — Nem a fájlba ágyazott, hanem külön tárolt aláírás a MANIFEST hash‑ére. (EN: *detached signature*).
* **Logikai URI/ID** — Költözés‑tűrő azonosító: `<kind>://<namespace>/<path>[@vN]`. (EN: *logical URI/ID*).

## M

* **MANIFEST.sha256** — A kiadási csomag komponenseinek és hash‑einek listája. (EN: *manifest*).
* **Metrikák** — Árva‑ráta, hash‑egyezés, kapu‑hibák stb. (EN: *metrics*).

## N

* **Namespace (névtér)** — URI‑prefix (pl. `doc://`, `schema://`); policy határozza meg az engedélyezetteket. (EN: *namespace*).

## O

* **OIDC kötés** — Rövid életű, kontextushoz kötött token a Transit/HSM eléréséhez. (EN: *OIDC binding*).
* **Orphan (árva) él** — Nem létező célra mutató él; tilos merge előtt. (EN: *orphan edge*).

## P

* **Policy** — Szabályok (URI‑grammatika, névterek, kötelező horgonyok) és kikényszerítésük. (EN: *policy*).
* **PR narratíva** — Rövid „miért” magyarázat a gráfváltozásokról. (EN: *PR change narrative*).
* **Protected branch** — Olyan ág, ahol a kapuk blokkolók. (EN: *protected branch*).

## R

* **RBAC** — Szerepkör‑alapú hozzáférés‑kezelés, főleg kulcs‑/titokhozzáférésre. (EN: *RBAC*).
* **Reproducibility (reprodukálhatóság)** — Ugyanaz a bemenet → ugyanaz a kimenet, minden környezetben. (EN: *reproducibility*).
* **Release bundle** — Kötelezően publikálandó fájlok együttese (MANIFEST, SIG, ATTEST, csomag). (EN: *release bundle*).
* **Rollback** — Utolsó jó állapot visszahozása a hash alapján. (EN: *rollback*).

## S

* **SLSA‑light** — Könnyített attesztációs keret (ki/mi/mikor/mivel). (EN: *SLSA‑light*).
* **STRICT‑GRAPH** — Szabály: `related_nodes` csak engedélyezett névtérből, árvák tiltása. (EN: *STRICT‑GRAPH*).
* **Signature (aláírás)** — `sig://vault-transit/<key>`; MANIFEST hash‑hez kötött bizonyíték. (EN: *signature*).

## T

* **TRIAD‑ON** — App / Infra / Tests‑Docs triász egészségi kapui és arányai. (EN: *TRIAD‑ON*).
* **Transit Token** — Rövid életű hozzáférés aláírás indításához a runnerből. (EN: *transit token*).

## U

* **URI‑grammatika** — Azonosító‑szabály: kisbetű, engedett szeparátorok `-` `/` `:`, opcionális `@vN`. (EN: *URI grammar*).

## V

* **Verify** — Egységes ellenőrzés: hash újraszámolás + aláírás + atteszt + policy. (EN: *verify*).
* **Verziótag (`@vN`)** — Logikai csomópontok főverziója a kompatibilitás jelzésére. (EN: *version tag*).

## W

* **Waiver (kivétel)** — Időzáras, jóváhagyott átmeneti felmentés egy policy alól; nem lazítja az anchor‑kötelezettségeket. (EN: *waiver*).

---

### Kapcsolódó fejezetek

* 02 — Elvek • 03 — Adatmodell • 04 — Életciklus • 05 — CI integráció • 06 — Policyk • 07 — Példák • 08 — Fenyegetési modell • 09 — GYIK
