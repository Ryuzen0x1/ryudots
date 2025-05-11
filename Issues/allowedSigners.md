## git commit -S silently fails to sign

It's probably due to the non-existent allowed signers file, which keeps track of trusted individuals' emails and public ssh-keys. <br>

In order for `git log` or `git show` to validate ssh signatures, you must create an "allowed signers" file; see the documentation for [gpg.ssh.allowedSignersFile](https://git-scm.com/docs/git-config#Documentation/git-config.txt-gpgsshallowedSignersFile).

For example, if I configure ssh signing like this:

```
git config gpg.format ssh
git config user.signingKey ~/.ssh/id_rsa.pub
git config commit.gpgsign true
```

And then commit a change in a test repository:

```
echo "This is a test" > example-file
git add example-file
git commit -m "Example commit"
```

`git log` will show "No signature":

```
$ git log --show-signature
error: gpg.ssh.allowedSignersFile needs to be configured and exist for ssh signature verification
commit 88d2772f8907d2b429140a466e7c97fa5e2d6e30 (HEAD -> master)
No signature
Author: lars <lars@example.com>
Date:   Sun Feb 4 14:43:31 2024 +0000

    Example commit
```

Note the warning message in the output from that command:

```
error: gpg.ssh.allowedSignersFile needs to be configured and exist for ssh signature verification
```

We can confirm that the commit actually has a signature by using `git cat-file`:

```
$ git cat-file -p HEAD
tree 3f676eeca925687d55ce0be08dbb2923338f09ec
author lars <lars@example.com> 1707057811 +0000
committer lars <lars@example.com> 1707057811 +0000
gpgsig -----BEGIN SSH SIGNATURE-----
 U1NIU0lHAAAAAQAAAZcAAAAHc3NoLXJzYQAAAAMBAAEAAAGBAJyGND3BB04qrqyUITvVZh
 9EBroH7YEZa9RE8Sn0TInwyMT4HNvkNyxTWFjlTC311cFid3HnoKLOH6L5QuGLlSYlJCPM
 K9XmO+rlPifgpSi17ayfTO1t9/rLsNpyqfjBqMpVq5mpcn57KQTceZrEYyikD2R2gh9K01
 lVF72QP87U+QEAIPVatdMrN/MZ1qRz7l8CBH46qj5BOLtfl8dCJinvduW8Y+gyPFqjBkbO
 6Bj2luLDfffSV3BXUVNLhO43W5kkMwycZNqyWXCvVJsZbrn41z2+U138WQyLb6riQWai9r
 9vG31dvPf/Vuqc7PnR1ZGM1ZWo/deaJySrF9xrvie1Vv3YmLEC645HCN9/tOvc6TllNmvs
 B6wY373bUrtVT0Kun1OsIYDKBCuM9Xo6n6TSjUjkxkbwte/haPRcIGYNPoE5kVceVwgGvx
 tBjoKJxe6eH6ugfh17/28QTJ0v1JUO+EgxWIc0FYtbbdyf/dl/rFtZsWL3bx9iMptbVp6Y
 3QAAAANnaXQAAAAAAAAABnNoYTUxMgAAAZQAAAAMcnNhLXNoYTItNTEyAAABgIgBygW+mh
 I1EsC2LoBtOaNjrZWtiisO+9KmDMBuAn2n15JHt3h+6BwODLqEqcLiBzTJVZoQZVgdlNrF
 jKhY1PhNqewy9CvDF+n4j9V85+LbOOktWLodx7KJ8Epfv4z6QlqR4shohH12c7fAWRKsJ9
 zH+bB9L29uuZqfqHyNJFlox9fZsPTAerY/VLoa/j/ij2uGgM+/18d93Gc13GMSdqf+CrF1
 bVZ/j1SE4cneR/YbFI4A3n23iqqCwQoE07WtrYE9b27jnDkoURQi98QJ1YKUS0Jrv1+iap
 ntnXwDSs25FxHQOytBPyf075rMsH6ZnKL/ycSRbGA8dezeivmJJ26uOwGjPEy9FXguqRk8
 W1t4om6vh9BtKTiPVqwoISfQ7CZytZLZ4jzzG6+txjXQtSgVj0HaPXXsYXx8vTYOAkodxO
 RtxQeoDhXk9ReX5QtqHpjR0Z7Ozo5f5PRyVkb/qI6p+Hbq/Qqrkg13OvFv1THrAL0Sxntk
 vbg6zBTk+VB1Sg==
 -----END SSH SIGNATURE-----
```

For git to verify that commit, we need to create an allowed signers file:

```
echo "lars@example.com $(cat ~/.ssh/id_rsa.pub)" > ~/.config/git/allowed-signers
git config gpg.ssh.allowedSignersFile '~/.config/git/allowed-signers'
```

And now we see the signature verification in the output of `git log --show-signature`:

```
$ git log --show-signature
commit 88d2772f8907d2b429140a466e7c97fa5e2d6e30 (HEAD -> master)
Good "git" signature for lars@example.com with RSA key SHA256:nqEzGFF0Z1rMkovqKg4yIbbyViKTuq4ugzhNIh8ggok
Author: lars <lars@example.com>
Date:   Sun Feb 4 14:43:31 2024 +0000

    Example commit
```
