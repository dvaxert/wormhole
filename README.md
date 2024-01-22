# wormhole

## License
[![GitHub license](https://badgen.net/github/license/dvaxert/wormhole)](https://github.com/dvaxert/wormhole/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/dvaxert/wormhole.svg)](https://github.com/dvaxert/wormhole/releases/)
[![codecov](https://codecov.io/gh/dvaxert/wormhole/graph/badge.svg?token=HnPv7uHLGJ)](https://codecov.io/gh/dvaxert/wormhole) 
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fdvaxert%2Fwormhole.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fdvaxert%2Fwormhole?ref=badge_shield)
[![Windows](https://github.com/dvaxert/wormhole/actions/workflows/windows.yml/badge.svg?branch=master)](https://github.com/dvaxert/wormhole/actions/workflows/windows.yml)
[![Linux](https://github.com/dvaxert/wormhole/actions/workflows/linux.yml/badge.svg?branch=master)](https://github.com/dvaxert/wormhole/actions/workflows/linux.yml)
[![MacOS](https://github.com/dvaxert/wormhole/actions/workflows/macos.yml/badge.svg?branch=master)](https://github.com/dvaxert/wormhole/actions/workflows/macos.yml)

# wormhole

## About 

**Wormhole** is an application for the flexible creation of [p2p](https://en.wikipedia.org/wiki/Peer-to-peer) (*peer-to-peer*) networks between users using [webrtc](https://webrtc.org/?hl=en) technology and open servers running this technology. The signaling server in this case is various applications, such as [telegram](https://telegram.org/), by which signaling messages can be delivered between users. Solutions based on other technologies can also act as a signaling server. All signaling messages are encrypted using the [openssl](https://www.openssl.org/) library and are therefore either inaccessible or inaccessible.

**Wormhole** involves networking for private use, such as:
* Gaining access to a home LAN.
* Creating a local network for playing online games together.

## How it works

1. Client and server users register with a signaling server, e.g. `telegram` bot.

> *The client and server can be different devices of the same user.*

2. Client and server users add each other to the whitelists of users with whom they are allowed to communicate.

> *This also exchanges the public part of the sync-key and creates specific settings for this user.*

3. The client requests a connection to the host.

> *Messages are exchanged via the signaling server.*

4. Programs on the users' computers verify each other's certificates and connection settings. The programs also negotiate the webrtc servers used to establish the connection.

5. The connection is established through the selected servers.

6. A virtual device emulating a local network is created for the convenience of users.

## C4 model diagrams

System level diagram

![System context diagram](/doc/system_context_diagram.png "System level diagram")

Container diagram

![Container diagram](/doc/container_diagram.png "Component diagram")

Component diagram

![System context diagram](/doc/component_diagram.png "Component diagram")

## Build program

TODO

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fdvaxert%2Fwormhole.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fdvaxert%2Fwormhole?ref=badge_large)
