const express = require('express');
const router = express.Router();
const { uploadSingleFile, uploadMultipleFiles } = require('../controllers/uploadController');
const { uploadSingle, uploadMultiple } = require('../middlewares/uploadMiddleware');

router.post('/single', uploadSingle, uploadSingleFile);

router.post('/multiple', uploadMultiple, uploadMultipleFiles);

module.exports = router;
