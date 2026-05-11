# STAR-Fusion Tutorial

Comprehensive tutorial and documentation for running STAR-Fusion RNA-seq fusion detection analysis.

## Overview

This repository contains structured documentation and scripts for learning STAR-Fusion, a tool for detecting gene fusions in RNA-seq data.

## Quick Start

### For Conda Users (Recommended)

```bash
conda activate rna_fusion_analysis
chmod +x quickstart_conda.sh
./quickstart_conda.sh
```

### For Docker Users

```bash
chmod +x quickstart.sh
./quickstart.sh
```

## Documentation

- **CONDA_SETUP.md** - Setup guide for conda/mamba installations
- **INDEX.md** - Navigation hub for all documentation
- **PLAN.md** - Detailed step-by-step tutorial (8 phases)
- **COMMANDS.md** - Command reference and cheat sheet
- **README.md** - Complete reference guide
- **GETTING_STARTED.md** - Quick overview and orientation

## Scripts

- **quickstart_conda.sh** - Automated setup for conda environments
- **quickstart.sh** - Automated setup for Docker
- **run_complete_pipeline.sh** - Complete analysis pipeline

## Requirements

### Conda Setup
- STAR-Fusion
- STAR aligner
- Trinity
- GMAP
- BLAST+
- Samtools

### Docker Setup
- Docker Desktop
- 4GB RAM minimum

## What You'll Learn

- Detect gene fusions from RNA-seq data
- Validate fusion predictions with FusionInspector
- Reconstruct fusion transcripts with Trinity
- Analyze protein coding effects
- Interpret fusion annotations

## Expected Results

Tutorial detects approximately 10 fusion events including:
- CCDC6--RET (known cancer fusion)
- TATDN1--GSDMB
- ACACA--STAC2
- And more

## Time Required

- Setup: 5-10 minutes
- Genome library build: 45 minutes
- Analysis: 15 minutes
- Review: 10 minutes
- Total: ~1 hour 20 minutes

## Resources

- [STAR-Fusion GitHub](https://github.com/STAR-Fusion/STAR-Fusion)
- [Official Wiki](https://github.com/STAR-Fusion/STAR-Fusion/wiki)
- [Tutorial Data](https://github.com/STAR-Fusion/STAR-Fusion-Tutorial)
- [Trinity CTAT](https://github.com/NCIP/Trinity_CTAT/wiki)

## License

Documentation and scripts are provided as-is for educational purposes.

## Getting Help

1. Check documentation in this repository
2. Visit STAR-Fusion GitHub issues
3. Join Trinity CTAT Google Forum
