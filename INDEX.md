# 🧬 STAR-Fusion Tutorial - Complete Guide

Welcome! This is your one-stop resource for learning STAR-Fusion, a tool for detecting gene fusions in RNA-seq data.

## 📚 Documentation Overview

This project contains everything you need to successfully run the STAR-Fusion tutorial. Here's how to use these resources:

### 🚀 Start Here
**👉 [CONDA_SETUP.md](CONDA_SETUP.md)** - **YOU HAVE CONDA SETUP!** Use this instead of Docker!

**Alternative:** [GETTING_STARTED.md](GETTING_STARTED.md) - Docker-based quick start

### 📖 Main Resources

| Document | Purpose | When to Use |
|----------|---------|-------------|
| **[README.md](README.md)** | Complete reference guide | For detailed information and troubleshooting |
| **[PLAN.md](PLAN.md)** | Step-by-step tutorial | Follow this for the complete tutorial |
| **[COMMANDS.md](COMMANDS.md)** | Command cheat sheet | Quick reference while working |
| **[GETTING_STARTED.md](GETTING_STARTED.md)** | Quick start guide | To get up and running fast |

### 🛠️ Scripts

| Script | Purpose | How to Use |
|--------|---------|------------|
| **[quickstart.sh](quickstart.sh)** | Automated setup | Run first: `./quickstart.sh` |
| **[run_complete_pipeline.sh](run_complete_pipeline.sh)** | Complete analysis | Run inside Docker: `bash /data/run_complete_pipeline.sh` |

## 🎯 Quick Navigation

### I want to...

**...get started quickly**
→ Run `./quickstart.sh` and follow prompts

