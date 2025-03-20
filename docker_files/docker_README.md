First, install Docker in your computer.

    sudo apt install docker

Then create a Docker group to run/manage docker withouth sudo permission 
    sudo groupadd docker
    sudo usermod -aG docker $USER

You will need to log off and log in again so that the changes start working.

To create a docktope docker image, run (in the folder with the Dockerfile):

    docker build -t docktope:dt18 -f Dockerfile_docktope .

To start a Docktope docker container, run the following command:

    docker run --rm -it docktope:dt18 /bin/bash

* `--rm`: Remove the docker container after you're done (i.e., "power off" rather than "suspend" the container).
* `-it`: Run interactively with a terminal. You are logged in as root and can install anything else you want.
* `docktope:dt18`: Name and tag of the docker image.

Often you will want to save results on your host machine or edit a script on your host machine that you want to run inside a container. You can do this by mounting a working directory on your host, say `~/myproject`, as a directory inside the container, say `/home/myproject`. To do that, run docker like so:

    docker run --rm -it -v ${HOME}/myproject-at-host:/home/myproject-at-container docktope:dt18 /bin/bash

(If `${HOME}/myproject` doesn't exist, it will be automatically created.)

Other useful docker tips:

- Docker images are shared among all users belonging to the docker user group. To check whether you are in that group, type "groups". The graddock docker image is already present on styx.cs.rice.edu.
- `docker images`: Get a list of all images on a machine.
- `docker pull mmoll/graddock`: Download the graddock docker image that Mark has uploaded to Docker Hub.
- `docker ps`: Get a list of all containers running on a machine, identified by container-name.
- `docker exec -it container-name bash`: To open a new terminal on a running container.
- `docker rmi docktope:dt18`: Deletes the docktope:dt18 image from the computer.

