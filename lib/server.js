const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const PORT = process.env.PORT || 8080;
const crypto = require('crypto');
const path = require('path');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const app = express();

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



// Model Event
const eventSchema = new mongoose.Schema({
  id_organizer: { type: mongoose.Schema.Types.ObjectId, ref: 'Organizer' },
  image_event: { type: String },
  nama_event: { type: String },
  kategori_event: { type: String },
  htm_event: { type: Number },
  tanggal_event: { type: Date },
  waktu_event: { type: String },
  kota_event: { type: String },
  alamat_event: { type: String },
  status_event: { type: String },
  deskripsi_event: { type: String },
  status_event: { 
    type: String,
    required: true, 
    enum: ["upcoming", "ongoing", "completed"], // Batasi nilai status
    default: "upcoming" 
  },
});

// Model Reservation
const reservationSchema = new mongoose.Schema({
  id_user: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'User', 
    required: true 
  },
  id_event: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Event', 
    required: true 
  },
  nama_tim: { 
    type: String, 
    required: true 
  },
  metode_pembayaran: { 
    type: String, 
    required: true, 
  },
  status: { 
    type: String, 
    required: true, 
    enum: ["Pending Payment", "Confirmed", "Canceled"], // Batasi nilai status
    default: "Pending Payment" 
  },
  reserved_at: { 
    type: Date, 
    default: Date.now 
  },
  created_at: { 
    type: Date, 
    default: Date.now 
  },
  updated_at: { 
    type: Date, 
    default: Date.now 
  }
});

// Middleware untuk mengupdate `updated_at` setiap kali data diubah
reservationSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

// Model Payment
const paymentSchema = new mongoose.Schema({
  id_payment: { 
    type: String, 
    required: true 
  },
  id_reservasi: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: 'Reservation', 
    required: true 
  },
  total_harga: { 
    type: Number, 
    required: true 
  },
  // metode_pembayaran: { 
  //   type: String, 
  //   required: true, 
  //   enum: ["Credit Card", "Bank Transfer", "E-Wallet"] // Batasi metode pembayaran
  // },
  status: { 
    type: String, 
    required: true, 
    enum: ["Pending", "Paid", "Failed", "Refunded",  "Canceled"], // Batasi nilai status
    default: "Pending" 
  },
  confirmation_receipt: { 
    type: String, 
    required: true 
  },
  created_at: { 
    type: Date, 
    default: Date.now 
  },
  updated_at: { 
    type: Date, 
    default: Date.now 
  }
});

// Middleware untuk mengupdate `updated_at` setiap kali data diubah
paymentSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

// Model User
const userSchema = new mongoose.Schema({
  username: { type: String, required: true },
  nama_user: { type: String },
  kota_user: { type: String },
  tlpn_user: { type: String },
  email_user: { type: String },
  password_user: { type: String },
  poin_user: { type: Number, default: 0 },
  isVerified: { type: Boolean, default: false },
});

// Model Organizer
const organizerSchema = new mongoose.Schema({
    id_organizer : { type: String },
    nama_organizer: { type: String },
    email_organizer: { type: String },
    kota_organizer: { type: String },
    alamat_organizer: { type: String },
    tlpn_organizer: { type: String },
    password_organizer: { type: String }
});

// Model Region
const regionSchema = new mongoose.Schema({
  id: { type: String },
  name: { type: String },
  alt_name: { type: String },
  latitude: { type: Number },
  longitude: { type: Number }
});

// Model ticket
const ticketSchema = new mongoose.Schema({
  id_transaksi: { type: String, required: true },
  id_user: { type: String, required: true },
  id_event: { type: String, required: true },
  nama_tim: { type: String, required: true },
  tanggal_event: { type: Date, required: true },
  waktu_event: { type: String, required: true },
  nama_event: { type: String, required: true },
  htm_event: { type: String, required: true },
  lokasi_event: { type: String, required: true },
  status_payment: { type: Date, required: true },
  status_ticket: { type: String, required: true ,
    enum: ["sudah check-in", "belum check-in"], // Batasi nilai status
    default: "belum check-in" 
  },
});


// Mendeklarasikan Model
const User = mongoose.models.Users || mongoose.model('User', userSchema);
const Organizer = mongoose.models.Organizer || mongoose.model('Organizer', organizerSchema);
const Region = mongoose.models.Region || mongoose.model('Region', regionSchema);
const Event = mongoose.models.Event || mongoose.model('Event', eventSchema);
const Ticket = mongoose.models.Ticket || mongoose.model('Ticket', ticketSchema);
const Reservation = mongoose.models.Reservation || mongoose.model('Reservation', reservationSchema);
const Payment = mongoose.models.Payment || mongoose.model('Payment', paymentSchema);


// Route Cek Koneksi
app.get('/getStatus', (req, res) => {
  mongoose.connection.readyState === 1
    ? res.status(200).send("Koneksi MongoDB berhasil!")
    : res.status(500).send("Koneksi Mo  ngoDB gagal!");
});


// Fungsi untuk memverifikasi password saat login
const verifyPassword = (inputPassword, storedPassword) => {
  const hashedInputPassword = crypto.pbkdf2Sync(inputPassword, "salt", 1000, 64, "sha512").toString("hex");
  return hashedInputPassword === storedPassword; // Bandingkan hash password input dengan yang tersimpan
};

// Route Login
app.post('/loginUser', async (req, res) => {
  const { username, password_user } = req.body;
  console.log(password_user)
  try {
      // Mencari user berdasarkan username
      const user = await User.findOne({ username });

      if (!user) {
          return res.status(200).json({ status: 'gagal', message: "User tidak ditemukan!" });
      }

      // 3. Verifikasi password menggunakan PBKDF2
      if (!verifyPassword(password_user, user.password_user)) {
        return res.status(200).json({ status: 'gagal', message: "Password salah!" });
      }

      // Mengecek apakah akun sudah diverifikasi
      if (!user.isVerified) {
          return res.status(200).json({
              status: 'unverified',
              message: "Akun belum diverifikasi! Silakan verifikasi email Anda.",
          });
      }

      // Jika login berhasil
      res.status(200).json({ status: 'sukses', message: "Login berhasil!" });

  } catch (err) {
      res.status(500).json({ status: 'gagal', message: "Terjadi kesalahan: " + err.message });
  }
});



// Get Data for Specific User
app.get('/getUser/:username', async (req, res) => {
  const { username } = req.params;
  try {
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(404).send("User tidak ditemukan!");
    }
    console.log(user)
    res.status(200).json(user);
  } catch (err) {
    res.status(500).send("Gagal mengambil data: " + err.message);
  }
});

