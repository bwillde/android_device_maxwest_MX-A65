#
# Copyright (C) 2026 The Android Open Source Project
# SPDX-License-Identifier: Apache-2.0
#
# TWRP device tree for the Maxwest Astro A65 (MX-A65)
#   SoC        : MediaTek MT6761 (Helio A22), eMMC
#   Android    : 13 (TP1A.220624.014), vendor 12, first API 33
#   Boot       : boot header v2, recovery-as-boot (no recovery partition;
#                vendor_boot / init_boot exist but are empty/unused)
#   Partitions : A/B, dynamic partitions (super 5 GiB), Virtual A/B
#   Crypto     : FBE v2 + metadata encryption
#
# All values below were taken from the stock boot_a image header
# (unpack_bootimg.py) and the GPT (mtkclient printgpt).
#

DEVICE_PATH := device/maxwest/MX-A65

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# A/B
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    lk \
    product \
    system \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \
    vendor
BOARD_USES_RECOVERY_AS_BOOT := true
TARGET_NO_RECOVERY := true
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a53

TARGET_USES_64_BIT_BINDER := true

# Bootloader / platform
TARGET_BOOTLOADER_BOARD_NAME := MX-A65
TARGET_NO_BOOTLOADER := true
TARGET_BOARD_PLATFORM := mt6761
BOARD_HAS_MTK_HARDWARE := true
BOARD_USES_MTK_HARDWARE := true

# Display
TARGET_SCREEN_WIDTH := 720
TARGET_SCREEN_HEIGHT := 1600
TARGET_SCREEN_DENSITY := 320

# Kernel (prebuilt from stock boot_a; 4.19.191, non-GKI)
#   kernel load 0x40080000, ramdisk 0x51b00000, tags/dtb 0x47880000
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x11a88000
BOARD_KERNEL_TAGS_OFFSET := 0x07808000
BOARD_DTB_OFFSET := 0x07808000
BOARD_BOOT_HEADER_VERSION := 2
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 buildvariant=user

# Stock kernel is gzip-compressed (Image.gz); the DTB is passed manually
# to mkbootimg below exactly as in the stock header-v2 image.
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img

BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --base $(BOARD_KERNEL_BASE)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)

# Partitions (sizes from GPT)
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432          # 0x2000000
BOARD_DTBOIMG_PARTITION_SIZE := 8388608             # 0x800000
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_PRODUCT := product

# Dynamic partitions: super = 0x140000000 (5 GiB).
# Virtual A/B => a single copy of the group; group size = super - 4 MiB.
# Members confirmed on device via `ls /dev/block/mapper`:
#   system_a, vendor_a, product_a (+ system_b). No system_ext/odm.
# TODO: confirm group name from the super lp metadata.
BOARD_SUPER_PARTITION_SIZE := 5368709120
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_SIZE := 5364514816
BOARD_MAIN_PARTITION_LIST := system vendor product

# Platform version / patch level (TWRP convention: max values so the
# bootloader's anti-rollback never rejects the recovery image).
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)

# AVB: keep verification out of the way for the custom boot image.
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab
TARGET_USES_MKE2FS := true
BOARD_SUPPRESS_SECURE_ERASE := true

# Crypto
# Build 1: decryption disabled; /data will show as encrypted.
# Build 2: enable once vendor keymint/gatekeeper blobs are pulled.
TW_INCLUDE_CRYPTO := false
TW_INCLUDE_CRYPTO_FBE := false
TW_INCLUDE_FBE_METADATA_DECRYPT := false
BOARD_USES_METADATA_PARTITION := true

# TWRP configuration
TW_THEME := portrait_hdpi
TW_DEVICE_VERSION := MX-A65-bryce
RECOVERY_SDCARD_ON_DATA := true
TW_EXTRA_LANGUAGES := true
TW_DEFAULT_LANGUAGE := en
TW_SCREEN_BLANK_ON_BOOT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_MAX_BRIGHTNESS := 255
TW_DEFAULT_BRIGHTNESS := 160
TW_USE_TOOLBOX := true
TW_INCLUDE_REPACKTOOLS := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_LIBRESETPROP := true
TW_INCLUDE_FASTBOOTD := true
TW_EXCLUDE_APEX := true
TW_HAS_MTP := true
TW_MTP_DEVICE := /dev/mtp_usb
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_FRAMERATE := 60
TARGET_USE_CUSTOM_LUN_FILE_PATH := /config/usb_gadget/g1/functions/mass_storage.usb0/lun.%d/file
TW_CUSTOM_CPU_TEMP_PATH := /sys/devices/virtual/thermal/thermal_zone0/temp
TW_BACKUP_EXCLUSIONS := /data/fonts

# Debug
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
