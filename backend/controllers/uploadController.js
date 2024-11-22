const { uploadFile, uploadFiles } = require('../config/cloudStorage');
const AudioTrack = require('../models/AudioTrack');
const Program = require('../models/Program'); // Fixed capitalization issue
const ffprobe = require('ffprobe');
const ffprobeStatic = require('ffprobe-static');
const ffmpeg = require('fluent-ffmpeg'); // Import ffmpeg

const getAudioDuration = (buffer) => {
  return new Promise((resolve, reject) => {
    const tmpFilePath = `/tmp/${Date.now()}_audio.mp3`;

    // Save the buffer to a temporary file
    require('fs').writeFileSync(tmpFilePath, buffer);

    // Use ffmpeg to extract duration
    ffmpeg(tmpFilePath)
      .ffprobe((err, metadata) => {
        // Clean up the temporary file
        require('fs').unlinkSync(tmpFilePath);

        if (err) return reject(err);
        const duration = metadata.format.duration; // Duration in seconds
        resolve(duration);
      });
  });
};

// Add track to program
const addTrackToProgram = async (programId, audioTrackId) => {
  const program = await Program.findById(programId);
  if (!program) {
    throw new Error('Program not found');
  }
  program.tracks.push(audioTrackId);
  await program.save();
};

// Handle single file upload
const uploadSingleFile = async (req, res) => {
  try {
    // Ensure a file is provided
    if (!req.file) {
      return res.status(400).json({ message: 'No file provided' });
    }

    if (!req.body.title) {
      return res.status(400).json({ message: 'Title is required' });
    }

    const { type } = req.body; // 'audio' or 'image'
    const validTypes = ['audio', 'image'];
    if (!validTypes.includes(type)) {
      return res.status(400).json({ message: 'Invalid type. Must be "audio" or "image".' });
    }

    const fileBuffer = req.file.buffer;
    const folder = type === 'audio' ? 'audio' : 'images'; // Categorize by type
    const fileUrl = await uploadFile(fileBuffer, folder); // Upload to correct folder

    let newRecord;

    if (type === 'audio') {
      const duration = await getAudioDuration(fileBuffer);
      newRecord = new AudioTrack({
        title: req.body.title,
        duration: `${Math.floor(duration / 60)}:${Math.floor(duration % 60)}`, // Format duration as MM:SS
        audioUrl: fileUrl, // Save URL in database
      });
      await newRecord.save();

  // Associate the audio track with a program (if there's a programId in the request)
      if (req.body.programId) {
        await addTrackToProgram(req.body.programId, newRecord._id);
      }

    } else if (type === 'image') {
      // Create the record for the image
      newRecord = new Program({
        title: req.body.title,
        imageUrl: fileUrl, // Save URL in database
        description: req.body.description,
        tracks: [],
      });
      await newRecord.save();
    }

    // Respond with uploaded data
    res.status(201).json({
      message: `Single ${type} uploaded successfully`,
      data: {
        ...newRecord._doc, // Include database record details
        audioUrl: fileUrl, // Return uploaded file URL for audio
      },
    });
  } catch (error) {
    console.error('Error details:', error);
    res.status(500).json({ message: 'Failed to upload file', error: error.message });
  }
};


const uploadMultipleFiles = async (req, res) => {
  try {
    if (!req.files || req.files.length === 0) {
      return res.status(400).json({ message: 'No files provided' });
    }

    const { type, programId } = req.body; // Make sure to get the programId from the request body
    const validTypes = ['audio', 'image'];

    if (!validTypes.includes(type)) {
      return res.status(400).json({ message: 'Invalid type. Must be "audio" or "image".' });
    }

    let titles;
    try {
      titles = JSON.parse(req.body.titles); // Parse the JSON string
    } catch (err) {
      return res.status(400).json({
        message: 'Titles must be a valid JSON array of strings. Example: ["Relaxing Sound 1", "Relaxing Sound 2"]',
      });
    }

    let descriptions = [];
    if (req.body.description) {
      try {
        descriptions = JSON.parse(req.body.description);
      } catch (err) {
        return res.status(400).json({
          message: 'Descriptions must be a valid JSON array of strings.',
        });
      }
    }

    const fileCount = req.files.length;

    if (!Array.isArray(titles) || titles.length !== fileCount) {
      return res.status(400).json({
        message: `Titles are required for all ${type}s. Please provide an array of ${fileCount} titles.`,
      });
    }

    if (descriptions.length && descriptions.length !== fileCount) {
      return res.status(400).json({
        message: `Descriptions must match the number of ${type}s. Please provide ${fileCount} descriptions.`,
      });
    }

    const fileBuffers = req.files.map((file) => file.buffer);
    const folder = type === 'audio' ? 'audio' : 'images';
    const fileUrls = await uploadFiles(fileBuffers, folder);

    let records;

    if (type === 'audio') {
      records = await Promise.all(
        fileUrls.map(async (audioUrl, index) => {
          const duration = await getAudioDuration(fileBuffers[index]); // Extract duration
          const newTrack = await new AudioTrack({
            title: titles[index],
            duration: `${Math.floor(duration / 60)}:${Math.floor(duration % 60)}`, // Save the duration
            audioUrl,
          }).save();

          // Add the new track to the program
          if (programId) {
            const program = await Program.findById(programId);
            program.tracks.push(trackId);
            await program.save();
            if (program) {
              program.tracks.push(newTrack._id); // Push the new track to the program's tracks
              await program.save();
            }
          }

          return newTrack;
        })
      );
    } else if (type === 'image') {
      records = await Promise.all(
        fileUrls.map((url, index) =>
          new Program({
            title: titles[index],
            description: descriptions[index] || '', // Provide description if available
            imageUrl: url,
          }).save()
        )
      );
    }

    // Return success response
    res.status(201).json({
      message: `Multiple ${type}s uploaded successfully`,
      data: records.map((record, index) => {
        const responseRecord = {
          ...record._doc,
        };

        // Only add audioUrl for audio files, exclude it for images
        if (type === 'audio') {
          responseRecord.audioUrl = fileUrls[index]; // Add audio URL for audio files
        } else if (type === 'image') {
          responseRecord.imageUrl = fileUrls[index]; // Add image URL for image files
        }

        return responseRecord;
      }),
    });
  } catch (error) {
    console.error('Error uploading multiple files:', error);
    res.status(500).json({ message: 'Failed to upload files', error: error.message });
  }
};



module.exports = { uploadSingleFile, uploadMultipleFiles, addTrackToProgram, getAudioDuration };