app.get('/getOrganizer/:email_organizer', async (req, res) => {
  const { email_organizer } = req.params;
  try {
    const organizer = await Organizer.findOne({ email_organizer });
    if (!organizer) {
      return res.status(404).send("Organizer tidak ditemukan!");
    }
    res.status(200).json(organizer);
  } catch (err) {
    res.status(500).send("Gagal mengambil data: " + err.message);
  }
});

// Verify Password
app.post('/verifyPassword', async (req, res) => {
  const { username, password } = req.body;

  try {
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(404).send("User tidak ditemukan!");
    }

    if (user.password_user !== password) {
      return res.status(400).send("Password salah!");
    }

    res.status(200).json({ message: 'Password benar!' });
  } catch (err) {
    res.status(500).send("Terjadi kesalahan: " + err.message);
  }
});

// // Endpoint untuk memperbarui data pengguna
// app.put('/updateUser', async (req, res) => {
//   const { id_user, username, nama_user, tlpn_user, email_user, kota_user } = req.body;

//   // Validasi input
//   if (!id_user) {
//     return res.status(400).json({ status: 'failed', message: "ID User harus diisi!" });
//   }

//   // Buat objek untuk field yang akan diupdate
//   const updateFields = {};
//   if (username) updateFields.username = username;
//   if (nama_user) updateFields.nama_user = nama_user;
//   if (tlpn_user) updateFields.tlpn_user = tlpn_user;
//   if (email_user) updateFields.email_user = email_user;
//   if (kota_user) updateFields.kota_user = kota_user;

//   // Pastikan ada field yang diupdate
//   if (Object.keys(updateFields).length === 0) {
//     return res.status(400).json({ status: 'failed', message: "Tidak ada data yang dikirim untuk diperbarui." });
//   }

//   try {
//     const user = await User.findOneAndUpdate(
//       { _id: new mongoose.Types.ObjectId(id_user) }, // Konversi id_user ke ObjectId
//       { $set: updateFields }, // Gunakan $set untuk mengupdate field
//       { new: true } // Mengembalikan data setelah update
//     );

//     if (!user) {
//       return res.status(404).json({ status: 'failed', message: "User tidak ditemukan!" });
//     }

//     res.status(200).json({ status: 'success', message: 'Update berhasil!', data: user });
//   } catch (err) {
//     res.status(500).json({ status: 'failed', message: "Gagal memperbarui data: " + err.message });
//   }
// });

app.put('/updateUser', async (req, res) => {
  const { id_user, username, nama_user, tlpn_user, email_user, kota_user } = req.body;

  // Validasi input yang lebih ketat
  if (!id_user || !mongoose.Types.ObjectId.isValid(id_user)) {
    return res.status(400).json({ 
      status: 'failed', 
      message: "ID User harus berupa ObjectId yang valid!" 
    });
  }

  // Validasi field yang akan diupdate
  const updateFields = {};
  if (username) {
    if (username.length < 3 || username.length > 30) {
      return res.status(400).json({
        status: 'failed',
        message: "Username harus antara 3-30 karakter"
      });
    }
    updateFields.username = username;
  }
  
  if (nama_user) {
    if (nama_user.length < 2 || nama_user.length > 50) {
      return res.status(400).json({
        status: 'failed',
        message: "Nama harus antara 2-50 karakter"
      });
    }
    updateFields.nama_user = nama_user;
  }

  if (tlpn_user) {
    if (!/^[0-9]{10,15}$/.test(tlpn_user)) {
      return res.status(400).json({
        status: 'failed',
        message: "Nomor telepon harus 10-15 digit angka"
      });
    }
    updateFields.tlpn_user = tlpn_user;
  }

  if (email_user) {
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email_user)) {
      return res.status(400).json({
        status: 'failed',
        message: "Format email tidak valid"
      });
    }
    updateFields.email_user = email_user;
  }

  if (kota_user) updateFields.kota_user = kota_user;

  // Pastikan ada field yang diupdate
  if (Object.keys(updateFields).length === 0) {
    return res.status(400).json({ 
      status: 'failed', 
      message: "Tidak ada data yang valid untuk diperbarui." 
    });
  }

  try {
    // Optimasi query dengan hanya memproyeksikan field yang diperlukan
    const user = await User.findOneAndUpdate(
      { _id: new mongoose.Types.ObjectId(id_user) },
      { $set: updateFields },
      { 
        new: true,
        projection: { 
          username: 1, 
          nama_user: 1, 
          tlpn_user: 1, 
          email_user: 1, 
          kota_user: 1,
          _id: 0 // Exclude _id from response
        }
      }
    ).lean(); // Gunakan lean() untuk performa lebih baik

    if (!user) {
      return res.status(404).json({ 
        status: 'failed', 
        message: "User tidak ditemukan!" 
      });
    }

    // Format respons yang lebih konsisten
    res.status(200).json({ 
      status: 'success', 
      message: 'Data user berhasil diperbarui',
      data: {
        user: user,
        updated_fields: Object.keys(updateFields)
      }
    });
  } catch (err) {
    // Error handling yang lebih spesifik
    if (err.code === 11000) {
      return res.status(409).json({
        status: 'failed',
        message: "Username atau email sudah digunakan"
      });
    }
    
    console.error('Error updating user:', err);
    res.status(500).json({ 
      status: 'error', 
      message: "Terjadi kesalahan server",
      error: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  }
});

// // Update User
// app.put('/updateUser', async (req, res) => {
//   const { id_user, username, nama_user, tlpn_user, email_user, kota_user, password_user } = req.body;

//   // Buat objek untuk field yang akan diupdate
//   const updateFields = {};
//   if (username) updateFields.username = username;
//   if (nama_user) updateFields.nama_user = nama_user;
//   if (tlpn_user) updateFields.tlpn_user = tlpn_user;
//   if (email_user) updateFields.email_user = email_user;
//   if (kota_user) updateFields.kota_user = kota_user;
//   if (password_user) updateFields.password_user = await hashPassword(password_user); // Hash password jika diupdate

//   // Pastikan ada field yang diupdate
//   if (Object.keys(updateFields).length === 0) {
//     return res.status(400).send("Tidak ada data yang dikirim untuk diperbarui.");
//   }

//   try {
//     const user = await User.findOneAndUpdate(
//       { id_user },
//       updateFields,  // Update field yang dikirim
//       { new: true }  // Mengembalikan data setelah update
//     );

//     if (!user) {
//       return res.status(404).send("User tidak ditemukan!");
//     }

//     res.status(200).json({ message: 'Update berhasil!', user });
//   } catch (err) {
//     res.status(500).send("Gagal memperbarui data: " + err.message);
//   }
// });

