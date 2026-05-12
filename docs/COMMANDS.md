# STAR-Fusion Command Cheat Sheet

Quick reference for common commands used in the STAR-Fusion tutorial.

## 📦 Initial Setup (Run Once)

```bash
# Navigate to project directory
cd ~/Projects/STAR_Fusion_Tutorial

# Run quick start script
chmod +x quickstart.sh
./quickstart.sh
```

## 🐳 Docker Commands

### Start Docker Container
```bash
cd ~/Projects/STAR_Fusion_Tutorial/STAR-Fusion-Tutorial
docker run --rm -it -v $(pwd):/data -v /tmp:/tmp trinityctat/starfusion:latest bash
```

### Alternative: Docker with More Memory
```bash
docker run --rm -it -v $(pwd):/data -v /tmp:/tmp --memory=8g trinityctat/starfusion:latest bash
```

### Exit Docker
```bash
exit
# or press Ctrl+D
```

## 🔧 Building Genome Library (Inside Docker)

```bash
# Navigate to data directory
cd /data/STAR-Fusion-Tutorial

# Build genome library (~45 minutes)
${STAR_FUSION_HOME}/ctat-genome-lib-builder/prep_genome_lib.pl \
    --genome_fa minigenome.fa \
    --gtf minigenome.gtf \
    --fusion_annot_lib CTAT_HumanFusionLib.mini.dat.gz \
    --dfam_db human \
    --pfam_db current
```

## 🔍 Running STAR-Fusion

### Basic Fusion Detection
```bash
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir
```

### With FusionInspector Validation
```bash
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir \
    --FusionInspector validate
```

### With Trinity Reconstruction
```bash
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir \
    --FusionInspector validate \
    --denovo_reconstruct
```

### With Coding Effect Analysis
```bash
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir \
    --examine_coding_effect
```

### Complete Pipeline (All Features)
```bash
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir \
    --FusionInspector validate \
    --denovo_reconstruct \
    --examine_coding_effect
```

## 📊 Viewing Results

### View Fusion Predictions
```bash
# View abridged results (easier to read)
less STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv

# View first 10 fusions
head -n 11 STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv

# View specific columns (fusion name, junction reads, spanning reads)
cut -f1,2,3 STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv | head -20
```

### Count Fusions
```bash
# Count total fusions (subtract 1 for header)
wc -l STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv

# Count without header
tail -n +2 STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv | wc -l
```

### Search for Specific Fusions
```bash
# Search for specific gene
grep "CCDC6" STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv

# Search for known cancer fusions
grep -i "cosmic\|mitelman" STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv

# Find in-frame fusions
grep "INFRAME" STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.coding_effect.tsv
```

### View Coding Effects
```bash
# View all coding effect predictions
less STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.coding_effect.tsv

# View just fusion names and protein fusion types
cut -f1,20 STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.coding_effect.tsv | head
```

### View FusionInspector Results
```bash
# View validated fusions
less STAR-Fusion_outdir/FusionInspector-validate/finspector.fusion_predictions.final.abridged.FFPM.annotated

# View reconstructed fusion transcripts
less STAR-Fusion_outdir/FusionInspector-validate/finspector.gmap_trinity_GG.fusions.fasta
```

## 🔎 Analyzing Results

### Get Fusion Statistics
```bash
# Total fusions
echo "Total fusions: $(tail -n +2 STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv | wc -l)"

# Count in-frame fusions
echo "In-frame fusions: $(grep -c INFRAME STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.coding_effect.tsv)"

# Count known cancer fusions
echo "Known cancer fusions: $(grep -c -i "cosmic\|mitelman" STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv)"
```

### Export Specific Fusions
```bash
# Export fusion names only
cut -f1 STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv > fusion_names.txt

# Export high-confidence fusions (>50 junction reads)
awk -F'\t' '$2 > 50' STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv > high_confidence_fusions.tsv
```

