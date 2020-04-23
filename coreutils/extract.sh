#!/bin/bash

for f in $(find build/src -type f -executable); do
    extract-bc ${f}
done
