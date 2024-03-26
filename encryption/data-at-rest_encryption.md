# Data-at-rest encryption

[Refer][1](https://wiki.archlinux.org/title/Data-at-rest_encryption)

All data-at-rest encryption methods operate in such a way that even though the disk actually holds encrypted data, the operating system and applications "see" it as the corresponding normal readable data as long as the cryptographic container (i.e. the logical part of the disk that holds the encrypted data) has been "unlocked" and mounted.

For this to happen, some "secret information" (usually in the form of a keyfile and/or passphrase) needs to be supplied by the user, from which the actual encryption key can be derived (and stored in the kernel keyring for the duration of the session).

If you are completely unfamiliar with this sort of operation, please also read the #How the encryption works section below.

The available data-at-rest encryption methods can be separated into two types by their layer of operation:

## Stacked filesystem encryption

Stacked filesystem encryption solutions are implemented as a layer that stacks on top of an existing filesystem, causing all files written to an encryption-enabled folder to be encrypted on-the-fly before the underlying filesystem writes them to disk, and decrypted whenever the filesystem reads them from disk. This way, the files are stored in the host filesystem in encrypted form (meaning that their contents, and usually also their file/folder names, are replaced by random-looking data of roughly the same length), but other than that they still exist in that filesystem as they would without encryption, as normal files / symlinks / hardlinks / etc.

The way it is implemented, is that to unlock the folder storing the raw encrypted files in the host filesystem ("lower directory"), it is mounted (using a special stacked pseudo-filesystem) onto itself or optionally a different location ("upper directory"), where the same files then appear in readable form - until it is unmounted again, or the system is turned off.

Available solutions in this category are **eCryptfs** and **EncFS**.

## Cloud-storage optimized

If you are deploying stacked filesystem encryption to achieve zero-knowledge synchronization with third-party-controlled locations such as cloud-storage services, you may want to consider alternatives to eCryptfs and EncFS, since these are not optimized for transmission of files over the Internet. There are some solutions designed for this purpose instead:

> **gocryptfs**
> **cryptomatorAUR** or cryptomator-binAUR (multi-platform)
> **cryfs**

Note that some cloud-storage services offer zero-knowledge encryption directly through their own client applications.

## Block device encryption

Block device encryption methods, on the other hand, operate below the filesystem layer and make sure that everything written to a certain block device (i.e. a whole disk, or a partition, or a file acting as a loop device) is encrypted. This means that while the block device is offline, its whole content looks like a large blob of random data, with no way of determining what kind of filesystem and data it contains. Accessing the data happens, again, by mounting the protected container (in this case the block device) to an arbitrary location in a special way.

The following "block device encryption" solutions are available in Arch Linux:

- **loop-AES**
    loop-AES is a descendant of cryptoloop and is a secure and fast solution to system encryption. However, loop-AES is considered less user-friendly than other options as it requires non-standard kernel support.

- **dm-crypt**
    dm-crypt is the standard device-mapper encryption functionality provided by the Linux kernel. It can be used directly by those who like to have full control over all aspects of partition and key management. The management of dm-crypt is done with the cryptsetup userspace utility. It can be used for the following types of block-device encryption: LUKS (default), plain, and has limited features for loopAES and Truecrypt devices.

> LUKS, used by default, is an additional convenience layer which stores all of the needed setup information for dm-crypt on the disk itself and abstracts partition and key management in an attempt to improve ease of use and cryptographic security.
> plain dm-crypt mode, being the original kernel functionality, does not employ the convenience layer. It is more difficult to apply the same cryptographic strength with it. When doing so, longer keys (passphrases or keyfiles) are the result. It has, however, other advantages for very specific cases. For example, a single block device can be segmented and encrypted accordingly.

- **TrueCrypt/VeraCrypt**
    A portable format, supporting encryption of whole disks/partitions or file containers, with compatibility across all major operating systems. TrueCrypt was discontinued by its developers in May 2014. The VeraCrypt fork was audited in 2016.

For practical implications of the chosen layer of operation, see the #Block device vs stacked filesystem encryption below, as well as the general write up for eCryptfs. See Category:Encryption for the available content of the methods compared below, as well as other tools not included in the table. 
