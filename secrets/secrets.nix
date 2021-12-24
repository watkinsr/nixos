let
  pimeys =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBq/Wd5wTvrpIc5fXZJgI85uYlCYC7CaQ7fQqnwm/wEE";
in {
  "secret1.age".publicKeys = [ pimeys ];
  "secret2.age".publicKeys = [ pimeys ];
}
