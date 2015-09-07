#!/bin/bash

printf '\n'

cat << EOF
<body>
`env | grep WWW`
</body>
EOF