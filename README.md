# RCCG HPC Documentation

Public user documentation for all RCCG HPC systems, built with [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/) and published to GitHub Pages.

One site, organized by system (ACC Cluster, On-Prem Cluster, ...) and by cross-cutting topic (Containers, ...), with tags to filter across both.

**This repo is 100% public. Do not add internal IPs, resource IDs, credentials, or Internal-classified material here.** A CI check blocks common patterns (IPs, GUIDs, SSH key headers) on every push, but it's a safety net, not a substitute for judgment — review before committing.

## First-time setup

1. Push this repo to `https://github.com/<your-org>/rccg-public-docs` (public).
2. In `mkdocs.yml`, replace `<your-org>` in `site_url` and `repo_url`.
3. Repo → Settings → Pages → Source: **GitHub Actions**.
4. Push to `main`. The site builds and deploys automatically, live at the `site_url` within ~1 minute.

## Local development

```bash
pip install -r requirements.txt
mkdocs serve
```

Open `http://localhost:8000`. Live-reloads as you edit.

## Adding content

**New page in an existing section:** add a `.md` file under the matching `docs/<section>/` folder, add it to `nav:` in `mkdocs.yml`.

**New system:** create `docs/<new-system>/index.md`, add a nav tab for it in `mkdocs.yml`, link it from `docs/index.md`.

**Tags:** every page can carry a YAML frontmatter `tags:` list (see existing pages for examples). Use this for audience (`researcher`, `admin`) or system, independent of which nav tab the page lives under — this is how overlapping-audience content stays discoverable regardless of section. The `docs/tags.md` page renders an automatic tag index.

## Structure

```
.
├── mkdocs.yml
├── requirements.txt
├── docs/
│   ├── index.md              # portal — links by system and by topic
│   ├── tags.md                # auto-generated tag index
│   ├── acc-cluster/
│   │   ├── index.md
│   │   ├── getting-started.md
│   │   ├── submitting-jobs.md
│   │   ├── storage.md
│   │   └── software/
│   │       └── index.md
│   ├── onprem-cluster/
│   │   └── index.md
│   ├── containers/
│   │   ├── index.md
│   │   ├── building-images.md
│   │   └── running-on-slurm.md
└── .github/workflows/
    └── deploy.yml             # build (with leak-guard check) + deploy to Pages
```

## Maintenance

- Enable Dependabot for `pip` and `github-actions` in repo settings.
- `mkdocs build --strict` runs on every push — a broken nav link or plugin error fails the build before it deploys.
- Add the [`mike`](https://github.com/jimporter/mike) plugin later if you need versioned docs (e.g. per cluster generation).
