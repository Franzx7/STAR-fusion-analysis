# STAR-Fusion Tutorial - Structured Plan of Action

## Overview
This plan guides you through running STAR-Fusion on example RNA-seq data to identify fusion transcripts in cancer samples. The tutorial uses a mini-genome dataset that requires minimal computational resources (4GB RAM).

## Prerequisites

### System Requirements
- **RAM**: Minimum 4GB
- **OS**: macOS (current system)
- **Time**: ~1 hour total (excluding genome lib building which takes ~45 min)

### Software Requirements
You have two options:

#### Option 1: Docker (RECOMMENDED - Easiest)
- Install Docker Desktop for Mac
- All tools are pre-installed in the container
- Image: `trinityctat/starfusion:latest`

#### Option 2: Manual Installation (Advanced)
Install the following:
- STAR-Fusion
- STAR aligner
- Trinity
- GMAP
- NCBI BLAST+
- Dependencies: samtools, jellyfish, salmon, etc.

**Recommendation**: Use Docker to avoid complex dependency management

---

## Phase 1: Setup and Data Acquisition

### Step 1.1: Clone Tutorial Repository
```bash
cd ~/Projects/STAR_Fusion_Tutorial
git clone https://github.com/STAR-Fusion/STAR-Fusion-Tutorial.git
cd STAR-Fusion-Tutorial
```

**Expected Output**: Directory containing:
- `minigenome.fa` - Small genome sequence (~750 genes)
- `minigenome.gtf` - Transcript structure annotations
- `rnaseq_1.fastq.gz` - RNA-Seq read 1 data (left)
- `rnaseq_2.fastq.gz` - RNA-Seq read 2 data (right)
- `CTAT_HumanFusionLib.mini.dat.gz` - Fusion annotation library

**Status**: ⬜ Not Started

---

### Step 1.2: Set Up Docker Environment (if using Docker)
```bash
docker pull trinityctat/starfusion:latest

# Run Docker container with current directory mounted
docker run --rm -it -v $(pwd):/data -v /tmp:/tmp trinityctat/starfusion:latest bash

# Inside container, navigate to data
cd /data/STAR-Fusion-Tutorial
```

**Expected Output**: Shell prompt inside Docker container with access to tutorial data

**Status**: ⬜ Not Started

---

## Phase 2: Build CTAT Genome Library

### Step 2.1: Prepare Custom Genome Library
This creates a reference package containing genome, annotations, and metadata for fusion-finding.

```bash
# Inside Docker (or if installed locally, set STAR_FUSION_HOME first)
${STAR_FUSION_HOME}/ctat-genome-lib-builder/prep_genome_lib.pl \
    --genome_fa minigenome.fa \
    --gtf minigenome.gtf \
    --fusion_annot_lib CTAT_HumanFusionLib.mini.dat.gz \
    --dfam_db human \
    --pfam_db current
```

**Duration**: ~45 minutes
**Expected Output**: `ctat_genome_lib_build_dir/` directory with:
- Reference genome indices
- BLAST databases
- Supporting metadata files

**Status**: ⬜ Not Started

**⚠️ Important Note**: This mini genome lib is ONLY for tutorial purposes. For real data, use pre-compiled full genome libs.

---

## Phase 3: Fusion Detection with STAR-Fusion

### Step 3.1: Run Basic STAR-Fusion
Identify fusion transcripts based on discordant read alignments.

```bash
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir
```

**Duration**: ~2 minutes
**Expected Output**: `STAR-Fusion_outdir/` containing:
- `star-fusion.fusion_predictions.tsv` - Full fusion predictions
- `star-fusion.fusion_predictions.abridged.tsv` - Shortened version

**Status**: ⬜ Not Started

---

### Step 3.2: Review Fusion Predictions
```bash
# View top fusion predictions
head STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv
```

**Expected Fusions** (examples from tutorial):
- TATDN1--GSDMB
- ACACA--STAC2
- CCDC6--RET (known cancer fusion)
- BCAS4--BCAS3
- RPS6KB1--SNF8

**Key Columns**:
- FusionName: Gene pairs involved
- JunctionReadCount: Split reads supporting fusion
- SpanningFragCount: Spanning reads supporting fusion
- annots: Known annotations (cancer databases, etc.)

**Status**: ⬜ Not Started

---

## Phase 4: In Silico Validation with FusionInspector

### Step 4.1: Run FusionInspector in Validate Mode
Performs refined analysis by realigning reads to fusion contigs.

```bash
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir \
    --FusionInspector validate
```

**Duration**: ~10 minutes
**Expected Output**: `STAR-Fusion_outdir/FusionInspector-validate/` containing:
- `finspector.fusion_predictions.final` - Validated fusions
- `finspector.fusion_predictions.final.abridged.FFPM.annotated` - Abridged version
- `finspector.bed` - Transcript annotations for IGV
- `finspector.consolidated.bam` - Aligned reads (for IGV)
- `finspector.junction_reads.bam` - Junction reads (for IGV)
- `finspector.spanning_reads.bam` - Spanning reads (for IGV)

**Status**: ⬜ Not Started

---

