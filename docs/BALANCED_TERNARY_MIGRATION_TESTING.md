# Balanced Ternary Migration Testing (Phased)

This project is migrating from a sparse-index ternary representation (`SparseVec`) toward a ternary-native packed substrate (`PackedTritVec` and successors) as part of the "balanced ternary everywhere" refactor.

To avoid regressions, testing shifts in **phases**. Each phase enables stricter equivalence suites and invariants.

## Feature flags

- `bt-phase-1`
  - Enables heavy refactor invariants (`ternary-refactor`) and adds phase-1 equivalence checks.
  - Goal: prove that `PackedTritVec` basic ops match existing `SparseVec` semantics.
  - As of 2026-08-18 this gate runs against the sibling `embeddenator-vsa` wrap of
    `trit-vsa` 0.3. Holographic bind is still trit multiplication (`P*P=P`).

- `bt-phase-2`
  - **Honesty (2026-08-18):** this is a *test gate*, not a future implementation.
    Packed scratch for bundle/bind already shipped unconditional in
    `embeddenator-vsa` (density `DIM/8`, not `cfg(feature = "bt-phase-2")`).
    `--features bt-phase-2` only enables `tests/bt_phase2_scratch_invariants.rs`
    (TLS scratch checks). It does not switch the runtime substrate.

- `bt-phase-3`
  - **Still empty.** Feature is `bt-phase-3 = ["bt-phase-2"]` with no
    `bt_phase3_*` tests. Real phase-3 is a BT-native default substrate /
    `VsaBackend` trait (see `docs/KERNEL_VSA_INTEROP.md`), not this flag.
    Do not start that work until the vsa wrap + core/retrieval/fs gates are green.

- `bt-migration`
  - Convenience umbrella for the highest currently-implemented phase
    (today: phase-2 test gate).

## How to run

Baseline (fast default suite):

- `cargo test`

Phase 1 (packed equivalence + refactor invariants):

- `cargo test --features bt-phase-1`

All migration suites currently implemented:

- `cargo test --features bt-migration`

## Notes

- These phases are intentionally feature-gated so default CI/dev loops remain fast.
- As we land new ternary-native implementations, we move assertions from feature-gated tests into the default suite only when stable.
