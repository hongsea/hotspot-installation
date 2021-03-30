var express = require('express');
var app = express();
var path = require('path');

// viewed at http://localhost:8080
app.use(express.static('public'))
app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname + '/'));
});

app.get('/how', function(req, res) {
    res.sendFile(path.join(__dirname + '/public/how.html'));
});

app.listen(8080);