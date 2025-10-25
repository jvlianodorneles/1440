#!/bin/bash

# Set the applet's UUID and the output directory for the .pot file.
UUID="1440@jvlianodorneles"
APPLET_DIR="/home/juliano/.local/share/cinnamon/applets/1440@jvlianodorneles"
PO_DIR="$APPLET_DIR/po"

cd "$PO_DIR"

# Extract translatable strings from applet.js and metadata.json.
xgettext --from-code=UTF-8 -o "$UUID.pot" -L JavaScript -k_ -kN_ "$APPLET_DIR/applet.js" "$APPLET_DIR/metadata.json"

# Define the languages to translate to.
LANGUAGES=("en" "zh_CN" "es" "hi" "pt_BR")

# Loop through the languages and create/update .po files.
for lang in "${LANGUAGES[@]}"; do
    PO_FILE="$lang.po"
    if [ -f "$PO_FILE" ]; then
        # Update the existing .po file.
        msgmerge --update "$PO_FILE" "$UUID.pot"
    else
        # Create a new .po file.
        msginit --input="$UUID.pot" --locale="$lang"
    fi

    # Compile the .po file into a .mo file.
    MO_DIR="$APPLET_DIR/locale/$lang/LC_MESSAGES"
    mkdir -p "$MO_DIR"
    msgfmt "$PO_FILE" -o "$MO_DIR/$UUID.mo"
done