## set the user and group ownership of mnt to current user:group, e.g. 1000:1000, and the setgid flag for mnt
## cd into this directory and run this script

# sudo chown -R "$(id -u):$(id -g)" ..

# sudo chmod -R 2775 ../mnt

cd scripts

. ./setup.sh

cd ..

ls -aln ../mnt

docker compose up

