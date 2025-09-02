> ⚠️ Hinweis: Dieses Projekt dient ausschließlich Demonstrations- und Lernzwecken und ist nicht für die kommerzielle Nutzung bestimmt.


# 🎬 Cine Vibe  
_Ein minimalistisches iOS-Projekt zur Filmempfehlung auf Basis persönlicher Präferenzen._



Cine Vibe ist die App für alle, die mehr Zeit mit guten Filmen und weniger Zeit mit der Suche danach verbringen möchten. Im Alltag, wo man ständig mit unzähligen Entscheidungen und einem Überfluss an Möglichkeiten konfrontiert ist, fällt es schwer, zur Ruhe zu kommen. Gerade am Abend, wenn du einfach nur abschalten möchtest, hilft Cine Vibe, indem es dir die Auswahl erleichtert und dir Filme präsentiert, die wirklich zu dir passen.  
Was Cine Vibe besonders macht, ist seine klare Ausrichtung: Keine KI, keine massenorientierten Algorithmen. Statt auf Trends oder populäre Mechanismen setzt die App auf Präzision und Individualität – für Empfehlungen, die dich nicht nur begeistern, sondern auch überraschen können.

---


<p>
  <img width="200" src="Screenshots/screenshot_intro.png">
  <img width="200" src="Screenshots/screenshot_rating.png">
  <img width="200" src="Screenshots/screenshot_watchlist.png">
</p>




> 🖼️ **Hinweis zu den Screenshots**  
> Die gezeigten Screenshots enthalten urheberrechtlich geschützte Filmcover.  
> Diese dienen **ausschließlich zur Illustration** der App-Funktionalität und **nicht zur Weiterverbreitung**.  
> Alle Rechte an den Covern liegen bei den jeweiligen Rechteinhabern.  
> Die Cover sind **nicht Bestandteil des Quellcodes oder des App-Bundles**.


---

## Features

- **Einfache Registrierung und Anmeldung**: Der Admin kann sich unkompliziert mit E-Mail und Passwort über Firebase authentifizieren.  
- **Benutzerverwaltung**: Familienmitglieder können hinzugefügt werden, jedes Mitglied erhält sein eigenes Profil.  
- **Individuelle Watchlist**: Sowohl der Admin als auch die Familienmitglieder können persönliche Watchlists erstellen.  
- **Flexibles Rating-System**: Nutzer können Filme bewerten, um präzisere Empfehlungen zu erhalten – jedes Rating ist direkt anpassbar.  
- **Personalisierte Filmempfehlungen**: Empfehlungen basieren auf den individuellen Vorlieben der Nutzer.
- **Benutzerwechsel**: Ermöglicht einen schnellen Wechsel zwischen verschiedenen Benutzern.
- **Intuitive Bedienung**: Die Benutzeroberfläche ist übersichtlich und auf eine einfache Nutzung ausgerichtet.  

---

## Technischer Aufbau

Cine Vibe ist auf einer klar strukturierten **MVVM-Architektur** (Model-View-ViewModel) aufgebaut, die eine saubere Trennung zwischen Daten, Logik und Benutzeroberfläche gewährleistet.

### Projektstruktur

- **Configuration**: Enthält grundlegende Einstellungen und Konfigurationen, wie den App Delegate und globale Variablen.  
- **Managers**: Verwalten spezifische Funktionen und Prozesse, z. B. Audio, Genre-Filter, API-Integration oder Datenmanagement.  
- **Models**: Definieren die Datenstrukturen für die App, wie Filme, Benutzer, Genres und Präferenzen.  
- **ViewModels**: Stellen die Verbindung zwischen Daten und Benutzeroberfläche her und enthalten die Logik für die App-Funktionen.  
- **Views**: Erstellen die Benutzeroberfläche mit SwiftUI und sorgen für eine intuitive Nutzererfahrung.  

---

## Datenspeicherung

Die App nutzt Firebase für die Authentifizierung und zur Speicherung von Benutzer- und Familienprofilen sowie deren individuellen Watchlists. Jede registrierte Person – sei es der Hauptnutzer oder ein Familienmitglied – hat die Möglichkeit, Filme in der persönlichen Watchlist zu speichern, die sicher in der Cloud hinterlegt werden.  
Benutzerpräferenzen (z. B. Likes, Dislikes, Genre-Auswahl) werden nur temporär im Arbeitsspeicher gehalten – ohne dauerhafte Speicherung. Diese Daten werden nicht dauerhaft gespeichert, um sicherzustellen, dass bei jeder Nutzung der App die Empfehlungen von den aktuellen Stimmungen und Vorlieben des Nutzers beeinflusst werden können.

---

## Weiterentwicklung

