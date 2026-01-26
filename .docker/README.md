# Docker CI Strategy

Docker images for Embeddenator CI builds and deployments.

##  Images

### `ghcr.io/tzervas/embeddenator`

Multi-arch container with Embeddenator binary.

**Architectures:**
- `linux/amd64`
- `linux/arm64`

**Base:** Alpine Linux 3.19 (minimal footprint)

##  Usage

### Pull Image

```bash
# Latest version
docker pull ghcr.io/tzervas/embeddenator:latest

# Specific version
docker pull ghcr.io/tzervas/embeddenator:v0.20.0

# Architecture-specific
docker pull ghcr.io/tzervas/embeddenator:v0.20.0-amd64
docker pull ghcr.io/tzervas/embeddenator:v0.20.0-arm64
```

### Run Container

```bash
# Help
docker run --rm ghcr.io/tzervas/embeddenator:latest --help

# Mount data directory
docker run --rm -v $(pwd)/data:/data ghcr.io/tzervas/embeddenator:latest <command>

# Interactive shell
docker run --rm -it --entrypoint /bin/sh ghcr.io/tzervas/embeddenator:latest
```

##  Building Locally

### Build for Current Architecture

```bash
docker build -f .docker/Dockerfile.embr-ci -t embeddenator:local .
```

### Build Multi-Arch

```bash
# Create builder
docker buildx create --name embr-builder --use

# Build and push
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -f .docker/Dockerfile.embr-ci \
  -t ghcr.io/tzervas/embeddenator:dev \
  --push \
  .
```

##  Manifest Generation

Generate multi-arch manifest list:

```bash
# Generate manifest
python .docker/generate_manifest.py --version v0.20.0

# Dry run
python .docker/generate_manifest.py --version v0.20.0 --dry-run
```

##  Security

### GHCR Authentication

```bash
# Login to GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

### Trivy Scanning

Automatic vulnerability scanning runs on every build:

```bash
# Manual scan
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image ghcr.io/tzervas/embeddenator:latest
```

##  .dockerignore

Excludes from build context:
-  Secrets and credentials
-  Build artifacts (target/, *.embr)
-  Development files (.vscode/, docs/)
-  Large datasets
-  Git history

See [.dockerignore](.dockerignore) for full list.

## 🏷️ Tagging Strategy

**Version Tags:**
- `v0.20.0` - Specific release
- `v0.20.0-amd64` - Architecture-specific
- `v0.20.0-arm64` - Architecture-specific
- `latest` - Latest stable release

**Branch Tags:**
- `main` - Latest commit on main
- `develop` - Latest commit on develop

## 🤖 CI/CD

Automated builds triggered by:
- Git tags (`v*`)
- Manual workflow dispatch

See [docker-build.yml](../.github/workflows/docker-build.yml)

##  Directory Structure

```
.docker/
├── Dockerfile.embr-ci     # Multi-stage build
├── .dockerignore          # Context exclusions
├── generate_manifest.py   # Manifest generator
└── README.md              # This file
```

##  Image Layers

```
Stage 1: deps          # Cargo dependencies (cached)
Stage 2: builder       # Source build
Stage 3: runtime       # Minimal Alpine + binary
```

**Final Image Size:** ~15MB (Alpine + stripped binary)

## 🏃 Homelab Deployment

For self-hosted runners:

```bash
# Build on homelab server
docker build -f .docker/Dockerfile.embr-ci -t embeddenator:homelab .

# Run with specific resources
docker run --rm \
  --cpus=2 \
  --memory=4g \
  -v /data/embeddenator:/data \
  embeddenator:homelab <command>
```

##  Notes

- **Non-root:** Container runs as user `embr` (UID 1000)
- **Health Check:** Validates binary with `--version`
- **FUSE Support:** fuse3 included in runtime image
- **Static Binary:** musl-based for portability

## 🆘 Troubleshooting

**Build fails with cache errors:**
```bash
docker buildx prune -af
```

**Permission denied:**
```bash
# Ensure user matches container UID
docker run --rm --user $(id -u):$(id -g) ...
```

**Manifest push fails:**
```bash
# Re-authenticate
docker logout ghcr.io
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
```

##  References

- [Dockerfile.embr-ci](Dockerfile.embr-ci) - Build configuration
- [generate_manifest.py](generate_manifest.py) - Manifest script
- [GitHub Packages Docs](https://docs.github.com/en/packages)
