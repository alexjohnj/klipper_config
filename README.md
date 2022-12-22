# Ender 3 S1 Klipper Config

Config files and macros for Klipper and Mainsail running on an Ender 3 S1.

I wrote some of the macros but grabbed a load from a random Reddit post. I don't remember which one.

You should probably use the default `printer.cfg` for the S1 and not this one.


## File System Structure

- Printer specific configuration goes in the `printers/$PRINTER_NAME/` directory.
- Device specific configuration for the _active_ printer this Pi controls are symlinked into the `active_printer/` directory.
- The current device's `printer.cfg` is symlinked to the root of the directory.
- Common configuration files for all printers (e.g., Mainsail, macros) go in the root of the directory. Common configuration files should import the active printer's configuration from the `active_printer/` directory.
