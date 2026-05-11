# STAR-Fusion Tutorial Project

This directory contains everything you need to run the STAR-Fusion tutorial for identifying fusion transcripts in RNA-seq data.

## 📁 Contents

- **`PLAN.md`** - Comprehensive step-by-step tutorial plan with detailed instructions
- **`quickstart.sh`** - Automated setup script to get you started quickly
- **`STAR-Fusion-Tutorial/`** - Tutorial data (created after running quickstart.sh)

## 🚀 Quick Start

### Option 1: Using the Quick Start Script (Easiest)

```bash
cd ~/Projects/STAR_Fusion_Tutorial
chmod +x quickstart.sh
./quickstart.sh
```

This script will:
1. Check that Docker is installed and running
2. Clone the tutorial data repository
3. Pull the STAR-Fusion Docker image
4. Optionally launch you into an interactive Docker environment

### Option 2: Manual Setup

If you prefer to run commands manually, follow the detailed instructions in `PLAN.md`.

## 📋 Prerequisites

### Required
- **Docker Desktop for Mac** - Download from https://www.docker.com/products/docker-desktop
- **4GB RAM minimum** (the mini-genome tutorial is lightweight)
- **~2GB disk space** for Docker image and data

### Optional
- **IGV (Integrative Genomics Viewer)** - For visualizing fusion evidence
  - Download from https://software.broadinstitute.org/software/igv/download

## 🎯 What You'll Learn

This tutorial demonstrates the complete CTAT Fusion workflow:

1. **STAR-Fusion** - Identify fusion transcripts from RNA-seq reads
2. **FusionInspector** - Validate and refine fusion predictions
3. **Trinity** - De novo reconstruct fusion transcript sequences
4. **Coding Effect Analysis** - Determine impact on protein-coding regions

## ⏱️ Time Commitment

- **Setup**: ~10 minutes
- **Genome Library Building**: ~45 minutes
- **Running Analysis**: ~15-20 minutes
- **Total**: ~1 hour 20 minutes

## 📊 Expected Results

Using the tutorial's mini-genome and RNA-seq data, you should detect several fusions including:

- **TATDN1--GSDMB** - Known cancer fusion (documented in CCLE, ChimerPub)
- **CCDC6--RET** - Famous cancer fusion (Cosmic, Mitelman databases)
- **ACACA--STAC2** - Local rearrangement
- **BCAS4--BCAS3** - Known fusion from multiple databases
- **RPS6KB1--SNF8** - Local inversion event

## 📖 Documentation Structure

### PLAN.md Sections

1. **Overview & Prerequisites** - System requirements and software setup
2. **Phase 1: Setup** - Data acquisition
3. **Phase 2: Genome Library** - Building reference resources
4. **Phase 3: Fusion Detection** - Basic STAR-Fusion run
5. **Phase 4: Validation** - FusionInspector analysis
6. **Phase 5: Reconstruction** - Trinity de novo assembly
7. **Phase 6: Coding Effect** - Protein impact analysis
8. **Phase 7: Complete Pipeline** - All-in-one command
9. **Phase 8: Results Analysis** - Interpreting outputs

## 🐳 Docker Usage

### Start Interactive Session
```bash
cd ~/Projects/STAR_Fusion_Tutorial/STAR-Fusion-Tutorial
docker run --rm -it -v $(pwd):/data -v /tmp:/tmp trinityctat/starfusion:latest bash
```

### Inside Docker Container
```bash
cd /data/STAR-Fusion-Tutorial
# Now run tutorial commands
```

### Exit Docker
```bash
exit  # or press Ctrl+D
```

## 🔬 Workflow Overview

```
RNA-Seq FASTQ files
        ↓
   STAR-Fusion (fusion detection)
        ↓
   FusionInspector (validation)
        ↓
   Trinity (transcript reconstruction)
        ↓
   Coding Effect Analysis
        ↓
   Annotated Fusion Results
```

## 📁 Output Files

After running the complete analysis, you'll have:

### STAR-Fusion Outputs
- `star-fusion.fusion_predictions.tsv` - Full predictions with read IDs
- `star-fusion.fusion_predictions.abridged.tsv` - Shortened version

### FusionInspector Outputs
- `finspector.fusion_predictions.final` - Validated fusions
- `finspector.consolidated.bam` - Aligned reads for IGV
- `finspector.junction_reads.bam` - Junction-spanning reads
- `finspector.spanning_reads.bam` - Fragment-spanning reads
- `finspector.bed` - Transcript annotations

