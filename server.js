'use strict';

var express = require('express');
var morgan = require('morgan'); // Require the morgan package

var app = express();

// Setup view engine
app.set('view engine', 'jade');

// Add the morgan middleware for logging
app.use(morgan('combined'));

app.use(express.static(__dirname + '/dist'));

app.get('/', function(req, res) {
  res.render('index');
});

var server = app.listen(
  process.env.PORT || 8081,
  '0.0.0.0',
  function () {
    var address = server.address().address;
    var port = server.address().port;
    console.log('App listening at http://%s:%s', address, port);
    console.log('Press Ctrl+C to quit.');
  }
);
