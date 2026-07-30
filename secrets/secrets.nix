let
  # reused from hosts/koitar/configuration.nix's openssh.authorizedKeys.keys -
  # swap this for a different key if that's not the one you want to edit secrets with
  ifa = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB9+W/cjdW4fKLLwQ9JnzOwAuGq9WzPRCeb69KiaHVXL";
  users = [ ifa ];

  koitar = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4JCN+9BQQoEt79VOaGb5CYKnkVS6xlIL1S3aH27nry";
  macbook = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDVuJZYebVlxZWVs5me8LdmAQGqYiuhdOJ+IW9ChXROI";
  systems = [ koitar macbook ];
in
{
  "ifa-password.age".publicKeys = users ++ systems;
}
