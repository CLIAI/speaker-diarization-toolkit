# Speaker Diarization Toolkit

A comprehensive toolkit for speaker identification and diarization in audio transcripts. Maps generic speaker labels (S1, S2, ...) to known speaker profiles using embeddings, voice characteristics, and LLM-based analysis.

## Overview

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Audio     │───>│   catalog   │───>│   assign    │───>│   review    │
│   Input     │    │  (track)    │    │   (map)     │    │  (verify)   │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
                         │                   │                  │
                         v                   v                  v
                   ┌───────────┐       ┌───────────┐     ┌───────────┐
                   │ STT/Trans │       │ Profiles  │     │  Report   │
                   │  Backend  │       │ Embeddings│     │  Status   │
                   └───────────┘       └───────────┘     └───────────┘
```

## Tools

The toolkit consists of several specialized tools:

| Tool | Purpose |
|------|---------|
| `speaker-catalog` | Recording inventory and processing state management |
| `speaker-assign` | Map diarization labels to known speaker profiles |
| `speaker-review` | Interactive review workflow for assignments |
| `speaker-llm` | LLM-based speaker name detection from transcripts |
| `speaker-process` | Batch processing queue management |
| `speaker-report` | Pipeline status and health reporting |
| `speaker_detection` | Core speaker profile management |
| `speaker_samples` | Sample extraction and review |
| `speaker_segments` | Transcript segment extraction |

## Quick Start

```bash
# 1. Add a speaker profile
./speaker_detection add alice --name "Alice Smith" --tag team

# 2. Catalog a recording
./speaker-catalog add meeting.mp3 --context team-standup

# 3. Register transcript (from your STT backend)
./speaker-catalog register-transcript meeting.mp3 \
    --backend speechmatics --transcript meeting.json

# 4. Assign speakers
./speaker-assign meeting.mp3 --transcript meeting.json

# 5. Review assignments
./speaker-review

# 6. Check pipeline status
./speaker-report status
```

## Installation

No installation required. Tools use `uv run` for automatic dependency management.

**Requirements:**

* Python 3.11+
* ffprobe (usually bundled with ffmpeg)
* b3sum (optional, falls back to SHA256)
* jq (for query commands)

## Configuration

Set the data directory:

```bash
export SPEAKERS_EMBEDDINGS_DIR="$HOME/.config/speakers_embeddings"
```

## Testing

Run the test suite:

```bash
# Run all tests
./run_speaker_diarization_tests.sh

# Run unit tests only (fast, no API)
./run_speaker_diarization_tests.sh unit

# Run specific collection
./run_speaker_diarization_tests.sh catalog

# View test documentation
./run_speaker_diarization_tests.sh --doc catalog

# Run in Docker
./run_speaker_diarization_tests.sh docker
```

See `evals/TESTING.md` for testing methodology.

## Documentation

Each tool has detailed documentation:

* `speaker-catalog.README.md` - Recording catalog management
* `speaker-assign.README.md` - Speaker label assignment
* `speaker-review.README.md` - Interactive review workflow
* `speaker-llm.README.md` - LLM-based name detection
* `speaker-process.README.md` - Batch processing
* `speaker-report.README.md` - Status reporting
* `speaker_detection.README.md` - Core profile management
* `speaker_samples.README.md` - Sample extraction
* `speaker_segments.README.md` - Segment extraction

Development notes are in `*.DEV_NOTES.md` files.

## Architecture

### Data Storage

All data stored in `$SPEAKERS_EMBEDDINGS_DIR`:

```
$SPEAKERS_EMBEDDINGS_DIR/
├── speakers/           # Speaker profiles (YAML)
├── embeddings/         # Voice embeddings
├── samples/            # Audio samples per speaker
├── catalog/            # Recording catalog entries
├── assignments/        # Speaker assignments
└── cache/              # LLM response cache
```

### Backend Support

Currently supports:

* **Speechmatics** - Primary STT backend with diarization
* **AssemblyAI** - Alternative transcript format support

## License

MIT License - See LICENSE file for details.

## Contributing

Contributions welcome! Please see the development notes in `*.DEV_NOTES.md` files for implementation details.
