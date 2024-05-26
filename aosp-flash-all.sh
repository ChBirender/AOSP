#!/bin/sh

# Copyright 2012 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cd "${ANDROID_PRODUCT_OUT}"
zip -0 image-aosp-redfin-trunk-staging-eng.zip android-info.txt boot.img dtbo.img product.img super_empty.img system.img system_ext.img system_other.img vbmeta.img vbmeta_system.img vendor.img vendor_boot.img
cd ../../../../

sleep 2

if ! [ $($(which fastboot) --version | grep "version" | cut -c18-23 | sed 's/\.//g' ) -ge 3301 ]; then
  echo "fastboot too old; please download the latest version at https://developer.android.com/studio/releases/platform-tools.html"
  exit 1
fi
fastboot flash bootloader "${ANDROID_PRODUCT_OUT}"/bootloader.img
fastboot reboot-bootloader
sleep 5
fastboot flash radio "${ANDROID_PRODUCT_OUT}"/radio.img
fastboot reboot-bootloader
sleep 5
fastboot -w update "${ANDROID_PRODUCT_OUT}"/image-aosp-redfin-trunk-staging-eng.zip
