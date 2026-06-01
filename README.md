# Unofficial Entra ID Device Join Specification

This repository is the home of the unofficial Entra ID device join
specification. It documents the Device Registration Join Protocol used to
establish a device identity between a physical device and an Entra ID tenant.

Microsoft does not publish protocol documentation for this flow. The
Himmelblau project maintains this specification so the discovery, nonce, and
device join details are written down for other implementors.

The source document is [aad-join-spec.md](aad-join-spec.md). Generated HTML and
PDF versions are produced from that file for easier reading and distribution.

## Build Instructions

The build requires:

- `pandoc`
- Google Chrome available as `google-chrome`

Run:

```sh
make
```

The build creates `aad-join-spec.html` with `pandoc`, then renders
`aad-join-spec.pdf` from the HTML using headless Google Chrome.

To remove generated artifacts, run:

```sh
make clean
```
