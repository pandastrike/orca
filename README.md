# Orca

Orca simplifies simulation-based distributed load testing.

## Current Status

A new version of Orca is in the works. This will be ES6-based and use Docker and CoreOS to deploy drones to an Orca cluster.

## Installation

> TODO: We'll add this once we release this version of Orca.

## Getting Started

You can try Orca on your local machine. We'll use an example application.

1. Since this version is still under development, you'll need to clone the Orca repo and install it from source.

  ```
  git clone https://github.com/pandastrike/orca.git
  cd orca && npm install -g
  ```

2. Install and start Redis. We'll use the default port. (This is configurable, but that's what the example uses.)

3. Clone the Orca examples repository and change to the examples directory:

  ```
  git clone https://github.com/pandastrike/orca-examples.git
  cd orca-examples
  ```

4. Start the echo server:

  ```
  coffee echo/app/server.coffee
  ```

4. In a new shell, start the leader.

  ```
  (cd echo/leader && orca-leader .)
  ```

5. In a separate shell, start a drone. We also have to set the `NODE_PATH` variable, so that Node will look for locally installed modules.

  ```
  (cd echo/drone && NODE_PATH=$NODE_PATH:./node_modules orca-drone .)
  ```

The leader will wait for the drone to install the test package (which is in `test`) and then run a simple test, verifying that the echo server is working.

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
[ { result: 'hello' } ]
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
