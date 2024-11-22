const mongoose = require('mongoose');

const AudioTrackSchema = new mongoose.Schema({
  title: { type: String, required: true },
  audioUrl: { type: String, required: true },
  duration: { type: String, required: true },
});

module.exports = mongoose.model('AudioTrack', AudioTrackSchema);
