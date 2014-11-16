# Orca: Echo Example
A *Hello World* introduction to Orca, simulation-based distributed load testing.

## Introduction
We're going to use PandaStrike's CoreOS test cluster, which we're running on Amazon's EC2 service for you, to introduce you to Orca.  This example takes you through the basics of how Orca functions on the CoreOS + Docker cloud platform.  Our end goal is to deploy a single Orca Drone to test against a simple Node Server.

Spinning up a CoreOS cluster is not the focus of this tutorial.  However, CoreOS provides a regularly updated, publicly available image of their OS, so building a cluster on Amazon (or any cloud provider) is relatively painless.

## Prerequisites

You'll need:

1. To coordinate with us to get your **public key** into our cluster for SSH access.

2. Your **userID**, a value ranging from 00 to 99

3. **git** to pull this repo.

4. The orchestration tool, **fleetctl**.  This is available via your OS package manager.

OSX users with HomeBrew can use:

    brew install fleetctl

Ubuntu users can use:

    apt-get install fleetctl



## Getting Started

1. Assuming that we've got your public key entered into our cluster as an `authorized_key`, you should be ready to get your hands dirty.

  Verify that your setup is configured properly by running:
  ```
  fleetctl --tunnel coreos.pandastrike.com list-machines
  ```
  If everything is working, this will produce a list of every CoreOS machine in our cluster, and will look something like this.
  ```
  > MACHINE		IP		        METADATA
  > 05cd8495...	10.229.64.167	 -
  > 50b58f24...	10.250.163.185	-
  > c0171bc5...	10.228.6.17	   -
  ```

2. Clone this repo to your local machine.

  ```
  git clone https://github.com/pandastrike/orca.git
  cd orca/examples/echo
  ```

3. Now, we will use fleetctl's `start` command. CoreOS relies on `*.service` files to specify jobs for the cluster (See *CoreOS* in the main README for more information). `reflector@.service` is a *template* service file, so you'll need to add your userID to the filename (only within the command).  For the rest of this tutorial, user `02` will be shown.

  To access the cluster from your local machine, we need to use fleetctl's `--tunnel <address>` flag, which will make use of SSH for you.  With this flag, you only need to type the specific fleetctl command and the service it applies to.  Let's begin with Redis.

  ```
  fleetctl --tunnel coreos.pandastrike.com start redis@02.service
  ```

