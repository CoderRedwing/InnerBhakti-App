const multer = require('multer');


const storage = multer.memoryStorage();


const fileFilter = (req, file, cb) => {
  const allowedTypes = ['image/jpeg', 'image/png', 'audio/mpeg', 'audio/mp3'];
  if (allowedTypes.includes(file.mimetype)) {
    cb(null, true);
  } else {
    cb(new Error('Invalid file type. Only images and audio files are allowed.'));
  }
};


const uploadSingle = multer({ storage, fileFilter }).single('file');


const uploadMultiple = multer({ storage, fileFilter }).array('files', 5); 

module.exports = { uploadSingle, uploadMultiple };
