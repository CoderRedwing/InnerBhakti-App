require('dotenv').config();
const Program = require('../models/Program');
const AudioTrack = require('../models/AudioTrack');
const mongoose = require('mongoose');

const seedDatabase = async () => {
  await mongoose.connect(process.env.MONGO_URI);
    
  const track1 = new AudioTrack({
    title: 'Track 1',
    audioUrl: 'https://res.cloudinary.com/ajiteshyt/video/upload/v1732122457/audio/oo9z2u5iawzox1mj3ns6.mp3',
    duration: '4:00',
  });

  const track2 = new AudioTrack({
    title: 'Track 2',
    audioUrl: 'https://res.cloudinary.com/ajiteshyt/video/upload/v1732121657/audio/zqfgse0v1ri3qtn9huxn.mp3',
    duration: '5:30',
  });

  const program = new Program({
    title: 'Meditation Program',
    imageUrl: 'https://res.cloudinary.com/ajiteshyt/image/upload/v1732044583/images/xzope7e6sgxipgunkys7.png',
    description: '20 Days Plan',
    tracks: [track1._id, track2._id],
  });

  await track1.save();
  await track2.save();
  await program.save();

  console.log('Database seeded');
  process.exit();
};

seedDatabase();
