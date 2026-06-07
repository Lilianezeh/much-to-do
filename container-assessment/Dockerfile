# ─── Stage 1: Builder ───────────────────────────────────────────
FROM golang:1.23-alpine AS builder

# Install build dependencies
RUN apk add --no-cache git ca-certificates tzdata

# Set working directory
WORKDIR /app

# Allow newer Go toolchain
ENV GOTOOLCHAIN=auto

# Copy go mod files first for better caching
COPY Server/MuchToDo/go.mod Server/MuchToDo/go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the source code
COPY Server/MuchToDo/ .

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags="-w -s" \
    -o muchtodo \
    ./cmd/api/main.go

# ─── Stage 2: Final Image ───────────────────────────────────────
FROM alpine:3.19

# Install ca-certificates for HTTPS calls
RUN apk --no-cache add ca-certificates tzdata

# Create non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/muchtodo .
# .env removed for CI/CD compatibility

# Set ownership
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD wget -qO- http://localhost:8080/health || exit 1

# Run the binary
CMD ["./muchtodo"]