const express = require('express');
const { getPrograms, getProgramDetails } = require('../controllers/programController');
const router = express.Router();

router.get('/', getPrograms);
router.get('/:id', getProgramDetails);

module.exports = router;
