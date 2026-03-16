# SmartLock Manager Demo

**SmartLock Manager** is a demo Phoenix LiveView application showcasing real-time updates, asynchronous IoT 
simulations, and an interactive dashboard. This app is designed to demonstrate Elixir, Phoenix LiveView, and 
real-time streaming concepts in a concise and visually engaging way.

When I initially started researching Elixir, I couldn't find too many real world applications 
that didn't require logins to see some basic functionality. If you are
looking for a basic working example of Elixir with Phoenix LiveView, this is a good option. If you have other good 
options to share please open an issue the repo and share a link. 

---

In the gif below, note that there are two tabs open, but pointing to the same URL. The purpose is to show the real-time
streaming updates across separate instances of the application.

![Smartlock Demo](assets/demo.gif)

---

## Purpose

This application simulates a fleet of smart locks with features including:

- **Real-time lock status updates** across multiple browser tabs.
- **Async command processing** (lock/unlock) with "Processing" state.
- **Simulated heartbeats** to show device connectivity.
- **Reset Demo** to quickly restore initial state.
- **Delete locks** with immediate updates to all connected clients.
- **Live pagination** for large datasets.
---

## Live Demo

A live version is hosted on Fly.io: [https://smartlock.fly.dev](https://smartlock.fly.dev)

---

## Project Structure

```
smartlock/
├── assets/                  # Frontend: CSS, JS, demo media
├── config/                  # Environment configs: dev, prod, test
├── lib/
│   ├── smartlock/           # Core logic
│   │   ├── locks.ex         # Lock operations and business logic
│   │   ├── locks/lock.ex    # Lock schema
│   │   └── iot/lock_simulator.ex  # Simulated IoT behavior
│   └── smartlock_web/       # Web interface
│       ├── live/lock_live/  # LiveView dashboard
│       ├── components/      # Reusable UI components
│       └── router.ex        # Routes
├── priv/
│   ├── repo/migrations/     # DB migrations
│   └── static/favicon.png   # App favicon
├── test/                    # Tests: domain & LiveView
├── mix.exs                  # Elixir project
└── README.md                # Project overview & demo instructions
```

**Notes:**
- `locks.ex` handles lock toggling, deletion, and heartbeat updates.
- `lock_simulator.ex` runs the background IoT simulation.
- `lock_live/` drives the real-time dashboard using LiveView and PubSub.
- `components/` provides reusable UI elements like tables, headers, and flash messages.

## Features Demonstrated

| Feature | Description |
|---------|------------|
| Phoenix LiveView | Interactive UI with minimal JavaScript. |
| PubSub & Streams | Real-time updates broadcast to all connected clients. |
| Async Simulation | Locks show "Processing" when commands are issued. |
| Multi-tab Sync | Changes in one tab immediately update all others. |
| Pagination | Efficient handling of large lock lists with streaming. |
| Reset Demo | Quickly restore all locks to initial state. |
| Delete Lock | Remove locks with instant broadcast. |

---

## Local Development - Getting Started

### Prerequisites

- Elixir ~> 1.15
- Erlang/OTP ~> 26
- PostgreSQL
- Node.js & Tailwind CSS (for assets)

### Setup

1. Clone the repo:

```bash
git clone https://github.com/blentz100/smartlock.git
cd smartlock
```

2. Install deps:
```
mix deps.get
cd assets && npm install && cd ..
```

3. Database setup:
```
mix ecto.setup
```

4. Start the dev server:
```
mix phx.server
```

5. Open your browser at `http://localhost:4000`

## Architecture Highlights
- Lock Simulator: GenServer that periodically simulates lock heartbeats and random state changes.

- LiveView Table: Uses Phoenix.LiveView.Streams for efficient streaming and updates.

- Broadcasts: PubSub broadcasts keep all clients in sync without polling.

- Responsive UX: Status badges, processing indicators, and toast messages enhance demo polish.