Geplante Erweiterungen:    
- **Altersbasierte Inhalte**: Beim Hinzufügen von Familienmitgliedern kann der Admin festlegen, ob es sich um ein Kind, einen Teenager oder einen Erwachsenen handelt. Die Empfehlungen und Watchlist werden entsprechend altersgerecht angepasst.  
- **Verfügbarkeitsanzeige**: Die App zeigt an, auf welchen Streamingdiensten die empfohlenen Filme aktuell verfügbar sind, sodass du sie direkt finden und ansehen kannst.

---

## Credits

Die Entwicklung von Cine Vibe wurde durch verschiedene Tools und Plattformen unterstützt, die mir als wertvolle Hilfen während des gesamten Prozesses gedient haben:  

### Entwicklungsressourcen:
- [Google](https://www.google.de) 
- [ChatGPT](https://chat.openai.com) 
- [developer.apple.com](https://developer.apple.com)   
- [Hacking with Swift](https://www.hackingwithswift.com)   
- [YouTube](https://www.youtube.com) 

### Medienressourcen:
- Die ursprünglich verwendeten Filmcover wurden ausschließlich zu Demonstrationszwecken eingebunden und sind aus dem Projekt entfernt worden.
- Der Sound für das Intro stammt von [Freesound.org](https://www.freesound.org).
- Die im Projekt verwendeten Filmcover dienen **ausschließlich Demonstrationszwecken**. Die Rechte an den gezeigten Covern liegen bei den jeweiligen Filmstudios oder Rechteinhabern.
- Der Sound für das Intro stammt von [Freesound.org](https://www.freesound.org) – Titel: *[Dateiname oder Link einfügen]*, Lizenz: *[z. B. CC BY 3.0]*, Urheber: *[Benutzername]*.

---

## Hinweise zur Einrichtung

### 🎬 Hinweis zu Cover-Bildern

Die App zeigt im Intro animierte Cover-Bilder (`Cover1`, `Cover2`, …), die **nicht im Repository enthalten sind**, um Urheberrechte zu wahren.

Sie können bei Bedarf im Xcode-Projekt (Assets) ergänzt werden.  
Die Bildnamen müssen den Einträgen in `IntroImageModel.imageName` entsprechen.

---

### 🎵 Hinweis zum Sound:
Der Sound für das Intro stammt von [Freesound.org](https://www.freesound.org) – Titel: *NiceSound.wav*, Lizenz: *z. B. CC BY 3.0*, Urheber: *[Benutzername]*.  
Die Datei ist **nicht im Repository enthalten**, sondern muss lokal ergänzt werden (siehe `.gitignore`).

---

### 🔑 Firebase-Konfiguration

Für Firebase wird eine eigene `GoogleService-Info.plist` benötigt.

1. Erstelle ein Projekt unter [firebase.google.com](https://firebase.google.com)
2. Lade die Datei `GoogleService-Info.plist` herunter
3. Lege sie in `CineVibe03/` ab

⚠️ Ohne diese Datei funktioniert kein Login, keine Datenbank und keine Watchlist.
⚠️ Achtung: Diese App speichert persönliche Daten (z. B. Watchlists) über Firebase. Wenn du das Projekt verwendest, bist du **selbst für die Konfiguration und den Datenschutz deiner Firebase-Instanz verantwortlich.**


---

### 🔐 API-Key (TMDB)

Die App nutzt die TMDB-API zur Bereitstellung von Filmdaten. Diese Daten unterliegen den [Nutzungsbedingungen von TMDB](https://www.themoviedb.org/terms-of-use). Die Nutzung erfordert einen eigenen API-Schlüssel.


👉 Für die Film-API [TMDB](https://www.themoviedb.org/) wird ein **eigener API-Key** benötigt.  
Bitte erstelle ihn selbst und ergänze ihn im Code (siehe `APIManager.swift` oder ähnlicher Ort).





## Fazit

Cine Vibe ist nicht einfach nur eine weitere App in einer Welt voller Streaming-Dienste. Sie ist eine bewusste Antwort auf den Überfluss. Keine Zeitverschwendung, keine Trends – nur Filmempfehlungen, die wirklich zu dir passen und dir in deiner aktuellen Stimmung gerecht werden. Bereit, dich auf Neues einzulassen?

## Lizenz

Dieses Projekt steht unter der [MIT-Lizenz](LICENSE). Du darfst den Code nutzen, verändern und verbreiten – **unter Nennung der Urheberin** und **unter Beachtung der Lizenzbedingungen**.

> „Cine Vibe“ wurde von Sarina Martines ([@Rinari-Dev-Studio](https://github.com/Rinari-Dev-Studio)) als privates Lernprojekt konzipiert und umgesetzt.

Bitte beachte: Drittinhalte wie Filmcover oder Sounds stehen **nicht notwendigerweise unter derselben Lizenz**.


