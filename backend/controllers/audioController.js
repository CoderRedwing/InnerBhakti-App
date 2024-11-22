const AudioTrack = require('../models/AudioTrack');

// Fetch all audio tracks
exports.getAllAudioTracks = async (req, res) => {
  try {
    const audioTracks = await AudioTrack.find(); // Fetch all tracks
    res.status(200).json(audioTracks);
  } catch (err) {
    console.error('Error fetching audio tracks:', err);
    res.status(500).json({ error: 'Failed to fetch audio tracks', details: err.message });
  }
};

// Fetch a specific audio track by ID
exports.getAudioTrack = async (req, res) => {
  try {
    const audioTrack = await AudioTrack.findById(req.params.id); // Fetch track by ID
    if (!audioTrack) {
      return res.status(404).json({ error: 'Audio track not found' });
    }
    res.status(200).json(audioTrack);
  } catch (err) {
    console.error('Error fetching audio track:', err);
    res.status(500).json({ error: 'Failed to fetch audio track', details: err.message });
  }
};
