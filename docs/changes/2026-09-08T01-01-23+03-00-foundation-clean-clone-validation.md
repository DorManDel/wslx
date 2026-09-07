# foundation-clean-clone-validation

## Goal

Verify that the published WSLX Foundation works from a completely fresh GitHub
clone and completes the full user lifecycle successfully.

## Mapxplanation Update

No structural responsibility changed, so `docs/MAP.md` does not require an
update.

## Files Changed

- `docs/CURRENT_STATE.md`
- this validation record

## Why

The Foundation baseline was published to GitHub and needed validation
independent of the original development checkout.

## Validation

- [x] fresh clone from `DorManDel/wslx`
- [x] `make check`
- [x] `./install.sh`
- [x] `command -v wslx`
- [x] `wslx version`
- [x] `wslx doctor`
- [x] `wslx uninstall --yes`
- [x] shell refresh confirms WSLX is removed
- [x] reinstall succeeds

## Result

The published Foundation baseline successfully completed the full clean-clone
lifecycle:

clone -> test -> install -> doctor -> uninstall -> reinstall

WSLX is currently installed from the clean GitHub clone and reports version
`0.1.0-dev`.

## Next

Begin WSLX-002 — PathX.