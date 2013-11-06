# Fahrplan

A simple http client for express REST APIs. The express API should expose a `/_meta` route that responds with the app.routes json.

## Example

    var Fahrplan = require("fahrplan");
    var my_api_client = new Fahrplan({host: "127.0.0.1",port: "80"});
    // calling GET /welcome
    fahrplan.welcome(function(err, result) {
        console.log(result);
    });

    // more info about the api client
    console.log(fahrplan._inspect());
