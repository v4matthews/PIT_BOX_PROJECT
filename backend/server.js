const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const app = express();
const PORT = 5000;
const multer = require('multer');
const { GridFsStorage } = require('multer-gridfs-storage');
const Grid = require('gridfs-stream');
const crypto = require('crypto');
const path = require('path');

const { format, parseISO } = require('date-fns');

// Koneksi GridFS
const conn = mongoose.connection;
let gfs;
conn.once('open', () => {
    gfs = Grid(conn.db, mongoose.mongo);
    gfs.collection('uploads');
});

// Middleware
app.use(cors());
app.use(express.json());

// Koneksi ke MongoDB
mongoose.connect('mongodb+srv://pitboxproject:gvoucher123@pitboxproject.a7j7i.mongodb.net/pitbox?retryWrites=true&w=majority', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log("MongoDB connected!");
  })
  .catch((err) => {
    console.error("MongoDB connection error:", err);
  });

const storage = new GridFsStorage({
    url: 'mongodb+srv://pitboxproject:gvoucher123@pitboxproject.a7j7i.mongodb.net/pitbox?retryWrites=true&w=majority',
    file: (req, file) => {
        return new Promise((resolve, reject) => {
            crypto.randomBytes(16, (err, buf) => {
                if (err) {
                    return reject(err);
                }
                const filename = buf.toString('hex') + path.extname(file.originalname);
                const fileInfo = {
                    filename: filename,
                    bucketName: 'uploads', // Sesuaikan dengan koleksi GridFS Anda
                };
                resolve(fileInfo);
            });
        });
    },
});
const upload = multer({ storage });

// Schema untuk User
const userSchema = new mongoose.Schema({
    username: { type: String, required: true },
    nama_user: { type: String },
    alamat_user: { type: String },
    tlpn_user: { type: String },
    email_user: { type: String },
    password_user: { type: String }
});

const organizerSchema = new mongoose.Schema({
    team: { type: String },
    alamat_organizer: { type: String },
    tlpn_organizer: { type: String },
    email_organizer: { type: String },
    password_organizer: { type: String }
});

const regionSchema = new mongoose.Schema({
  id: { type: String },
  name: { type: String },
  alt_name: { type: String },
  latitude: { type: Number },
  longitude: { type: Number }
});

const eventSchema = new mongoose.Schema({
  id: { type: String },
  kategori: { type: String },
  nama_event: { type: String },
  htm_event: { type: Number },
  tanggal_event: { type: Date },
  lokasi_event: { type: String }
});

// Mendeklarasikan Model
const User = mongoose.models.User || mongoose.model('User', userSchema);
const Organizer = mongoose.models.Organizer || mongoose.model('Organizer', organizerSchema);
const Region = mongoose.models.Region || mongoose.model('Region', regionSchema);
const Event = mongoose.models.Event || mongoose.model('Event', eventSchema);

// Secret key untuk JWT (Ganti dengan kunci yang lebih aman di produksi)
// const JWT_SECRET = '001';


// Route Cek Koneksi
app.get('/getStatus', (req, res) => {
  mongoose.connection.readyState === 1
    ? res.status(200).send("Koneksi MongoDB berhasil!")
    : res.status(500).send("Koneksi MongoDB gagal!");
});

// Route Login
app.post('/loginUser', async (req, res) => {
    const { username, password_user } = req.body;
  
    try {
      // Mencari user berdasarkan email
      const user = await User.findOne({ username });
      console.log(user)
  
      if (!user) {
        return res.status(400).send("User tidak ditemukan!");
      }
      
    if (user.password_user !== password_user) {
        return res.status(400).send("Password salah!");
      }
      console.log("ini pass",user.password_user)
      console.log(password_user)

      res.status(200).json({ message: 'Login berhasil!' });
  
    } catch (err) {
      res.status(500).send("Terjadi kesalahan: " + err.message);
    }
});

// Route Login Organizer
app.post('/loginOrganizer', async (req, res) => {
  const { email_organizer, password_organizer } = req.body;

  try {
    // Mencari user berdasarkan email
    const user = await Organizer.findOne({ email_organizer });
    console.log(user)

    if (!user) {
      return res.status(400).send("User tidak ditemukan!");
    }
    
  if (user.password_organizer !== password_organizer) {
      return res.status(400).send("Password salah!");
    }
    console.log("ini pass",user.password_organizer)
    console.log(password_organizer)
    // Mengirimkan token ke frontend
    res.status(200).json({ message: 'Login berhasil!' });

  } catch (err) {
    res.status(500).send("Terjadi kesalahan: " + err.message);
  }
});

// Register User DONE
app.post('/registerUser', async (req, res) => {
  const { username, nama_user, alamat_user, tlpn_user, email_user, password_user } = req.body;
  try {
    const newItem = new User({ username, nama_user, alamat_user, tlpn_user, email_user, password_user });
    await newItem.save();
    res.status(201).send("Registrasi berhasil!");
  } catch (err) {
    res.status(500).send("Gagal melakukan registrasi: " + err.message);
  }
});

// Get Data User
app.get('/getUser', async (req, res) => {
  try {
    const items = await User.find();
    res.status(200).json(items);
  } catch (err) {
    res.status(500).send("Gagal mengambil data: " + err.message);
  }
});

