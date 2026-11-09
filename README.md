# endeavr-guides

Public how-to guides for joining the ENDEAVR team VPN.

- `index.html`: step-by-step visual guide for Windows, macOS, Linux, Android and iPhone
- `handbook.html`: detailed member handbook

**This repository is public.** It must never contain server addresses, internal IPs, account names,
invitation links, setup keys, passwords, tokens or private keys. Members receive the server address
and their personal invitation privately from the administrator.

Internal runbooks live in the private repository `endeavr-infra`.

## Checks

Every pull request runs `.github/workflows/ci.yml`; `make ci` runs the identical commands
locally (needs `uv` and Node.js):

- `make html` — every page validated against the HTML standard (`html-validate --preset standard`)
- `make content-guard` — `scripts/check-content.sh` fails on IPv4 literals, private keys, UUIDs
  (setup keys / invitation ids), NetBird tokens, setup-key values and dynamic-DNS hostnames
- `make actionlint` — the workflows themselves

A failing workflow on `main` opens one tracking issue (`main-red-alert.yml`) that closes
itself when `main` is green again.
