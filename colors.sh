#!/bin/bash

function fg_rgb() {
    echo -e "\x1b[38;2;$1;$2;$3m"
}

function bg_rgb() {
    echo -e "\x1b[48;2;$1;$2;$3m"
}

function reset_colors() {
    echo -e "\x1b[0m"
}

FG_SECONDARY=$(fg_rgb "255" "255" "255")
BG_SECONDARY=$(bg_rgb "72" "172" "240")

FG_PRIMARY=$(fg_rgb "255" "255" "255")
BG_PRIMARY=$(bg_rgb "179" "120" "186")

FG_SUCCESS=$(fg_rgb "255" "255" "255")
BG_SUCCESS=$(bg_rgb "49" "175" "144")

FG_ERROR=$(fg_rgb "255" "255" "255")
BG_ERROR=$(bg_rgb "244" "91" "105")

FG_WARNING=$(fg_rgb "51" "65" "85")
BG_WARNING=$(bg_rgb "239" "202" "8")

FG_HIDDEN=$(fg_rgb "83" "88" "99")