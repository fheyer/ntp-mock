# Delivering mock time with NTP

The included NTP server can be used to update clients with a fake time. For example this allows running time dependent tests on clients connected over a network.
The delta to correct time is controlled by env variable `FAKETIME` (on command line or in `.env`).
For example set

    FAKETIME=-15y

to let the NTP server deliver a time fifteen years in the past.
Clients have to be set up to use the mock time source via the IP of the host Docker runs on.

## Build and run

### Run as a service using docker compose

A Dockerfile and a service definition for docker compose are included. 
So after setting up `.env` you can run the service using docker compose:

    docker compose build && docker compose up -d ntp

After changes to `FAKETIME` the NTP service has to be restarted:

    docker compose stop ntp && docker compose up -d ntp

### Run manually using Docker

Alternatively you can run the service purely with Docker providing the complete setup in the parameters of `docker run`:

    docker build -t ntp-mock:latest . && docker run -p 127.0.0.1:123:123/udp --env FAKETIME=+15d ntp-mock:latest

