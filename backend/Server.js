const express  = require('express');
const mongoose = require('mongoose');
const cors     = require('cors');
const bcrypt   = require('bcryptjs');
const jwt      = require('jsonwebtoken');

const app = express();
app.use(cors());
app.use(express.json());

const MONGO_URI  = 'mongodb://127.0.0.1:27017/majiSmartDB';
const PORT       = 3000;
const JWT_SECRET = 'your_super_secret_jwt_key_change_this_in_production';

mongoose.connect(MONGO_URI)
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB error:', err.message));

// User Schema
const userSchema = new mongoose.Schema({
  name:     { type: String, required: true, trim: true },
  email:    { type: String, required: true, unique: true, lowercase: true, trim: true },
  phone:    { type: String, default: '' },
  role:     { type: String, default: 'System Administrator' },
  password: { type: String, required: true },
}, { timestamps: true });

userSchema.pre('save', async function (next) {
  if (!this.isModified('password')) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

const User = mongoose.model('User', userSchema);

// Auth Middleware
function authMiddleware(req, res, next) {
  const header = req.headers.authorization;
  if (!header || !header.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'No token provided' });
  }
  try {
    const decoded = jwt.verify(header.split(' ')[1], JWT_SECRET);
    req.userId = decoded.id;
    next();
  } catch {
    res.status(401).json({ error: 'Invalid or expired token' });
  }
}

// POST /api/auth/signup
app.post('/api/auth/signup', async (req, res) => {
  try {
    const { name, email, password, phone, role } = req.body;

    if (!name || !email || !password)
      return res.status(400).json({ error: 'Name, email and password are required' });

    const exists = await User.findOne({ email });
    if (exists)
      return res.status(409).json({ error: 'Email already registered' });

    const user = await User.create({ name, email, password, phone, role });
    const token = jwt.sign({ id: user._id }, JWT_SECRET, { expiresIn: '7d' });

    res.status(201).json({
      token,
      user: {
        id:    user._id,
        name:  user.name,
        email: user.email,
        role:  user.role,
        phone: user.phone,
      },
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/auth/login
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password)
      return res.status(400).json({ error: 'Email and password are required' });

    const user = await User.findOne({ email });
    if (!user) return res.status(401).json({ error: 'Invalid credentials' });

    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(401).json({ error: 'Invalid credentials' });

    const token = jwt.sign({ id: user._id }, JWT_SECRET, { expiresIn: '7d' });

    res.json({
      token,
      user: {
        id:    user._id,
        name:  user.name,
        email: user.email,
        role:  user.role,
        phone: user.phone,
      },
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET /api/auth/me
app.get('/api/auth/me', authMiddleware, async (req, res) => {
  try {
    const user = await User.findById(req.userId).select('-password');
    if (!user) return res.status(404).json({ error: 'User not found' });
    res.json({
      id:    user._id,
      name:  user.name,
      email: user.email,
      role:  user.role,
      phone: user.phone,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PATCH /api/auth/me
app.patch('/api/auth/me', authMiddleware, async (req, res) => {
  try {
    const allowed = ['name', 'phone', 'role'];
    const updates = {};
    allowed.forEach(k => {
      if (req.body[k] !== undefined) updates[k] = req.body[k];
    });

    if (req.body.password) {
      updates.password = await bcrypt.hash(req.body.password, 10);
    }

    const user = await User.findByIdAndUpdate(req.userId, updates, { new: true }).select('-password');
    res.json({
      id:    user._id,
      name:  user.name,
      email: user.email,
      role:  user.role,
      phone: user.phone,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Meter Schema
const meterSchema = new mongoose.Schema({
  name:       { type: String,  default: 'Main Water Meter' },
  location:   { type: String,  default: 'Ngara Estate - Block 3' },
  meterId:    { type: String,  default: 'NWM-2024-047' },
  flowRate:   { type: Number,  default: 12.5 },
  todayUsage: { type: Number,  default: 0 },
  isFlowing:  { type: Boolean, default: true },
  updatedAt:  { type: String,  default: () => new Date().toLocaleTimeString() },
}, { timestamps: true });

const Meter = mongoose.model('Meter', meterSchema);

async function getMeter() {
  let meter = await Meter.findOne();
  if (!meter) meter = await Meter.create({});
  return meter;
}

// GET /api/meter
app.get('/api/meter', authMiddleware, async (req, res) => {
  try {
    const meter = await getMeter();
    res.json(meter);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PATCH /api/meter
app.patch('/api/meter', authMiddleware, async (req, res) => {
  try {
    const meter = await getMeter();
    const allowed = ['name', 'location', 'meterId', 'flowRate', 'todayUsage', 'isFlowing'];
    allowed.forEach(key => {
      if (req.body[key] !== undefined) meter[key] = req.body[key];
    });
    meter.updatedAt = new Date().toLocaleTimeString();
    await meter.save();
    res.json(meter);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Listen on 0.0.0.0 so Android emulator can reach the server via 10.0.2.2
app.listen(PORT, '0.0.0.0', () => {
  console.log('Server running on port ' + PORT);
  console.log('Listening on all interfaces - emulator can connect via 10.0.2.2:' + PORT);
});