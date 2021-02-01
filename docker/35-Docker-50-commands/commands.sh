# 1. Build an image from a Dockerfile
docker build -t myimage:latest .

# 2. Run a container in interactive mode with a shell
docker run -it --rm myimage:latest sh

# 3. List all running containers
docker ps

# 4. List all containers, including stopped ones
docker ps -a

# 5. Stop a running container
docker stop <container_name_or_id>

# 6. Start a stopped container
docker start <container_name_or_id>

# 7. Remove a stopped container
docker rm <container_name_or_id>

# 8. Remove a running container (forceful)
docker rm -f <container_name_or_id>

# 9. List all images on the local machine
docker images

# 10. Remove an image
docker rmi <image_name_or_id>

# 11. Pull an image from a registry
docker pull <image_name>

# 12. Push an image to a registry
docker push <image_name>

# 13. Tag an image with a new name
docker tag <image_name> <new_image_name>

# 14. Create a network
docker network create <network_name>

# 15. List all networks
docker network ls

# 16. Remove a network
docker network rm <network_name>

# 17. Attach a container to a network
docker network connect <network_name> <container_name_or_id>

# 18. Detach a container from a network
docker network disconnect <network_name> <container_name_or_id>

# 19. Run a container with port mapping
docker run -p <host_port>:<container_port> <image_name>

# 20. Run a container with a specific name
docker run --name <container_name> <image_name>

# 21. Run a container in the background
docker run -d <image_name>

# 22. Inspect a container
docker inspect <container_name_or_id>

# 23. Inspect an image
docker inspect <image_name_or_id>

# 24. Get logs from a container
docker logs <container_name_or_id>

# 25. Get container resource usage statistics
docker stats <container_name_or_id>

# 26. Execute a command in a running container
docker exec <container_name_or_id> <command>

# 27. Copy files between a container and the local filesystem
docker cp <container_name_or_id>:<path_to_file_inside_container> <local_path>

# 28. Set environment variables when running a container
docker run -e <env_variable_name>=<env_variable_value> <image_name>

# 29. Mount a host directory as a volume in a container
docker run -v <host_directory_path>:<container_directory_path> <image_name>

# 30. Create a named volume
docker volume create <volume_name>

# 31. List all volumes
docker volume ls

# 32. Remove a volume
docker volume rm <volume_name>

# 33. Run a container with a named volume
docker run -v <volume_name>:<container_directory_path> <image_name>

# 34. Run a container with a temporary writable container layer
docker run --rm -it --name <container_name> <image_name> sh

# 35. Build an image from a Dockerfile in a specific directory
docker build -t <image_name> <path_to_dockerfile_directory>

# 36. Save an image to a tar archive
docker save -o <output_file_name.tar> <image_name>

# 37. Remove all stopped containers:
docker container prune

# 38. Remove all dangling images:
docker image prune

# 39. Remove all unused networks:
docker network prune

# 40. Remove all unused volumes:
docker volume prune

# 41. Tag an image with a new name and tag:
docker tag old-image-name:old-image-tag new-image-name:new-image-tag

# 42. Push an image to a registry:
docker push registry-url/image-name:tag

# 43. Pull an image from a registry:
docker pull registry-url/image-name:tag

# 44. Build a Docker image using a Dockerfile:
docker build -t image-name .

# Show the logs of a running container: 
docker logs container-name

# Stop a running container: 
docker stop container-name

# Pause a running container: 
docker pause container-name

# Unpause a paused container: 
docker unpause container-name

# Restart a stopped container: 
docker restart container-name

# Monitor resource usage of containers: 
docker stats container-name