app.put('/updatePassword', async (req, res) => {
  const { id_user, current_password, new_password } = req.body;

  // Validasi input
  if (!id_user || !mongoose.Types.ObjectId.isValid(id_user)) {
    return res.status(400).json({ 
      status: 'failed', 
      message: "ID User harus berupa ObjectId yang valid!" 
    });
  }

  if (!current_password || !new_password) {
    return res.status(400).json({
      status: 'failed',
      message: "Password saat ini dan password baru harus diisi"
    });
  }

  if (current_password === new_password) {
    return res.status(400).json({
      status: 'failed',
      message: "Password baru tidak boleh sama dengan password lama"
    });
  }

  // Validasi kekuatan password baru
  const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
  if (!passwordRegex.test(new_password)) {
    return res.status(400).json({
      status: 'failed',
      message: "Password baru harus minimal 8 karakter dan mengandung huruf besar, huruf kecil, angka, dan karakter khusus"
    });
  }

  try {
    // Mencari user dengan optimasi query
    const user = await User.findOne({ 
      _id: new mongoose.Types.ObjectId(id_user) 
    }).select('password_user');

    if (!user) {
      return res.status(404).json({ 
        status: 'failed', 
        message: 'Pengguna tidak ditemukan' 
      });
    }

    // Verifikasi password saat ini
    const isPasswordValid = await verifyPassword(current_password, user.password_user);
    if (!isPasswordValid) {
      return res.status(401).json({ 
        status: 'failed', 
        message: "Password saat ini salah" 
      });
    }

    // Hash password baru
    const hashedPassword = await hashPassword(new_password);

    // Update password dengan optimasi
    const updateResult = await User.updateOne(
      { _id: new mongoose.Types.ObjectId(id_user) },
      { $set: { password_user: hashedPassword } }
    );

    if (updateResult.modifiedCount === 0) {
      return res.status(500).json({ 
        status: 'failed', 
        message: "Gagal memperbarui password" 
      });
    }

    // Response sukses
    res.status(200).json({ 
      status: 'success', 
      message: 'Password berhasil diperbarui',
      data: {
        password_updated_at: new Date()
      }
    });

  } catch (err) {
    console.error('Error updating password:', err);
    
    // Handle specific errors
    if (err.name === 'MongoError' && err.code === 11000) {
      return res.status(500).json({
        status: 'failed',
        message: "Konflik database terjadi"
      });
    }

    res.status(500).json({ 
      status: 'error', 
      message: 'Terjadi kesalahan server',
      error: process.env.NODE_ENV === 'development' ? err.message : undefined
    });
  }
});

// Register Organizer DONE
app.post('/registerOrganizer', async (req, res) => {
  const { id_organizer, nama_organizer, email_organizer, tlpn_organizer, kota_organizer, alamat_organizer, password_organizer } = req.body;
  try {
    const hashedPassword = await hashPassword(password_organizer);
    console.log(hashedPassword)

    const newItem = new Organizer({ id_organizer, nama_organizer, email_organizer, tlpn_organizer, kota_organizer, alamat_organizer, password_organizer : hashedPassword });
    await newItem.save();
    res.status(201).send("Registrasi Organizer berhasil!");
  } catch (err) {
    res.status(500).send("Gagal melakukan registrasi Organizer: " + err.message);
  }
});

// Route Login Organizer
app.post('/loginOrganizer', async (req, res) => {
  const { email_organizer, password_organizer } = req.body;
 
  try {
      // Mencari user berdasarkan username
      const organizer = await Organizer.findOne({ email_organizer });

      if (!organizer) {
          return res.status(200).json({ status: 'gagal', message: "User tidak ditemukan!" });
      }

      // 3. Verifikasi password menggunakan PBKDF2
      if (!verifyPassword(password_organizer, organizer.password_organizer)) {
        return res.status(200).json({ status: 'gagal', message: "Password salah!" });
      }

      // Mengecek apakah akun sudah diverifikasi
      // if (!organizer.isVerified) {
      //     return res.status(200).json({
      //         status: 'unverified',
      //         message: "Akun belum diverifikasi! Silakan verifikasi email Anda.",
      //     });
      // }

      // Jika login berhasil
      res.status(200).json({ status: 'sukses', message: "Login berhasil!" });

  } catch (err) {
      res.status(500).json({ status: 'gagal', message: "Terjadi kesalahan: " + err.message });
  }
});

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

//sssss
app.post('/forgetUserEndpoint', async (req, res) => {
  const { email_user, tlpn_user } = req.body;
  try {
      // Mencari user berdasarkan email
      const user = await User.findOne({ email_user });

      if (!user) {
          return res.status(200).json({ status: 'gagal', message: "Email tidak ditemukan!" });
      }

      if (user.tlpn_user !== tlpn_user) {
        return res.status(200).json({ status: 'gagal', message: "Nomor telepon tidak sesuai!" });
      }

      // Generate password sementara
      const temporaryPassword = crypto.randomBytes(8).toString('hex');
      const hashedTemporaryPassword = await hashPassword(temporaryPassword);

      // Update password user dengan password sementara
      user.password_user = hashedTemporaryPassword;
      await user.save();

      // Kirim email dengan password sementara
      const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: 'pitboxproject@gmail.com',
          pass: 'ytfj xmwy vqle cvjv', // Kata sandi aplikasi
        },
      });

      const mailOptions = {
        from: 'pitboxproject@gmail.com',
        to: email_user,
        subject: 'Password Recovery',
        html: `
        <div style="font-family: Arial, sans-serif; line-height: 1.6;">
          <p>Hai ${email_user},</p>
          <p>Kami menerima permintaan untuk mereset kata sandi akun Anda. Jangan khawatir! Berikut adalah kata sandi sementara Anda:</p>
          <p>Password Sementara: <strong>${temporaryPassword}</strong></p>
          <p>Harap segera masuk dan ganti kata sandi Anda demi keamanan akun Anda. Jika Anda tidak meminta reset ini, abaikan email ini.</p>
          <p>Salam,<br>Tim Pitbox Project</p>
        </div>`,
      };

      transporter.sendMail(mailOptions, (error) => {
        if (error) {
          return res.status(500).json({ status: 'gagal', message: "Gagal mengirim email" });
        } else {
          return res.status(200).json({ status: 'sukses', message: "Password sementara berhasil dikirim ke email Anda" });
        }
      });

  } catch (err) {
      res.status(500).json({ status: 'gagal', message: "Terjadi kesalahan: " + err.message });
  }
});

// app.post('/forgetUserEndpoint', (req, res) => {
//   const { email_user, tlpn_user } = req.body;

//   const user = User.findOne(user => user.email_user === email_user && user.tlpn_user === tlpn_user);
//   try{
//     const user = await User.findOne({ username });
//   }catch(err){
//   }
 
