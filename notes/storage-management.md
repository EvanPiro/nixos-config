# Storage Management

The adventurous dev will routinely deal with disc capacity issues, where the builds and applications they're running will leave behind data in miscellaneous places in the OS file tree. The process of finding where the disc is filling up can be difficult without the right tooling.

A great tool that is readily available in `nixpkgs` is [`ncdu`](https://en.wikipedia.org/wiki/Ncdu) which will scan your file tree from your current directory and open a UI where you can find the largest files.
```
nix-shell -p ncdu
```