**...understand what STAR-Fusion does**
→ Read [GETTING_STARTED.md](GETTING_STARTED.md#-what-is-star-fusion)

**...follow detailed step-by-step instructions**
→ Follow [PLAN.md](PLAN.md) from Phase 1 onwards

**...find a specific command**
→ Check [COMMANDS.md](COMMANDS.md)

**...troubleshoot an issue**
→ See troubleshooting sections in [README.md](README.md#-troubleshooting) or [PLAN.md](PLAN.md)

**...understand the results**
→ Read [README.md](README.md#-understanding-the-results)

**...run everything automatically**
→ Use `quickstart.sh` then `run_complete_pipeline.sh` inside Docker

## 📊 Tutorial Structure

```
Your Learning Path:

1️⃣ Setup (5 min)
   └─ Run: quickstart.sh
   
2️⃣ Understand (10 min)
   └─ Read: GETTING_STARTED.md
   
3️⃣ Execute (1 hour)
   └─ Follow: PLAN.md
   └─ Reference: COMMANDS.md
   
4️⃣ Analyze (10 min)
   └─ Review results
   └─ Compare with expected outputs
```

## ⚡ Three Ways to Run the Tutorial

### Option 1: Quick & Automated (Fastest)
Best for: Getting results quickly
```bash
./quickstart.sh
# Enter Docker when prompted
bash /data/run_complete_pipeline.sh
```

### Option 2: Step-by-Step (Best for Learning)
Best for: Understanding each component
1. Open [PLAN.md](PLAN.md)
2. Follow each phase sequentially
3. Use [COMMANDS.md](COMMANDS.md) as reference

### Option 3: Manual Commands (Most Control)
Best for: Advanced users
1. Review [COMMANDS.md](COMMANDS.md)
2. Run individual commands as needed
3. Customize parameters

## 🎓 What You'll Learn

By completing this tutorial, you will:

- ✅ Detect gene fusions in RNA-seq data
- ✅ Validate fusion predictions
- ✅ Reconstruct fusion transcripts
- ✅ Analyze protein-coding impacts
- ✅ Interpret fusion annotations
- ✅ Visualize results in IGV (optional)

## 📁 Expected Results

You should detect approximately **10 fusion events**, including:
- **CCDC6--RET** - Famous thyroid cancer fusion
- **TATDN1--GSDMB** - Cancer cell line fusion
- **ACACA--STAC2** - Local rearrangement
- Several others with varying read support

## ⏱️ Time Requirements

| Activity | Duration |
|----------|----------|
| Initial setup | 5-10 minutes |
| Genome library building | ~45 minutes |
| Running analyses | ~15 minutes |
| Reviewing results | ~10 minutes |
| **Total** | **~1 hour 20 minutes** |

*Note: Genome building can run in the background*

## 🔧 System Requirements

- **OS**: macOS (current system)
- **RAM**: 4GB minimum (6-8GB recommended)
- **Disk**: 2GB free space
- **Software**: Docker Desktop for Mac
- **Skills**: Basic command line familiarity

## 📞 Getting Help

### Within This Tutorial
1. Check [README.md](README.md) troubleshooting section
2. Review [PLAN.md](PLAN.md) for detailed instructions
3. Consult [COMMANDS.md](COMMANDS.md) for syntax

### External Resources
- [STAR-Fusion GitHub](https://github.com/STAR-Fusion/STAR-Fusion)
- [Official Wiki](https://github.com/STAR-Fusion/STAR-Fusion/wiki)
- [Trinity CTAT Forum](https://groups.google.com/forum/#!forum/trinity_ctat_users)

## ✅ Your Action Plan

**Right now:**
1. [ ] Ensure Docker Desktop is installed
2. [ ] Navigate to `~/Projects/STAR_Fusion_Tutorial`
3. [ ] Run `chmod +x quickstart.sh`
4. [ ] Run `./quickstart.sh`

**Next steps:**
5. [ ] Enter Docker environment
6. [ ] Either run automated pipeline OR follow PLAN.md
7. [ ] Review results
8. [ ] Visualize in IGV (optional)

## 📖 Recommended Reading Order

**For beginners:**
1. GETTING_STARTED.md (overview)
2. README.md (detailed info)
3. PLAN.md (step-by-step)
4. COMMANDS.md (reference)

**For experienced users:**
1. README.md (quick scan)
2. COMMANDS.md (for syntax)
3. PLAN.md (for context)

**For quick results:**
1. GETTING_STARTED.md (setup)
2. COMMANDS.md (run commands)
3. README.md (interpret results)

## 🎬 Ready to Begin?

Choose your starting point:

**🚀 Quick Start**: Run `./quickstart.sh` now

**📚 Learn First**: Read [GETTING_STARTED.md](GETTING_STARTED.md)

**📋 Detailed Plan**: Open [PLAN.md](PLAN.md)

**🔍 Command Reference**: Check [COMMANDS.md](COMMANDS.md)

---

## 📝 Document Descriptions

### GETTING_STARTED.md
- **Length**: Short (5-10 min read)
- **Purpose**: Orientation and quick start
- **Covers**: What STAR-Fusion is, tutorial overview, setup
- **Best for**: First-time users

### README.md
- **Length**: Medium (15-20 min read)
- **Purpose**: Complete reference
- **Covers**: All features, troubleshooting, results interpretation
- **Best for**: Reference and troubleshooting

### PLAN.md
- **Length**: Long (comprehensive)
- **Purpose**: Step-by-step tutorial
- **Covers**: 8 phases with all commands and explanations
- **Best for**: Following along while doing the tutorial

### COMMANDS.md
- **Length**: Short (quick reference)
- **Purpose**: Command cheat sheet
- **Covers**: All common commands with syntax
- **Best for**: Copy-paste reference while working

### quickstart.sh
- **Type**: Bash script
- **Purpose**: Automated setup
- **Does**: Checks Docker, downloads data, starts environment
- **Run**: `./quickstart.sh`

### run_complete_pipeline.sh
- **Type**: Bash script
- **Purpose**: Complete analysis automation
- **Does**: Builds library, runs all analyses, summarizes results
- **Run**: Inside Docker: `bash /data/run_complete_pipeline.sh`

---

## 🌟 Key Success Indicators

You're on track if you:
- ✅ Successfully enter Docker environment
- ✅ Build genome library without errors
- ✅ Detect ~10 fusion events
- ✅ See CCDC6--RET in results
- ✅ Generate output files in expected locations

## 💡 Pro Tips

1. **Save Time**: Build genome library first, then grab coffee
2. **Stay Organized**: Use PLAN.md to track progress (status checkboxes)
3. **Learn More**: Read about detected fusions in literature
4. **Go Visual**: Try IGV for impressive visualizations
5. **Ask Questions**: Use Trinity CTAT forum for help

---

**🎯 Bottom Line**: Start with `./quickstart.sh`, follow [PLAN.md](PLAN.md), reference [COMMANDS.md](COMMANDS.md) as needed!

**Happy Fusion Hunting! 🧬🔬**