//   if (user) {
//     // Kirim email dengan password lama
//     const transporter = nodemailer.createTransport({
//       service: 'gmail',
//       auth: {
//         user: 'pitboxproject@gmail.com',
//         pass: 'ytfj xmwy vqle cvjv', // Kata sandi aplikasi
//       },
//     });

//     const mailOptions = {
//       from: 'pitboxproject@gmail.com',
//       to: user.email,
//       subject: 'Password Recovery',
//       text: `Password anda adalah is: ${user.password}`
//     };

//     transporter.sendMail(mailOptions, (error, info) => {
//       if (error) {
//         return res.status(500).send('Gagal mengirim email');
//       } else {
//         return res.status(200).send('Password berhasil dikirim ke email');
//       }
//     });
//   } else {
//     return res.status(400).send('Email atau nomor telepon tidak ditemukan');
//   }
// });

//================ REGISTRASI ===============================================

const nodemailer = require('nodemailer');
// const crypto = require("crypto");

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'pitboxproject@gmail.com',
    pass: 'ytfj xmwy vqle cvjv', // Kata sandi aplikasi
  },
});

const generateVerificationToken = (email) => {
  return jwt.sign({ email }, 'your-secret-key', { expiresIn: '1h' });
};

const hashPassword = async (password_user) => {
  return crypto.pbkdf2Sync(password_user, "salt", 1000, 64, "sha512").toString("hex");
};

app.post('/registerUser', async (req, res) => {
  const { id_user, username, nama_user, tlpn_user, email_user, kota_user, password_user } = req.body;

  console.log()
  try {
    const existingUser = await User.findOne({ email_user });
    if (existingUser) {
      return res.status(400).send("Email sudah terdaftar.");
    }

    // Hash password sebelum disimpan ke database
    // const saltRounds = 10; // Jumlah iterasi hashing (semakin tinggi, semakin aman)
    // const hashedPassword = await bcrypt.hash(password_user, parseInt(saltRounds));


    console.log("Cek Hash")
    console.log(password_user)

    const hashedPassword = await hashPassword(password_user);
    console.log(hashedPassword)

    const newItem = new User({ id_user, username, nama_user, tlpn_user, email_user, kota_user, password_user : hashedPassword });
    await newItem.save();

    const token = generateVerificationToken(email_user);
    const verificationLink = `https://pit-box-project-backend-452431537344.us-central1.run.app/verify-email?token=${token}`;

    const mailOptions = {
      from: 'pitboxproject@gmail.com',
      to: email_user,
      subject: 'Selamat Bergabung di PIT BOX!',
      html: `
          <div style="font-family: Arial, sans-serif; text-align: center; padding: 20px;">
              <h2>🎉 Selamat Bergabung di PIT BOX! 🎉</h2>
              <p>Halo <b>${nama_user}</b>,</p>
              <p>Terima kasih telah mendaftar di <b>PIT BOX</b>. Kami senang Anda bergabung bersama kami!</p>
              <p>Untuk mengkonfirmasi pendaftaran akun Anda, silahkan verifikasi alamat email Anda dengan mengklik link di bawah ini:</p>
              <a href="${verificationLink}" 
                style="display: inline-block; padding: 10px 20px; margin: 10px 0; background-color: #007bff; color: #fff; text-decoration: none; border-radius: 5px;">
                <b>Verifikasi Email Saya</b>
              </a>
              <p><small>Link ini akan kedaluwarsa dalam 1 jam, jadi pastikan Anda segera memverifikasi email Anda.</small></p>
              <p>Jika Anda tidak merasa mendaftar di <b>PIT BOX</b>, Anda dapat mengabaikan email ini.</p>
              <p>Terima kasih,<br>Tim <b>PIT BOX PROJECT</b></p>
          </div>
      `
  };

    await transporter.sendMail(mailOptions);

    res.status(201).send("Registrasi berhasil! Silahkan cek email Anda untuk verifikasi.");
  } catch (err) {
    res.status(500).send(err.message);
  }
});

app.get('/verify-email', async (req, res) => {
  const { token } = req.query;

  try {
    // Verifikasi token
    const decoded = jwt.verify(token, 'your-secret-key');
    const email = decoded.email;

    // Update status verifikasi email di database
    await User.findOneAndUpdate({ email_user: email }, { isVerified: true });

    res.send("Email berhasil diverifikasi!");
  } catch (err) {
    res.status(400).send("Token tidak valid atau sudah kadaluarsa.");
  }
});


// Endpoint untuk mengirim ulang email verifikasi
app.post('/resend-verification', async (req, res) => {
  const { username } = req.body;

  try {
    // Cari user berdasarkan email
    const user = await User.findOne({ username });

    if (!user) {
      return res.status(404).json({ message: 'Email tidak ditemukan!' });
    }

    const email = user.email_user; // Ambil email dari hasil pencarian
    console.log("Email pengguna:", email);

    // Jika akun sudah diverifikasi, beri tahu pengguna
    if (user.isVerified) {
      return res.status(400).json({ message: 'Akun sudah diverifikasi!' });
    }

    // Generate token verifikasi baru
    const token = generateVerificationToken(email);
    const verificationLink = `https://pit-box-project-backend-452431537344.us-central1.run.app/verify-email?token=${token}`;

    // Kirim email verifikasi
    const mailOptions = {
      from: 'pitboxproject@gmail.com',
      to: email,
      subject: 'Verifikasi Ulang Email Anda di PIT BOX',
      html: `
        <div style="font-family: Arial, sans-serif; text-align: center; padding: 20px;">
            <h2>🎉 Verifikasi Ulang Email Anda 🎉</h2>
            <p>Halo <b>${user.nama_user}</b>,</p>
            <p>Anda telah meminta untuk mengirim ulang email verifikasi. Silakan klik link di bawah ini untuk memverifikasi email Anda:</p>
            <a href="${verificationLink}" 
              style="display: inline-block; padding: 10px 20px; margin: 10px 0; background-color: #007bff; color: #fff; text-decoration: none; border-radius: 5px;">
              <b>Verifikasi Email Saya</b>
            </a>
            <p><small>Link ini akan kedaluwarsa dalam 1 jam, jadi pastikan Anda segera memverifikasi email Anda.</small></p>
            <p>Jika Anda tidak merasa meminta verifikasi ulang, Anda dapat mengabaikan email ini.</p>
            <p>Terima kasih,<br>Tim <b>PIT BOX PROJECT</b></p>
        </div>
      `,
    };

    await transporter.sendMail(mailOptions);

    res.status(200).json({ status: 'sukses', message: 'Email verifikasi telah dikirim ulang!' });
  } catch (err) {
    res.status(500).json({ status: 'gagal', message: 'Gagal mengirim ulang email verifikasi: ' + err.message });
  }
});


