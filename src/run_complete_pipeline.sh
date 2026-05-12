#!/bin/bash

# STAR-Fusion Complete Pipeline Script
# Run this script INSIDE the Docker container
# Usage: bash run_complete_pipeline.sh

set -e  # Exit on error

echo "=========================================="
echo "STAR-Fusion Complete Pipeline"
echo "=========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "minigenome.fa" ]; then
    echo "Error: Cannot find minigenome.fa"
    echo "Are you in the STAR-Fusion-Tutorial directory?"
    echo "Run: cd /data/STAR-Fusion-Tutorial"
    exit 1
fi

# Check if STAR_FUSION_HOME is set
if [ -z "$STAR_FUSION_HOME" ]; then
    echo "Error: STAR_FUSION_HOME is not set"
    echo "Are you running inside the Docker container?"
    exit 1
fi

echo "✓ Environment check passed"
echo ""

# Ask user if they want to build genome lib or use existing
if [ -d "ctat_genome_lib_build_dir" ]; then
    echo "Found existing genome library directory."
    read -p "Do you want to rebuild it? This takes ~45 minutes (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        BUILD_LIB=true
    else
        BUILD_LIB=false
        echo "Using existing genome library"
    fi
else
    BUILD_LIB=true
fi

echo ""

# Phase 1: Build CTAT Genome Library
if [ "$BUILD_LIB" = true ]; then
    echo "=========================================="
    echo "Phase 1: Building CTAT Genome Library"
    echo "Duration: ~45 minutes"
    echo "=========================================="
    echo ""

    START_TIME=$(date +%s)

    ${STAR_FUSION_HOME}/ctat-genome-lib-builder/prep_genome_lib.pl \
        --genome_fa minigenome.fa \
        --gtf minigenome.gtf \
        --fusion_annot_lib CTAT_HumanFusionLib.mini.dat.gz \
        --dfam_db human \
        --pfam_db current

    END_TIME=$(date +%s)
    ELAPSED=$((END_TIME - START_TIME))
    echo ""
    echo "✓ Genome library built in $ELAPSED seconds"
else
    echo "=========================================="
    echo "Phase 1: Skipping genome library build"
    echo "=========================================="
fi

echo ""

# Phase 2: Run Complete STAR-Fusion Analysis
echo "=========================================="
echo "Phase 2: Running Complete STAR-Fusion Analysis"
echo "Duration: ~15 minutes"
echo "=========================================="
echo ""
echo "This includes:"
echo "  - Fusion detection (STAR-Fusion)"
echo "  - Validation (FusionInspector)"
echo "  - De novo reconstruction (Trinity)"
echo "  - Coding effect analysis"
echo ""

START_TIME=$(date +%s)

${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir \
    --FusionInspector validate \
    --denovo_reconstruct \
    --examine_coding_effect

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

echo ""
echo "✓ Analysis completed in $ELAPSED seconds"
echo ""

# Phase 3: Summarize Results
echo "=========================================="
echo "Phase 3: Results Summary"
echo "=========================================="
echo ""

# Count fusions
if [ -f "STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv" ]; then
    FUSION_COUNT=$(tail -n +2 STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv | wc -l)
    echo "Total fusions detected: $FUSION_COUNT"
    echo ""

    echo "Top 5 fusions by read support:"
    echo "--------------------------------"
    head -6 STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv | cut -f1,2,3
    echo ""

    echo "Known cancer fusions:"
    echo "--------------------------------"
    grep -i "cosmic\|mitelman" STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv | cut -f1 || echo "None found"
    echo ""
fi

# Check for coding effect results
if [ -f "STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.coding_effect.tsv" ]; then
    INFRAME_COUNT=$(grep -c "INFRAME" STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.coding_effect.tsv || echo "0")
    echo "In-frame fusions: $INFRAME_COUNT"
    echo ""
fi

# List output files
echo "Output Files Generated:"
echo "--------------------------------"
echo "Main Results:"
echo "  STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv"
echo "  STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.coding_effect.tsv"
echo ""
echo "FusionInspector Results:"
echo "  STAR-Fusion_outdir/FusionInspector-validate/finspector.fusion_predictions.final.abridged.FFPM.annotated"
echo "  STAR-Fusion_outdir/FusionInspector-validate/finspector.consolidated.bam"
echo "  STAR-Fusion_outdir/FusionInspector-validate/finspector.bed"
echo ""
echo "Trinity Results:"
echo "  STAR-Fusion_outdir/FusionInspector-validate/finspector.gmap_trinity_GG.fusions.fasta"
echo ""

echo "=========================================="
echo "Pipeline Complete!"
echo "=========================================="
echo ""
echo "Next Steps:"
echo "  1. Review fusion predictions in STAR-Fusion_outdir/"
echo "  2. Open IGV to visualize fusion evidence"
echo "  3. Examine coding effects in the coding_effect.tsv file"
echo ""
echo "To view detailed fusion information:"
echo "  less STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv"
echo ""
echo "To view fusion transcripts:"
echo "  less STAR-Fusion_outdir/FusionInspector-validate/finspector.gmap_trinity_GG.fusions.fasta"
echo ""
