# Orca Architecture

Orca leverages state-of-the-art components to run test scripts and report results across a cluster of nodes in a coordinated fashion.

* Redis is used for messaging between the Orca Leader and the Drones

* Docker is used to ensure Drones run in a consistent environment

* Fleet is used to allocate Drones to a CoreOS cluster

* NPM is used to package tests and reliably install them

* Results are reported to ElasticSearch in real-time

* Kibana is used to analyze and report on results

```
           +----------------+
           |                |          +------> NPM
           |     Leader     |          |
           |                |          |
           +----------------+          |   Drones install
                                       |   tests...
                   ^                   |
                   |                   |
                   |       +-----------+-------------------------------+
         Redis     |       |                                           |
       Messaging   |       |                                           |
       Transport   |       |   +----------------+                      |
                   |       |   |                |                      |
                   +-----> |   |     Drone      |     ... many Drones  |
                           |   |                |                      |
                           |   +----------------+                      |
                           |    Docker Container                       |
                           |                                           |
                           +---------+---+ CoreOS-Cluster +------------+
    Fleet is used                    |
    to deploy Drones                 |
    to CoreOS cluster                |   Drones report
                                     |   results...
                                     |
                                     v                    Fleet can also
                                                          deploy any of the
                            +-----------------+           other components
           Kibana           |                 |
         Dashboard +----->  |  ElasticSearch  |
                            |                 |
                            +-----------------+

```
