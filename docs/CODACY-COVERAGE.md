# Codacy coverage for Python tooling

This repository's runtime code is GLSL. This workflow measures executed Python
lines in `tools/` during source validation, profile validation, and a public
package build. It does not measure shader execution, GLSL branch coverage,
rendering correctness, or Iris compatibility. The scripts in `validation/`
and manual/in-game checks remain separate checks.

## Enable uploads

1. Add `Oshakuru/Mac-os-Shaders` to Codacy and enable Python analysis and the
   `main` branch.
2. In Codacy, open the repository settings and obtain its repository API token.
3. In GitHub **Settings > Secrets and variables > Actions**, add a repository
   secret named `CODACY_PROJECT_TOKEN` with that token. Do not commit the token.
4. Merge this workflow and push another commit (or run the workflow manually
   for an enabled branch). Check the Actions log for a successful upload.
5. In Codacy **Repository Settings > Coverage > Test your integration**, confirm
   reports show **Processed** for at least two commits. PR comparisons also
   require coverage for the common ancestor.

Without the secret, validation and coverage generation still run, the XML report
is retained as a workflow artifact, and the upload is explicitly skipped.
Fork and Dependabot PRs generally cannot upload because they do not receive this
secret. No privileged pull_request_target workflow is used.

## Run locally

From the repository root with Python 3.12:

```sh
python -m pip install coverage==7.10.7
python -m coverage erase
python -m coverage run tools/validate.py
python -m coverage run --append tools/check_profiles.py
python -m coverage run --append tools/build.py --without-cubic
python -m coverage xml -o cobertura.xml
python -m coverage report
```

Coverage is a smoke-test baseline, not a comprehensive unit-test suite.
Failure/error branches and the optional externally supplied cubic-texture build
are not exercised. Build subprocesses rerun the validators; their coverage is
already collected by the separate validator invocations. No minimum percentage
is enforced.

Reference: https://docs.codacy.com/coverage-reporter/
