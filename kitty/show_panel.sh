#!/bin/sh
#
#kitty +kitten panel sh -c 'printf "\n\n\nHello, world."; sleep 5s'
kitty +kitten panel sh -c 'printf "\n\n\n$(curl -sS wttr.in/ShenZhen?format=3)"; sleep 5s'
