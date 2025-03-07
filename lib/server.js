const express = require('express');
const multer = require('multer');
const cors = require('cors');
const mongoose = require('mongoose');
const PORT = process.env.PORT || 8080;
const { GridFsStorage } = require('multer-gridfs-storage');
const Grid = require('gridfs-stream');
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
});

// Model Reservation
const reservationSchema = new mongoose.Schema({
  id_user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  id_event: { type: mongoose.Schema.Types.ObjectId, ref: 'Event', required: true },
  nama_tim: { type: String, required: true },
  status: { type: String, required: true },
  reserved_at: { type: Date, default: Date.now },
});

// Model Payment
const paymentSchema = new mongoose.Schema({
  id_payment: { type: String, required: true },
  id_reservasi: { type: mongoose.Schema.Types.ObjectId, ref: 'Reservation', required: true },
  total_harga: { type: Number, required: true },
  metode_pembayaran: { type: String, required: true },
  status: { type: String, required: true },
  confirmation_receipt: { type: String, required: true },
});

// Model User
const userSchema = new mongoose.Schema({
  username: { type: String, required: true },
  nama_user: { type: String },
  kota_user: { type: String },
  tlpn_user: { type: String },
  email_user: { type: String },
  password_user: { type: String },
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
  tanggal_event: { type: Date, required: true },
  waktu_event: { type: String, required: true },
  nama_event: { type: String, required: true },
  htm_event: { type: String, required: true },
  lokasi_event: { type: String, required: true },
  status_payment: { type: Date, required: true },
});


// Mendeklarasikan Model
const User = mongoose.models.Users || mongoose.model('User', userSchema);
const Organizer = mongoose.models.Organizer || mongoose.model('Organizer', organizerSchema);
const Region = mongoose.models.Region || mongoose.model('Region', regionSchema);
const Event = mongoose.models.Event || mongoose.model('Event', eventSchema);
const Ticket = mongoose.models.Ticket || mongoose.model('Ticket', ticketSchema);
const Reservation = mongoose.models.Reservation || mongoose.model('Reservation', reservationSchema);
const Payment = mongoose.models.Reservation || mongoose.model('Payment', paymentSchema);


