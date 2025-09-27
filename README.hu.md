# CIC Tech‑Artifacts

**Leírás:**
A `cic‑tech‑artifacts` repository a CIC ökoszisztémához kapcsolódó **új technikai koncepciók, proof‑of‑concept modulok és referencia‑artefaktumok** gyűjtőhelye.
Ez **nem része a CIC‑core kódnak**, hanem sandbox, ahol biztonságosan kísérletezhetünk és dokumentálhatunk.

---

## 🎯 Cél

* Inkubátor a koncepciófázisban lévő ötletekhez.
* Referencia‑specifikációk és API‑definíciók közzététele.
* Proof‑of‑concept (PoC) kódok, adapterek, példák megosztása.
* A fő CIC‑core kódbázis tisztán tartása.

---

## 📂 Struktúra

```
concept/              ← minden új elképzelés külön mappában
  ├─ dgp‑provenance/   ← Deterministic Graph Provenance koncepció
  │    ├─ spec/        ← API, séma, fogalmak
  │    ├─ examples/    ← minta MANIFEST, audit‑passport
  │    └─ notes.md
  ├─ ois‑interop/      ← OIS kapcsolódási gondolatok
  ├─ ...
LICENSE               ← CC BY‑NC‑SA 4.0
README.md             ← ez a dokumentum
CONTRIBUTING.md       ← rövid útmutató a közreműködéshez
```

---

## 📜 Irányelvek

* Minden koncepciót a `concept/` alatt saját mappában tartunk.
* Dokumentáció **Markdownban**, API‑definíció **OpenAPI/Protobuf** vagy YAML.
* Mintaadatok, konfigurációk, kódok kis méretűek legyenek.
* Amikor egy koncepció kiforrja magát, **külön repóba** vagy a CIC‑core‑ba kerülhet.

---

## ⚖️ Licence

* **CC BY‑NC‑SA 4.0** – a tartalom szabadon felhasználható nem‑kereskedelmi célra, a forrás megjelölésével és azonos feltételekkel továbbadható.
* A kódmintákra alapértelmezetten ugyanilyen feltételek érvényesek.

---

## 🤝 Közreműködés

1. Forkold a repót és hozz létre új ágat.
2. A `concept/` alatt hozz létre saját mappát.
3. Írd meg a dokumentációt és, ha kell, adj hozzá példakódot.
4. Nyiss Pull Requestet, rövid magyarázattal.

---

## 🌱 Példák

* **dgp‑provenance** – triád‑alapú provenance gate és audit‑útlevél.
* **ois‑interop** – ötletek a CIC és az OIS közötti biztonságos adatáramláshoz.

---

> Ez a repo a CIC‑hez tartozó **innovációs homokozó**: nem production kód, hanem az új elképzelések első, dokumentált állomása.
