# Embeddenator Core Ecosystem Roadmap Review
**Date:** January 15, 2026
**Reviewer:** Integration Review
**Status:** Phase 3 In Progress - Critical Issues Identified

---

## Executive Summary

This document provides a comprehensive review of the embeddenator-core ecosystem and all sister repositories, identifying remaining integration tasks, work items, and a complete roadmap to completion against documented requirements and success criteria.

### Critical Finding
**Version Mismatch Detected:** embeddenator-core/Cargo.toml requires `embeddenator-fs = "0.20.0-alpha.2"` but only `0.20.0-alpha.1` is published to crates.io. This blocks the build and must be resolved immediately.

### Overall Project Status
- **Phase 1:** ✅ Complete (Foundation & Architecture)
- **Phase 2A:** ✅ Complete (6 core components extracted)
- **Phase 2B:** ✅ Complete (CLI extracted)
- **Phase 3:** ⚠️ In Progress (Integration & Publishing - 21% complete)
- **Critical Blockers:** 1 version mismatch, integration testing incomplete

---

## Repository Ecosystem Map

### 1. Core Monorepo
**Repository:** embeddenator-core
**Current Version:** 0.20.0-alpha.1
**Location:** /home/user/embeddenator-core
**Status:** ⚠️ Blocked (version mismatch)

**Purpose:** Main orchestrator and binary, integrates all component libraries

**Dependencies:**
- embeddenator-vsa = "0.20.0-alpha.1" ✅
- embeddenator-retrieval = "0.20.0-alpha.1" ✅
- embeddenator-fs = "0.20.0-alpha.2" ❌ **NOT PUBLISHED**
- embeddenator-interop = "0.20.0-alpha.1" ✅
- embeddenator-io = "0.20.0-alpha.1" ✅
- embeddenator-obs = "0.20.0-alpha.1" ✅
- embeddenator-cli = "0.20.0-alpha.1" ✅

**Workspace Structure:**
```
embeddenator-core/
├── crates/
│   ├── embeddenator/     # Core library
│   └── embeddenator-cli/ # CLI interface
├── src/                  # Binary entry point
├── tests/                # Integration tests
├── benches/              # Benchmarks
└── docs/                 # Documentation
```

### 2. Component Libraries (Published to crates.io)

#### 2.1 embeddenator-vsa
- **Version:** 0.20.0-alpha.1 ✅
- **Purpose:** Vector Symbolic Architecture - sparse ternary vector operations
- **Dependencies:** None (foundation layer)
- **LOC:** ~4,252
- **Status:** Published & stable
- **Tests:** Comprehensive (29 ternary arithmetic tests)
- **Unsafe Blocks:** 5 (SIMD operations, audited as safe)

#### 2.2 embeddenator-retrieval
- **Version:** 0.20.0-alpha.1 ✅
- **Purpose:** Query engine with shift-sweep search
- **Dependencies:** embeddenator-vsa
- **LOC:** ~578
- **Status:** Published & stable
- **Tests:** 18/18 passing
- **Unsafe Blocks:** 0

#### 2.3 embeddenator-fs
- **Version:** 0.20.0-alpha.1 ✅ (but Cargo.toml requests 0.20.0-alpha.2 ❌)
- **Purpose:** EmbrFS - FUSE filesystem backed by holographic engrams
- **Dependencies:** embeddenator-vsa, embeddenator-retrieval
- **LOC:** ~3,675
- **Status:** ⚠️ Version mismatch issue
- **Tests:** Comprehensive
- **Unsafe Blocks:** 2 (POSIX calls, audited as safe)

#### 2.4 embeddenator-interop
- **Version:** 0.20.0-alpha.1 ✅
- **Purpose:** Kernel interop and system integration
- **Dependencies:** embeddenator-vsa, embeddenator-fs
- **LOC:** ~159
- **Status:** Published & stable
- **Tests:** Passing
- **Unsafe Blocks:** 0

#### 2.5 embeddenator-io
- **Version:** 0.20.0-alpha.1 ✅
- **Purpose:** Envelope format and serialization
- **Dependencies:** None (foundation layer)
- **LOC:** ~166
- **Status:** Published & stable
- **Tests:** 11/11 passing
- **Unsafe Blocks:** 0

