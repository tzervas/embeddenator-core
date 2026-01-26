# embeddenator-core Status

**Version:** 0.22.0
**crates.io:** [embeddenator-core](https://crates.io/crates/embeddenator-core)
**Last Updated:** 2026-01-26

---

## Overview

Umbrella crate that re-exports all Embeddenator components, providing a unified entrypoint for the holographic computing substrate.

---

## Component Dependencies

| Dependency | Version | Purpose |
|------------|---------|---------|
| embeddenator-vsa | 0.21.0 | Vector Symbolic Architecture primitives |
| embeddenator-io | 0.21.0 | I/O and serialization |
| embeddenator-obs | 0.21.0 | Observability and metrics |
| embeddenator-retrieval | 0.21.0 | Search and retrieval |
| embeddenator-fs | 0.23.0 | Filesystem operations |
| embeddenator-interop | 0.22.0 | FFI and language bindings |
| embeddenator-cli | 0.21.1 | Command-line interface |

---

## Container Images

```bash
# Pull latest
docker pull ghcr.io/tzervas/embeddenator-core:latest

# Pull specific version
docker pull ghcr.io/tzervas/embeddenator-core:0.22.0

# Run
docker run --rm ghcr.io/tzervas/embeddenator-core:latest --help
```

**Available Tags:**
- `0.22.0` - Current release
- `0.22.0-amd64` - AMD64 specific
- `latest` - Latest release
- `latest-amd64` - Latest AMD64 specific

---

## Features

| Feature | Default | Description |
|---------|---------|-------------|
| `fuse` | No | FUSE filesystem support |
| `simd` | No | SIMD optimizations |
| `qa` | No | QA test suite |
| `bt-migration` | No | Balanced ternary migration tests |

---

## Breaking Changes (v0.22.0)

**Package Renamed:** `embeddenator` → `embeddenator-core`

```toml
# Before
[dependencies]
embeddenator = "0.21"

# After
[dependencies]
embeddenator-core = "0.22"
```

```rust
// Rust imports unchanged - lib name is still "embeddenator"
use embeddenator::prelude::*;
```

---

## Remaining Tasks

- [ ] Sync version with component crates
- [ ] Add prelude module for common imports
- [ ] Document feature flag combinations
- [ ] ARM64 container image (requires native runner)

---

## Links

- **Documentation:** https://docs.rs/embeddenator-core
- **Repository:** https://github.com/tzervas/embeddenator-core
- **Changelog:** [CHANGELOG.md](./CHANGELOG.md)
