# Agent Notes

## Purpose

This repo is Element Web with ChurchTools-specific customizations. When updating to a newer upstream Element Web tag, port the ChurchTools changes as a small set of clear commits instead of copying old patches blindly.

Recommended commit split:

- `Apply ChurchTools web branding`
- `Support disabling encryption for ChurchTools`

## Monorepo Layout

Element Web is now a monorepo. Most web-app files live under `apps/web/`.

Useful paths:

- ChurchTools config template: `apps/web/config.churchtools.json`
- Local runtime config: `apps/web/config.json`
- Web source: `apps/web/src/`
- Theme assets: `apps/web/res/themes/element/`
- Web package script: `apps/web/scripts/package.sh`
- ChurchTools deploy wrapper: `deployVersion.sh`

The old external `matrix-react-sdk` code has been absorbed into this repo. Do not reintroduce an old `matrix-react-sdk` dependency override.

## Branding Changes

Keep these in the branding commit:

- ChurchTools config
- ChurchTools logo, start page, and font assets
- Welcome/login wording and relevant translations
- ChurchTools theme colors
- Version normalization for `churchtools-v...` tags
- Deploy packaging wrapper

Use current Element Web config conventions. Prefer `snake_case` keys such as `embedded_pages`, `setting_defaults`, `desktop_builds`, `default_country_code`, and `show_labs_settings`.

If the config references a theme asset, make sure the asset exists under `apps/web/res/themes/element/`; otherwise local and packaged builds may miss it.

## Encryption Changes

Keep encryption behavior in its own commit.

The old SDK-only crypto-store change is not enough in newer Element Web versions because Rust crypto is initialized centrally. When `disable_encryption` is enabled, make sure the implementation:

- skips crypto-store creation,
- skips `initRustCrypto()`,
- guards verification/right-panel flows when crypto is unavailable.

Likely files to inspect:

- `apps/web/src/IConfigOptions.ts`
- `apps/web/src/utils/createMatrixClient.ts`
- `apps/web/src/MatrixClientPeg.ts`
- `apps/web/src/stores/right-panel/RightPanelStore.ts`

## Deploy Script

`deployVersion.sh` should build from `apps/web`, unpack the generated `element-$version.tar.gz`, copy `apps/web/config.churchtools.json` to `config.json` inside the unpacked package, and create `webchat-$version.zip`.

Before running `zip -r`, remove any existing `webchat-$version.zip`; otherwise old files can remain in the archive.

## Local Development

Create a runtime config:

```bash
cp apps/web/config.churchtools.json apps/web/config.json
```

Start the app:

```bash
pnpm --dir apps/web start
```

The dev server usually runs at:

```text
http://localhost:8080/
```

If dependency resolution looks wrong, especially with transitive CLI packages, reinstall with isolated linking:

```bash
pnpm install --config.node-linker=isolated --force
```

## Quick Checks

Run targeted lint on touched TypeScript files when possible:

```bash
./node_modules/.bin/eslint <changed-ts-files>
```

Validate JSON configs/translations:

```bash
node -e 'for (const f of process.argv.slice(1)) JSON.parse(require("fs").readFileSync(f,"utf8")); console.log("json ok")' apps/web/config.churchtools.json
```

If a font or theme asset fails in the browser, verify the served URL, for example:

```bash
curl -I http://localhost:8080/themes/element/lato-v14-latin-ext_latin-regular.woff2
```

## Working Tree

Local generated files such as `config.json`, `src/`, or `webapp/` may be present. Do not include them in ChurchTools commits unless there is an explicit reason.
