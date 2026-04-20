---
draft: true
tags:
  - dashboard
---

# 🌌 Falano Universe – Dashboard

## 🚀 Wiki veröffentlichen

Um Änderungen auf [wiki.falano-universum.de](https://wiki.falano-universum.de) zu publizieren:

> **`Sync-Wiki.bat`** im FalanoWiki-Ordner per Doppelklick starten.
> Das Skript synchronisiert den Vault, zeigt versteckte Seiten an und fragt wie weiter verfahren werden soll.

**Kurzanleitung im Skript:**
- `l` → Lokal testen auf http://localhost:8080
- `p` → Auf Cloudflare veröffentlichen (Git Push)
- `b` → Beides
- `n` → Abbrechen

---

## 👁️ Sichtbarkeit steuern

Über die Properties jeder Seite:

| Property | Ergebnis |
|---|---|
| `draft: false` | ✅ Sichtbar im Wiki |
| `draft: true` | ❌ Versteckt im Wiki |

---

## 📂 Ordner-Übersicht

| Ordner | Im Wiki? | Zweck |
|---|---|---|
| Characters | ✅ (je nach Property) | Charaktere |
| Locations | ✅ (je nach Property) | Orte |
| Factions | ✅ (je nach Property) | Fraktionen |
| Species | ✅ (je nach Property) | Spezies |
| Stories | ✅ (je nach Property) | Geschichten |
| Ideas | ❌ Immer privat | Notizen & Entwürfe |
| ZZ Templates | ❌ Immer privat | Vorlagen |

---

## 🔗 Links

- [Wiki öffnen](https://wiki.falano-universum.de)
- [Cloudflare Dashboard](https://dash.cloudflare.com)
- [GitHub Repository](https://github.com/SilvenAku/falano-wiki)
