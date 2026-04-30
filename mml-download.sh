#!/bin/bash
# mml-download.sh
#
# Downloads, verifies, and extracts MML dataset shards from the web.
#
# Usage:
#   bash mml-download.sh <split> [modality] [n_shards]
#
# Examples:
#   bash mml-download.sh train                   # all modalities for train
#   bash mml-download.sh index ground            # all ground shards for index
#   bash mml-download.sh train satellite 200     # explicit count
#
# Arguments:
#   split     — train | index | query
#   modality  — ground | satellite | text  (optional; default: all for split)
#   n_shards  — total number of shards     (optional; default: from built-in table)
#
# Run from the directory where you want the data to land.
# Files are extracted into ./<modality>/h1/h2/h3/<hash>.<ext>
# Tars & md5sum are deleted after successful extraction.

set -uo pipefail

# ── Config ────────────────────────────────────────────────────────────────────

BASE_URL="https://archive.compute.dtu.dk/downloads/public/projects/MMLandmarks"

# Number of shards to download+verify+extract in parallel.
NUM_PROC=6

# Shard counts: SHARDS_<SPLIT>_<MODALITY>=N
SHARDS_train_ground=80
SHARDS_train_satellite=200
SHARDS_train_text=1
SHARDS_index_ground=80
SHARDS_index_satellite=120
SHARDS_query_ground=4
SHARDS_query_satellite=10
SHARDS_query_text=1

# Modalities per split (space-separated)
MODALITIES_train="ground satellite text"
MODALITIES_index="ground satellite"
MODALITIES_query="ground satellite text"

# ── Args ──────────────────────────────────────────────────────────────────────

if [[ $# -lt 1 ]]; then
    echo "Usage: bash $0 <split> [modality] [n_shards]"
    echo "  split:    train | index | query"
    echo "  modality: ground | satellite | text  (default: all for split)"
    echo "  n_shards: total number of shards     (default: from built-in table)"
    exit 1
fi

SPLIT="$1"

# Validate split
modalities_var="MODALITIES_${SPLIT}"
if [[ -z "${!modalities_var+x}" ]]; then
    echo "ERROR: unknown split '${SPLIT}'. Must be train | index | query."
    exit 1
fi
ALL_MODALITIES="${!modalities_var}"

# Build list of (modality, n_shards) pairs to process
declare -a JOBS_MODALITY=()
declare -a JOBS_NSHARDS=()

if [[ $# -ge 2 ]]; then
    MODALITY="$2"
    if [[ $# -ge 3 ]]; then
        N_SHARDS="$3"
    else
        key="SHARDS_${SPLIT}_${MODALITY}"
        if [[ -z "${!key+x}" ]]; then
            echo "ERROR: no shard count for ${SPLIT}/${MODALITY}. Provide n_shards explicitly."
            exit 1
        fi
        N_SHARDS="${!key}"
    fi
    JOBS_MODALITY=("$MODALITY")
    JOBS_NSHARDS=("$N_SHARDS")
else
    for mod in $ALL_MODALITIES; do
        key="SHARDS_${SPLIT}_${mod}"
        JOBS_MODALITY+=("$mod")
        JOBS_NSHARDS+=("${!key}")
    done
fi

# ── Worker ────────────────────────────────────────────────────────────────────

download_verify_and_extract() {
    local modality="$1"
    local i="$2"
    local dest="$3"
    local shard_url="$4"
    local tar_name="images_${i}.tar"
    local md5_name="md5.images_${i}.txt"
    local tar_path="${dest}/${tar_name}"
    local md5_path="${dest}/${md5_name}"

    echo "[${modality}] Downloading ${tar_name}..."
    if ! curl -fsSL -o "$tar_path" "${shard_url}/${tar_name}"; then
        echo "ERROR: failed to download ${shard_url}/${tar_name}"
        return 1
    fi
    if ! curl -fsSL -o "$md5_path" "${shard_url}/${md5_name}"; then
        echo "ERROR: failed to download ${shard_url}/${md5_name}"
        return 1
    fi

    local md5_computed md5_expected
    md5_computed=$(md5sum "$tar_path" | cut -d' ' -f1)
    md5_expected=$(cut -d' ' -f1 < "$md5_path")

    if [[ "$md5_computed" == "$md5_expected" ]]; then
        tar -xf "$tar_path" -C "$dest"
        rm "$tar_path" "$md5_path"
        echo "[${modality}] ${tar_name} — OK (extracted, tar removed)"
    else
        echo "ERROR: MD5 mismatch for ${tar_name}"
        echo "  computed: $md5_computed"
        echo "  expected: $md5_expected"
        return 1
    fi
}

# ── Main ──────────────────────────────────────────────────────────────────────

for idx in "${!JOBS_MODALITY[@]}"; do
    MODALITY="${JOBS_MODALITY[$idx]}"
    N_SHARDS="${JOBS_NSHARDS[$idx]}"
    N=$(( N_SHARDS - 1 ))
    SHARD_URL="${BASE_URL}/${SPLIT}/${MODALITY}"
    DEST="./${MODALITY}"

    mkdir -p "$DEST"

    echo "Downloading ${N_SHARDS} shards: ${SPLIT}/${MODALITY}"
    echo "  Source : ${SHARD_URL}"
    echo "  Dest   : ${DEST}"
    echo ""

    for i in $(seq 0 "$NUM_PROC" "$N"); do
        upper=$(( i + NUM_PROC - 1 ))
        limit=$(( upper > N ? N : upper ))
        for j in $(seq -f "%03g" "$i" "$limit"); do
            download_verify_and_extract "$MODALITY" "$j" "$DEST" "$SHARD_URL" &
        done
        wait
    done

    echo "Done: ${SPLIT}/${MODALITY} → ${DEST}/"
    echo ""
done