### Step 4.2: Visualize Results in IGV (Optional)
```bash
# Download IGV from: https://software.broadinstitute.org/software/igv/download
# Load these files:
# 1. finspector.bed
# 2. finspector.consolidated.bam
# 3. finspector.junction_reads.bam
# 4. finspector.spanning_reads.bam
```

**Purpose**: Visual inspection of fusion evidence at nucleotide level

**Status**: ⬜ Not Started

---

## Phase 5: De Novo Transcript Reconstruction

### Step 5.1: Reconstruct Fusion Transcripts with Trinity
```bash
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir \
    --FusionInspector validate \
    --denovo_reconstruct
```

**Duration**: ~5 minutes
**Expected Output**: Additional files in `FusionInspector-validate/`:
- `finspector.gmap_trinity_GG.fusions.fasta` - De novo fusion transcripts
- `finspector.gmap_trinity_GG.fusions.gff3.bed` - Fusion transcript structures (for IGV)

**Status**: ⬜ Not Started

---

## Phase 6: Coding Effect Analysis

### Step 6.1: Examine Impact on Coding Regions
Determines if fusions are in-frame or frame-shifted and predicts protein domains.

```bash
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir \
    --examine_coding_effect
```

**Duration**: ~1 minute
**Expected Output**: 
- `STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.coding_effect.tsv`

**Additional Columns**:
- PROT_FUSION_TYPE: INFRAME vs FRAMESHIFT
- FUSION_CDS: Coding sequence of fusion
- FUSION_TRANSL: Translated protein sequence
- PFAM_LEFT/RIGHT: Protein domains retained in fusion

**Status**: ⬜ Not Started

---

## Phase 7: Complete Pipeline (All-in-One)

### Step 7.1: Run Complete Analysis in Single Command
Instead of running steps separately, execute everything at once:

```bash
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir \
    --FusionInspector validate \
    --denovo_reconstruct \
    --examine_coding_effect
```

**Duration**: ~15 minutes total
**Expected Output**: All outputs from Phases 3-6 in one run

**Status**: ⬜ Not Started

---

## Phase 8: Results Analysis and Interpretation

### Step 8.1: Summarize Key Findings
```bash
# Count total fusions detected
wc -l STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv

# Check for known cancer fusions
grep -i "cancer\|cosmic\|mitelman" STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv

# Identify in-frame fusions (potentially functional)
grep "INFRAME" STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.coding_effect.tsv
```

**Status**: ⬜ Not Started

---

## Quick Reference: Key Commands Summary

### Complete Workflow (Recommended)
```bash
# 1. Setup
cd ~/Projects/STAR_Fusion_Tutorial
git clone https://github.com/STAR-Fusion/STAR-Fusion-Tutorial.git
cd STAR-Fusion-Tutorial

# 2. Docker
docker run --rm -it -v $(pwd):/data -v /tmp:/tmp trinityctat/starfusion:latest bash
cd /data/STAR-Fusion-Tutorial

# 3. Build genome lib
${STAR_FUSION_HOME}/ctat-genome-lib-builder/prep_genome_lib.pl \
    --genome_fa minigenome.fa \
    --gtf minigenome.gtf \
    --fusion_annot_lib CTAT_HumanFusionLib.mini.dat.gz \
    --dfam_db human \
    --pfam_db current

# 4. Run complete analysis
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir \
    --FusionInspector validate \
    --denovo_reconstruct \
    --examine_coding_effect
```

---

## Expected Timeline

| Phase | Task | Duration |
|-------|------|----------|
| 1 | Setup & Data Download | 5 min |
| 2 | Build Genome Library | 45 min |
| 3 | STAR-Fusion Detection | 2 min |
| 4 | FusionInspector Validation | 10 min |
| 5 | Trinity Reconstruction | 5 min |
| 6 | Coding Effect Analysis | 1 min |
| 7 | Complete Pipeline (alternative) | 15 min |
| 8 | Results Analysis | 10 min |
| **TOTAL** | | **~1 hour 20 min** |

---

## Troubleshooting

### Issue: Docker not installed
**Solution**: Install Docker Desktop for Mac from https://www.docker.com/products/docker-desktop

### Issue: Out of memory
**Solution**: Increase Docker memory allocation in Docker Desktop settings (minimum 4GB)

### Issue: Permission denied
**Solution**: Ensure Docker volume mounting has proper permissions

### Issue: STAR_FUSION_HOME not set (non-Docker)
**Solution**: 
```bash
export STAR_FUSION_HOME=/path/to/STAR-Fusion
```

---

## Next Steps After Tutorial

1. **Apply to Real Data**: Use pre-compiled full CTAT genome libs
2. **Explore Documentation**: https://github.com/STAR-Fusion/STAR-Fusion/wiki
3. **Join Community**: Trinity CTAT Google Forum
4. **Learn More**: 
   - FusionInspector documentation
   - STAR aligner documentation
   - Trinity de novo assembly

---

## Progress Tracking

Update status indicators (⬜ → ⏳ → ✅) as you complete each phase:
- ⬜ Not Started
- ⏳ In Progress
- ✅ Completed
- ❌ Failed/Blocked

---

## Notes and Observations

_Use this section to record your findings, questions, or issues encountered during the tutorial_

---

**Last Updated**: Ready to begin
**Contact**: For issues, consult STAR-Fusion GitHub issues or Trinity CTAT Google Forum
