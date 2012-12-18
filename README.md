# Orca:  Distributed load testing

Orca provides tools and a simple protocol for running distributed load tests of any kind of service.  You supply an NPM-installable package that implements the load test, and Orca arranges for its performance across the desired number of test clients.

Orca also provides a REST API service for inspecting results and a web application for visualizing them.

## Test packages

An Orca test package is simply a Node.js module which exports a test class. The test class must implement a `run` method, in which the load testing work is performed.  Orca test clients install the package at runtime, using a reference provided by the test orchestrator.  Any package reference supported by NPM will work.

## Orca in action

Load testing is managed by two kinds of components

* Leader: orchestrates the distributed load test and stores the results.
* Nodes: perform the actual load testing.

Orca conducts a load test in three distinct phases:

### Announce

The leader publishes a message announcing a load test, then waits for the required number of nodes to respond.  If too few nodes respond within a reasonable amount of time, the leader aborts.

### Prepare

The leader publishes a message describing the test package and options.  Nodes install the package and instantiate the test class with the provided options.  Nodes report success or failure of the preparation stage to the leader, which aborts the test run on any failures.

### Run:

A full test consists of several upward steps in concurrency. For each level, the leader publishes a message instructing the nodes to generate load at the specified concurrency. The leader then waits until all nodes have completed the test and reported their results before moving on to the next step.

When all steps have been completed, the leader stores the combined results in MongoDB and prints to stdout a BSON query sufficient to locate the results.


## System software dependencies

* node.js 0.8.x
* ruby 1.9.x: Rake is used for development, testing, and build tasks
* redis: message transport between components
* mongodb: test result storage


## Usage

Run `npm install` in the project's top level directory to install the required dependencies.

### Leader

    bin/lead -c path/to/config.cson -t path/to/test_spec.cson

A command line tool which orchestrates the performance of the distributed load testing.  The `name` field of the test specification determines which pubsub channel will be used to communicate with the clients.


### Distributed Nodes

    bin/node -c path/to/config.cson -n test_name

The agents that actually run the load tests.  The test_name flag determines which pubsub channel will be used for communicating with the leader.


### API Server

    bin/api_server -c path/to/config.cson

Runs an HTTP service which dispatches requests as tasks in message queues.  Workers take the tasks, process them, and return results to the API Server, which uses the results to craft HTTP responses.


### API Worker

    bin/tests_worker -c path/to/config.cson

Retrieves test results from MongoDB and formats them as needed. This may include aggregation and analysis.

### Orca Web

    rake build:web # output to build/web

A rich web application for displaying test results, consisting of HTML/CSS/JS only, and can be served by any web server (e.g. Apache, nginx).  The application communicates with the Orca reporting API, which means it needs to know where you are running the API server. This is accomplished by providing a configuration file at build time.


## Configuration files

Orca uses configuration files in CSON format, which is like JSON, but with CoffeeScript syntax. No more brace or comma woes, and comments are allowed.

### Environment:

    redis:
      host: "localhost"
      port: 6379
    mongo:
      host: "localhost"
      port: 27017
      database: "orca"
    api:
      port: 8000
      service_url: "http://localhost:8000"

### Test specification:

    name: "example_test"
    description: "A trivial HTTP request"
    quorum: 2
    repeat: 3
    step: 16
    timeout: 5000 # 5 seconds
    package: 
      # a reference usable by `npm install`
      reference: "http://github.com/dyoder/orca-test/tarball/master"
      # the module name to require
      name: "orca-test"
    options:
      # Options to provide to the test module's run method
      # Here, it's merely the location of the service to be load tested.
      service:
        url: "http://localhost:1337"

## Reporting API

* [Resource specification](api/resources.coffee)
* [Schemas](api/schema.coffee)
