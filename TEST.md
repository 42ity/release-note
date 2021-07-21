# How to fake an OBS tree to test the publish_hook

Create a user obsrun on your system linux \
Clone the reposotory bios-infra (https://bitbucket-prod.tcc.etn.com/projects/BIOS/repos/bios-infra) into local path (\<PATH_ROOT\>)

## Test for master image

* mkdir -p /mnt/nas/images/Debian_10.0/fty-ipm2deploy-image/master/x86_64/
* mkdir -p /mnt/nas/images/Debian_10.0/fty-ipm2devel-image/master/x86_64/
* mkdir -p /srv/obs/repos/fty:/master:/proprietary:/images-ipm2/Debian_10.0_Images
* cd /srv/obs/repos/fty:/master:/proprietary:/images-ipm2/Debian_10.0_Images
* rm -rf \*
* rm -rf /mnt/nas/images/Debian_10.0/fty-ipm2devel-image/master/x86_64/\*
* rm -rf /mnt/nas/images/Debian_10.0/fty-ipm2deploy-image/master/x86_64/\*
* touch fty-ipm2deploy-image-16.12.02-08.00.12_x86_64.squashfs fty-ipm2deploy-image-16.12.02-08.00.12_x86_64.squashfs.md5 fty-ipm2deploy-image-16.12.02-08.00.12_x86_64.tar.gz fty-ipm2deploy-image-16.12.02-08.00.12_x86_64.tar.gz.md5 fty-ipm2devel-image-16.12.02-08.05.19_x86_64.squashfs fty-ipm2devel-image-16.12.02-08.05.19_x86_64.squashfs.md5 fty-ipm2devel-image-16.12.02-08.05.19_x86_64.tar.gz fty-ipm2devel-image-16.12.02-08.05.19_x86_64.tar.gz.md5
* cd \<PATH_ROOT\>/bios-infra/build-service/obs-bin
* ./publish_hook fty:master:proprietary:images-ipm2/Debian_10.0_Images /srv/obs/repos/fty\:/master\:/proprietary\:/images-ipm2/Debian_10.0_Images /fty-ipm2deploy-image-16.12.02-08.00.12_x86_64.squashfs /fty-ipm2deploy-image-16.12.02-08.00.12_x86_64.squashfs.md5 /fty-ipm2deploy-image-16.12.02-08.00.12_x86_64.tar.gz /fty-ipm2deploy-image-16.12.02-08.00.12_x86_64.tar.gz.md5 /fty-ipm2devel-image-16.12.02-08.05.19_x86_64.squashfs /fty-ipm2devel-image-16.12.02-08.05.19_x86_64.squashfs.md5 /fty-ipm2devel-image-16.12.02-08.05.19_x86_64.tar.gz /fty-ipm2devel-image-16.12.02-08.05.19_x86_64.tar.gz.md5
* Type ctrl+c to stop the program
* cat /mnt/nas/images/Debian_10.0/fty-ipm2devel-image/master/x86_64/fty-ipm2devel-image-16.12.02-08.05.19+1_x86_64.squashfs-manifest.json
* Check if release note is in file

## Test for relase image

* mkdir -p /mnt/nas/images/Debian_10.0/IPM_Editions-va/2.3.0/x86_64/
* mkdir -p /mnt/nas/images/Debian_10.0/IPM_Editions-vadevel/2.3.0/x86_64/
* mkdir -p /srv/obs/repos/IPM2\:/2.3.0:/proprietary:/images-ipm2/Debian_10.0_Images
* cd /srv/obs/repos/IPM2\:/2.3.0:/proprietary:/images-ipm2/Debian_10.0_Images
* rm -rf \*
* rm -rf /mnt/nas/images/Debian_10.0/IPM_Editions-va/2.3.0/x86_64/\*
* rm -rf /mnt/nas/images/Debian_10.0/IPM_Editions-vadevel/2.3.0/x86_64/\*
* touch IPM_Editions-va-2.3.0+46_x86_64.squashfs IPM_Editions-va-2.3.0+46_x86_64.squashfs.md5 IPM_Editions-va-2.3.0+46_x86_64.tar.gz IPM_Editions-va-2.3.0+46_x86_64.tar.gz.md5 IPM_Editions-vadevel-2.3.0+48_x86_64.squashfs IPM_Editions-vadevel-2.3.0+48_x86_64.squashfs.md5 IPM_Editions-vadevel-2.3.0+48_x86_64.tar.gz IPM_Editions-vadevel-2.3.0+48_x86_64.tar.gz.md5
* cd \<PATH_ROOT\>/bios-infra/build-service/obs-bin
* ./publish_hook IPM2:2.3.0:proprietary:images-ipm2/Debian_10.0_Images /srv/obs/repos/IPM2\:/2.3.0:/proprietary:/images-ipm2/Debian_10.0_Images /IPM_Editions-va-2.3.0+46_x86_64.squashfs /IPM_Editions-va-2.3.0+46_x86_64.squashfs.md5 /IPM_Editions-va-2.3.0+46_x86_64.tar.gz /IPM_Editions-va-2.3.0+46_x86_64.tar.gz.md5 /IPM_Editions-vadevel-2.3.0+48_x86_64.squashfs /IPM_Editions-vadevel-2.3.0+48_x86_64.squashfs.md5 /IPM_Editions-vadevel-2.3.0+48_x86_64.tar.gz /IPM_Editions-vadevel-2.3.0+48_x86_64.tar.gz.md5
* Type ctrl+c to stop the program
* cat /mnt/nas/images/Debian_10.0/IPM_Editions-va/2.3.0/x86_64/IPM_Editions-va-2.3.0+1+46_x86_64.squashfs-manifest.json
* Check if release note is in file