#### 2.6 embeddenator-obs
- **Version:** 0.20.0-alpha.1 ✅
- **Purpose:** Observability - metrics, logging, tracing
- **Dependencies:** None (foundation layer)
- **LOC:** ~953
- **Status:** Published & stable
- **Tests:** Passing
- **Unsafe Blocks:** 2 (TSC reads, audited as safe)

#### 2.7 embeddenator-cli
- **Version:** 0.20.0-alpha.1 ✅
- **Purpose:** CLI interface for all operations
- **Dependencies:** All Phase 2A components
- **LOC:** ~1,174
- **Status:** Published & stable
- **Tests:** 1 test passing (stub implementations)

#### 2.8 embeddenator-testkit
- **Version:** 0.20.0-alpha.1 ✅
- **Purpose:** Testing utilities and fixtures
- **Dependencies:** embeddenator-vsa, embeddenator-io
- **Status:** Published & stable

### 3. Independent MCP Server Projects (NOT Extractions)

These are standalone projects that use embeddenator but are not part of the core extraction:

- **embeddenator-context-mcp** v0.1.0-alpha.1
- **embeddenator-security-mcp** v0.1.0-alpha.1
- **embeddenator-agent-mcp** v0.1.0-alpha.1
- **embeddenator-webpuppet-mcp** v0.1.0-alpha.2
- **embeddenator-webpuppet** v0.0.0 (Browser automation library)

**Status:** Independent - No integration tasks required for core roadmap

---

## Phase 3: Integration & Publishing - Detailed Status

### Phase 3 Timeline
**Original:** Jan 4-18, 2026 (14 days)
**Current Date:** Jan 15, 2026 (Day 12)
**Completion:** 21% (3/14 tasks complete)
**Status:** ⚠️ Behind schedule

### Week 1: Integration & Security (Jan 4-11)

#### Task 3.1: Integration Testing (2 days) ❌ NOT STARTED
**Status:** ⏹️ Blocked by version mismatch
**Owner:** QA Tester
**Priority:** P0 - Critical

**Required Subtasks:**
- [ ] Create `tests/phase3_integration.rs`
- [ ] Cross-component API tests (VSA→Retrieval→FS→Interop)
- [ ] CLI integration tests with stubs
- [ ] Error recovery validation (RwLock poisoning, corruption, SIMD fallbacks)
- [ ] Memory safety tests (miri, valgrind, asan)
- [ ] Generate integration test report

**Dependencies:** Fix version mismatch first

#### Task 3.2: Security Audit (2 days) ✅ COMPLETE
**Status:** ✅ Completed Jan 4, 2026
**Owner:** Security Audit Agent
**Result:** All components approved for publishing

**Findings:**
- 9 unsafe blocks audited (not 54 as initially estimated)
- 0 critical issues, 0 major issues
- All SAFETY comments comprehensive
- All unsafe code justified and safe

**Unsafe Block Summary:**
| Component | Blocks | Risk | Status |
|-----------|--------|------|--------|
| embeddenator-vsa | 5 (SIMD) | Low | ✅ Approved |
| embeddenator-fs | 2 (POSIX) | Minimal | ✅ Approved |
| embeddenator-obs | 2 (TSC) | Low | ✅ Approved |
| All others | 0 | None | ✅ Approved |

#### Task 3.3: Performance Validation (3 days) ❌ NOT STARTED
**Status:** ⏹️ Pending
**Owner:** Performance Tuner
**Priority:** P1 - High

**Benchmark Suite:**
- [ ] VSA operations baseline (`benches/vsa_ops.rs`)
- [ ] SIMD cosine performance (`benches/simd_cosine.rs`)
- [ ] Hierarchical scale tests (`benches/hierarchical_scale.rs`)
- [ ] Query hierarchical benchmarks (`benches/query_hierarchical.rs`)
- [ ] Retrieval performance (`benches/retrieval.rs`)
- [ ] Regression analysis (<5% target)
- [ ] Performance report generation

**Infrastructure:** 56-core homelab server with AVX2 support

**Baseline Targets:**
- VSA operations: ~4,500 ops/sec
- SIMD cosine: <10µs per operation
- Hierarchical 100K items: <2s
- Query 1K items: <50ms
- Index 10K items: <100ms

### Week 2: Publishing & Cleanup (Jan 11-18)