// Cek User
app.post('/cekUser', async (req, res) => {
  const { username } = req.body;

  try {
    // Mencari user berdasarkan email
    const user = await User.findOne({ username });
    console.log(user)

    if (!user) {
      return res.status(200).send(true); 
    }

    return res.status(400).send(false);

  } catch (err) {
    res.status(500).send("Terjadi kesalahan: " + err.message);
  }
});

// Cek Email
app.post('/cekEmail', async (req, res) => {
  const { email_user } = req.body;

  try {
    // Mencari user berdasarkan email
    const email = await User.findOne({ email_user });
    console.log(email)

    if (!email) {
      return res.status(200).send(true); 
    }

    return res.status(400).send(false);

  } catch (err) {
    res.status(500).send("Terjadi kesalahan: " + err.message);
  }
});

// Cek Email Organizer
app.post('/cekEmailOrganizer', async (req, res) => {
  const { email_organizer } = req.body;

  try {
    // Mencari user berdasarkan email
    const email = await Organizer.findOne({ email_organizer });
    console.log(email)

    if (!email) {
      return res.status(200).send(true); 
    }

    return res.status(400).send(false);

  } catch (err) {
    res.status(500).send("Terjadi kesalahan: " + err.message);
  }
});

// Register Organizer DONE
app.post('/registerOrganizer', async (req, res) => {
    const { team, alamat_organizer, tlpn_organizer, email_organizer, password_organizer } = req.body;
    try {
      const newItem = new Organizer({ team, alamat_organizer, tlpn_organizer, email_organizer, password_organizer });
      await newItem.save();
      res.status(201).send("Registrasi Organizer berhasil!");
    } catch (err) {
      res.status(500).send("Gagal melakukan registrasi Organizer: " + err.message);
    }
});
  
  // Get Data Organizer
app.get('/getOrganizer', async (req, res) => {
  try {
    const items = await Organizer.find();
    res.status(200).json(items);
  } catch (err) {
    res.status(500).send("Gagal mengambil data: " + err.message);
  }
});

  // Get Data Region
app.get('/getRegion', async (req, res) => {
  try {
    const items = await Region.find();
    res.status(200).json(items);
  } catch (err) {
    res.status(500).send("Gagal mengambil data: " + err.message);
  }
});


// GET EVENTS
// Get Event All Categories
app.get('/getAllCategories', async (req, res) => {
  try {
    const items = await Event.find();
    res.status(200).json(items);
  } catch (err) {
    res.status(500).send("Gagal mengambil data: " + err.message);
  }
});

// Get Event STO Categories
app.get('/getStoCategories', async (req, res) => {
  try {
    const items = await Event.find({ kategori: "STO" });
    res.status(200).json(items);
  } catch (err) {
    res.status(500).send("Gagal mengambil data: " + err.message);
  }
});

// Get Event Damper Style Categories
app.get('/getDsCategories', async (req, res) => {
  try {
    const items = await Event.find({ kategori: "DS" });
    res.status(200).json(items);
  } catch (err) {
    res.status(500).send("Gagal mengambil data: " + err.message);
  }
});

// Get Event STB Categories
app.get('/getStbCategories', async (req, res) => {
  try {
    const items = await Event.find({ kategori: "STB" });
    res.status(200).json(items);
  } catch (err) {
    res.status(500).send("Gagal mengambil data: " + err.message);
  }
});

// Get Event STB UP Categories
app.get('/getStbUpCategories', async (req, res) => {
  try {
    const items = await Event.find({ kategori: "STB UP" });
    res.status(200).json(items);
  } catch (err) {
    res.status(500).send("Gagal mengambil data: " + err.message);
  }
});

// Get Event Sloop Categories
app.get('/getSloopCategories', async (req, res) => {
  try {
    const items = await Event.find({ kategori: "SLOOP" });
    res.status(200).json(items);
  } catch (err) {
    res.status(500).send("Gagal mengambil data: " + err.message);
  }
});

// Get Event Sloop Categories
app.get('/getNascarCategories', async (req, res) => {
  try {
    const items = await Event.find({ kategori: "NASCAR" });
    res.status(200).json(items);
  } catch (err) {
    res.status(500).send("Gagal mengambil data: " + err.message);
  }
});

// Upload Gambar
app.post('/upload', upload.single('file'), (req, res) => {
  try {
    console.log(req.file); // Informasi file yang diupload
    res.status(200).send("Gambar berhasil diupload!");
  } catch (err) {
    res.status(500).send("Terjadi kesalahan saat mengupload gambar.");
  }
});


// Get Gambar
app.get('/file/:filename', (req, res) => {
  gfs.files.findOne({ filename: req.params.filename }, (err, file) => {
      if (!file || file.length === 0) {
          return res.status(404).json({ error: 'File tidak ditemukan' });
      }
      // Cek apakah file adalah gambar
      if (file.contentType === 'image/jpeg' || file.contentType === 'image/png') {
          const readStream = gfs.createReadStream(file.filename);
          readStream.pipe(res);
      } else {
          res.status(400).json({ error: 'Bukan file gambar' });
      }
  });
});

// Delete Gambar
app.delete('/file/:id', (req, res) => {
  gfs.remove({ _id: req.params.id, root: 'uploads' }, (err) => {
      if (err) {
          return res.status(500).json({ error: err.message });
      }
      res.status(200).send('File berhasil dihapus');
  });
});



// Start Server
app.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});
