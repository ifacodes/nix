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

  # Client-certificate material for theory.aoife.moe (mTLS).
  # Only the irreducible secrets live here — the .crt/.pem are public, and the
  # .p12 bundles and iOS .mobileconfig are regenerated from key + cert.
  "woodshed-ca-key.age".publicKeys = users ++ systems; # CA master: mints device access
  "woodshed-koitar-key.age".publicKeys = [ ifa koitar ];
  "woodshed-iphone-key.age".publicKeys = ifa;
  "woodshed-macbook-key.age".publicKeys = [ ifa macbook ];
  "woodshed-p12-password.age".publicKeys = users ++ systems;
}
