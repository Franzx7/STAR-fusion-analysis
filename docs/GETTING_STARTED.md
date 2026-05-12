# STAR-Fusion Tutorial - Getting Started Guide

## 🎯 What is STAR-Fusion?

STAR-Fusion is a tool for detecting fusion transcripts (gene fusions) in RNA-seq data. Gene fusions are important in cancer biology as they can:
- Drive tumor formation
- Serve as diagnostic biomarkers
- Be therapeutic targets

## 📚 What This Tutorial Covers

This hands-on tutorial will teach you to:
1. **Detect fusions** using STAR-Fusion
2. **Validate fusions** using FusionInspector
3. **Reconstruct fusion transcripts** using Trinity
4. **Analyze protein impacts** of detected fusions

## 🚦 Getting Started - Choose Your Path

### Path A: Quick Start (Recommended for Beginners)
**Time**: 5 minutes to start
```bash
cd ~/Projects/STAR_Fusion_Tutorial
chmod +x quickstart.sh
./quickstart.sh
```
This automated script will set everything up for you.

### Path B: Step-by-Step (Recommended for Learning)
**Time**: 10 minutes to start
1. Read `README.md` for overview
2. Follow `PLAN.md` phase by phase
3. Run commands manually to understand each step

### Path C: Automated Pipeline (Fast Track)
**Time**: 1 hour total (mostly automated)
1. Run `quickstart.sh` to set up
2. Enter Docker container
3. Run `bash run_complete_pipeline.sh`
4. Get results automatically

## 📋 Before You Begin - Checklist

- [ ] macOS system with 4GB+ RAM
- [ ] Docker Desktop installed
- [ ] 2GB free disk space
- [ ] 1-2 hours available time
- [ ] Terminal/command line familiarity

## 🗺️ Tutorial Workflow

```
START
  ↓
📥 Download Tutorial Data (5 min)
  ↓
🐳 Set Up Docker Environment (5 min)
  ↓
🔧 Build Genome Library (45 min) ← Can run in background
  ↓
🔍 Run STAR-Fusion (2 min)
  ↓
✅ Validate with FusionInspector (10 min)
  ↓
🧬 Reconstruct with Trinity (5 min)
  ↓
📊 Analyze Coding Effects (1 min)
  ↓
📈 Review Results (10 min)
  ↓
END
```

## 📁 Project Structure

After setup, your directory will look like this:

```
~/Projects/STAR_Fusion_Tutorial/
├── README.md                      # Overview and reference
├── PLAN.md                        # Detailed step-by-step guide
├── GETTING_STARTED.md            # This file
├── quickstart.sh                  # Automated setup script
├── run_complete_pipeline.sh       # Complete pipeline script
└── STAR-Fusion-Tutorial/          # Tutorial data (after cloning)
    ├── minigenome.fa              # Mini genome
    ├── minigenome.gtf             # Gene annotations
    ├── rnaseq_1.fastq.gz          # RNA-seq reads (left)
    ├── rnaseq_2.fastq.gz          # RNA-seq reads (right)
    ├── CTAT_HumanFusionLib.mini.dat.gz  # Fusion library
    ├── ctat_genome_lib_build_dir/ # Generated genome library
    └── STAR-Fusion_outdir/        # Results directory
```

## 🎓 Learning Resources

### Essential Reading
1. **README.md** - Start here for overview
2. **PLAN.md** - Detailed tutorial with all commands