4. Now we are going to monitor what you just deployed with fleetctl's `journal` command.  Your job has been deployed on the CoreOS cluster, but where is it? Even though it could be on any one of several machines, you can always reference this and any other job through its `*.service` file.

  ```
  fleetctl --tunnel coreos.pandastrike.com journal -f --lines=30 redis@02.service
  ```
  Ignore `Error response from daemon: No such container` if it appears in your log.  This is an optional command used to clear away any old container that shares a name with one you're about to start.

  It might take a moment, and there will be several debugging and informational messages, but eventually you will see a message indicating Redis is ready.  You can stop the CoreOS journaling with `ctrl+C`.

  ```
  Starting CoreOS Reflector Demo...
  ======================================
  New Service Started
  ======================================
  Public IP Address: 54.67.24.1
  Private IP Address: 172.31.14.119
  {"host":"54.67.24.1", "port":6379}
  redis
  redis
  Pulling repository dockerfile/redis
  Started Spin Up Redis.
  Status: Image is up to date for dockerfile/redis:latest
  _._
  _.-``__ ''-._
  _.-``    `.  `_.  ''-._           Redis 2.8.17 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._
  (    '      ,       .-`  | `,    )     Running in stand alone mode
  |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
  |    `-._   `._    /     _.-'    |     PID: 1
  `-._    `-._  `-./  _.-'    _.-'
  |`-._`-._    `-.__.-'    _.-'_.-'|
  |    `-._`-._        _.-'_.-'    |           http://redis.io
  `-._    `-._`-.__.-'_.-'    _.-'
  |`-._`-._    `-.__.-'    _.-'_.-'|
  |    `-._`-._        _.-'_.-'    |
  `-._    `-._`-.__.-'_.-'    _.-'
  `-._    `-.__.-'    _.-'
  `-._        _.-'
  `-.__.-'
  [1] 12 Nov 09:58:38.559 # Server started, Redis version 2.8.17
  ```

5. The various components of Orca are explained in detail in the main README.  We will simply proceed with their deployment here and only provide a brief description.

  ```
  fleetctl --tunnel coreos.pandastrike.com start target@02.service leader@02.service drone@0200.service
  ```
  - target = The echo server.  This is the service Orca will test against.
  - leader = The Orca Leader.  The Leader announces tests indefinitely, waiting for a reply.
  - drone = The Orca Drone.  The Drone conducts the test against the target and returns a result to the leader.

  **Note:** The Drone service file has the identifier `0200`.  Because you will usually launch more than one Drone, your userID is not enough to provide unique names in the cluster.  Please add an additional ID for the Drone, 00 to 99 (or 000 to 999, etc).  The service file will recognize the userID of `02` for IP lookups, and Docker containers will bear the full `02**` ID.

6. Review the logs from `leader@02.service`.

  ```
  fleetctl --tunnel coreos.pandastrike.com journal -f --lines=30 leader@02.service
  ```

  If everything works out, it should look something like this:
  ```
  [2014-11-12 10:08:34.824] [DEBUG] [default] - Waiting for replies...
  [2014-11-12 10:08:34.852] [DEBUG] [default] - Subscribed to orca.168e1902c1d73792.drones...
  [2014-11-12 10:08:35.825] [DEBUG] [default] - Announcing test...
  [2014-11-12 10:08:36.838] [DEBUG] [default] - Announcing test...
  [2014-11-12 10:08:37.851] [DEBUG] [default] - Announcing test...
  [2014-11-12 10:08:56.313] [DEBUG] [default] - 1 drones have joined...
  [2014-11-12 10:08:56.313] [DEBUG] [default] - Quorum reached, beginning test...
  [2014-11-12 10:08:56.342] [DEBUG] [default] - 1 results in...
  [2014-11-12 10:08:56.342] [DEBUG] [default] - All the results are in
  [ { result: 'Pandas Are Awesome.' } ]
  ```

  Say it with me:  **Pandas Are Awesome.**  Congratulations, you have successfully completed your first Orca deployment in the cloud!

## Shutdown
You can stop the CoreOS journaling with `ctrl+C`.

  We also have to be considerate and release cluster resources when we are done.  To release the CoreOS machine running our job, we use the `stop` command and reference the service name.

  ```
  fleetctl --tunnel coreos.pandastrike.com stop reflector@02.service
  > Unit reflector.service loaded on 05cd8495.../10.229.64.167
  ```

  To remove the service from the cluster's pool we must use the `destroy` command.
  ```
  fleetctl --tunnel coreos.pandastrike.com destroy reflector@02.service
  > Destroyed reflector.service
  ```
  **Note: This command is also important if we edit our `*.service` file locally and want to give the cluster the new version.  We must destroy the old version first.**

## Architecture
The following covers some specifics for this example, but please see the main README for more context.

### The Target
Orca is designed to load test an app or service through its web interface. The target doesn't need to be on the same machine or cluster as the rest of Orca...  all you need is the IP address of the interface, and Orca takes care of the rest.  To keep things simple here, the target is a one-line Node server that echoes whatever text it receives.

### The Test
For this example, to keep things simple, the test is a single http call that transmits a hard-coded string, "Pandas Are Awesome." (*Because it's true!!*)

### Drones
Now, to keep things simple in this example, there is only one Drone testing our target server.  But know that Drones can work together in swarms of arbitrary size, and that's the power of Orca.

### The Leader
The swarm is a mighty tool, but it needs direction.  This is provided by the Leader, which is responsible for announcing tests to the swarm, gathering Drones until a quorum is reached, launching the test with that quorum, and then collecting the results.

For this example, we only needed one Drone, so it was a quorum of 1.

The Leader communicates with Drones by using Redis's publish-submit mechanism.  Using Redis means the Leader doesn't need to know the location of each Drone, everyone just needs to be able to locate Redis.  

We use the `config.cson` files to tell the Leader and Drones the location of Redis.
