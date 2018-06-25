# defaultapp
A CLI to query and edit default URL schemes on macOS
Inspired by [Grayson/defaultapp](https://github.com/Grayson/defaultapp/).

## Installation

```sh
git clone https://github.com/h0d/defaultapp.git
cd defaultapp
make install
```

Alternatively, you can provide a custom location, e.g. `$HOME/bin/`:

```sh
make install LOCATION=$HOME/bin
```

The development happens on Sierra but this should work with El Capitan and above.

## Usage

```bash
defaultapp help
```

## TODO
- Allow to edit default apps for a given filetype
- Allow to bind scripts to URL schemes or filetypes
