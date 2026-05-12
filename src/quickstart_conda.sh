#!/bin/bash

# STAR-Fusion Tutorial - Conda Setup Quick Start
# This script is for users with conda/mamba installation (no Docker needed!)

set -e  # Exit on error

echo "=========================================="
echo "STAR-Fusion Tutorial - Conda Setup"
echo "=========================================="
echo ""

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if conda environment exists
echo -e "${YELLOW}Checking conda environment...${NC}"
if conda env list | grep -q "rna_fusion_analysis"; then
    echo -e "${GREEN}✓ Found conda environment: rna_fusion_analysis${NC}"
else
    echo -e "${RED}✗ Environment 'rna_fusion_analysis' not found!${NC}"
    echo ""
    echo "Please create it first:"
    echo "  conda create -n rna_fusion_analysis -c bioconda -c conda-forge star-fusion"
    exit 1
fi

echo ""
echo -e "${BLUE}Activating environment...${NC}"

# Source conda
if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
    source "$HOME/miniforge3/etc/profile.d/conda.sh"
elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/miniconda3/etc/profile.d/conda.sh"
elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
    source "$HOME/anaconda3/etc/profile.d/conda.sh"
else
    echo -e "${RED}Cannot find conda installation!${NC}"
    exit 1
fi

conda activate rna_fusion_analysis

echo -e "${GREEN}✓ Environment activated${NC}"
echo ""

# Verify tools
echo -e "${YELLOW}Verifying required tools...${NC}"

TOOLS=("STAR-Fusion" "STAR" "Trinity" "gmap" "blastn" "samtools")
ALL_OK=true

for tool in "${TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
        echo -e "${GREEN}✓ $tool found${NC}"
    else
        echo -e "${RED}✗ $tool not found${NC}"
        ALL_OK=false
    fi
done

if [ "$ALL_OK" = false ]; then
    echo ""
    echo -e "${RED}Some tools are missing!${NC}"
    echo "Please reinstall the environment."
    exit 1
fi

echo ""
echo -e "${GREEN}✓ All required tools verified${NC}"
echo ""

# Check if tutorial data exists
echo "=========================================="
echo "Tutorial Data Setup"
echo "=========================================="
echo ""

if [ -d "STAR-Fusion-Tutorial" ]; then
    echo -e "${YELLOW}Tutorial data directory already exists.${NC}"
    read -p "Do you want to re-download it? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf STAR-Fusion-Tutorial
        git clone https://github.com/STAR-Fusion/STAR-Fusion-Tutorial.git
    fi
else
    echo "Cloning tutorial repository..."
    git clone https://github.com/STAR-Fusion/STAR-Fusion-Tutorial.git
fi

cd STAR-Fusion-Tutorial

echo -e "${GREEN}✓ Tutorial data ready${NC}"
echo ""

# Verify data files
echo "Verifying tutorial data files..."
required_files=("minigenome.fa" "minigenome.gtf" "rnaseq_1.fastq.gz" "rnaseq_2.fastq.gz" "CTAT_HumanFusionLib.mini.dat.gz")
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ Found: $file${NC}"
    else
        echo -e "${RED}✗ Missing: $file${NC}"
    fi
done

echo ""
echo "=========================================="
echo "Ready to Run!"
echo "=========================================="
echo ""
echo -e "${BLUE}You have two options:${NC}"
echo ""
echo "Option 1: Run Complete Pipeline Automatically"
echo "  This will build the genome library and run the full analysis"
echo ""
echo "Option 2: Run Steps Manually"
echo "  Follow commands step-by-step to understand each component"
echo ""