#### Task 3.4: Publishing Preparation (3 days) ❌ NOT STARTED
**Status:** ⏹️ Pending
**Owner:** Documentation Writer
**Priority:** P0 - Critical

**Per-Component Checklist:**

For each of 7 components:
- [ ] Cargo.toml metadata complete (authors, license, keywords, categories)
- [ ] README.md crates.io-ready with examples
- [ ] CHANGELOG.md with v0.2.0 entry
- [ ] All public APIs have rustdoc comments
- [ ] Doctests passing
- [ ] `cargo clippy` no warnings
- [ ] `cargo publish --dry-run` succeeds
- [ ] Package size <10MB
- [ ] Git tag created

#### Task 3.5: Publish to crates.io (2 days) ⚠️ PARTIAL
**Status:** ⚠️ Partial - All v0.20.0-alpha.1 published, but version sync issues
**Owner:** Workflow Orchestrator
**Priority:** P0 - Critical

**Publishing Order (Dependency Chain):**
```
Level 0 (independent):
├─ embeddenator-io ✅ 0.20.0-alpha.1
└─ embeddenator-obs ✅ 0.20.0-alpha.1

Level 1 (no deps):
└─ embeddenator-vsa ✅ 0.20.0-alpha.1

Level 2 (depends on vsa):
└─ embeddenator-retrieval ✅ 0.20.0-alpha.1

Level 3 (depends on vsa + retrieval):
└─ embeddenator-fs ✅ 0.20.0-alpha.1 (but core requires .2)

Level 4 (depends on vsa + fs):
└─ embeddenator-interop ✅ 0.20.0-alpha.1

Level 5 (depends on all):
└─ embeddenator-cli ✅ 0.20.0-alpha.1

Auxiliary:
└─ embeddenator-testkit ✅ 0.20.0-alpha.1
```

**Critical Issue:** Version mismatch between published crates and core requirements

#### Task 3.6: Monorepo Cleanup (2 days) ❌ NOT STARTED
**Status:** ⏹️ Pending
**Owner:** Rust Implementer
**Priority:** P1 - High

