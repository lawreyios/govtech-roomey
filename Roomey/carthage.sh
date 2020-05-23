#!/bin/sh

CACHE_PREFIX=$(xcrun swift --version | head -1 | sed 's/.*\((.*)\).*/\1/' | tr -d "()" | tr " " "-")

 # Copy frameworks from local cache
rome download --platform iOS --cache-prefix "$CACHE_PREFIX"

# List what is missing and update/build if needed
rome list --missing --platform iOS --cache-prefix "$CACHE_PREFIX" | awk '{print $1}' | xargs carthage bootstrap --platform iOS --cache-builds

# Upload to local cache what is missing
rome list --missing --platform iOS --cache-prefix "$CACHE_PREFIX" | awk '{print $1}' | xargs rome upload --platform iOS --cache-prefix "$CACHE_PREFIX"