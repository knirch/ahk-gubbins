#Include <MMSystem.ahk>

deviceID := 0 ; MIDI device ID (use the MIDI Mapper by default)
noteOn := 0x90 ; Note On message on channel 1
note := 60 ; MIDI note number (C4)
velocity := 127 ; MIDI velocity (127 = maximum)

midiOutOpen(&hMidi, deviceID, 0, 0, 0)
midiOutShort(&hMidi, (noteOn << 8) | note | (velocity << 16))
midiOutClose(&hMidi)