//================================================================================

// // Register User DONE
// app.post('/registerUser', async (req, res) => {
//   const { id_user, username, nama_user, tlpn_user, email_user, kota_user, password_user } = req.body;
//   try {
//     const newItem = new User({ id_user, username, nama_user, tlpn_user, email_user, kota_user, password_user });
//     await newItem.save();
//     res.status(201).send("Registrasi berhasil!");a
//   } catch (err) {
//     res.status(500).send("Gagal melakukan registrasi: " + err.message);
//   }
// });

// Get Data User
app.get('/getUser', async (req, res) => {
  try {
    const items = await User.find();
    console.log(items)
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

// Get STO Categories
app.get('/getSTOCategories', async (req, res) => {
  try {
    const stoItems = await Event.find({ kategori_event: 'STO' });
    res.status(200).json(stoItems);
  } catch (err) {
    res.status(500).send("Gagal mengambil data kategori STO: " + err.message);
  }
});


//====================================
app.post('/insertEvent', async (req, res) => {
  const { id_organizer, nama_event, kategori_event, htm_event, tanggal_event, waktu_event, kota_event, alamat_event, deskripsi_event, imageId} = req.body;

  // Validasi input
  if (!id_organizer) {
    return res.status(400).json({ status: 'failed', message: "ID Organizer harus diisi!" });
  }

  try {
    // Cek apakah organizer ada
    const organizer = await Organizer.findById(id_organizer);
    if (!organizer) {
      return res.status(404).json({ status: 'failed', message: "Organizer tidak ditemukan!" });
    }

    // Buat event baru
    const newItem = new Event({ id_organizer, nama_event, kategori_event, htm_event, tanggal_event, waktu_event, kota_event, alamat_event, deskripsi_event, image_event: imageId});
    await newItem.save();

    res.status(201).json({ status: 'success', message: "Event berhasil dibuat", data: newItem });
  } catch (err) {
    res.status(500).json({ status: 'failed', message: "Event gagal dibuat: " + err.message });
  }
});

app.get('/getEvents', async (req, res) => {
  try {
    const events = await Event.find();
    res.status(200).json(events);
  } catch (err) {
    res.status(500).send("Gagal mengambil data event: " + err.message);
  }
});

app.get('/getEvents/:id', async (req, res) => {
  const { id } = req.params;
  try {
    const event = await Event.findById(id);
    if (!event) {
      return res.status(404).send("Event tidak ditemukan!");
    }
    res.status(200).json(event);
  } catch (err) {
    res.status(500).send("Gagal mengambil data event: " + err.message);
  }
});



// Start Server
app.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});



//============================================================

//Part Midtrans Payment Gateway

const midtransClient = require('midtrans-client');
const { ca } = require('date-fns/locale');

// Midtrans Snap API
const snap = new midtransClient.Snap({
  isProduction: false, // Sandbox mode
  serverKey: 'SB-Mid-server-PceSpwc4a_3v7LQ5RAz52ZfB',
  clientKey: 'SB-Mid-client-Wg07joWeF1pPp6mW',
});


// Endpoint untuk membuat transaksi
app.post('/create-transaction', async (req, res) => {
  const { id_event, nama_event, htm_event, nama_user, email_user } = req.body;
  console.log(id_event, nama_event, htm_event, nama_user, email_user);
  const parameter = {
    transaction_details: {
      order_id: `ORDER-${Date.now()}`, // ID unik untuk transaksi
      gross_amount: htm_event,
    },
    item_details: [
      {
        id: id_event,
        price: htm_event,
        quantity: 1,
        name: nama_event,
      },
    ],
    customer_details: {
      first_name: nama_user,
      email: email_user,
    },
  };

  try {
    const transaction = await snap.createTransaction(parameter);
    res.json({ token: transaction.token, redirect_url: transaction.redirect_url });
  } catch (error) {
    console.error('Error creating transaction:', error);
    res.status(500).json({ error: 'Failed to create transaction' });
  }
});


//============================================================

// Endpoint untuk mengambil data event
app.get('/getFilteredEvents', async (req, res) => {
  const { category, location, date1, date2, page = 1, limit = 10 } = req.query;

  try {
    let query = {};

    // Filter berdasarkan kategori
    if (category && category !== 'All Class') {
      query.kategori_event = category;
    }

    // Filter berdasarkan lokasi
    if (location && location !== 'Semua Lokasi') {
      query.kota_event = location;
    }

    // Filter berdasarkan tanggal
    if (date1 && date2) {
      query.tanggal_event = {
        $gte: new Date(date1),
        $lte: new Date(date2),
      };
    } else if (date1) {
      query.tanggal_event = { $gte: new Date(date1) };
    } else if (date2) {
      query.tanggal_event = { $lte: new Date(date2) };
    }

    const pageNumber = parseInt(page);
    const limitNumber = parseInt(limit);
    const skip = (pageNumber - 1) * limitNumber;

    // Mengambil data dengan pagination
    const filteredEvents = await Event.find(query)
      .skip(skip)
      .limit(limitNumber);

    // Menghitung total data untuk pagination
    const totalEvents = await Event.countDocuments(query);

    res.status(200).json({
      events: filteredEvents,
      total: totalEvents,
      page: pageNumber,
      limit: limitNumber,
    });
  } catch (err) {
    res.status(500).send("Gagal mengambil data: " + err.message);
  }

});


app.get('/getTickets/:id_user', async (req, res) => {
  const { id_user} = req.params;

  try {
    if (!id_user) {
      return res.status(400).send("id user tidak ditemukan");
    }
    const tickets = await Ticket.find({ id_user });
    console.log("ini ticket", tickets)
    // if (tickets.length === 0) {
    //   return res.status(404).json({ status: "failed", message: 'Anda belum memiliki ticket' });
    // }

    res.status(200).json({ 
      status: 'success', 
      data: tickets 
    });
  } catch (err) {
    res.status(500).send("Failed to retrieve tickets: " + err.message);
  }
});


// Endpoint untuk membuat reservasi
app.post('/createReservation', async (req, res) => {
  const { id_user, id_event, nama_tim, metode_pembayaran } = req.body;

  // Validasi input
  if (!id_user || !id_event || !nama_tim) {
    return res.status(400).json({ status: "failed", message: "Semua field harus diisi!" });
  }

  try {
    // Cek apakah nama tim sudah digunakan
    const existingReservation = await Reservation.findOne({ nama_tim, id_event });
    if (existingReservation) {
      return res.status(400).json({ 
        status: "failed", 
        message: "Nama tim sudah digunakan untuk event ini!" 
      });
    }

    const newReservation = new Reservation({
      id_user,
      id_event,
      nama_tim,
      status: 'Pending Payment',
      metode_pembayaran, // Status awal
      reserved_at: new Date(),
    });

    const savedReservation = await newReservation.save();
    res.status(201).json({ 
      status: "success", 
      message: 'Reservasi berhasil dibuat!', 
      data: savedReservation 
    });
  } catch (err) {
    res.status(500).json({ 
      status: "failed", 
      message: 'Gagal membuat reservasi: ' + err.message 
    });
  }
});

// Endpoint untuk membuat pembayaran menggunakan Midtrans
// app.post('/createPayment', async (req, res) => {
//   const { reservation_id} = req.body;

//   // Validasi input
//   if (!reservation_id) {
//     return res.status(400).json({ 
//       status: "failed", 
//       message: "Reservation ID harus diisi!" 
//     });
//   }

//   try {
//     // Cari reservasi dan populate data event dan user
//     const reservation = await Reservation.findById(reservation_id)
//       .populate('id_event')
//       .populate('id_user');

//     console.log("Reservasi", reservation)
//     if (!reservation) {
//       return res.status(404).json({ 
//         status: "failed", 
//         message: 'Reservasi tidak ditemukan!' 
//       });
//     }

//     // Validasi status reservasi
//     if (reservation.status !== 'Pending Payment') {
//       return res.status(400).json({ 
//         status: "failed", 
//         message: 'Reservasi tidak dalam status Pending Payment!' 
//       });
//     }

//     // Validasi harga event
//     const hargaEvent = reservation.id_event.htm_event;
//     if (!hargaEvent || hargaEvent <= 0) {
//       return res.status(400).json({ 
//         status: "failed", 
//         message: 'Harga event tidak valid!' 
//       });
//     }

//     // Buat parameter transaksi Midtrans
//     const parameter = {
//       transaction_details: {
//         order_id: `ORDER-${Date.now()}-${reservation_id}`, // ID unik untuk transaksi
//         gross_amount: hargaEvent,
//       },
//       item_details: [
//         {
//           id: reservation.id_event._id,
//           price: hargaEvent,
//           quantity: 1,
//           name: reservation.id_event.nama_event,
//         },
//       ],
//       customer_details: {
//         first_name: reservation.id_user.nama_user,
//         email: reservation.id_user.email_user,
//         phone: reservation.id_user.tlpn_user,
//       },
//       enabled_payments: [reservation.metode_pembayaran], // Metode pembayaran yang diaktifkan
//     };

//     // Buat transaksi Midtrans
//     const transaction = await snap.createTransaction(parameter);

//     // Simpan data pembayaran sesuai model Payment
//     const newPayment = new Payment({
//       id_payment: transaction.token, // Token dari Midtrans
//       id_reservasi: reservation_id, // Referensi ke model Reservation
//       total_harga: hargaEvent,
//       metode_pembayaran : reservation.metode_pembayaran, // Total harga dari event
//       status: 'Pending', // Status awal pembayaran
//       confirmation_receipt: transaction.redirect_url, // URL redirect Midtrans
//     });

//     await newPayment.save();

//     // Update status reservasi
//     reservation.status = 'Pending Payment';
//     await reservation.save();

//     // Response sukses
//     res.status(201).json({ 
//       status: 'success',
//       message: 'Pembayaran berhasil dibuat!', 
//       data: {
//         payment: newPayment,
//         redirect_url: transaction.redirect_url,
//       },
//     });
//   } catch (err) {
//     console.error('Error creating payment:', err);
//     res.status(500).json({ 
//       status: "failed", 
//       message: 'Gagal membuat pembayaran: ' + err.message 
//     });
//   }
// });

// Endpoint untuk membuat pembayaran menggunakan Midtrans
app.post('/createPayment', async (req, res) => {
  const { id_reservasi, total_harga, metode_pembayaran } = req.body;

  // Validasi input
  if (!id_reservasi || !total_harga || !metode_pembayaran) {
    return res.status(400).json({
      status: "failed",
      message: "Reservation ID, total harga, dan metode pembayaran harus diisi!"
    });
  }

  try {
    // Cari reservasi dan populate data event dan user
    const reservation = await Reservation.findById(id_reservasi)
      .populate('id_event')
      .populate('id_user');

    if (!reservation) {
      return res.status(404).json({
        status: "failed",
        message: 'Reservasi tidak ditemukan!'
      });
    }

    // Validasi status reservasi
    if (reservation.status !== 'Pending Payment') {
      return res.status(400).json({
        status: "failed",
        message: 'Reservasi tidak dalam status Pending Payment!'
      });
    }

    // Buat parameter transaksi Midtrans
    const parameter = {
      transaction_details: {
        order_id: `ORDER-${Date.now()}-${id_reservasi}`, // ID unik untuk transaksi
        gross_amount: total_harga,
      },
      item_details: [
        {
          id: reservation.id_event._id,
          price: total_harga,
          quantity: 1,
          name: reservation.id_event.nama_event,
        },
      ],
      customer_details: {
        first_name: reservation.id_user.nama_user,
        email: reservation.id_user.email_user,
        phone: reservation.id_user.tlpn_user,
      },
      enabled_payments: [metode_pembayaran], // Metode pembayaran yang diaktifkan
      finish_redirect_url: 'https://your-frontend-url.com/payment-success', // URL pengalihan saat pembayaran berhasil
    };

    // Buat transaksi Midtrans
    const transaction = await snap.createTransaction(parameter);

    // Simpan data pembayaran sesuai model Payment
    const newPayment = new Payment({
      id_payment: transaction.token, // Token dari Midtrans
      id_reservasi: id_reservasi, // Referensi ke model Reservation
      total_harga: total_harga,
      metode_pembayaran: metode_pembayaran,
      status: 'Pending', // Status awal pembayaran
      confirmation_receipt: transaction.redirect_url, // URL redirect Midtrans
    });

    await newPayment.save();

    // Update status reservasi
    reservation.status = 'Pending Payment';
    await reservation.save();

    // Response sukses
    res.status(201).json({
      status: 'success',
      message: 'Pembayaran berhasil dibuat!',
      data: {
        payment: newPayment,
        redirect_url: transaction.redirect_url,
      },
    });
  } catch (err) {
    console.error('Error creating payment:', err);
    res.status(500).json({
      status: "failed",
      message: 'Gagal membuat pembayaran: ' + err.message
    });
  }
});

// Endpoint untuk memeriksa status pembayaran
app.get('/checkPaymentStatus/:id_payment', async (req, res) => {
  const { id_payment } = req.params;

  try {
    const payment = await Payment.findOne({ id_payment });
    if (!payment) {
      return res.status(404).json({ status: "failed", message: 'Pembayaran tidak ditemukan!' });
    }

    // Periksa status pembayaran dari Midtrans
    const statusResponse = await snap.transaction.status(id_payment);

    // Update status pembayaran dan reservasi
    if (statusResponse.transaction_status === 'settlement') {
      payment.status = 'Paid';
      await payment.save();

      const reservation = await Reservation.findById(payment.id_reservasi);
      reservation.status = 'Paid';
      await reservation.save();
    } else if (statusResponse.transaction_status === 'expire') {
      payment.status = 'Failed';
      await payment.save();

      const reservation = await Reservation.findById(payment.id_reservasi);
      reservation.status = 'Failed';
      await reservation.save();
    }

    res.status(200).json({ 
      status: 'success',
      message: 'Status pembayaran diperbarui!', 
      data: payment 
    });
  } catch (err) {
    res.status(500).json({ 
      status: "failed", 
      message: 'Gagal memeriksa status pembayaran: ' + err.message 
    });
  }
});

// Callback Midtrans untuk mengupdate status reservasi dan pembayaran
// Endpoint untuk menangani callback dari Midtrans
// ==================
app.post('/midtrans-callback', async (req, res) => {
  const notification = req.body;
  console.log('Received Midtrans notification:', notification);

  try {
    // Validasi signature key (jika menggunakan secure notification)
    // const isValid = midtransClient.Coreapi().validate(notification);
    // if (!isValid) return res.status(401).send('Invalid signature');

    const { order_id, transaction_status, fraud_status } = notification;
    
    // Ekstrak ID reservasi dari order_id (format: ORDER-timestamp-reservationId)
    const reservationId = order_id.split('-')[2];
    
    // 1. Update status pembayaran
    const payment = await Payment.findOneAndUpdate(
      { id_reservasi: reservationId },
      { 
        status: getPaymentStatus(transaction_status, fraud_status),
        updated_at: new Date()
      },
      { new: true }
    );

    if (!payment) {
      return res.status(404).json({ status: "failed", message: "Pembayaran tidak ditemukan" });
    }

    // 2. Update status reservasi
    const reservation = await Reservation.findByIdAndUpdate(
      reservationId,
      { 
        status: getReservationStatus(transaction_status, fraud_status),
        updated_at: new Date()
      },
      { new: true }
    );

    if (!reservation) {
      return res.status(404).json({ status: "failed", message: "Reservasi tidak ditemukan" });
    }

    // 3. Jika pembayaran berhasil, buat tiket
    if (transaction_status === 'settlement' || (transaction_status === 'capture' && fraud_status === 'accept')) {
      const event = await Event.findById(reservation.id_event);
      const user = await User.findById(reservation.id_user);

      const newTicket = new Ticket({
        id_transaksi: order_id,
        id_user: user._id,
        id_event: event._id,
        nama_tim: reservation.nama_tim,
        tanggal_event: event.tanggal_event,
        waktu_event: event.waktu_event,
        nama_event: event.nama_event,
        htm_event: event.htm_event,
        lokasi_event: event.alamat_event,
        status_payment: new Date()
      });

      await newTicket.save();

      // Kirim notifikasi ke user (jika diperlukan)
      // await sendNotification(user, 'Pembayaran berhasil', `Tiket untuk ${event.nama_event} telah diterbitkan`);
    }

    res.status(200).json({ status: "success", message: "Status berhasil diperbarui" });
  } catch (err) {
    console.error("Error handling Midtrans callback:", err);
    res.status(500).json({ status: "failed", message: "Gagal memproses callback: " + err.message });
  }
});

// Helper functions untuk menentukan status
function getPaymentStatus(transactionStatus, fraudStatus) {
  switch (transactionStatus) {
    case 'capture':
      return fraudStatus === 'accept' ? 'Paid' : 'Pending';
    case 'settlement':
      return 'Paid';
    case 'pending':
      return 'Pending';
    case 'deny':
    case 'cancel':
    case 'expire':
      return 'Failed';
    default:
      return 'Pending';
  }
}

function getReservationStatus(transactionStatus, fraudStatus) {
  switch (transactionStatus) {
    case 'capture':
      return fraudStatus === 'accept' ? 'Confirmed' : 'Pending Payment';
    case 'settlement':
      return 'Confirmed';
    case 'pending':
      return 'Pending Payment';
    case 'deny':
    case 'cancel':
    case 'expire':
      return 'Canceled';
    default:
      return 'Pending Payment';
  }
}
// ==================


// app.post('/midtrans-callback', async (req, res) => {
//   const { order_id, transaction_status, fraud_status } = req.body;

//   try {
//     // Extract reservation ID dari order_id
//     const reservationId = order_id.split('-')[2];

//     // Cari reservasi berdasarkan ID
//     const reservation = await Reservation.findById(reservationId);
//     if (!reservation) {
//       return res.status(404).json({ status: "failed", message: "Reservasi tidak ditemukan!" });
//     }

//     // Cari pembayaran terkait reservasi
//     const payment = await Payment.findOne({ id_reservasi: reservationId });
//     if (!payment) {
//       return res.status(404).json({ status: "failed", message: "Pembayaran tidak ditemukan!" });
//     }

//     // Update status berdasarkan status transaksi Midtrans
//     if (transaction_status === 'capture' && fraud_status === 'accept') {
//       reservation.status = 'Confirmed';
//       payment.status = 'Paid';
      
//     } else if (transaction_status === 'settlement') {
//       reservation.status = 'Confirmed';
//       payment.status = 'Paid';
//     } else if (transaction_status === 'cancel' || transaction_status === 'deny' || transaction_status === 'expire') {
//       reservation.status = 'Canceled';
//       payment.status = 'Failed';
//     } else if (transaction_status === 'pending') {
//       reservation.status = 'Pending Payment';
//       payment.status = 'Pending';
//     }

//     // Simpan perubahan ke database
//     await reservation.save();
//     await payment.save();

//     res.status(200).json({ status: "success", message: "Status reservasi dan pembayaran berhasil diperbarui!" });
//   } catch (err) {
//     console.error("Error handling Midtrans callback:", err);
//     res.status(500).json({ status: "failed", message: "Gagal memperbarui status: " + err.message });
//   }
// });



// Endpoint untuk mengambil data reservasi berdasarkan id_user
app.get('/getReservations/:id_user', async (req, res) => {
  const { id_user } = req.params;

  try {
    const userReservations = await Reservation.find({ id_user })
      .populate('id_event')
      .populate('id_user');

    if (userReservations.length === 0) {
      return res.status(404).json({ status: "failed", message: 'Tidak ada reservasi ditemukan' });
    }

    res.status(200).json({ 
      status: 'success', 
      data: userReservations 
    });
  } catch (err) {
    res.status(500).json({ 
      status: "failed", 
      message: 'Gagal mengambil data reservasi: ' + err.message 
    });
  }
});

// Fungsi untuk menghapus transaksi yang tidak diupdate menjadi "Paid" dalam waktu 24 jam
// const deleteUnpaidReservations = async () => {
//   try {
//     const twentyFourHoursAgo = new Date(Date.now() - 24 * 60 * 60 * 1000);

//     // Cari reservasi yang statusnya bukan "Paid" dan dibuat lebih dari 24 jam yang lalu
//     const unpaidReservations = await Reservation.find({
//       status: { $ne: "Paid" },
//       reserved_at: { $lt: twentyFourHoursAgo },
//     });

//     if (unpaidReservations.length > 0) {
//       // Hapus reservasi yang ditemukan
//       const reservationIds = unpaidReservations.map((reservation) => reservation._id);
//       await Reservation.deleteMany({ _id: { $in: reservationIds } });

//       // Hapus pembayaran terkait reservasi yang dihapus
//       await Payment.deleteMany({ id_reservasi: { $in: reservationIds } });

//       console.log(`${unpaidReservations.length} unpaid reservations deleted.`);
//     }
//   } catch (err) {
//     console.error("Error deleting unpaid reservations:", err.message);
//   }
// };

// // Jalankan fungsi setiap jam menggunakan setInterval
// setInterval(deleteUnpaidReservations, 60 * 60 * 1000); // Setiap 1 jam

// Endpoint untuk mengambil data reservasi berdasarkan id_user
app.get('/getReservations', async (req, res) => {

  try {
    const userReservations = await Reservation.find();

    if (userReservations.length > 0) {
      res.status(200).json(userReservations);
    } else {
      res.status(404).json({ message: 'Tidak ada reservasi ditemukan' });
    }
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil data reservasi: ' + err.message });
  }
});

// Endpoint untuk memperbarui status reservasi
app.put('/updateReservationStatus', async (req, res) => {
  const { reservation_id, status } = req.body;

  // Validasi input
  if (!reservation_id || !status) {
    return res.status(400).json({ status: "failed", message: "Reservation ID dan status harus diisi!" });
  }

  try {
    const reservation = await Reservation.findById(reservation_id);
    if (!reservation) {
      return res.status(404).json({ status: "failed", message: 'Reservasi tidak ditemukan!' });
    }

    reservation.status = status;
    await reservation.save();

    res.status(200).json({ 
      status: 'success', 
      message: 'Status reservasi berhasil diperbarui!', 
      data: reservation 
    });
  } catch (err) {
    res.status(500).json({ 
      status: "failed", 
      message: 'Gagal memperbarui status reservasi: ' + err.message 
    });
  }
});

// Endpoint untuk mengambil data reservasi berdasarkan id_user
app.get('/getPayment/:id_reservasi', async (req, res) => {
  const { id_reservasi } = req.params;

  try {
    const payment = await Payment.findOne({ id_reservasi });

    if (!payment) {
      return res.status(404).json({ message: 'Pembayaran tidak ditemukan!' });
    }

    res.status(200).json(payment);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil data pembayaran: ' + err.message });
  }
});

// Endpoint untuk membatalkan reservasi dan pembayaran
app.post('/cancelReservation', async (req, res) => {
  const { reservation_id } = req.body;

  // Validasi input
  if (!reservation_id) {
    return res.status(400).json({ 
      status: "failed", 
      message: "Reservation ID harus diisi!" 
    });
  }

  try {
    // Cari reservasi berdasarkan ID
    const reservation = await Reservation.findById(reservation_id);
    if (!reservation) {
      return res.status(404).json({ 
        status: "failed", 
        message: "Reservasi tidak ditemukan!" 
      });
    }

    // Periksa apakah reservasi sudah dibayar
    if (reservation.status === "Paid") {
      return res.status(400).json({ 
        status: "failed", 
        message: "Reservasi yang sudah dibayar tidak dapat dibatalkan!" 
      });
    }

    // Ubah status reservasi menjadi "Canceled"
    reservation.status = "Canceled";
    await reservation.save();

    // Ubah status pembayaran menjadi "Canceled"
    const payment = await Payment.findOne({ id_reservasi: reservation_id });
    if (payment) {
      payment.status = "Canceled";
      await payment.save();
    }

    res.status(200).json({ 
      status: "success", 
      message: "Reservasi berhasil dibatalkan!" 
    });
  } catch (err) {
    res.status(500).json({ 
      status: "failed", 
      message: "Gagal membatalkan reservasi: " + err.message 
    });
  }
});


// app.get('/getPaymentMethods', async (req, res) => {
//   try {
//     const enabledPayments = ['other_qris', 'bank_transfer']; // Sesuaikan dengan yang diaktifkan di Midtrans
//     res.status(200).json({ 
//       status: 'success', 
//       data: enabledPayments 
//     });
//   } catch (err) {
//     res.status(500).json({ 
//       status: 'failed', 
//       message: 'Gagal mengambil metode pembayaran: ' + err.message 
//     });
//   }
// });

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));


