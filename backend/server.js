const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const app = express();
const PORT = 5000;

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
    nama_organizer: { type: String },
    alamat_organizer: { type: String },
    tlpn_organizer: { type: String },
    email_organizer: { type: String },
    password_organizer: { type: String }
});

// Mendeklarasikan Model
const User = mongoose.models.User || mongoose.model('User', userSchema);
const Organizer = mongoose.models.Organizer || mongoose.model('Organizer', organizerSchema);

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
    //   if (!isMatch) {
    //     return res.status(400).send("Password salah!");
    //   }
  
      // Membuat JWT token jika login berhasil
    //   const token = jwt.sign(
    //     { userId: user._id, username: user.username },  // Payload untuk token
    //     'secret_key', // Ganti dengan kunci rahasia Anda
    //     { expiresIn: '1h' }  // Token kadaluarsa dalam 1 jam
    //   );
  
      // Mengirimkan token ke frontend
      res.status(200).json({ message: 'Login berhasil!' });
  
    } catch (err) {
      res.status(500).send("Terjadi kesalahan: " + err.message);
    }
  });

  // Register User DONE
// app.post('/loginUser', async (req, res) => {
//     const { username, password_user } = req.body;

//     try {
//         const user = await User.findOne({ username });
//         console.log(user)
//         if (!user) {
//             return res.status(400).send("User tidak ditemukan!");
//           }
//     } catch (err) {
//       res.status(500).send("Gagal melakukan registrasi: " + err.message);
//     }
//   });

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

// Register Organizer DONE
app.post('/registerOrganizer', async (req, res) => {
    const { nama_organizer, alamat_organizer, tlpn_organizer, email_organizer, password_organizer } = req.body;
    try {
      const newItem = new Organizer({ nama_organizer, alamat_organizer, tlpn_organizer, email_organizer, password_organizer });
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

// // Middleware untuk Verifikasi Token
// const authenticateToken = (req, res, next) => {
//     const token = req.header('Authorization')?.split(' ')[1];  // Ambil token dari header Authorization
  
//     if (!token) {
//       return res.status(401).send('Akses ditolak. Token tidak ditemukan.');
//     }
  
//     // Verifikasi token dengan JWT_SECRET
//     jwt.verify(token, JWT_SECRET, (err, user) => {
//       if (err) {
//         return res.status(403).send('Token tidak valid.');
//       }
//       req.user = user;  // Menyimpan informasi user dari token
//       next();  // Lanjutkan ke route berikutnya
//     });
//   };
  
//   // Contoh route yang dilindungi menggunakan JWT
//   app.get('/protected', authenticateToken, (req, res) => {
//     res.status(200).json({
//       message: 'Ini adalah route yang dilindungi!',
//       user: req.user,  // Menampilkan informasi user yang terkandung dalam token
//     });
//   });

// Start Server
app.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});
