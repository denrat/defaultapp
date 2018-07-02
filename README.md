# defaultapp
A CLI to query and edit default URL schemes on macOS.

Inspired by [Grayson/defaultapp](https://github.com/Grayson/defaultapp/).

## Installation

```sh
git clone https://github.com/h0d/defaultapp.git
cd defaultapp
make install
```

One-liner:

```sh
git clone https://github.com/h0d/defaultapp.git && make -C defaultapp install && rm -rf defaultapp
```

Alternatively, you can provide a custom location, e.g. `$HOME/bin` (default is `/usr/local/bin`):

```sh
make install LOCATION=$HOME/bin
```

The development happens on Sierra but this should work with El Capitan and above.

## Usage
- Get the bundle identifier for a given URL scheme

```sh
defaultapp get mailto  # -> com.apple.mail
```

- Get all possible bundle identifiers to link to the given URL scheme

```sh
defaultapp getall mailto  # -> com.apple.mail org.gnu.emacs
```

- Change the app associated with the URL scheme

```sh
defaultapp set mailto com.apple.mail
# or
defaultapp set mailto Mail
# or
defaultapp set mailto Mail.app
```

- Show help

```sh
defaultapp help
```

## TODO
- Allow to edit default apps for a given filetype (e.g. `defaultapp set .mkv IINA.app`)
- Allow to bind scripts to URL schemes or filetypes (e.g. `defaultapp create myscheme Safari`, `defaultapp create https --file myscript.sh`)
  - Possibly create a .app in ~/.config/defaultapp/custom/ with Contents/MacOS/name being `myscript $*` registering io.defaultapp.myscript
- Start versionning
- Add backup option (`defaultapp backup` -> `defaultapp restore [specific_file]`)
