# Repository Agent Instructions

## Project

This repository contains public technical documentation for the RCCG
Azure CycleCloud environment.

The documentation source is Markdown under `docs/`.

The documentation is built with MkDocs and published to GitHub Pages.

## Documentation rules

- Treat the existing documentation as the source of truth for terminology,
  structure, and style.
- Prefer editing existing pages over creating duplicate pages.
- Keep documentation concise, practical, and user-oriented.
- Preserve the existing Markdown and MkDocs conventions.
- Check `mkdocs.yml` before changing documentation navigation.
- When a page should appear in the published documentation, add or update the appropriate `nav` entry in `mkdocs.yml` following the existing navigation structure.
- Do not manually edit generated files under `site/`.
- Do not modify `.github/workflows/` unless explicitly requested.
- Do not modify `scripts/leak-guard.sh` unless explicitly requested.
- Do not modify `.leak-terms` unless explicitly requested.
- Do not add secrets, credentials, private information, or internal-only
  information.

## Validation

Before considering a documentation change complete, run: 
    mkdocs build --strict
    bash scripts/leak-guard.sh

Both commands must pass.

If a validation command fails, diagnose and fix the relevant documentation
or configuration issue and run the validation again.

## Git workflow

For each documentation change:

1. Start from an up-to-date `main` branch.
2. Create a dedicated `docs/<topic>` branch.
3. Make the documentation changes.
4. Run the required validation commands.
5. Review the resulting diff.
6. **Show the proposed changes to the user and ask for explicit validation.**
7. **If the user approves the changes, proceed to commit.**
8. Commit with a neutral summary using the repository convention.
9. Push the branch.
10. Create a pull request against `main`.
11. Enable automatic squash merge.
12. Delete the branch after merge.

If the user does not approve the changes:
- Ask for or incorporate the user's remarks.
- Return to step 3 and modify the documentation accordingly.
- Run the validation commands again.
- Review and present the updated diff for approval.

**Do not commit, push, create a pull request, or merge until the user has explicitly approved the final changes.**

Do not rewrite history.
Do not force-push.
Do not merge directly into `main`.

## Scope

The primary source files are:

- `docs/**/*.md`
- `mkdocs.yml`

Generated output under `site/` should normally not be edited manually.

When a page is being promoted for publication, make the corresponding `nav` changes in `mkdocs.yml`.

Do not make unrelated changes.
