#!/bin/sh
docker pull composer:1

if [ ! -e ${HOME}/.local/bin/ ]; then
    mkdir ${HOME}/.local/bin
fi
if [ ! -e ${HOME}/.cache/composer_cache ]; then
    mkdir -p ${HOME}/.cache/composer_cache
fi
cat > ${HOME}/.local/bin/composer << 'EOF'
#!/bin/sh
echo "Current directory: '"$(pwd)"'"
docker run --user $(id -u):$(id -g) --rm -v $(pwd):/app -v ${HOME}/.cache/composer_cache:/composer/cache composer:1 $@
EOF

chmod +x ${HOME}/.local/bin/composer