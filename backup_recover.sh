#!/bin/bash

# Backup-Verzeichnis
BACKUP_DIR="/pfad/zum/backup/verzeichnis"

# Guacamole und Tomcat Konfigurationsverzeichnisse
GUACAMOLE_CONFIG_DIR="/pfad/zum/guacamole/config"
TOMCAT_DIR="/pfad/zum/tomcat"

# Funktion zum Auflisten der verfügbaren Backups
list_backups() {
    echo "Verfügbare Backups:"
    ls "$BACKUP_DIR"/*.tar.gz
}

# Funktion zur Wiederherstellung eines ausgewählten Backups
restore_backup() {
    echo "Wiederherstellung von (1) Guacamole, (2) Tomcat oder (3) Beide?"
    read choice

    case $choice in
        1)
            echo "Bitte geben Sie den Namen des Guacamole-Backups ein, das Sie wiederherstellen möchten:"
            read guacamole_backup_name

            # Überprüfen, ob das Backup existiert
            if [ ! -f "$BACKUP_DIR/$guacamole_backup_name" ]; then
                echo "Backup $guacamole_backup_name nicht gefunden!"
                exit 1
            fi

            echo "Stellen Sie sicher, dass Sie die aktuellen Guacamole-Konfigurationsdateien mit den Dateien aus dem Backup überschreiben möchten? (ja/nein)"
            read confirmation
            if [ "$confirmation" = "ja" ]; then
                TMP_DIR=$(mktemp -d)
                tar -xzf "$BACKUP_DIR/$guacamole_backup_name" -C "$TMP_DIR"
                echo "Wiederherstellung von Guacamole-Konfiguration..."
                cp -r "$TMP_DIR/pfad/zum/guacamole/config/"* "$GUACAMOLE_CONFIG_DIR/"
                rm -rf "$TMP_DIR"
                echo "Wiederherstellung von Guacamole abgeschlossen."
            else
                echo "Wiederherstellung abgebrochen."
            fi
            ;;
        2)
            echo "Bitte geben Sie den Namen des Tomcat-Backups ein, das Sie wiederherstellen möchten:"
            read tomcat_backup_name

            # Überprüfen, ob das Backup existiert
            if [ ! -f "$BACKUP_DIR/$tomcat_backup_name" ]; then
                echo "Backup $tomcat_backup_name nicht gefunden!"
                exit 1
            fi

            echo "Stellen Sie sicher, dass Sie die aktuellen Tomcat-Konfigurationsdateien mit den Dateien aus dem Backup überschreiben möchten? (ja/nein)"
            read confirmation
            if [ "$confirmation" = "ja" ]; then
                TMP_DIR=$(mktemp -d)
                tar -xzf "$BACKUP_DIR/$tomcat_backup_name" -C "$TMP_DIR"
                echo "Wiederherstellung von Tomcat-Konfiguration..."
                cp -r "$TMP_DIR/pfad/zum/tomcat/"* "$TOMCAT_DIR/"
                rm -rf "$TMP_DIR"
                echo "Wiederherstellung von Tomcat abgeschlossen."
            else
                echo "Wiederherstellung abgebrochen."
            fi
            ;;
        3)
            echo "Bitte geben Sie den Namen des Guacamole-Backups ein, das Sie wiederherstellen möchten:"
            read guacamole_backup_name
            echo "Bitte geben Sie den Namen des Tomcat-Backups ein, das Sie wiederherstellen möchten:"
            read tomcat_backup_name

            # Überprüfen, ob die Backups existieren
            if [ ! -f "$BACKUP_DIR/$guacamole_backup_name" ]; then
                echo "Backup $guacamole_backup_name nicht gefunden!"
                exit 1
            fi
            if [ ! -f "$BACKUP_DIR/$tomcat_backup_name" ]; then
                echo "Backup $tomcat_backup_name nicht gefunden!"
                exit 1
            fi

            echo "Stellen Sie sicher, dass Sie die aktuellen Konfigurationsdateien mit den Dateien aus den Backups überschreiben möchten? (ja/nein)"
            read confirmation
            if [ "$confirmation" = "ja" ]; then
                TMP_DIR=$(mktemp -d)
                tar -xzf "$BACKUP_DIR/$guacamole_backup_name" -C "$TMP_DIR"
                echo "Wiederherstellung von Guacamole-Konfiguration..."
                cp -r "$TMP_DIR/pfad/zum/guacamole/config/"* "$GUACAMOLE_CONFIG_DIR/"

                tar -xzf "$BACKUP_DIR/$tomcat_backup_name" -C "$TMP_DIR"
                echo "Wiederherstellung von Tomcat-Konfiguration..."
                cp -r "$TMP_DIR/pfad/zum/tomcat/"* "$TOMCAT_DIR/"

                rm -rf "$TMP_DIR"
                echo "Wiederherstellung von Guacamole und Tomcat abgeschlossen."
            else
                echo "Wiederherstellung abgebrochen."
            fi
            ;;
        *)
            echo "Ungültige Auswahl. Wiederherstellung abgebrochen."
            ;;
    esac
}

# Hauptmenü
echo "Willkommen zum Backup-Wiederherstellungsskript."
list_backups
restore_backup
