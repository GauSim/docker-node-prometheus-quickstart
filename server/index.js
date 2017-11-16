const client = require('prom-client');
const http = require('http');


const collectDefaultMetrics = client.collectDefaultMetrics;

// Probe every 5th second.
collectDefaultMetrics({ timeout: 5000 });

const counter = new client.Counter({ name: 'simons_counter', help: 'test counter from simon' });

// map to metrics
const server = http.createServer((req, res) => {


  const metrics = client.register.metrics();

  res.setHeader('Content-Type', 'text/html');
  res.setHeader('X-Foo', 'bar');
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  
  res.end(metrics);

  counter.inc(1); 
  

}).listen(3000);