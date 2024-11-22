const express = require('express');
const { getAudioTrack, getAllAudioTracks } = require('../controllers/audioController');
const router = express.Router();

router.get('/', getAllAudioTracks);
router.get('/:id', getAudioTrack);


module.exports = router;
