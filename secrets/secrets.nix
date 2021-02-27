let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE6vjWaa794gLjAKU7YCzqVPQ6g8cviBdddmV14Mk/Ti";
  users = [ user1 ];
in
{
  "env.age".publicKeys = users;
}