// Route untuk halaman success/failed
app.get('/payment/success', (req, res) => {
  res.status(200).sendFile(path.resolve(__dirname, 'public', 'success.html'));
});

app.get('/payment/failed', (req, res) => {
  res.status(200).sendFile(path.resolve(__dirname, 'public', 'failed.html'));
});


// Fungsi untuk menyimpan gambar ke mongodb
const multer = require('multer');
const { GridFsStorage } = require('multer-gridfs-storage');

// Konfigurasi GridFS Storage
const storage = new GridFsStorage({
  url: 'mongodb+srv://pitboxproject:gvoucher123@pitboxproject.a7j7i.mongodb.net/pitbox?retryWrites=true&w=majority',
  file: (req, file) => {
    return {
      filename: `${Date.now()}-${file.originalname}`,
      bucketName: 'uploads', // Nama bucket di MongoDB
    };
  },
});

const upload = multer({ storage });

// Endpoint untuk mengunggah gambar
app.post('/uploadImage', upload.single('image'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: 'Gambar tidak ditemukan!' });
  }
  res.status(200).json({
    message: 'Gambar berhasil diunggah!',
    fileId: req.file.id, // ID file di GridFS
  });
});


app.get('/getImage/:id', async (req, res) => {
  const fileId = req.params.id;

  try {
    const file = await gfs.files.findOne({ _id: new mongoose.Types.ObjectId(fileId) });
    if (!file) {
      return res.status(404).json({ message: 'Gambar tidak ditemukan!' });
    }

    const readStream = gfs.createReadStream({ _id: file._id });
    readStream.pipe(res);
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil gambar: ' + err.message });
  }
});