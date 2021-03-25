#!/bin/bash

xxd -r -p char.hex | head -c 8192 > bin.chr
nesasm game.asm
