# Dell Precision 7780 Audio Fix

Debian package that forces the Intel SOF driver for the Dell Precision 7780
SoundWire audio interface and digital microphone array.

On affected systems, Linux can auto-select the legacy HDA driver. Speakers may
appear, but the internal microphone is exposed as an incorrect analog source
and can return saturated samples. This package installs:

```text
options snd_intel_dspcfg dsp_driver=3
```

It also depends on Debian's PipeWire, WirePlumber, ALSA, Intel sound firmware,
and SOF firmware packages.

## Build

```bash
./build.sh
```

The package is written to `dist/`.

## Install

Ensure Debian sources include `non-free-firmware`, then run:

```bash
sudo apt install ./dist/precision-7780-audio-fix_1.0.0-1_all.deb
sudo reboot
```

## Verify

After reboot:

```bash
cat /sys/module/snd_intel_dspcfg/parameters/dsp_driver
systemctl --user status pipewire pipewire-pulse wireplumber
wpctl status
speaker-test -D pipewire -c 2 -t wav -l 1
arecord -D pipewire -f S16_LE -r 48000 -c 2 -d 5 mic-test.wav
```

The DSP driver value should be `3`.

## Scope

This package is intentionally model-specific. Do not install it on unrelated
hardware without confirming that forcing the Intel SOF driver is appropriate.