read -p "Do you want to run the complete pipeline now? (y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "=========================================="
    echo "Running Complete Pipeline"
    echo "=========================================="
    echo ""

    # Check if genome library exists
    if [ -d "ctat_genome_lib_build_dir" ]; then
        echo -e "${YELLOW}Genome library already exists. Skipping build...${NC}"
    else
        echo -e "${BLUE}Step 1: Building CTAT Genome Library (~45 minutes)${NC}"
        echo "This is the longest step - grab a coffee!"
        echo ""

        START_TIME=$(date +%s)

        prep_genome_lib.pl \
            --genome_fa minigenome.fa \
            --gtf minigenome.gtf \
            --fusion_annot_lib CTAT_HumanFusionLib.mini.dat.gz \
            --dfam_db human \
            --pfam_db current

        END_TIME=$(date +%s)
        ELAPSED=$((END_TIME - START_TIME))
        echo ""
        echo -e "${GREEN}✓ Genome library built in $ELAPSED seconds${NC}"
    fi

    echo ""
    echo -e "${BLUE}Step 2: Running STAR-Fusion Complete Analysis (~15 minutes)${NC}"
    echo ""

    START_TIME=$(date +%s)

    STAR-Fusion \
        --left_fq rnaseq_1.fastq.gz \
        --right_fq rnaseq_2.fastq.gz \
        --genome_lib_dir ctat_genome_lib_build_dir \
        --FusionInspector validate \
        --denovo_reconstruct \
        --examine_coding_effect \
        --CPU 4

    END_TIME=$(date +%s)
    ELAPSED=$((END_TIME - START_TIME))

    echo ""
    echo -e "${GREEN}✓ Analysis completed in $ELAPSED seconds${NC}"
    echo ""

    # Summarize results
    echo "=========================================="
    echo "Results Summary"
    echo "=========================================="
    echo ""

    if [ -f "STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv" ]; then
        FUSION_COUNT=$(tail -n +2 STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv | wc -l)
        echo -e "${GREEN}Total fusions detected: $FUSION_COUNT${NC}"
        echo ""

        echo "Top 5 fusions:"
        echo "--------------------------------"
        head -6 STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv | cut -f1,2,3
        echo ""

        if grep -q -i "CCDC6--RET" STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv; then
            echo -e "${GREEN}✓ Found CCDC6--RET (known cancer fusion!)${NC}"
        fi

        echo ""
        echo "Output files:"
        echo "  - STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv"
        echo "  - STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.coding_effect.tsv"
        echo "  - STAR-Fusion_outdir/FusionInspector-validate/finspector.fusion_predictions.final.abridged.FFPM.annotated"
    fi

    echo ""
    echo "=========================================="
    echo "Tutorial Complete!"
    echo "=========================================="
    echo ""
    echo "Next steps:"
    echo "  1. Review results: less STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv"
    echo "  2. Check coding effects: less STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.coding_effect.tsv"
    echo "  3. Visualize in IGV (load BAM files from FusionInspector-validate/)"
    echo ""

else
    echo ""
    echo "Manual mode selected."
    echo ""
    echo "To run commands manually, see:"
    echo "  - CONDA_SETUP.md for conda-specific commands"
    echo "  - COMMANDS.md for command reference"
    echo "  - PLAN.md for step-by-step tutorial"
    echo ""
    echo "Quick start commands:"
    echo ""
    echo "# Build genome library:"
    echo "prep_genome_lib.pl \\"
    echo "    --genome_fa minigenome.fa \\"
    echo "    --gtf minigenome.gtf \\"
    echo "    --fusion_annot_lib CTAT_HumanFusionLib.mini.dat.gz \\"
    echo "    --dfam_db human \\"
    echo "    --pfam_db current"
    echo ""
    echo "# Run STAR-Fusion:"
    echo "STAR-Fusion \\"
    echo "    --left_fq rnaseq_1.fastq.gz \\"
    echo "    --right_fq rnaseq_2.fastq.gz \\"
    echo "    --genome_lib_dir ctat_genome_lib_build_dir \\"
    echo "    --FusionInspector validate \\"
    echo "    --denovo_reconstruct \\"
    echo "    --examine_coding_effect"
    echo ""
fi

echo ""
echo -e "${GREEN}Environment 'rna_fusion_analysis' is still active.${NC}"
echo "To deactivate: conda deactivate"
echo ""