### Reference Documentation
- [STAR-Fusion Official Wiki](https://github.com/STAR-Fusion/STAR-Fusion/wiki)
- [FusionInspector Documentation](https://github.com/FusionInspector/FusionInspector/wiki)
- [Trinity CTAT Home](https://github.com/NCIP/Trinity_CTAT/wiki)

## 💡 Key Concepts to Understand

### What are Gene Fusions?
Gene fusions occur when:
- Two previously separate genes join together
- Common in cancer (e.g., BCR-ABL in leukemia)
- Can create novel proteins with new functions

### Tutorial Components

1. **STAR-Fusion**: Initial fusion detection
   - Identifies discordant read alignments
   - Fast, sensitive fusion caller
   - Output: List of candidate fusions

2. **FusionInspector**: Validation
   - Realigns reads to fusion contigs
   - Provides high-confidence fusions
   - Output: Validated fusions + BAM files for IGV

3. **Trinity**: Transcript reconstruction
   - De novo assembles fusion transcripts
   - Shows full fusion isoforms
   - Output: FASTA sequences of fusions

4. **Coding Effect Analysis**: Protein impact
   - Determines if fusion is in-frame
   - Predicts retained protein domains
   - Output: Functional predictions

## 🔍 What Results to Expect

Using the tutorial data, you'll detect **~10 fusion events** including:

### Known Cancer Fusions
- **CCDC6--RET**: Thyroid cancer fusion (famous!)
- **TATDN1--GSDMB**: Documented in cancer cell lines

### Characteristics You'll Learn to Evaluate
- Read support (how many reads support the fusion?)
- Splice type (does it use normal splice sites?)
- Coding impact (in-frame or frameshift?)
- Database annotations (previously seen?)
- Breakpoint details (where does fusion occur?)

## 🚀 Quick Commands Reference

### Starting Docker
```bash
cd ~/Projects/STAR_Fusion_Tutorial/STAR-Fusion-Tutorial
docker run --rm -it -v $(pwd):/data -v /tmp:/tmp trinityctat/starfusion:latest bash
```

### Inside Docker - Navigate to Data
```bash
cd /data/STAR-Fusion-Tutorial
```

### Run Complete Pipeline (inside Docker)
```bash
bash /data/run_complete_pipeline.sh
```

### View Results (inside Docker)
```bash
# View fusion predictions
less STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv

# Count fusions
wc -l STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv

# Check for cancer fusions
grep -i cosmic STAR-Fusion_outdir/star-fusion.fusion_predictions.abridged.tsv
```

### Exit Docker
```bash
exit
```

## ❓ Common Questions

### Q: Do I need to install STAR-Fusion?
**A**: No! The Docker image has everything pre-installed.

### Q: Can I use this for my real data?
**A**: After learning with the tutorial, yes! But you'll need:
- Full CTAT genome library (not the mini one)
- More RAM (32GB+ recommended)
- More time for processing

### Q: What if something goes wrong?
**A**: Check the Troubleshooting section in `PLAN.md` or `README.md`

### Q: How long will this take?
**A**: Total ~1 hour 20 minutes, with 45 minutes for genome building (can run in background)

### Q: Do I need bioinformatics experience?
**A**: Basic command line skills are helpful, but the tutorial is beginner-friendly!

## 🎯 Your First Steps (Right Now!)

1. **Check Docker Installation**
   ```bash
   docker --version
   # If this fails, install Docker Desktop for Mac
   ```

2. **Navigate to Tutorial Directory**
   ```bash
   cd ~/Projects/STAR_Fusion_Tutorial
   ```

3. **Run Quick Start**
   ```bash
   chmod +x quickstart.sh
   ./quickstart.sh
   ```

4. **Follow the Prompts**
   - The script will guide you through setup
   - Answer yes to enter Docker environment
   - Start running tutorial commands!

## 📊 Success Criteria

You'll know the tutorial is successful when you:
- [ ] Detect ~10 fusion events
- [ ] See CCDC6--RET in your results (known cancer fusion)
- [ ] Generate BAM files for IGV visualization
- [ ] Produce coding effect predictions
- [ ] Understand the output file formats

## 🎉 After Completing the Tutorial

1. **Review your results** - Compare with expected outputs
2. **Try IGV visualization** - Load BAM files to see fusion evidence
3. **Read the papers** - Learn more about detected fusions
4. **Plan next steps** - Apply to your own data

## 📞 Getting Help

### Within This Tutorial
1. Check `README.md` for troubleshooting
2. Review `PLAN.md` for detailed instructions
3. Verify you're running commands in correct directory

### External Resources
1. STAR-Fusion GitHub Issues
2. Trinity CTAT Google Forum
3. Official documentation wikis

## 🎬 Ready to Start?

Choose your path and let's get started!

**Quick Start**: Run `./quickstart.sh` now
**Step-by-Step**: Open `PLAN.md` and start with Phase 1
**Full Understanding**: Read `README.md` first, then `PLAN.md`

---

**Good luck and happy fusion hunting! 🧬🔬**

If you encounter any issues, all the information you need is in `README.md` and `PLAN.md`.
