# bert.cpp.flake

## Usage as a flake

[![FlakeHub](https://img.shields.io/endpoint?url=https://flakehub.com/f/ditsuke/bert.cpp/badge)](https://flakehub.com/flake/ditsuke/bert.cpp)

Add bert.cpp to your `flake.nix`:

```nix
{
  inputs.bert.cpp.url = "https://flakehub.com/f/ditsuke/bert.cpp/*.tar.gz";

  outputs = { self, bert.cpp }: {
    # Use in your outputs
  };
}

```
