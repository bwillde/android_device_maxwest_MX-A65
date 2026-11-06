# TWRP device tree for the Maxwest Astro A65 (MX-A65)

| | |
|---|---|
| SoC | MediaTek MT6761 (Helio A22) |
| Storage | eMMC 29 GiB |
| Display | 720x1600 @ 320 dpi |
| Android | 13 (TP1A.220624.014), vendor 12 |
| Kernel | 4.19.191 prebuilt (stock) |
| Boot | header v2, **recovery-as-boot** (no recovery partition) |
| Partitions | A/B, dynamic (`super` 5 GiB), Virtual A/B |
| Encryption | FBE v2 + metadata encryption |

## Build
```sh
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1
repo sync -c --force-sync --no-clone-bundle --no-tags
git clone <this repo> device/maxwest/MX-A65
source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
lunch twrp_MX-A65-eng
mka bootimage
```
Or run the **Build TWRP (MX-A65)** GitHub Actions workflow (Actions tab → Run workflow).

## Test (boot without flashing)
```sh
adb reboot bootloader
fastboot boot twrp-MX-A65-boot.img
```

## Status
- [ ] Boots
- [ ] Touch
- [ ] ADB / MTP
- [ ] Mount system/vendor/product (super)
- [ ] /data decryption (disabled in build 1)
- [ ] Backup / restore
- [ ] fastbootd
