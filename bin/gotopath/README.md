gotopath
========

Tiny utilities (ga, gd) to jump to common paths of your system quickly



go (soon to be renamed to ga):

Goto Alias

Create and jump to an alias.

$ cd /some/large/and/complicated/path
$ ga -a place
Alias added

$ ga place        (jumps to /some/large/and/complicated/path)

$ ga -l           (lists aliases)

$ ga --help



gd:

Kind of 'ncd' (Norton change directory) clone

$ gd --help

Usage: $gd [OPTION] [DIRECTORY]
  DIRECTORY             Directory to jump to. (Default: current)
Options:
  -h  --help            Show this help page.
  -b  --build           Rebuild database

$ gd -b                                                                                                                                                       ⏎
Building DB...

~$ gd backup
/some/backup$ gd backup
/some/other/backup$ 
