#!/usr/bin/env bash

set -e
PRINTER_NAME=$1
ACTIVE_PRINTER_DIR="active_printer"

if [ -z $PRINTER_NAME ]; then
    echo "USAGE: activate PRINTER_NAME"
    exit 1
fi

PRINTER_CONFIG_DIR="printers/$PRINTER_NAME"

if ! [ -d $PRINTER_CONFIG_DIR ]; then
    echo "No configuration directory exists for printer $PRINTER_NAME"
    exit 1
fi

if ! [ -e "$PRINTER_CONFIG_DIR/printer.cfg" ]; then
    echo "No printer.cfg file exists for printer $PRINTER_NAME"
    exit 1
fi

mkdir -p "$ACTIVE_PRINTER_DIR"
ln -f -s "$PRINTER_CONFIG_DIR/printer.cfg" "./printer.cfg"

if [[ -e "$PRINTER_CONFIG_DIR/macros.cfg" ]]; then
    ln -f -s "../$PRINTER_CONFIG_DIR/macros.cfg" "$ACTIVE_PRINTER_DIR/macros.cfg"
else
    rm -f "$ACTIVE_PRINTER_DIR/macros.cfg"
    > "$ACTIVE_PRINTER_DIR/macros.cfg"
fi

if [[ -e "$PRINTER_CONFIG_DIR/moonraker.conf" ]]; then
    ln -f -s "../$PRINTER_CONFIG_DIR/moonraker.conf" "$ACTIVE_PRINTER_DIR/moonraker.conf"
else
    rm -f "$ACTIVE_PRINTER_DIR/moonraker.conf"
    > "$ACTIVE_PRINTER_DIR/moonraker.conf"
fi
