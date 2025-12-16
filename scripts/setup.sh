## set the user and group ownership of mnt to current user:group, e.g. 1000:1000, and the setgid flag for mnt
## cd into this directory and run this script

USER_AND_GROUP="$(id -u):$(id -g)"

sudo chown -R ${USER_AND_GROUP} ..

sudo chmod -R 2775 ../mnt

ls -aln ../mnt