// Route Cek Koneksi
app.get('/getStatus', (req, res) => {
  mongoose.connection.readyState === 1
    ? res.status(200).send("Koneksi MongoDB berhasil!")
    : res.status(500).send("Koneksi Mo  ngoDB gagal!");p
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

// Update User
app.put('/updateUser', async (req, res) => {
  const { id_user, username, nama_user, tlpn_user, email_user, kota_user, password_user } = req.body;

  // Buat objek untuk field yang akan diupdate
  const updateFields = {};
  if (username) updateFields.username = username;
  if (nama_user) updateFields.nama_user = nama_user;
  if (tlpn_user) updateFields.tlpn_user = tlpn_user;
  if (email_user) updateFields.email_user = email_user;
  if (kota_user) updateFields.kota_user = kota_user;
  if (password_user) updateFields.password_user = await hashPassword(password_user); // Hash password jika diupdate

  // Pastikan ada field yang diupdate
  if (Object.keys(updateFields).length === 0) {
    return res.status(400).send("Tidak ada data yang dikirim untuk diperbarui.");
  }

  try {
    const user = await User.findOneAndUpdate(
      { id_user },
      updateFields,  // Update field yang dikirim
      { new: true }  // Mengembalikan data setelah update
    );

    if (!user) {
      return res.status(404).send("User tidak ditemukan!");
    }

    res.status(200).json({ message: 'Update berhasil!', user });
  } catch (err) {
    res.status(500).send("Gagal memperbarui data: " + err.message);
  }
});

// Endpoint untuk memperbarui password pengguna
app.put('/updatePassword', async (req, res) => {
  const { id_user, current_password, new_password } = req.body;

  try {
    // Mencari user berdasarkan id_user
    const user = await User.findOne({ id_user });
    if (!user) {
      return res.status(404).json({ status: 'gagal', message: 'Pengguna tidak ditemukan' });
    }

    // Verifikasi password saat ini
    if (!verifyPassword(current_password, user.password_user)) {
      return res.status(400).json({ status: 'gagal', message: "Password lama Anda salah!" });
    }
    
    const hashedPassword = await hashPassword(new_password);

    // Hash password baru
    user.password_user = hashedPassword;

    // Simpan perubahan
    await user.save();

    res.status(200).json({ status: 'sukses', message: 'Password berhasil diperbarui' });
  } catch (err) {
    res.status(500).json({ status: 'gagal', message: 'Gagal memperbarui password: ' + err.message });
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

// Register Organizer DONE
app.post('/registerOrganizer', async (req, res) => {
    const { id_organizer, nama_organizer, email_organizer, tlpn_organizer, kota_organizer, alamat_organizer, password_organizer } = req.body;
    try {
      const newItem = new Organizer({ id_organizer, nama_organizer, email_organizer, tlpn_organizer, kota_organizer, alamat_organizer, password_organizer });
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
  const { id_event, nama_event, kategori_event, htm_event, tanggal_event, waktu_event, kota_event, alamat_event, deskripsi_event } = req.body;
  console.log("Ini Nama Event: ", nama_event)
  console.log("Ini Tanggal Event: ", tanggal_event)
  console.log("Ini Waktu Event: ", waktu_event)
  try {
    const newItem = new Event({ id_event, nama_event, kategori_event, htm_event, tanggal_event, waktu_event, kota_event, alamat_event, deskripsi_event });
    await newItem.save();
    res.status(201).send("Event berhasil dibuat");
  } catch (err) {
    res.status(500).send("Event gagal dibuat: " + err.message);
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


app.get('/getTickets', async (req, res) => {
  try {
    const tickets = await Ticket.find();
    console.log(tickets);
    res.status(200).json(tickets);
  } catch (err) {
    res.status(500).send("Failed to retrieve tickets: " + err.message);
  }
});


// Endpoint untuk membuat reservasi
app.post('/createReservation', async (req, res) => {
  const { id_user, id_event, nama_tim, status } = req.body;

  try {
    const newReservation = new Reservation({
      id_user,
      id_event,
      nama_tim,
      status: 'Pending', // Set status awal menjadi Pending
      reserved_at: new Date().toISOString()
    });

    await newReservation.save();
    res.status(201).json({ message: 'Reservasi berhasil dibuat!', reservation: newReservation });
  } catch (err) {
    res.status(500).json({ message: 'Gagal membuat reservasi: ' + err.message });
  }
});

// Endpoint untuk membuat pembayaran menggunakan Midtrans
app.post('/createPayment', async (req, res) => {
  const { id_reservasi, total_harga, metode_pembayaran } = req.body;

  try {
    // Mencari reservasi berdasarkan id_reservasi
    const reservation = await Reservation.findById(id_reservasi);
    if (!reservation) {
      return res.status(404).json({ message: 'Reservasi tidak ditemukan!' });
    }

    // Membuat parameter transaksi untuk Midtrans
    const parameter = {
      transaction_details: {
        order_id: `ORDER-${Date.now()}`, // ID unik untuk transaksi
        gross_amount: total_harga,
      },
      item_details: [
        {
          id: reservation.id_event,
          price: total_harga,
          quantity: 1,
          name: 'Pembayaran Reservasi',
        },
      ],
      customer_details: {
        first_name: reservation.nama_tim,
        email: 'email@example.com', // Ganti dengan email pengguna yang sesuai
      },
    };

    // Membuat transaksi menggunakan Midtrans
    const transaction = await snap.createTransaction(parameter);

    // Menyimpan data pembayaran ke dalam database
    const newPayment = new Payment({
      id_payment: transaction.token,
      id_reservasi,
      total_harga,
      metode_pembayaran,
      status: 'Pending',
      confirmation_receipt: transaction.redirect_url,
    });

    await newPayment.save();

    // Update status reservasi menjadi Paid jika pembayaran berhasil
    reservation.status = 'Paid';
    await reservation.save();

    res.status(201).json({ message: 'Pembayaran berhasil dibuat!', payment: newPayment, redirect_url: transaction.redirect_url });
  } catch (err) {
    res.status(500).json({ message: 'Gagal membuat pembayaran: ' + err.message });
  }
});

// Endpoint untuk memeriksa status pembayaran
app.get('/checkPaymentStatus/:id_payment', async (req, res) => {
  const { id_payment } = req.params;

  try {
    const payment = await Payment.findOne({ id_payment });
    if (!payment) {
      return res.status(404).json({ message: 'Pembayaran tidak ditemukan!' });
    }

    // Periksa status pembayaran dari Midtrans
    const statusResponse = await snap.transaction.status(id_payment);

    if (statusResponse.transaction_status === 'settlement') {
      payment.status = 'Paid';
      await payment.save();

      // Update status reservasi menjadi Paid
      const reservation = await Reservation.findById(payment.id_reservasi);
      reservation.status = 'Paid';
      await reservation.save();
    } else if (statusResponse.transaction_status === 'expire') {
      payment.status = 'Failed';
      await payment.save();

      // Update status reservasi menjadi Failed
      const reservation = await Reservation.findById(payment.id_reservasi);
      reservation.status = 'Failed';
      await reservation.save();
    }

    res.status(200).json({ message: 'Status pembayaran diperbarui!', payment });
  } catch (err) {
    res.status(500).json({ message: 'Gagal memeriksa status pembayaran: ' + err.message });
  }
});

// app.get('/getReservations', async (req, res) => {
//   try {
//     const reservation = await Reservation.find();
//     console.log(reservation);
//     res.status(200).json(reservation);
//   } catch (err) {
//     res.status(500).send("Failed to retrieve reservation: " + err.message);
//   }
// });

// Endpoint untuk mengambil data reservasi berdasarkan id_user
app.get('/getReservations/:id_user', async (req, res) => {
  const { id_user } = req.params;

  try {
    const userReservations = await Reservation.find({ id_user }).populate('id_event');

    if (userReservations.length > 0) {
      res.status(200).json(userReservations);
    } else {
      res.status(404).json({ message: 'Tidak ada reservasi ditemukan' });
    }
  } catch (err) {
    res.status(500).json({ message: 'Gagal mengambil data reservasi: ' + err.message });
  }
});