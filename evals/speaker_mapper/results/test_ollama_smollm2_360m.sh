#!/bin/bash
# Benchmark command used to generate results
# Generated on: 2025-10-14 00:20:50

./benchmark.py --llm-detect smollm2:360m --llm-endpoint http://localhost:11434/v1 --save-jsonl results/test_ollama_smollm2_360m.jsonl --save-ascii results/test_ollama_smollm2_360m.txt --output ascii
