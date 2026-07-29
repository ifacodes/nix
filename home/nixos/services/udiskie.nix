{ ... }:

{

  services.udiskie = {
    enable = true;

    settings = {
      program_options = {
        file_manager = "nautilus";
      };

      device_config = [
        # Ignore all APFS filesystems
        {
          id_type = "apfs";
          ignore = true;
        }
        # Ignore specific device by path (replace with your broken drive's path)
        # {
        #   device_file = "/dev/nvme0n1";
        #   ignore = true;
        # }
        # Or ignore by UUID if you know it
        # {
        #   id_uuid = "your-uuid-here";
        #   ignore = true;
        # }
      ];
    };

  };

}