**Cleanup Tasks:**
- [ ] Fix version mismatch in Cargo.toml
- [ ] Remove extracted code from monorepo (if any remains)
- [ ] Update all imports to use published crates
- [ ] Verify monorepo builds: `cargo build --release`
- [ ] Verify all tests pass: `cargo test --workspace`
- [ ] Archive handoff documents to `docs/handoff/archive/`
- [ ] Update VERSION_ROADMAP.md
- [ ] Update PROJECT_STATUS.md
- [ ] Update main README.md with component links
- [ ] Update CHANGELOG.md with Phase 3 completion
- [ ] Close all phase issues (#18-#24)

---

## Critical Issues & Blockers

### 🔴 Critical Issue #1: Version Mismatch
**Component:** embeddenator-fs
**Issue:** Cargo.toml requires 0.20.0-alpha.2 but only 0.20.0-alpha.1 is published
**Impact:** Blocks all builds, testing, and integration
**Priority:** P0
**Resolution Options:**

1. **Option A (Recommended):** Fix Cargo.toml
   ```toml
   # Change from:
   embeddenator-fs = "0.20.0-alpha.2"
   # To:
   embeddenator-fs = "0.20.0-alpha.1"
   ```
   - **Pros:** Immediate fix, no republishing needed
   - **Cons:** May miss features if .2 was intentional

2. **Option B:** Publish embeddenator-fs 0.20.0-alpha.2
   - **Pros:** Matches intent if .2 has actual changes
   - **Cons:** Requires build, test, publish cycle

**Recommended Action:** Investigate if 0.20.0-alpha.2 has actual changes. If not, fix Cargo.toml. If yes, publish .2 first.

### 🟡 Major Issue #2: Integration Testing Not Started
**Impact:** Phase 3 completion at risk
**Priority:** P0
**Days Behind:** 11 days (should have started Jan 5)
**Resolution:** Begin immediately after fixing version mismatch

### 🟡 Major Issue #3: Performance Validation Not Started
**Impact:** No regression analysis, quality at risk
**Priority:** P1
**Days Behind:** 8 days (should have started Jan 7)
**Resolution:** Can be parallelized with integration testing

---

## Updated Roadmap: Path to Completion

### Phase 3 Revised Timeline

**Today: Jan 15, 2026 (Day 12 of 14)**

#### Days 12-13: Critical Path (Jan 15-16)
**Priority:** Unblock and catch up

**Day 12 (Today):**
- [x] Create comprehensive roadmap review
- [ ] **FIX:** Resolve version mismatch (Option A recommended)
- [ ] **TEST:** Verify build with `cargo build --release`
- [ ] **TEST:** Verify tests with `cargo test --workspace`
- [ ] Begin integration testing (Task 3.1)

**Day 13 (Jan 16):**
- [ ] Complete integration testing
- [ ] Generate integration test report
- [ ] Begin performance validation (parallel)
- [ ] Publishing preparation (parallel)

#### Day 14: Final Push (Jan 17)
**Priority:** Complete and ship

- [ ] Complete performance validation
- [ ] Complete publishing preparation
- [ ] Dry-run all publishes
- [ ] Monorepo cleanup
- [ ] Update all documentation

#### Day 15: Overflow & Buffer (Jan 18)
**Priority:** Wrap up and verify

- [ ] Address any test failures
- [ ] Final verification
- [ ] Close all issues
- [ ] Archive handoff documents
- [ ] Phase 3 completion document

### Accelerated Completion Strategy

Given the timeline crunch, recommend **parallel execution** of remaining tasks:

**Parallel Track A: Integration & Testing**
- Fix version mismatch (1 hour)
- Integration testing (1 day)
- Performance validation (1 day)

**Parallel Track B: Publishing Prep**
- Update documentation (1 day)
- Publishing dry-runs (4 hours)
- Verification (4 hours)

**Sequential Track C: Cleanup**
- Monorepo cleanup (after Track A completes)
- Final documentation updates
- Issue closure

**Estimated Completion:** Jan 17-18 (3-4 days from now)

---

## Deliverables & Success Criteria

### Phase 3 Completion Criteria

#### Must-Have (P0) ✅
- [x] ✅ Security audit complete (0 critical issues)
- [ ] ❌ Version conflicts resolved
- [ ] ❌ Integration tests passing (all components)
- [ ] ❌ Monorepo builds with published dependencies
- [ ] ❌ All 7 components at consistent versions
- [ ] ❌ Documentation updated (README, CHANGELOG, PROJECT_STATUS)

#### Should-Have (P1) 📊
- [ ] ⏹️ Performance benchmarks completed
- [ ] ⏹️ Regression analysis (<5% target)
- [ ] ⏹️ All documentation crates.io-ready
- [ ] ⏹️ All tests passing (160+ tests, >95% pass rate)
- [ ] ⏹️ Phase issues closed (#18-#24)

#### Nice-to-Have (P2) 💡
- [ ] ⏹️ Migration guide for users
- [ ] ⏹️ Blog post announcement
- [ ] ⏹️ Community feedback collection plan
- [ ] ⏹️ v0.21.0 roadmap drafted

### Component-Specific Deliverables

#### embeddenator-core
- [ ] Cargo.toml version fix applied
- [ ] Builds successfully with published deps
- [ ] All tests passing
- [ ] README updated with component ecosystem
- [ ] CHANGELOG updated with Phase 3 notes

#### All Component Libraries
- [x] ✅ Published to crates.io (v0.20.0-alpha.1)
- [x] ✅ Security audit passed
- [ ] ⏹️ crates.io pages verified
- [ ] ⏹️ docs.rs building correctly
- [ ] ⏹️ README examples functional

### Documentation Deliverables
- [ ] Integration test report
- [ ] Performance benchmark report
- [ ] Phase 3 completion handoff
- [ ] Updated SPLIT_TRACKER.md (100% complete)
- [ ] Migration guide (if API changes)

---

## Remaining Work Breakdown by Repository

### embeddenator-core (Main Repository)

**Immediate Tasks:**
1. Fix Cargo.toml version mismatch (30 min)
2. Verify build and tests (1 hour)
3. Run integration test suite (4 hours)
4. Update documentation (2 hours)
5. Archive handoff docs (30 min)

**Estimated Effort:** 1 day

**Files to Update:**
- `Cargo.toml` - Fix embeddenator-fs version
- `README.md` - Ensure accuracy
- `CHANGELOG.md` - Add Phase 3 completion
- `PROJECT_STATUS.md` - Update status
- `VERSION_ROADMAP.md` - Mark Phase 3 complete
- `SPLIT_TRACKER.md` - Update to 100%

### Component Libraries (All)

**Verification Tasks per Component:**
1. Verify crates.io page renders correctly
2. Verify docs.rs builds and displays
3. Check README examples work
4. Verify keywords/categories appropriate
5. Monitor for community issues

**Estimated Effort:** 2-3 hours per component (14-21 hours total)

**Could be parallelized** or done post-Phase 3 as P2

### MCP Server Projects

**Status:** No action required - independent projects
**Recommendation:** Document relationship to core in README

---

## Risk Assessment & Mitigation

### High Risk ⚠️

**Risk 1: Timeline Overrun**
- **Probability:** High (currently 3 days behind)
- **Impact:** High (delays release, community expectations)
- **Mitigation:**
  - Parallel execution of remaining tasks
  - Consider minimal viable completion (P0 only)
  - Extend timeline by 3-5 days if needed
  - Move P2 tasks to v0.21.0

**Risk 2: Version Sync Issues**
- **Probability:** Medium (one found, may be more)
- **Impact:** High (blocks builds)
- **Mitigation:**
  - Automated version checker script
  - CI verification of version consistency
  - Document version sync process

**Risk 3: Integration Test Failures**
- **Probability:** Medium (untested integration)
- **Impact:** High (may require component fixes)
- **Mitigation:**
  - Allocate buffer time
  - Have rollback plan (patch versions)
  - Fix forward with 0.20.0-alpha.2 releases

### Medium Risk 📊

**Risk 4: Performance Regressions**
- **Probability:** Low (components tested individually)
- **Impact:** Medium (quality concern, not blocking)
- **Mitigation:**
  - Establish baselines quickly
  - Document any regressions
  - Fix in follow-up releases

**Risk 5: Documentation Incomplete**
- **Probability:** Medium (time pressure)
- **Impact:** Low (can improve iteratively)
- **Mitigation:**
  - Focus on crates.io essentials first
  - Detailed docs can follow in v0.21.0
  - Community can contribute

### Low Risk ✅

**Risk 6: Community Reception**
- **Probability:** Low (alpha release, clear disclaimers)
- **Impact:** Low (expectations managed)
- **Mitigation:**
  - Clear alpha status in all docs
  - Solicit feedback actively
  - Rapid response to issues

---

## Post-Phase 3: v0.21.0 Roadmap

### Immediate Priorities (Next 2 weeks)

1. **Bug Fixes** - Address any issues found in v0.20.0-alpha.1
2. **Performance Optimization** - Address any regressions identified
3. **Documentation Enhancement** - Expand examples, tutorials
4. **Community Engagement** - Respond to feedback, triage issues

### Feature Roadmap (Q1 2026)

#### v0.21.0 (Late January)
- Incremental update improvements
- Enhanced error messages
- Better CLI ergonomics
- Documentation improvements

#### v0.22.0 (February)
- Advanced retrieval algorithms
- Query performance optimizations
- Compression options (zstd/lz4)
- Expanded benchmarks

#### v0.23.0 (March)
- FUSE mount production hardening
- Enhanced monitoring/observability
- ARM64 CI automation (if infrastructure ready)
- Security improvements

### Path to v1.0.0

**Target:** Q2 2026

**Requirements:**
- [ ] API stability guarantee (no breaking changes)
- [ ] Production validation (real-world usage)
- [ ] Comprehensive documentation
- [ ] Performance optimizations complete
- [ ] Security audit (cryptographic properties)
- [ ] Large-scale testing (TB-scale validation)
- [ ] Community feedback incorporated
- [ ] Migration guides complete

---

## Recommendations

### Immediate Actions (Priority Order)

1. **🔴 CRITICAL:** Fix version mismatch in embeddenator-core/Cargo.toml (TODAY)
2. **🔴 CRITICAL:** Verify build with `cargo build --release` (TODAY)
3. **🔴 CRITICAL:** Run integration tests (Jan 16)
4. **🟡 HIGH:** Performance benchmarks (Jan 16, parallel)
5. **🟡 HIGH:** Documentation updates (Jan 16, parallel)
6. **🟡 HIGH:** Monorepo cleanup (Jan 17)
7. **🟢 MEDIUM:** Close phase issues (Jan 17)
8. **🟢 MEDIUM:** Archive handoff docs (Jan 17)

### Timeline Adjustment Recommendation

**Original:** Complete Jan 18, 2026
**Realistic:** Complete Jan 20, 2026 (with P0+P1 tasks)
**Minimal Viable:** Complete Jan 18, 2026 (P0 only)

**Recommended:** Target Jan 20 for quality completion with all P0+P1 tasks

### Resource Allocation

**Critical Path:** Integration testing + version fixes
**Parallel Tracks:**
- Track 1: Testing (QA Tester, Performance Tuner)
- Track 2: Documentation (Documentation Writer)
- Track 3: Cleanup (Rust Implementer)

**Bottleneck:** Integration testing (single-threaded, blocks other work)

### Success Metrics

**Phase 3 Success = All P0 criteria met:**
- [x] Security audit complete ✅
- [ ] Version conflicts resolved ❌
- [ ] Integration tests passing ❌
- [ ] Monorepo builds successfully ❌
- [ ] Documentation updated ❌

**Current:** 1/5 P0 criteria met (20%)
**Target:** 5/5 P0 criteria met by Jan 20

---

## Appendix A: Component Dependency Graph

```
Dependency Levels:

Level 0 (Foundation - No dependencies):
├─ embeddenator-io
├─ embeddenator-obs
└─ embeddenator-vsa

Level 1 (Depends on Level 0):
└─ embeddenator-retrieval (depends: vsa)

Level 2 (Depends on Level 0-1):
└─ embeddenator-fs (depends: vsa, retrieval)

Level 3 (Depends on Level 0-2):
└─ embeddenator-interop (depends: vsa, fs)

Level 4 (Depends on All):
├─ embeddenator-cli (depends: all Level 0-3)
└─ embeddenator-core (depends: all)

Auxiliary:
└─ embeddenator-testkit (depends: vsa, io)
```

---

## Appendix B: Test Coverage Summary

### Current Test Status
- **Total Tests:** 231+ (per CHANGELOG)
- **Pass Rate:** 100% (per VERSION_ROADMAP v1.0.0)
- **Property Checks:** 23,000+ per test run
- **Test Categories:**
  - Balanced ternary: 29 tests ✅
  - Codebook operations: 11 tests ✅
  - VSA operations: 42 tests ✅
  - Error recovery: 19 tests ✅
  - Hierarchical: 5 tests ✅
  - CLI integration: 8 tests ✅
  - E2E workflows: 6 tests ✅
  - Incremental updates: 18 tests ✅
  - SIMD: 16 tests ✅

### Integration Tests (Phase 3) - Not Yet Created
- [ ] Cross-component API tests
- [ ] CLI integration with real components
- [ ] Error recovery across boundaries
- [ ] Memory safety validation
- [ ] Performance regression suite

---

## Appendix C: Architecture Decision Records

**Total ADRs:** 17 (all in docs/adr/)

**Key ADRs for Phase 3:**
- ADR-016: Component Decomposition
- ADR-017: Phase 2A Component Extraction
- ADR-014: Incremental Updates
- ADR-013: Hierarchical Manifest Format
- ADR-012: Reusable Codebook Index

**Status:** All ADRs reviewed and current

---

## Appendix D: Publishing Checklist Template

For each component before v0.21.0 or patch releases:

### Pre-Publish Verification
- [ ] Version bumped in Cargo.toml
- [ ] CHANGELOG.md updated
- [ ] README.md accurate and complete
- [ ] All tests passing: `cargo test`
- [ ] No warnings: `cargo clippy`
- [ ] Formatted: `cargo fmt --check`
- [ ] Docs build: `cargo doc --no-deps`
- [ ] Dry-run succeeds: `cargo publish --dry-run`
- [ ] Git tag created: `git tag v0.x.y`
- [ ] Tag pushed: `git push origin v0.x.y`

### Post-Publish Verification
- [ ] crates.io page renders correctly
- [ ] docs.rs builds and displays
- [ ] Dependent crates can resolve version
- [ ] Examples in README work
- [ ] No immediate issues reported

### Communication
- [ ] Update main repo to new version
- [ ] Announce in discussions (if major)
- [ ] Update component matrix in core README

---

**Document Version:** 1.0
**Next Review:** After Phase 3 completion (target Jan 20, 2026)
**Maintained By:** Integration Review Team
**Contact:** embeddenator-core maintainers
