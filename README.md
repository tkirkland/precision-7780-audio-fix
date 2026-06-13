# Dell Precision 7780 Audio Fix

Debian package that forces the Intel SOF driver for the Dell Precision 7780
SoundWire audio interface and digital microphone array.

This is an unofficial community workaround. It is not provided, supported, or
endorsed by Dell.

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

## GitHub Actions

The `Build Debian package` workflow can be started manually from the
repository's **Actions** tab.

- Leave `publish_release` disabled to build, validate, checksum, and upload the
  `.deb` as a workflow artifact.
- Enable `publish_release` and provide a tag such as `v1.0.1` to create a
  release. If the release already exists, the workflow replaces its `.deb` and
  checksum assets.

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

## Official Dell references

Dell lists Ubuntu 22.04 LTS and Red Hat Enterprise Linux 9.2 as supported
operating systems for the Precision 7780:

- [Precision 7780 supported operating systems](https://www.dell.com/support/home/en-us/drivers/supportedos/precision-17-7780-laptop)
- [Precision 7780 drivers and downloads](https://www.dell.com/support/product-details/en-us/product/precision-17-7780-laptop/drivers)

Dell's download catalog does not currently provide a model-specific Linux
audio package. Supported Linux installations rely on the distribution kernel,
Intel SOF firmware, ALSA/UCM configuration, and userspace audio stack.
