#!/usr/bin/env fish

for k in resources/images/BambuStudio_32px.png resources/images/BambuStudio.ico resources/images/BambuStudio_192px.png resources/images/BambuStudio_128px.png resources/images/BambuStudio-mac_128px.png
    set FILE "$k"
    git checkout origin/master -- "$FILE"
    magick "$FILE" -modulate 100,100,123 "$FILE"
    icat "$FILE"
    set -e FILE
end