### Trinity Outputs
- `finspector.gmap_trinity_GG.fusions.fasta` - Reconstructed transcripts
- `finspector.gmap_trinity_GG.fusions.gff3.bed` - Transcript structures

### Coding Effect Outputs
- `star-fusion.fusion_predictions.abridged.coding_effect.tsv` - Protein impact

## 🎓 Understanding the Results

### Key Output Columns

- **FusionName**: Gene pairs involved (e.g., CCDC6--RET)
- **JunctionReadCount**: Split reads supporting the fusion junction
- **SpanningFragCount**: Read pairs spanning the fusion
- **SpliceType**: Whether fusion uses canonical splice sites
- **FFPM**: Fusion Fragments Per Million (normalized abundance)
- **annots**: Known annotations from cancer databases
- **PROT_FUSION_TYPE**: INFRAME or FRAMESHIFT
- **PFAM_LEFT/RIGHT**: Protein domains retained in fusion

### Interpreting Annotations

- **Cosmic, Mitelman**: Known cancer fusions
- **ChimerPub, ChimerKB**: Published chimeric transcripts
- **CCLE**: Cancer Cell Line Encyclopedia
- **FA_CancerSupp**: Fusion involves cancer suppressor gene
- **INTRACHROMOSOMAL**: Fusion within same chromosome
- **LOCAL_INVERSION/REARRANGEMENT**: Type of genomic event

## 🔧 Troubleshooting

### Docker Issues

**Problem**: Docker command not found
```bash
# Install Docker Desktop for Mac
open https://www.docker.com/products/docker-desktop
```

**Problem**: Docker daemon not running
```bash
# Start Docker Desktop application
open -a Docker
# Wait for Docker to start, then retry
```

**Problem**: Permission denied
```bash
# Ensure you're in the correct directory with data files
cd ~/Projects/STAR_Fusion_Tutorial/STAR-Fusion-Tutorial
```

### Memory Issues

**Problem**: Out of memory errors
```bash
# Increase Docker memory allocation:
# Docker Desktop → Settings → Resources → Memory → Set to 6GB or more
```

### Tutorial Data Issues

**Problem**: Missing data files
```bash
# Re-clone the repository
cd ~/Projects/STAR_Fusion_Tutorial
rm -rf STAR-Fusion-Tutorial
git clone https://github.com/STAR-Fusion/STAR-Fusion-Tutorial.git
```

## 🔗 Resources

### Official Documentation
- [STAR-Fusion Wiki](https://github.com/STAR-Fusion/STAR-Fusion/wiki)
- [FusionInspector Documentation](https://github.com/FusionInspector/FusionInspector/wiki)
- [Trinity CTAT](https://github.com/NCIP/Trinity_CTAT/wiki)

### Support
- [STAR-Fusion GitHub Issues](https://github.com/STAR-Fusion/STAR-Fusion/issues)
- [Trinity CTAT Google Forum](https://groups.google.com/forum/#!forum/trinity_ctat_users)

### Publications
- STAR-Fusion: Fast and Accurate Fusion Transcript Detection from RNA-Seq
- FusionInspector: Comprehensive Validation of Fusion Transcripts

## ⚠️ Important Notes

1. **Tutorial Data Only**: The mini-genome library created in this tutorial is NOT suitable for real data analysis. For production use, download pre-compiled full CTAT genome libraries.

2. **Computational Resources**: While this tutorial runs on 4GB RAM, real-world analyses require:
   - 32GB+ RAM for human genome
   - 100GB+ disk space for full CTAT libraries
   - Multi-core CPU recommended

3. **Time Estimates**: Tutorial times are approximate and depend on your system. The 45-minute genome library building step is unavoidable.

## 🎯 Next Steps After Tutorial

1. **Apply to Your Data**: Use pre-compiled CTAT genome libraries
2. **Explore Parameters**: Review STAR-Fusion documentation for filtering options
3. **Batch Processing**: Learn to process multiple samples
4. **Integration**: Incorporate into your RNA-seq pipeline
5. **Visualization**: Practice with IGV for result inspection

## 📝 Notes

Use `PLAN.md` to track your progress through the tutorial. Each phase has status checkboxes and space for notes.

## 🙋 Getting Help

If you encounter issues:
1. Check the Troubleshooting section in `PLAN.md`
2. Review this README
3. Consult official STAR-Fusion documentation
4. Ask on the Trinity CTAT Google Forum
5. Open an issue on the STAR-Fusion GitHub

---

**Happy Fusion Hunting! 🧬**
