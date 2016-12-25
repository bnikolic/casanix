for x in  casa casacore casacore-data casa-data casa-asap casa-gcwrap libsakura pgplot wcslib; do
    nix-build --check -A $x -j 1 --cores 5
done
