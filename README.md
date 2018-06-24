# rsbu (Rsync based back up shell script)

<!---
vim:se tw=78 ai si sts=4 et:
-->

Copyright © 2018 Osamu Aoki <osamu at debian.org>

`rsbu` comes with ABSOLUTELY NO WARRANTY.  This is free software, and you can
use, modify, and redistribute it under the GNU General Public Licence 2.0 or
later.

## What is `rsbu`

`rsbu` aims to be a simple, fast and light weight backup utility.

`rsbu` is a filesystem snapshot utility based on modern `rsync` (>3.1.0) which
supports multiple `--link-dest` arguments and modern `bash` (>4.1) which
supports the array variable.  `rsbu` is written entirely in the `bash` shell
script and highly customizable.

`rsbu` started as root with the default configuration at `/etc/rsbu.conf`
makes a snapshot of local machine directory `/home`, `/etc`, and `/usr/local`
under the local directory `/var/cache/rsbu/` while using he older backup data
efficiently with hardlinks.

`rsbu` started as a user with the example configuration copied to
`~/.rsbu.conf` makes a snapshot of local machine directory `~/Documents` under
the local directory `~/rsbu/` while using he older backup data efficiently
with hardlinks.

`rsbu` may be started with a custom configuration by specifying it by the `-c`
option.

You can customize these configuration settings.  If `ssh` access is available,
remote machine data may be backed up.

Since `rsbu` is a simple wrapper around `rsync`, you can use full feature of
`rsync` via its configuration.  For example, you can execute any custom
scripts before and after the `rsync` execution, can filter out some data from
the data to be backed up, and can back up remote machine data.

`rsbu` should be easily adopted to any reasonably modern UNIX compatible OSs.
But currently, `rsbu` is developed and focused on Debian GNU/Linux (>9) only.

No de-duplication effort is deployed in its default setting.  A companion
utility program to address this concern files, which may be moved around and
renamed, will be developed soon.

## How to use `rsbu` for the system backup

You can make the sanity check of the system configuration file
`/etc/rsbu.conf` with:

```
 $ sudo rsbu sanity
```

You can make snapshot backup any time with:

```
 $ sudo rsbu backup
```

This will backup your local `/etc/`, `/home/`, and `/usr/local/` directory
contents to the directory tree under
`/var/cache/rsbu/`*ISO_8601_format_seconds*`/` with the default configuration
settings.

The actual back up behavior can be customized by editing the `backup` function
defined in `/etc/rsbu.conf`.  This configuration file is source by
`/usr/bin/rsbu`.

You can list older backup data any time with:

```
 $ sudo rsbu list
```

You can prune older backup data any time with:

```
 $ sudo rsbu prune
```

This pruning procedure keeps recent backup data in high frequency while the
older backup data are made to be sparse by dropping them.

## How to use `rsbu` for the user backup

Let's set up the user configuration file `~/.rsbu.conf` from the example.

```
 $ cp /usr/share/doc/rsbu/examples/.rsbu.conf ~/.rsbu.conf
```

You can make the sanity check of the user configuration file `~/.rsbu.conf`
with:

```
 $ rsbu sanity
```

You can make snapshot backup any time with:

```
 $ rsbu backup
```

This will backup your local `~/Documents/` directory contents to the directory
tree under `~/rsbu/`*ISO_8601_format_seconds*`/` with the default
configuration settings.

The actual back up behavior can be customized by editing the `backup` function
defined in `~/.rsbu.conf`.  This configuration file is source by
`/usr/bin/rsbu`.

You can list older backup data any time with:

```
 $ rsbu list
```

You can prune older backup data any time with:

```
 $ rsbu prune
```

This pruning procedure keeps recent backup data in high frequency while the
older backup data are made to be sparse by dropping them.

## How to set up for `cron`/`anacron`

Adding a file with the following content in `/etc/cron.d/` automates your
backup job with `cron` to be executed every 15 minutes:

```
 */4 * * * *     /usr/bin/rsbu backup
```

Adding a file with the following content in `/etc/cron.daily/` automates your
pruning job with `cron`/`anacron` to be executed everyday sometime even if
you are on the intermittently used desktop system:

```
test -x /usr/bin/rsbu || exit 0
/usr/bin/rsbu prune
```

## How to speed up `rsbu prune`

If the user write permission of the directory is disabled, `rsbu prune`
becomes slow.  This happens often when the whole directory tree from the
read-only removable media such as CD and DVD.  The following should fix it.

```
 $ cd path/to/<data_dir>
 $ find  . -type d -exec chmod u+w "{}" \;
```

## How to keep data safe

In order to keep data safe from the data loss, it is important to keep the
backup data to be on the different disk drive from the original data.

Tweaking the `/etc/fstab` to mount a different drive on the backup data
directory is one way.  Tweaking udev rules for the removable storage device is
another approach.

## Focus of `rsbu`

`rsbu` is focused on:

* compatibility with the desktop system
* manual and automated random interval backup

The author thanks [rsnapshot](http://rsnapshot.org/) script in `perl` which
gave me motivation and inspiration to write this script in `bash` shell.

[rsnapshot](http://rsnapshot.org/) examples should provides interesting
refined backup tricks such as LVM snapshot.


