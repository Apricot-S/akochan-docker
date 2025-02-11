# akochan-docker

Run [Akochan](https://github.com/critter-mj/akochan) in a Docker container

## Usage

### Run as a TCP client

```sh
akochan-docker$ docker compose up
```

Uses port `11600`.

### Run temporarily with custom options

```sh
akochan-docker$ docker compose run --rm app ./system.exe [options]
```

## License

Copyright (c) Apricot S. All rights reserved.

Licensed under the [MIT license](LICENSE).
