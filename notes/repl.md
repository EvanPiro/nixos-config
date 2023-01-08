# Nix Repl

Nix repl can be loaded with the following
```
nix repl
```

You can view commands available to run via
```
nix-repl> :?
```

To load nixpkgs:
```
nix-repl> :l <nixpkgs>
```

To find out a function's arguments, with the result telling you if each attribute as a default value or not:
```
nix-repl> builtins.functionArgs stdenv.mkDerivation
```
