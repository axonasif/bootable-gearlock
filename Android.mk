GEARLOCK_ROOT:= "$(call my-dir)"
ANDROID_MAJOR_VERSION := $(word 1, $(subst ., , $(PLATFORM_VERSION)))
PATCH_FILE:= "$(ANDROID_BUILD_TOP)/$(GEARLOCK_ROOT)/patches/android-$(ANDROID_MAJOR_VERSION).patch"
PATCH_TARGET:= "$(ANDROID_BUILD_TOP)/bootable/newinstaller"
ifneq ($(filter 4 5 6, $(ANDROID_MAJOR_VERSION)),)
$(error "No ready to use patch files are available for android $(ANDROID_MAJOR_VERSION) yet")
endif

gearlock:
	cp "$(GEARLOCK_ROOT)/gearlock" "$(PRODUCT_OUT)"
	cp "$(GEARLOCK_ROOT)/hook" "$(PATCH_TARGET)/initrd/scripts/0-hook"
	if patch --dry-run --reverse --force -p1 -d "$(PATCH_TARGET)" -i "$(PATCH_FILE)" >/dev/null 2>&1; then echo "$(PATCH_FILE)" is already applied; else patch -b -p1 -d "$(PATCH_TARGET)" -i "$(PATCH_FILE)" && echo "Successfully applied patches for GearLock" || echo "Failed to apply $(PATCH_FILE)"; fi

all: $(gearlock)
