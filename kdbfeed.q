\l schema.q

// Function to add new price data
addPrice: {[src; prc]
    `.btcusd insert (.z.p; src; prc)
    }

// Start WebSocket listener
.z.ws: {
    data: .j.k x;
    addPrice[`$data`source; "F"$data`price];
    }

// Start HTTP listener for initial setup
.z.ph: {
    :enlist[`response]!enlist"WebSocket server running"
    }

// Start server
\p 5001