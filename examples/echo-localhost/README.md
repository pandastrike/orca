# Orca: Echo Example - Local Machine
A *Hello World* introduction to Orca, simulation-based distributed load testing.

## Introduction
This example takes you through the basics of how Orca functions, but without needing to deploy CoreOS and Docker.  Our end goal is to deploy an Orca Drone to test against a simple Node Server.

## Installation
You will need the following on your local machine to run this demo.
1. Git
2. [Redis](http://redis.io/)
3. Node v0.11  This version of Node contains the powerful concurrency technology, generators.  Orca's components are built from these to make the code simpler and shorter.

    i. If if it is not already present, install nvm from source and source the shell script we download.  If you already have nvm, skip to step *ii.*
    ```
    git clone https://github.com/creationix/nvm.git ~/.nvm && \
      cd ~/.nvm && \
      git checkout `git describe --abbrev=0 --tags`

    source ~/.nvm/nvm.sh &&
    ```

    ii. Install v0.11
    ```
    nvm install 0.11
    ```

4. The correct version of CoffeeScript.  While it has not been placed into the official npm package, the `master` branch of the primary CoffeeScript repo has what we need.  It can accept the `--harmony` flag and use ES6 based generators in Node.

    ```
    npm install -g jashkenas/coffee-script
    ```


## Getting Started

1. Start Redis. We'll use the default port. (This is configurable, but that's what the example uses.)

2. In a new shell, clone the Orca repo and install Node components.  The next steps will reference the top level of the Orca repo as `~/orca`, so replace `~` with wherever you have placed the Orca repo.

  ```
  git clone https://github.com/pandastrike/orca.git
  cd orca && npm install
  ```

3. Change to the echo-localhost example directory.  We will use files out of this directory for the next several steps.

  ```
  cd examples/echo-localhost
  ```

4. Start the echo server.  This is the service Orca will test against.

  ```
  coffee target-app/echo.coffee

  >==========================================
  >    The server is online and ready.
  >==========================================
  ```

5. In a new shell, start the Leader. Change to the Leader configuration directory and pass that path as an argument to the Leader.  You should see the Leader announcing tests indefinitely.

  ```
  (cd ~/orca/examples/echo-localhost/leader && ~/orca/bin/orca-leader .)
  ```

6. In a new shell, start a Drone.

  The Drone places a `node_modules/` directory with the Drone configuration file.  This contains required modules for the test, but we must alert Node to their presence.  Add this path to the `NODE_PATH` environmental variable, a series of colon-delimited module paths.

  ```
  (cd echo/drone && NODE_PATH=$NODE_PATH:./node_modules ~/orca/bin/orca-drone .)
  ```

7. The leader will wait for the drone to install the test package (which is in `test`) and then run a simple test, verifying that the echo server is working.

The output from the leader should look something like this:

```
[2014-10-26 13:15:19.061] [DEBUG] [default] - Waiting for replies...
[2014-10-26 13:15:19.074] [DEBUG] [default] - Subscribed to orca.5be4f5c50c0966ed.drones...
[2014-10-26 13:15:20.062] [DEBUG] [default] - Announcing test...
[2014-10-26 13:15:21.069] [DEBUG] [default] - Announcing test...
[2014-10-26 13:15:22.072] [DEBUG] [default] - Announcing test...
[2014-10-26 13:15:23.074] [DEBUG] [default] - Announcing test...
[2014-10-26 13:15:23.357] [DEBUG] [default] - 1 drones have joined...
[2014-10-26 13:15:23.357] [DEBUG] [default] - Quorum reached, beginning test...
[2014-10-26 13:15:23.368] [DEBUG] [default] - 1 results in...
[2014-10-26 13:15:23.368] [DEBUG] [default] - All the results are in
[ { result: 'Pandas Are Awesome.' } ]
```

The output from the drone should look like:

```
[2014-10-26 13:15:21.688] [DEBUG] [default] - Subscribing to orca.broadcast
[2014-10-26 13:15:21.701] [DEBUG] [default] - Awaiting test announcement...
[2014-10-26 13:15:22.073] [DEBUG] [default] - Test test announced...
[2014-10-26 13:15:22.078] [DEBUG] [default] - Installing test package...
npm http GET https://registry.npmjs.org/when
npm http 304 https://registry.npmjs.org/when
test@1.0.0 node_modules/test
└── when@3.5.1
[2014-10-26 13:15:23.354] [DEBUG] [default] - Publishing join message...
[2014-10-26 13:15:23.358] [DEBUG] [default] - Beginning test...
[2014-10-26 13:15:23.359] [DEBUG] [default] - Preparing test...
[2014-10-26 13:15:23.359] [DEBUG] [default] - Running test...
[2014-10-26 13:15:23.360] [DEBUG] [default] - Sending message: hello
[2014-10-26 13:15:23.366] [DEBUG] [default] - Received message: hello
[2014-10-26 13:15:23.367] [DEBUG] [default] - Test complete sending results...
```

## Architecture
If you got results similar to what's shown above, congratulations, you've successfully deployed a small Orca system on you local machine.  Orca is really meant to be deployed in a remote cluster of machines, but we can discuss its basic parts here.

### The Target
Orca is designed to load test an app or service through its web interface. So to use Orca, you need to be able to point it at something.  And it doesn't need to be on the same machine as the rest of Orca...  all you need is the IP address of the interface, and Orca takes care of the rest.  To keep things simple here, the target is a one-line Node server that echoes whatever text it receives.

### The Test
For this example, to keep things simple, the test is a single http call that transmits a hard-coded string, "Pandas Are Awesome." (*Because it's true!!*)

### Drones
Now, to keep things simple in this example, there is only one Drone testing our target server.  But know that Drones can work together in swarms of arbitrary size, and that's the power of Orca.

### The Leader
The swarm is a mighty tool, but it needs direction.  This is provided by the Leader, which is responsible for announcing tests to the swarm, gathering Drones until a quorum is reached, launching the test with that quorum, and then collecting the results.

For this example, we only needed one Drone, so it was a quorum of 1.

The Leader communicates with Drones by using Redis's publish-submit mechanism.  Using Redis means the Leader doesn't need to know the location of each Drone, everyone just needs to be able to locate Redis.  

We use the `config.cson` files to tell:
- The Leader which tests to announce.
- The Leader and Drones the location of Redis.
