#!/bin/bash

# STAR-Fusion Tutorial Quick Start Script
# This script guides you through running the STAR-Fusion tutorial

set -e  # Exit on error

echo "=========================================="
echo "STAR-Fusion Tutorial Quick Start"
echo "=========================================="
echo ""

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if Docker is installed
echo -e "${YELLOW}Checking prerequisites...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker is not installed!${NC}"
    echo "Please install Docker Desktop for Mac from:"
    echo "https://www.docker.com/products/docker-desktop"
    exit 1
else
    echo -e "${GREEN}✓ Docker is installed${NC}"
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${RED}Docker is not running!${NC}"
    echo "Please start Docker Desktop and try again."
    exit 1
else
    echo -e "${GREEN}✓ Docker is running${NC}"
fi

echo ""
echo "=========================================="
echo "Phase 1: Setup and Data Acquisition"
echo "=========================================="
echo ""

# Check if tutorial data already exists
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
echo "Phase 2: Docker Setup"
echo "=========================================="
echo ""

echo "Pulling STAR-Fusion Docker image..."
echo "(This may take a few minutes on first run)"
docker pull trinityctat/starfusion:latest

echo ""
echo -e "${GREEN}✓ Docker image ready${NC}"
echo ""

echo "=========================================="
echo "Ready to Run Tutorial!"
echo "=========================================="
echo ""
echo "You have two options:"
echo ""
echo "Option 1: Interactive Mode (Recommended for learning)"
echo "  Run: docker run --rm -it -v \$(pwd):/data -v /tmp:/tmp trinityctat/starfusion:latest bash"
echo "  Then follow commands from PLAN.md"
echo ""
echo "Option 2: Automated Mode (Run all steps)"
echo "  This will run the complete pipeline automatically."
echo ""

read -p "Do you want to enter interactive Docker shell now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "Starting Docker container..."
    echo "You'll be placed in the Docker environment."
    echo "Run: cd /data/STAR-Fusion-Tutorial"
    echo "Then follow the commands in PLAN.md"
    echo ""
    docker run --rm -it -v $(pwd):/data -v /tmp:/tmp trinityctat/starfusion:latest bash
else
    echo ""
    echo "To start later, run:"
    echo "  cd ~/Projects/STAR_Fusion_Tutorial/STAR-Fusion-Tutorial"
    echo "  docker run --rm -it -v \$(pwd):/data -v /tmp:/tmp trinityctat/starfusion:latest bash"
    echo ""
    echo "For detailed instructions, see: ../PLAN.md"
fi

echo ""
echo -e "${GREEN}Setup complete!${NC}"
