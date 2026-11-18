# iamraaj.in

Portfolio of Raaj, senior software engineer. A static site styled like an Indian bill book: one carbon-copy slip per project, with live demos of the web apps on their own subdomains.

| Site | What it is | Source |
|---|---|---|
| [iamraaj.in](https://iamraaj.in) | This portfolio | this repo |
| [billing.iamraaj.in](https://billing.iamraaj.in) | Billing demo: GST billing and stock | `iamraaj-billing` |
| [hr.iamraaj.in](https://hr.iamraaj.in) | HR demo: attendance, leave and payroll | `iamraaj-hr` |
| [kavach.iamraaj.in](https://kavach.iamraaj.in) | Kavach demo: DPDP, ISO 27001 and SOC 2 compliance | `iamraaj-kavach` |

## Layout

```
public/              everything served at https://iamraaj.in
  index.html         the page (static HTML, no build step)
  404.html
  assets/system.css  the design kit (with motion/ and layout/layout.css), unchanged
  assets/page.css    the page's palette, layout additions and motion (light theme only)
  assets/page.js     scroll reveals and the hero terminal
  assets/boot.js     runs before first paint (motion guards)
deploy/
  deploy.sh          publish public/ and the Caddy files to the VPS
  demos.sh           deploy or check the live demos (Billing, HR, Kavach)
  caddy/             Caddy site files, imported by the server's Caddyfile
scripts/check.sh     pre-deploy checks: complete pages, local links and anchors
```

## Working on it

There is no build. Open `public/index.html` in a browser, or serve the folder so absolute paths work:

```sh
python3 -m http.server 8000 -d public
```

Run the checks before committing (CI runs them too, plus `caddy validate`):

```sh
scripts/check.sh
```

### Adding a project

The page is text only: no images. Add a row to the `Live demos` or `Client projects` list in `#work` (name, one line with the stack, and the live link as `rows__value`), and keep each section within its screen (the checks in `scripts/check.sh` cover links; look at 1440x900 and 390x844 for heights).

Only state what the project's own README or code supports; the page makes no other claims.

## Hosting

One VPS, shared with other apps. Its Caddy container (owned by the bBilling deployment in `/opt/bbilling`) serves every `*.iamraaj.in` site through one line in its Caddyfile:

```
import /data/iamraaj/caddy/*.caddy
```

`/data` is Caddy's data volume, so the iamraaj files live there:

```
/data/iamraaj/caddy/00-common.caddy    shared snippets: security headers, SPA fallback
/data/iamraaj/caddy/iamraaj.caddy      iamraaj.in and www redirect (from this repo)
/data/iamraaj/caddy/<product>.caddy    one per demo (from each product repo)
/data/iamraaj/www/                     this site
/data/iamraaj/<product>/               a demo's frontend build, where it has one
```

Each demo runs as its own Docker Compose project in `/opt/iamraaj/<product>` with its own Postgres, joined to the shared `edge` network, with no public ports. HTTPS certificates are issued and renewed by Caddy. DNS: `A` records (or a `*` wildcard) for the subdomains, pointing at the VPS.

### Deploy

**Push to `main` and it deploys.** GitHub Actions (`.github/workflows/ci.yml`) runs the checks, uploads `public/` to the server and confirms the live page matches the commit. Progress: the repo's Actions tab, or `gh run watch`. A pull request runs the checks only. To redeploy without a change: Actions, CI, "Run workflow".

The workflow's SSH key (secrets `DEPLOY_SSH_KEY` and `DEPLOY_KNOWN_HOSTS`) is locked on the server to `rrsync -wo` into the site folder: it cannot open a shell, read files or touch anything else. To revoke it, delete the `github-actions-iamraaj-deploy` line from root's `~/.ssh/authorized_keys` on the server.

Changes to `deploy/caddy/` still go out by hand, from a machine with full SSH access:

```sh
deploy/deploy.sh            # default SSH host: bstock
```

It runs the checks, syncs `public/`, installs the Caddy files, adds the import line if it is missing, validates and reloads Caddy (no downtime), and confirms the site answers. Static files only, so it is safe at any hour.

> Keep the `import` line in the production bBilling repo's `deploy/Caddyfile` (`~/Documents/raaj/bbilling`) as well. Its deploys copy that file over the server's, and without the line every iamraaj.in site goes offline.

### Demos

Each demo has its own script in its repo (`deploy/iamraaj/deploy.sh`); `deploy/demos.sh` runs them from here:

```sh
deploy/demos.sh status      # portfolio and all three demos answering?
deploy/demos.sh kavach      # deploy one: billing, hr or kavach
deploy/demos.sh all         # deploy all three, then check them
```

Images are built on the Mac, so Docker Desktop must be running. The scripts refuse to run during Indian market hours (Mon to Fri, 08:00 to 16:59 IST), because the server is shared with other live services, and check those services are unchanged afterwards. Outreach and Stock have no public demo.

## Licence

All rights reserved.
