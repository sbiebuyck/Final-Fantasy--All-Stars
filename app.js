
/*
    SETUP
*/

// handlebars
const { engine } = require('express-handlebars');
var exphbs = require('express-handlebars');     // Import express-handlebars
app.engine('.hbs', engine({extname: ".hbs"}));  // Create an instance of the handlebars engine to process templates
app.set('view engine', '.hbs');                 // Tell express to use the handlebars engine whenever it encounters a *.hbs file.

// Express
var express = require('express');   // We are using the express library for the web server
var app     = express.json();            // We need to instantiate an express object to interact with the server in our code
PORT        = 50000;                 // Set a port number at the top so it's easy to change in the future


/*
    ROUTES
*/

app.get('/', function(req, res)
    {
        let query1 = "SELECT * FROM dml;";

        db.pool.query(query1, function(error, rows, fields){

            res.render('index', {data: rows});
        })
    });

app.post('/updateCharacter'), function(req, res){
    let data = req.body;
    query = `UPDATE Characters SET
        characterName = ${data.characterName}, homeID = (SELECT homeID FROM Homes WHERE homeName = ${data.homeName}, attack = ${data.attack}, health = ${data.health}, mana = ${data.mana}, inParty = ${data.inParty}, inBattle = ${data.inBattle}, abilityID = (SELECT abilityID FROM Abilities WHERE abilityName = ${data.abilityName}
    WHERE characterName = ${data.characterName};`;
    db.pool.query(query, function(error, rows, fields){
        if (error) {
            console.log(error)
            res.sendStatus(400);
        }
        else
        {
            res.redirect('/');
        }
    })
}

app.post('/deleteCharacter'), function(req, res){
    let data = req.body;
    query = `DELETE FROM Characters WHERE characterID = ${data.characterID}`;
    db.pool.query(query, function(error, rows, fields){
        if (error) {
            console.log(error)
            res.sendStatus(400);
        }
        else
        {
            res.redirect('/');
        }
    })
}

app.post('/addCharacter', function(req, res){
    let data = req.body;

    let homeID = data.homeID;
    if (homeID === data.homeID)
    {
        homeID = 'NULL';
    }

    let abilityID = data.abilityID;
    if (abilityID === null)
    {
        abilityID = 'NULL';
    }

    let inBattle = data.inBattle;
    if (inBattle === null)
    {
        inBattle = 'NULL';
    }

    let inParty = data.inParty;
    if (inParty === null)
    {
        inParty = 'NULL';
    }

    query1 = `INSERT INTO Characters (characterName, homeID, attack, health, mana, inParty, inBattle, abilityID) VALUES ('${data.characterName}', '${homeID}', ${data.attack}, ${data.health}, ${data.mana}, ${inBattle}, ${inParty}, ${abilityID})`;
    db.pool.query(query1, function(error, rows, fields){


        if (error) {

            console.log(error)
            res.sendStatus(400);
        }

        else
        {
            res.redirect('/');
        }
    })
});


/*
    LISTENER
*/
app.listen(PORT, function(){            // This is the basic syntax for what is called the 'listener' which receives incoming requests on the specified PORT.
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});