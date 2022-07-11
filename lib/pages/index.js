var waveformData = require("waveform-data")
var fetch = require("node-fetch")
fetch('https://firebasestorage.googleapis.com/v0/b/cdac-9f9c9.appspot.com/o/Audio%2Ftest?alt=media&token=50be1d23-21fa-449c-90b3-ec6c71c24c04')
    .then(response => response.arrayBuffer())
    .then(buffer => WaveformData.create(buffer))
    .then(waveform => {
        console.log(`Waveform has ${waveform.channels} channels`);
        console.log(`Waveform has length ${waveform.length} points`);
    });