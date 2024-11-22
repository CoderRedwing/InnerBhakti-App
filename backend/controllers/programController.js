const Program = require('../models/Program');

// Fetch all programs
exports.getPrograms = async (req, res) => {
  try {
    const programs = await Program.find().populate('tracks'); // Fetch all programs with tracks
    console.log('Populated programs:', JSON.stringify(programs, null, 2));
    res.status(200).json(programs);
  } catch (err) {
    console.error('Error fetching programs:', err);
    res.status(500).json({ error: 'Failed to fetch programs', details: err.message });
  }
};

// Fetch program details by ID
exports.getProgramDetails = async (req, res) => {
  try {
    const program = await Program.findById(req.params.id).populate('tracks'); // Fetch specific program with tracks
    if (!program) {
      return res.status(404).json({ error: 'Program not found' });
    }
    res.status(200).json(program);
  } catch (err) {
    console.error('Error fetching program details:', err);
    res.status(500).json({ error: 'Failed to fetch program details', details: err.message });
  }
};
