#!/usr/bin/env bash
set -euo pipefail

# ===== KONFIG =====
KEY_NAME="cic-my-sign-key"
VAULT_PORT=${VAULT_PORT:-18200}
export TOKEN_FILE="$XDG_RUNTIME_DIR/vault/sign-token"
export VAULT_API_ADDR="https://127.0.0.1:$VAULT_PORT"
export VAULT_ADDR="https://127.0.0.1:$VAULT_PORT"
: "${VAULT_SKIP_VERIFY:=1}" && export VAULT_SKIP_VERIFY
umask 077

# Commit message fájl (Git adja paraméterként)
COMMIT_MSG_FILE="$1"

# ===== Vault futás ellenőrzés =====
PIDFILE="$XDG_RUNTIME_DIR/vault/vault.pid"
if [[ ! -f "$PIDFILE" ]]; then
  echo "[!] Vault not running (no PID file: $PIDFILE)"
  exit 1
fi
PID=$(cat "$PIDFILE")
if ! ps -p "$PID" >/dev/null 2>&1; then
  echo "[!] Stale Vault PID ($PID)"
  exit 1
fi
vault status >/dev/null 2>&1 || { echo "[!] Vault not responding"; exit 1; }
export VAULT_TOKEN=$(cat $TOKEN_FILE)

# ===== Staged tartalom snapshot =====
if ! TREE_ID=$(git write-tree 2>/dev/null); then
  echo "[*] Nothing staged; skipping signing."
  exit 0
fi

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

# Kibontjuk, majd determinisztikus tar streamet készítünk
git archive --format=tar "$TREE_ID" | tar -xf - -C "$tmpdir"
DIGEST_B64=$(tar --sort=name --mtime='UTC 1970-01-01' \
  --owner=0 --group=0 --numeric-owner -cf - -C "$tmpdir" . \
  | openssl dgst -sha256 -binary | openssl base64 -A)

# ===== Vault aláírás =====
SIGNATURE=$(vault write -format=json "transit/sign/$KEY_NAME" \
  input="$DIGEST_B64" prehashed=true hash_algorithm=sha2-256 \
  | jq -r '.data.signature')

if [[ -z "${SIGNATURE:-}" || "$SIGNATURE" == "null" ]]; then
  echo "[!] Signing failed."
  exit 1
fi
CERT=$(vault kv get -format=json -mount=$KEY_NAME crt | jq -r '.data.data.bar')

# ===== Tanúsítvány beolvasás =====
if [[ -z "${CERT:-}" || "$CERT" == "null" ]]; then
  echo "[!] CERT get failed."
  exit 1
fi
# ===== Metaadat blokk hozzáfűzése =====
{
  echo ""
  echo "---"
  echo "[signing-metadata]"
  echo "key = $KEY_NAME"
  echo "signature = $SIGNATURE"
  echo "hash-algorithm = sha256"
  echo "digest = $DIGEST_B64"
  echo ""
  echo "[certificate]"
  echo "$CERT"
} >> "$COMMIT_MSG_FILE"

echo "[*] Commit message updated with signing metadata."