### Sort Fusions
```bash
# Sort by junction read count (descending)
sort -t$'\t' -k2 -nr STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv | head -20

# Sort by spanning fragment count
sort -t$'\t' -k3 -nr STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv | head -20
```

## 📁 File Management

### List Output Files
```bash
# List all STAR-Fusion outputs
ls -lh STAR-Fusion_outdir/

# List FusionInspector outputs
ls -lh STAR-Fusion_outdir/FusionInspector-validate/

# Find all BAM files (for IGV)
find STAR-Fusion_outdir -name "*.bam"

# Find all BED files
find STAR-Fusion_outdir -name "*.bed"
```

### Copy Results to Host (from inside Docker)
```bash
# Results are automatically in /data which maps to your host
# No need to copy - just exit Docker and files will be there
exit

# On host, results are in:
ls ~/Projects/STAR_Fusion_Tutorial/STAR-Fusion-Tutorial/STAR-Fusion_outdir/
```

## 🧹 Cleanup

### Remove Output Directory (Start Fresh)
```bash
# Inside Docker or on host
rm -rf STAR-Fusion_outdir

# Remove genome library (to rebuild)
rm -rf ctat_genome_lib_build_dir
```

### Remove Docker Image
```bash
# On host
docker rmi trinityctat/starfusion:latest
```

## 🚀 Automated Pipeline Script

### Run Complete Pipeline
```bash
# Inside Docker
bash /data/run_complete_pipeline.sh

# This script will:
# 1. Check environment
# 2. Build genome library (if needed)
# 3. Run complete STAR-Fusion analysis
# 4. Summarize results
```

## 🔧 Advanced Options

### Run with More Threads
```bash
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir \
    --CPU 8 \
    --FusionInspector validate \
    --denovo_reconstruct \
    --examine_coding_effect
```

### Run with Custom Output Directory
```bash
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir \
    --output_dir my_custom_output
```

### Run FusionInspector in Inspect Mode (faster)
```bash
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir \
    --FusionInspector inspect
```

## 📊 IGV Visualization

### Prepare Files for IGV
```bash
# BAM files are already sorted, just need to index if not already
# (Usually done automatically)

# Files to load in IGV:
# 1. STAR-Fusion_outdir/FusionInspector-validate/finspector.bed
# 2. STAR-Fusion_outdir/FusionInspector-validate/finspector.consolidated.bam
# 3. STAR-Fusion_outdir/FusionInspector-validate/finspector.junction_reads.bam
# 4. STAR-Fusion_outdir/FusionInspector-validate/finspector.spanning_reads.bam
```

## 🐛 Debugging

### Check if Tools are Available
```bash
# Inside Docker
echo $STAR_FUSION_HOME
which STAR-Fusion
which Trinity
```

### View Full Error Messages
```bash
# Run without capturing output
${STAR_FUSION_HOME}/STAR-Fusion \
    --left_fq rnaseq_1.fastq.gz \
    --right_fq rnaseq_2.fastq.gz \
    --genome_lib_dir ctat_genome_lib_build_dir 2>&1 | tee star_fusion.log
```

### Check Log Files
```bash
# View STAR-Fusion logs
cat STAR-Fusion_outdir/Log.final.out
cat STAR-Fusion_outdir/Log.out
```

## 💡 Useful Tips

### Monitor Progress
```bash
# Watch output directory grow
watch -n 10 "ls -lh STAR-Fusion_outdir/"

# Check running processes
top
htop  # if available
```

### Estimate Time Remaining
```bash
# Check process start time
ps aux | grep STAR-Fusion

# Monitor CPU usage
top
```

## 📝 Notes

- Commands assume you're inside the Docker container unless specified
- All paths are relative to `/data/STAR-Fusion-Tutorial` inside Docker
- The `${STAR_FUSION_HOME}` variable is pre-set in the Docker image
- Results persist after exiting Docker because of volume mounting

---

For more details, see `PLAN.md` or `README.md`
