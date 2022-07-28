
/*
    SETUP
*/
// Express
var express = require('express');   // We are using the express library for the web server
var app     = express();            // We need to instantiate an express object to interact with the server in our code
PORT        = 50000;                 // Set a port number at the top so it's easy to change in the future

/*
    ROUTES
*/

app.get('/index.html', function(req, res){
    res.sendFile('/index.html', {root: __dirname });
});

app.get('/battleactions.html', function(req, res){
    res.sendFile('/battleactions.html', {root: __dirname });
});

app.get('/homes.html', function(req, res){
    res.sendFile('/homes.html', {root: __dirname });
});

app.get('/spells.html', function(req, res){
    res.sendFile('/spells.html', {root: __dirname });
});

app.get('/abilities.html', function(req, res){
    res.sendFile('/abilities.html', {root: __dirname });
});

app.get('/characters.html', function(req, res){
    res.sendFile('/characters.html', {root: __dirname });
});

app.get('/characterSpells.html', function(req, res){
    res.sendFile('/characterSpells.html', {root: __dirname });
});

app.get('/characterActions.html', function(req, res){
    res.sendFile('/characterActions.html', {root: __dirname });
});

app.get('/abilityActions.html', function(req, res){
    res.sendFile('/abilityActions.html', {root: __dirname });
});

app.get('/spellActions.html', function(req, res){
    res.sendFile('/spellActions.html', {root: __dirname });
});


/*
    LISTENER
*/
app.listen(PORT, function(){            // This is the basic syntax for what is called the 'listener' which receives incoming requests on the specified PORT.
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});