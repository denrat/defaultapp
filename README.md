# defaultapp
A CLI to query and edit default URL schemes on macOS.

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
- Get the bundle identifier for a given URL scheme

```sh
defaultapp get mailto  # -> com.apple.mail
```

- Get all possible bundle identifiers to link to the given URL scheme

```sh
defaultapp getall mailto # -> com.apple.mail org.gnu.emacs
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
- Allow to edit default apps for a given filetype
- Allow to bind scripts to URL schemes or filetypes
