#
# Copyright (C) 2026 The Android Open Source Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Virtual A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from device
$(call inherit-product, device/maxwest/MX-A65/device.mk)

PRODUCT_DEVICE := MX-A65
PRODUCT_NAME := twrp_MX-A65
PRODUCT_BRAND := Maxwest
PRODUCT_MODEL := MX-A65
PRODUCT_MANUFACTURER := Maxwest

PRODUCT_GMS_CLIENTID_BASE := android-maxwest

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="vnd_AGN_1239WQ_S6590_A1_MV3224_61S_V01-user 13 TP1A.220624.014 1730519917 release-keys"

BUILD_FINGERPRINT := Maxwest/ASTRO_A65/MX-A65:13/TP1A.220624.014/1730519917:user/release-keys
