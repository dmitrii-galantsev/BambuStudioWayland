#!/usr/bin/env fish

for k in $(fd -i -u 'svg' resources/images/ | grep -i bambu) resources/images/splash_logo.svg
    echo "$k"
    sed -i -e 's/00AE42/00A0AE/g' "$k"
    echo '----'
end
