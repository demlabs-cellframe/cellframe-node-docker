# cellframe-node-docker
Scripts bundle to deploy container network full of nodes

#### Prerequisites:

* Docker
* Any linux-based system which supports bash v4.0+
* Multi-cored CPU and decent RAM capacity (the more - the better)

#### Installation:

1. Git clone
2. cd tmpfolder
3. ./dockerini.sh <container_name_template> <ports_range> <amount of containers> <Internal IP network with /24 range>

for example
./dockerini.sh cellframe-test 8083:8093 10 10.11.12.0
will create 10 containers with names cellframe-test_<NUM> (from 1 to 10), redirected ports from 8083 to 8092 and internal networks from 10.11.13.0 to 10.11.22.0

#### How it works:
TBC