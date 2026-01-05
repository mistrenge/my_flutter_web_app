# Digitaler Prototyp – Pocket CRM (Flutter Web App / PWA)

## Kurzbeschreibung
Dieses Repository enthält den im Rahmen der Lehrveranstaltung  
**„Entwicklung digitaler Prototypen“** entwickelten digitalen Prototypen **Pocket CRM**.

Der Prototyp wurde als **Flutter-basierte Webanwendung** umgesetzt und als  
**Progressive Web App (PWA)** bereitgestellt. Ziel ist es, exemplarisch zu zeigen, wie eine **mobile, geobasierte Anwendung** den Arbeitsalltag des **Außendienstes** unterstützen kann.

Im Vordergrund steht der Digital-Prototyping-Ansatz: schnelle Umsetzbarkeit, realitätsnahe Demonstration des Nutzens und iterative Weiterentwicklung – nicht die Entwicklung eines produktiven CRM-Systems.

---

## Live-Demo
Der digitale Prototyp ist über GitHub Pages erreichbar:

🔗 https://mistrenge.github.io/my_flutter_web_app/

Die Anwendung ist für die mobile Nutzung optimiert und kann direkt im Browser verwendet werden.

---

## Projektkontext
- **Modul:** Entwicklung digitaler Prototypen  
- **Studiengang:** Master Wirtschaftsinformatik  
- **Semester:** Wintersemester 2025/2026  

---

## Zielgruppe
Die primäre Zielgruppe des Prototyps ist der **Außendienst**, der:
- überwiegend mobil arbeitet,
- spontan Kundenbesuche plant,
- schnell auf Standort- und Unternehmensinformationen zugreifen muss.

Pocket CRM orientiert sich bewusst an einem **typischen Arbeitstag im Außendienst** und begleitet die Nutzenden Schritt für Schritt durch den gesamten Besuchs- und Akquiseprozess.

---

## Zielsetzung des Prototyps
Ziel des Prototyps ist es, zu demonstrieren, wie eine mobile Anwendung den Außendienst bei der **tourenbasierten Kunden- und Akquiseplanung** unterstützen kann, insbesondere durch:
- geobasierte Visualisierung von Kunden und Zielkunden,
- strukturierte Auswahl und Priorisierung relevanter Besuchsziele,
- nahtlose Übergänge zu bestehenden digitalen Systemen.

Der Prototyp dient als funktionaler und konzeptioneller Demonstrator im Sinne des Digital Prototyping.

---

## Kernfunktionen
Der Prototyp umfasst folgende zentrale Funktionen:

- **Standortanzeige**  
  Darstellung des eigenen Standorts auf einer interaktiven Karte sowie Anzeige von Kunden in der Umgebung.

- **Kunden- und Zielkundenanzeige**  
  Visualisierung von Bestands- und potenziellen Zielkunden inklusive relevanter Unternehmensinformationen.

- **Such- und Filterfunktionen**  
  Filterung nach Text, Ort, Branche, Mitarbeiteranzahl oder Entfernung zur gezielten Eingrenzung relevanter Kunden.

- **Favoriten- und Zielkundenlisten**  
  Markierung und Verwaltung priorisierter Kunden zur strukturierten Tourenplanung.

- **Routenexport zu Google Maps**  
  Übergabe ausgewählter Kundenadressen zur direkten Navigation.

- **Deep Links**  
  Direkte Verknüpfung zur Unternehmenswebsite sowie zum mobilen CRM-System (z. B. zur Erfassung von Besuchsberichten).

---

## Nutzerführung
Die Benutzerführung von Pocket CRM orientiert sich an einer **durchgängigen digitalen Journey**:
- Start in einer zentralen Übersichtsansicht mit Zugriff auf Kartenansicht, Website und mobiles CRM,
- geobasierte Tourenplanung als Ausgangspunkt des Arbeitstags,
- Priorisierung und Auswahl relevanter Kunden,
- direkte Navigation zum Kunden,
- anschließende Dokumentation über das angebundene CRM-System.

Damit vereint der Prototyp alle wesentlichen Arbeitsschritte des Außendienstes in einer intuitiv bedienbaren Anwendung.

---

## Datengrundlage
Zur realitätsnahen Demonstration der Karten- und Filterfunktionen wurde eine **synthetische, öffentlich zugängliche Datengrundlage** verwendet.

In einer frühen Entwicklungsphase wurden hierfür eigene **Web-Scraper** entwickelt, die öffentlich verfügbare Unternehmensdaten (z. B. Standort, Branche, Mitarbeiteranzahl) von Plattformen wie *wer-zu-wem.de* automatisiert extrahieren.

Diese Vorgehensweise:
- ermöglicht realistische Tests ohne Zugriff auf vertrauliche CRM-Daten,
- reduziert den Integrationsaufwand,
- unterstützt den schnellen Erkenntnisgewinn im Sinne des Digital-Prototyping-Ansatzes.

---

## Technischer Überblick
- **Framework:** Flutter  
- **Plattform:** Flutter Web  
- **App-Typ:** Progressive Web App (PWA)  
- **Hosting:** GitHub Pages  

Der vollständige Quellcode sowie die verwendeten Beispieldaten sind Bestandteil dieses Repositories.

---

## Nutzung / Ausführung
Die Anwendung ist primär für die **Einsicht, Demonstration und Bewertung** im Rahmen der Hausarbeit vorgesehen.

Eine lokale Ausführung ist optional, da der Prototyp vollständig über die bereitgestellte Web-URL genutzt werden kann.

---

## Abgrenzung
Bei diesem Projekt handelt es sich ausdrücklich um einen **digitalen Prototypen**.  
Aspekte wie produktiver Einsatz, Datenschutzbewertung, Skalierung, Performanceoptimierung oder eine vollständige Integration in bestehende CRM- oder ERP-Systeme sind nicht Gegenstand dieses Projekts.

---

## Autor
Michael Strenge  

---

## Stand
Letzte Aktualisierung: Januar 2026

