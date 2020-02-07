For more details, check out the [wiki](https://github.com/christophergeiger3/cesm-unifying-scripts/wiki)!

### To run:
```bash
git clone https://github.com/christophergeiger3/cesm-unifying-scripts
cd cesm-unifying-scripts
cp -r /glade/scratch/ranfeng/cesm1_2_0/* .
cd tools/mapping
./config.sh && make		## Generates files with the default configuration (see config.sh)
```

The `make` command should take a while to finish. After this command finishes, there should be
two new folders generated, which are by default named `logs` and `outputs`. You can change these names as detailed in the wiki.

Note:
  If you would like to tweak the configuration variables of the Makefile, you can do so by editing the
  bash values in config.sh, or by directly editing values in Variables.env.
For example:
```bash
nano config.sh
./config.sh && make
```
Or,

```bash
nano Variables.env
nano Defaults.env
make
```

See the wiki tab for more info on how to configure the Makefile.

Note:
  If you would like to get the latest updated version of this script from Github, run `git pull` in
  the cesm-unifying-scripts directory.
