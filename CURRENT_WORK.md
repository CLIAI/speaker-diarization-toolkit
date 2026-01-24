# Current Work & Future Plans

*Last updated: 2026-01-24*

## Current Focus: End-to-End Audio Processing Workflow

We're working on a streamlined workflow for processing audio files with speaker diarization, from raw audio to named transcripts with reusable speaker embeddings.

### Target Workflow

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│ 1. Check     │────>│ 2. Transcribe│────>│ 3. Review &  │────>│ 4. Update    │
│    Context   │     │    + Diarize │     │    Assign    │     │    Embeddings│
└──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
                                                                      │
                                                                      v
                                                               ┌──────────────┐
                                                               │ 5. Next File │
                                                               │   (leverage) │
                                                               └──────────────┘
```

### Step-by-Step Commands

#### 1. Check Context (Do I have the right speaker profiles?)

```bash
# List available speakers and their embeddings
./speaker_detection list
./speaker_detection list --tags my-context

# Check which speakers have embeddings enrolled
./speaker_detection embeddings alice
./speaker_detection check-validity

# If new context, create profiles:
./speaker_detection add alice --name "Alice Smith" --tag my-context
```

#### 2. Transcribe with Diarization (Speechmatics)

```bash
# Prerequisite: export SPEECHMATICS_API_KEY="..."

# Option A: External STT tool produces transcript
# (stt_speechmatics.py lives in handy_scripts_CLIAI or similar)
stt_speechmatics.py audio.mp3 -o audio.speechmatics.json

# Option B: If speakers already enrolled, use identify for matching
./speaker_detection identify audio.mp3 --tags my-context

# Register in catalog for tracking
./speaker-catalog add audio.mp3 --context my-context
./speaker-catalog register-transcript audio.mp3 \
    --backend speechmatics --transcript audio.speechmatics.json
```

#### 3. Review & Assign Speakers (Interactive with mpv)

```bash
# Multi-signal assignment (embeddings + LLM + context hints)
./speaker-assign assign audio.mp3 \
    --transcript audio.speechmatics.json \
    --use-embeddings --use-llm --context my-context

# Interactive TUI review
./speaker-review audio.mp3

# TUI Controls:
#   p - Play segment (mpv/ffplay, set via $SPEAKER_REVIEW_PLAYER)
#   a - Approve (auto-extract sample)
#   r - Reject (with notes)
#   s - Skip
#   e - Edit profile
#   n/N - Next/Previous
#   q - Quit (saves session)

# Manual sample review
./speaker_samples list alice --show-review
./speaker_samples review alice sample-001 --approve
```

#### 4. Create/Update Embeddings

```bash
# Enroll from transcript segments
./speaker_detection enroll alice audio.mp3 \
    --from-transcript audio.speechmatics.json --speaker-label S1

# Check trust levels (based on sample review states)
./speaker_detection embeddings alice --show-trust

# Re-enroll if samples were rejected
./speaker_detection remove-embedding alice emb-old123
./speaker_detection enroll alice better_audio.mp3
```

#### 5. Ready for Next File

```bash
# Embeddings are now available for future files
./speaker_detection identify next_audio.mp3 --tags my-context

# Batch processing
./speaker-process queue ./recordings/ --context my-context
./speaker-process run --parallel 4

# Health check
./speaker-report status
```

---

## Implementation Status

### Implemented (Working)

| Component | Status | Notes |
|-----------|--------|-------|
| `speaker_detection` | Complete | Profile CRUD, embedding management |
| `speaker_samples` | Complete | Extraction, review, provenance tracking |
| `speaker_segments` | Complete | Lightweight segment extraction |
| `speaker-catalog` | Complete | Recording inventory |
| `speaker-assign` | Complete | Multi-signal assignment (weights configurable) |
| `speaker-review` | Complete | Interactive TUI with audio playback |
| `speaker-llm` | Complete | Claude/GPT/Ollama name detection |
| `speaker-process` | Complete | Batch orchestration |
| `speaker-report` | Complete | Health metrics dashboard |
| Speechmatics backend | Complete | API integration for enrollment/identification |

### Gaps / Future Work

| Component | Status | Priority | Notes |
|-----------|--------|----------|-------|
| STT wrapper script | Missing | High | `stt_speechmatics.py` referenced but lives externally |
| PyAnnote backend | Planned | Medium | Local embedding computation |
| SpeechBrain backend | Planned | Medium | Alternative local backend |
| AssemblyAI backend | Partial | Medium | Transcript parsing works, no enrollment |
| OpenAI Whisper backend | Not started | Low | No diarization support upstream |

### External Dependencies

The toolkit expects transcripts as input. STT tools referenced in docs:

* `stt_speechmatics.py` - Produces `.speechmatics.json` format
* `stt_assemblyai_speaker_mapper.py` - Produces utterances with A/B/C labels

These may live in `handy_scripts_CLIAI` or another repository.

---

## Environment Setup

```bash
# Required
export SPEAKERS_EMBEDDINGS_DIR="$HOME/.config/speakers_embeddings"
export SPEECHMATICS_API_KEY="your-key"

# Optional
export SPEAKER_DETECTION_BACKEND="speechmatics"  # default
export SPEAKER_REVIEW_PLAYER="mpv"               # or ffplay
export ANTHROPIC_API_KEY="..."                   # for speaker-llm
export SPEAKER_DETECTION_DEBUG="1"               # verbose logging
```

---

## Next Steps

1. **Locate or create STT wrapper** - Need `stt_speechmatics.py` or equivalent in this repo
2. **Test complete workflow** - Process a real audio file end-to-end
3. **Document context management** - How to organize speakers by project/meeting type
4. **Add convenience script** - Single command for common workflow patterns

---

## Session Notes

*(Add notes from each work session here)*

### 2026-01-24

* Reviewed full toolkit architecture
* Documented target workflow for audio processing
* Identified gap: STT wrapper scripts live externally
* Created this tracking file
