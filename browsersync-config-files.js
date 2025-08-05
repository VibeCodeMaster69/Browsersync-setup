// bs-config.js - BrowserSync configuration
module.exports = {
    // Proxy the UniSat website
    proxy: "https://unisat.io",
    
    // Use your local IP for external access
    host: "192.168.254.146",
    
    // Port configuration
    port: 3000,
    ui: {
        port: 3001
    },
    
    // Only sync clicks and form inputs (not scrolling or navigation)
    ghostMode: {
        clicks: true,
        forms: {
            inputs: true,
            toggles: true,
            submit: false
        },
        scroll: false,
        location: false
    },
    
    // Don't automatically open browser
    open: false,
    
    // Don't show notifications
    notify: false,
    
    // Logging
    logLevel: "info",
    logPrefix: "NFT-Sync",
    
    // Improve performance for many connections
    socket: {
        socketIoOptions: {
            transports: ['websocket'],
            pingTimeout: 60000,
            pingInterval: 25000
        }
    },
    
    // CORS for external site
    cors: true,
    
    // Don't watch files since we're proxying
    files: false,
    
    // Snippet options
    snippetOptions: {
        async: true,
        whitelist: ["*"],
        rule: {
            match: /<\/body>/i,
            fn: function (snippet, match) {
                return snippet + match;
            }
        }
    }
};

// package.json - Already exists, but here's what it should contain
/*
{
  "name": "browsersync-nft",
  "version": "1.0.0",
  "description": "BrowserSync setup for NFT minting",
  "main": "index.js",
  "scripts": {
    "start": "browser-sync start --config bs-config.js",
    "proxy": "browser-sync start --proxy 'https://unisat.io' --host '192.168.254.146' --no-open",
    "test": "browser-sync start --server --no-open"
  },
  "devDependencies": {
    "browser-sync": "^2.29.3"
  }
}
*/