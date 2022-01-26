# DSA 4.1 Liber Reprints

Dieses Repository enthält ein Script, mit dem man druckbare PDFs aus den offiziellen PDFs des Liber Liturgium und des Liber Cantiones erzeugen kann.
„Druckbare PDFs“ bedeutet, dass vorne eine übergroße Seite für den Hardcover-Umschlag erzeugt wird und die einzelnen Seiten genug Platz am Rand für den Beschnitt haben.
Außerdem werden die PDFs vom A4-Format, in dem sie vorliegen, in ein kleineres Format skaliert, das näher an den Original-Büchern ist.

Die generierten PDFs sind angepasst an ein spezifisches Layout von [Wir machen Druck](www.wir-machen-druck.de).
Das spezifische Layout ist

> Buch 17,0 x 24,0 cm, Umschlag: Hardcover 4/0-farbig  
> Inhalt: 304/368 schwarz-/weiße Innenseiten (1/1-farbig)  
> Farbigkeit: 1/1 s/w-farbig  
> 115g Innenteil hochwertiger Qualitätsdruck matt || Umschlag Hardcover mit Mattfolie (FSC® select).

(Seitenzahl 304 fürs LC, 368 fürs LL)

Die erzeugten PDFs können kaum mit einer anderen Konfiguration benutzt werden; schon eine Änderung der Papierart würde die benötigte Breite des Umschlags ändern.


## Liber Cantiones

 * Der Umschlag wird aus der im Original-PDF enthaltenen Vorder- und Rückseite gebildet.
   Buchrücken und Ränder werden gefüllt, indem Teile dieser beiden Seiten dupliziert werden.
 * Das Original-PDF enthält die Hintergrundbilder der Seiten inklusive Beschnitt.
   Das Script vergrößert die ursprünglichen Seiten, sodass der Beschnitt wieder Teil der Seite ist.

## Liber Liturgium

 * Da die Rückseite des Umschlags nicht im Original-PDF enthalten ist, werden Buchrücken und Rückseite komplett aus Teilen der Vorderseite zusammengeklebt.
   Es wird keinen Schönheitswettbewerb gewinnen, aber funktioniert.

## Benutzung des Scripts

Das Script ist eine [Nix Flake](https://nixos.wiki/wiki/Flakes) und braucht dementsprechend den Nix Paketmanager mit Flake-Support angeschaltet.
Dieser ist auf allen gängigen Betriebssystemen außer Windows verfügbar, Windows-Nutzer können WSL verwenden.
Die verlinkte Seite beschreibt, wie die Installation vonstatten geht.

Lade den Inhalt dieses Repositories als Zip herunter und entpacke es (nicht mit git klonen, dann tut es nicht weil die Original-PDFs als Dateien, die nicht Teil des Repositories sind, referenziert werden müssen).
Lege die Original-PDFs als Dateien mit Namen `LiberLiturgium.pdf` und `LiberCantiones.pdf` in das entpackte Verzeichnis (du brauchst nur die, die du auch drucken willst).

Danach kannst du auf der Kommandozeile in diesem Verzeichnis einen der folgenden Befehle ausführen:

    nix build .#liberLiturgium
    nix build .#liberCantiones

Achtung, diese Befehle laden eine Menge Software herunter, die benutzt wird, um das PDF zu erstellen (vor allem TeX Live) – insgesamt irgendwas in der Region von 1GB.
Nachdem alles heruntergeladen wurde, wird das PDF erzeugt und in das Verzeichnis `result` gelegt (Achtung, symlink: generiert man das eine, ist das andere weg).

Zum Schluss kann die heruntergeladene Software wieder vollständig entfernt werden mit

    nix-collect-garbage

Das generierte PDF kann dann direkt beim Bestellvorgang bei Wir machen Druck hochgeladen werden.
Es sind keine Anpassungen nötig.

## Ist das legal?

Es gilt das Recht auf Privatkopie gemäß [§53 UrhG](https://www.gesetze-im-internet.de/urhg/__53.html).
Danach ist es auch erlaubt, jemand anderen (in diesem Fall die Druckerei) Kopien auf Papier herstellen zu lassen.

Ich bin kein Anwalt, dies ist nur meine Meinung und stellt keine gültige Rechtsberatung dar.

## Lizenz

Dieses Repository steht unter der [Do What The Fuck You Want To Public License](http://www.wtfpl.net).
Diese erstreckt sich nicht auf die urheberrechtlich geschützten PDFs, die von diesem Script erstellt werden.