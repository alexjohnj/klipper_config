#!/usr/bin/env bash

set -e

PRINTER_NAME=$1
ACTIVE_PRINTER_DIR="active_printer"
PRINTER_CONFIG_DIR="printers/$PRINTER_NAME"

KLIPPAIN_INSTALL_SCRIPT="https://raw.githubusercontent.com/Frix-x/klippain-shaketune/b42e377ac68147ad7913ae30333fd2a3d1227331/install.sh"
KLIPPAIN_SHAKETUNE_DIR="$HOME/klippain_shaketune"

TMC_AUTOTUNE_INSTALL_SCRIPT="https://raw.githubusercontent.com/andrewmcgr/klipper_tmc_autotune/b568ed8db68d0a6a662b5aa371fdb33faba4a923/install.sh"
TMC_AUTOTUNE_DIR="$HOME/klipper_tmc_autotune"

function info() {
    printf "[I] %s\n" "$1"
}

function error() {
    printf "[E] %s\n" "$1"
}

function fail() {
    error "$1"
    exit 1
}

function validate_args {
    if [ -z $PRINTER_NAME ]; then
        fail "USAGE: activate PRINTER_NAME"
    fi

    if ! [ -d $PRINTER_CONFIG_DIR ]; then
        fail "No configuration directory exists for printer $PRINTER_NAME"
    fi

    if ! [ -e "$PRINTER_CONFIG_DIR/printer.cfg" ]; then
        fail "No printer.cfg file exists for printer $PRINTER_NAME"
    fi
}

function install_config_files {
    info "Linking configuration files..."

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
}

function install_klippain_shaketune {
    if ! [ -d "$KLIPPAIN_SHAKETUNE_DIR" ]; then
        info "Installing Klippain Shake & Tune"
        curl -sSf "$KLIPPAIN_INSTALL_SCRIPT" | bash
    else
        info "Skipping Klippain Shake & Tune Install. Existing install detected at $KLIPPAIN_SHAKETUNE_DIR."
    fi
}

function install_tmc_autotune {
    if ! [ -d "$TMC_AUTOTUNE_DIR" ]; then
        info "Installing TMC Auto Tune"
        curl -sSf "$TMC_AUTOTUNE_INSTALL_SCRIPT" | bash
    else
        info "Skipping TMC Auto Tune Install. Existing install detected at $TMC_AUTOTUNE_DIR."
    fi
}

validate_args

info "Activating configuration for \"$PRINTER_NAME\""

install_config_files
install_klippain_shaketune
install_tmc_autotune
