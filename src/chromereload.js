'use strict';

// Reload client for Chrome Apps & Extensions.
// The reload client has a compatibility with livereload.
// WARNING: only supports reload command.
//livePort 与chromereload.js 里port相同，当然默认是LIVERELOAD_PORT = 35729
var LIVERELOAD_HOST = 'localhost:';
var LIVERELOAD_PORT = 33333;
var connection = new WebSocket('ws://' + LIVERELOAD_HOST + LIVERELOAD_PORT + '/livereload');

connection.onerror = function (error) {
    console.log('reload connection got error' + JSON.stringify(error));
};

connection.onmessage = function (e) {
    if (e.data) {
        var data = JSON.parse(e.data);
        if (data && data.command === 'reload') {
            chrome.runtime.reload();
        }
    }
};
