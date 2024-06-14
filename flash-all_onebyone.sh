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

adb reboot bootloader

cd out/target/product/redfin

if ! [ $($(which fastboot) --version | grep "version" | cut -c18-23 | sed 's/\.//g' ) -ge 3301 ]; then
  echo "fastboot too old; please download the latest version at https://developer.android.com/studio/releases/platform-tools.html"
  exit 1
fi
fastboot erase boot
fastboot reboot-bootloader
sleep 5
fastboot flash bootloader bootloader.img
fastboot reboot-bootloader
sleep 5
fastboot flash radio radio.img
fastboot reboot-bootloader
sleep 5
fastboot --set-active=a
fastboot flash boot boot.img
fastboot flash dtbo dtbo.img
fastboot flash vbmeta vbmeta.img
fastboot flash vbmeta_system vbmeta_system.img
fastboot flash vendor_boot vendor_boot.img
fastboot reboot fastboot
sleep 5

fastboot flash super super_empty.img
fastboot flash product product.img
fastboot flash system system.img
fastboot flash system_ext system_ext.img
fastboot flash vendor vendor.img
fastboot erase system
fastboot reboot bootloader
fastboot -w
fastboot reboot

cd ../../../../
