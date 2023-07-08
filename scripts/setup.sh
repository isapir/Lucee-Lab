## set the user and group ownership of mnt to 1000:1000, and the setgid flag for mnt

# sudo chown -R "$(id -u):$(id -g)" ../..

sudo chown -R "1000:1000" ../..

sudo chmod -R u=rwsX,g=rwsX,o=rw ../mnt
