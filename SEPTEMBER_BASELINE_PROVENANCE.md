# Ming September 2026 independent baseline

This branch reconstructs the independently developed September 2026 package
repairs from the preserved working tree and source archives.  It is based on
Terry Therneau's commit `fb1ec0e2a51206a65c2dd4d7c7814626e742d54b`
(September 11, 2026), before the October commits associated with pull request
#2.  The Git commits on this branch were created later to preserve and review
the work; their commit dates are not represented as September development
dates.

## Scope established by the preserved September files

- continuous Gaussian-marker indexing and analytic gradients, including
  repeated latent states in a product-state model;
- marker-option evaluation in the formula's caller environment;
- affine constraint translation, fixed-coefficient handling, and optimizer
  forwarding;
- return of optimized rather than starting coefficients when centering and
  scaling are disabled;
- consistent derivative conditioning after a known state, exact death, or
  alive censoring;
- correction of the sequential likelihood path to use the current parameter
  matrix; and
- source-build inclusion of the package data files.

The September validation was limited to the Gaussian continuous-marker path
used by the one-process and multiprocess analyses.  This baseline does not
claim the later comprehensive marker-family work from pull request #2.

## Claim-to-code map

| Independently developed function | Package implementation | Regression evidence |
|---|---|---|
| Repeated-state Gaussian gradient and indexing | `R/response.R`, `R/hmm1.R` | `tests/gaussian-marker-gradient.R` |
| Caller-scope marker options | `R/parsemarker.R` | `tests/marker-option-environment.R` |
| Affine constraints and optimizer forwarding | `R/hmmconstraint.R`, `R/cmsh.R`, `R/msh.fit.R`, `R/hmmscore.R` | `tests/constraint.R` |
| Optimized coefficients returned without scaling | `R/cmsh.R` | `tests/unscaled-coefficient-output.R` |
| Known-state, exact-death, and alive-censor derivative conditioning | `R/hmm1.R` | `tests/gaussian-marker-gradient.R`, `tests/marker-observation-conditioning.R` |
| Sequential likelihood uses current parameters | `R/hmmloglik.R` | exercised by the model-fitting tests |

The first two regression files in this table were preserved with the September
working tree.  The additional focused regression files were added when the
snapshot was committed to Git so that reviewers can directly reproduce the
September failure modes and repairs.

The later commit titled `Preserve single-row constraint dimensions` is an
October review fix discovered by applying the new focused test to the archived
constraint path.  It is intentionally separate from the preserved September
snapshot and is not claimed as September code.

## Preserved-file evidence

The filesystem timestamps below come from the preserved local working tree.
Git does not preserve file-creation timestamps, so the SHA-256 values provide
stable identifiers while the timestamps and contemporaneous analysis outputs
provide supporting provenance.

| File | Preserved modification time (CDT) | SHA-256 |
|---|---|---|
| `.Rbuildignore` | 2026-09-16 09:29:01 | `9038d66f3d3d0989c5b74a7722a5e814e671d13ec4b7464894f69afa49f4ad7d` |
| `R/cmsh.R` | 2026-09-16 01:36:33 | `f2566f98e262efd279876634647753c19d6fe4caa0714a60fe8b005e4456b3a7` |
| `R/hmm1.R` | 2026-09-16 13:33:12 | `e3a136568fd58ee2012f6912abb036c8df422275b442ee72698917a5eec0504e` |
| `R/hmmconstraint.R` | 2026-09-16 01:32:40 | `f39d3d4be9eb6dad8334a38e861de0f2949796b5ad3ea7e059be3d8a485a79a4` |
| `R/hmmloglik.R` | 2026-09-16 01:39:25 | `475cf4b9d9b86fc700a79c5bcd30336fcf2d9a8c60432b8c0b1659f0ece5b428` |
| `R/hmmscore.R` | 2026-09-16 09:45:19 | `1010b344f06119324dd60ed75b64f134bc66501d7416a7426c0316704abb4d08` |
| `R/msh.fit.R` | 2026-09-16 01:36:33 | `90786f4c66113b99001388875c07b50b68018f0abc40aa61e5260a9412c89cfb` |
| `R/parsemarker.R` | 2026-09-16 09:30:54 | `6bc4740a56bcfff445301e80653c04e9d9498a9c2a13aa64317a11b25e8fb8ff` |
| `R/response.R` | 2026-09-16 13:11:15 | `dc191006461e7faaf03abb8f5bd8eab90e296a07457e9e3c3a03208e0d6d78c7` |
| `tests/gaussian-marker-gradient.R` | 2026-09-16 13:33:26 | `f35eabc51fbcd82aecb240359293979837c705224a7cc92c03ed930cfb37bf73` |
| `tests/marker-option-environment.R` | 2026-09-16 09:36:21 | `65cae35347b972734ad686a33edc497c5e175af5e7cb56900f520262cc2ef126` |

The preserved September 16 source archives have SHA-256 values
`d2c2a653f25f85a0c90bb24341762aaf7437dc7157daa7c68532ada4cd2c6fbb`
and `acb27f7eb65cd9050abfc513dea4033f7b54b304ec9be0f3996c55eb08fb2f21`.
They are retained outside the public package branch because they duplicate the
source tree and include large package data files.

## Relationship to the integration branch

This branch contains no commit from pull request #2.  Pull request #3 is the
separate integration branch: it retains the pull request #2 commit for its
marker-family contribution and applies subsequent integration, compatibility,
and regression-test commits.  Neither pull request #2 nor pull request #3 is
rewritten by this baseline branch.
