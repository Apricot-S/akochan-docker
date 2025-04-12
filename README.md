# akochan-docker

A Docker environment for running [Akochan](https://github.com/critter-mj/akochan).

This project provides a containerized environment for Akochan with the following features:

- Automated build process and dependency management
- Cross-platform support via Docker
- TCP client connectivity to Mjai servers running on the host machine

## Requirements

- Docker
- Docker Compose

## Usage

### Run as a TCP client

The following command starts Akochan as a TCP client and connects to an Mjai server running on the host machine (port `11600`):

```sh
akochan-docker$ docker compose up
```

### Run temporarily with custom options

To run `system.exe` with direct command-line options:

```sh
akochan-docker$ docker compose run --rm app ./system.exe [options]
```

## License

Copyright (c) Apricot S. All rights reserved.

Licensed under the [MIT license](LICENSE).
