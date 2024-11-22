const cloudinary = require('cloudinary').v2;
const dotenv = require('dotenv');
dotenv.config(); // Load environment variables

// Configure Cloudinary with environment variables
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

// Function to upload files to Cloudinary
const uploadFile = async (fileBuffer, folder) => {
  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      { folder, resource_type: 'auto' },
      (error, result) => {
        if (error) {
          console.error('Cloudinary Upload Error:', error);
          return reject(new Error('Cloudinary upload failed'));
        }
        resolve(result.secure_url);
      }
    );
    stream.end(fileBuffer);
  });
};

const uploadFiles = async (fileBuffers, folder) => {
  const uploadPromises = fileBuffers.map((fileBuffer) =>
    uploadFile(fileBuffer, folder)
  );
  return Promise.all(uploadPromises);
};

// Function to delete files from Cloudinary
const deleteFile = async (publicId) => {
  try {
    await cloudinary.uploader.destroy(publicId);
    console.log(`File with public ID ${publicId} deleted successfully`);
  } catch (error) {
    console.error('Error deleting file from Cloudinary:', error);
    throw new Error('Cloudinary deletion failed');
  }
};

module.exports = { uploadFile, uploadFiles, deleteFile };
