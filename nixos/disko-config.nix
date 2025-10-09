{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-SAMSUNG_MZVL21T0HCLR-00BL2_S64NNX0WB10141"; # Change this to your actual disk device
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };
            lvm = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "vg1";
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
              resumeDevice = true; # Enable hibernation support
            };
          };
          lv0 = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
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