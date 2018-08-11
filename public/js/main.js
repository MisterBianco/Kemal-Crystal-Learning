'use strict'

var tv = document.getElementById("tv");
var channels = [
    "Speedy | Fun | Efficient",
    "Jarads Favorite Web Server",
    "GMO and Gluten Free | 100% VEGAN",
    "Like my messages? Like muh project."
];
var i = 0;

window.setInterval(function() {

    i = i == channels.length ? 0 : i;
    let new_text = channels[i];
    $('#tv').text(new_text);

    i++;
}, 7000);
