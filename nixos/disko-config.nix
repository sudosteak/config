{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda"; # Change this to your actual disk device
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              uuid = "6de3d44f-58f6-4ce3-8ccb-3f3a88714c2e";
              content = {
                type = "filesystem";
                format = "vfat";
                extraArgs = [ "-n" "BOOT" "--uuid" "REPLACE-WITH-ESP-FS-UUID" ];
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };
            luks = {
              size = "100%";
              uuid = "ec478600-3e20-4b11-b9f8-21352f0b04a9";
              content = {
                type = "luks";
                name = "crypt";
                extraFormatArgs = [ "--uuid=fb68476d-60eb-404c-9e20-342166620519" ];
                settings = {
                  allowDiscards = true;
                  passwordFile = "/dev/disk/by-uuid/6CF7-6192:/.keys/lv0.pass";
                };
                initrdUnlock = true;
                content = {
                  type = "lvm_pv";
                  vg = "vg1";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      vg1 = {
        type = "lvm_vg";
        lvs = {
          swp0 = {
            size = "34.16GiB"; # Adjust size as needed for hibernation (typically RAM size)
            content = {
              type = "swap";
              extraArgs = [ "--uuid" "80c9e30c-e000-45b6-bd59-5904c8bfc206" ];
              resumeDevice = true; # Enable hibernation support
            };
          };
          lv0 = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" "--uuid" "8c1967fc-ec57-421e-96bf-340248155ff0" ];
              subvolumes = {
                "@" = {
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" "ssd" "space_cache=v2" "noatime" "discard=async" ];
                };
                "@home" = {
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd" "ssd" "space_cache=v2" "noatime" "discard=async" ];
                };
                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "ssd" "space_cache=v2" "noatime" "discard=async" ];
                };
                "@var" = {
                  mountpoint = "/var";
                  mountOptions = [ "compress=zstd" "ssd" "space_cache=v2" "noatime" "discard=async" ];
                };
              };
            };
          };
        };
      };
    };
  };
}