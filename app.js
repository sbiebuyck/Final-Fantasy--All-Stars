
/*
    SETUP
*/
// Express

const { engine } = require('express-handlebars');
var exphbs = require('express-handlebars');     // Import express-handlebars
app.engine('.hbs', engine({extname: ".hbs"}));  // Create an instance of the handlebars engine to process templates
app.set('view engine', '.hbs');
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

    app.post('/addCharacter', function(req, res){
        let data = req.body;

        // Patrick - this section needs to be modified - not sure what we have that is NULL
        // let homeworld = parseInt(data['input-homeworld']);
        // if (isNaN(homeworld))
        // {
        //     homeworld = 'NULL'
        // }

        // let age = parseInt(data['input-age']);
        // if (isNaN(age))
        // {
        //     age = 'NULL'
        // }


        query1 = `INSERT INTO Characters (characterName, homeID, attack, health, mana, inParty, inBattle, abilityID) VALUES ('${data.characterName}', '${data.homeID}', ${attack}, ${health}, ${mana}, ${inBattle}, ${inParty}, ${abilityID})`;
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