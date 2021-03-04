vi process.c 
vi process.c
make
clear
vi process.c
make
vi cpu.c:133
ls
rm cpu.c:133
ls
clear
ls
vi cpu.c
make
grep -r --include=*.{c,h} "insert_ready"
grep -r --include=*.{c,h} "initialize_process_manager"
vi system.c
clear
make
grep -r --include=*.{c,h} "initialize_system"
make
vi system.o
vi system.c
make
gcc -c system.c
(gdb) run
(gdb) make
man gdb
clear
gdb system.c
clear
make
vi makefile
make
./simos_1.exe
clear
ls
git add -A
git commit
git push
