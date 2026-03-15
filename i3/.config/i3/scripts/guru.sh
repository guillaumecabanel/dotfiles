#!/bin/bash

DATE=$(LC_TIME=fr_FR.UTF-8 date '+%A %d %B %Y')

MESSAGE="_${DATE}_\n\n**Collab**\n- "

printf '%b' "$MESSAGE"
