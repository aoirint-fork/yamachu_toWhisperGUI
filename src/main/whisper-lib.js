'use strict';

const {ipcMain} = require('electron');
const path = require('path');
const edge = require('@yamachu/edge');

let edgeInitializer = edge.func({
    assemblyFile: path.join(process.env.EDGE_APP_ROOT, 'ToWhisper.dll'),
    typeName: 'ToWhisper.Program',
    methodName: 'Invoke',
});

let edgeInstance = edgeInitializer(null, true);

ipcMain.on('set_parameters', (event, arg) => {
    edgeInstance.setParameters(arg, (err, result) => {
        if (err) {
            event.sender.send('set_parameters', {error: true});
        } else {
            event.sender.send('set_parameters', {});
        }
    });
});

ipcMain.on('reset_parameters', (event, arg) => {
    edgeInstance.resetParameters(null, (err, result) => {
        if (err) {
            event.sender.send('reset_parameters', {error: true});
        } else {
            event.sender.send('reset_parameters', {});
        }
    });
});

ipcMain.on('do_synth', (event, arg) => {
    edgeInstance.generateWhisper(arg, (err, result) => {
        if (result != null && result.error !== undefined) {
            event.sender.send('done_synth', {error: result.error});
        } else {
            event.sender.send('done_synth', {});
        }
    });
});
