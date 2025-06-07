# AsmLearning

Files so far: 
first.asm 

### compile: 
```sh
nasm -felf64 -o first first.asm
ld -o first first.o
```

### run after compile: 
```sh
./first 'Hello, from DeezNuts' # should print once and show 'DEEZ NUTS'
./first 'anything else' # should print once and show 'No deez nuts here. Go away.' 
```

### Possible errors which are handled: 
- when no args are provided: 
```sh 
./first
# will print out 'No args provided. Need atleast 1 arg to function.'
```

machine built on: x86_64 (Linux, NixOS) 
if running aarch64/arm7/arm use a different assembler but make sure the syscalls align

