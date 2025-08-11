import express from 'express';
import mysql from 'mysql2';
import cors from 'cors';
import multer from 'multer';
import path from 'path';
import fs from 'fs';

import dotenv from 'dotenv';
dotenv.config();

const db = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
}).promise();

const app = express();
app.use(cors());
app.use(express.json());

// Tworzenie folderu na upload, jeśli nie istnieje
const uploadDir = 'images';
if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

// Konfiguracja Multer do przechwytywania plików
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, uploadDir);
    },
    filename: (req, file, cb) => {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname));
    }
});

const upload = multer({
    storage: storage,
    limits: {
        fileSize: 5 * 1024 * 1024 // limit 5 MB
    },
    fileFilter: (req, file, cb) => {
        const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png'];
        if (allowedTypes.includes(file.mimetype)) {
            cb(null, true);
        } else {
            cb(new Error('Niepoprawny typ pliku. Dozwolone: JPEG, PNG.'));
        }
    }
});

app.get('/images/:filename', (req, res) => {
    try {
        const filename = req.params.filename;
        const filePath = path.join('images', filename);

        // Sprawdź czy plik istnieje
        if (!fs.existsSync(filePath)) {
            return res.status(404).json({ error: 'Zdjęcie nie zostało znalezione' });
        }

        // NAGŁÓWKI ZAPOBIEGAJĄCE CACHE'OWANIU
        res.set({
            'Cache-Control': 'no-cache, no-store, must-revalidate, private, max-age=0',
            'Pragma': 'no-cache',
            'Expires': '0',
            'Last-Modified': new Date().toUTCString(),
            'Content-Type': 'image/png' // lub dynamicznie na podstawie rozszerzenia
        });

        setTimeout(() => {
            res.sendFile(path.resolve(filePath));
        }, 5000);
        // Wyślij plik
        //res.sendFile(path.resolve(filePath));
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Błąd serwera' });
    }
});

/*
app.use('/images', express.static(uploadDir, {
  maxAge: '1d',
  setHeaders: (res, path) => {
    res.set('Cache-Control', 'public, max-age=86400');
  }
}));
*/

app.get('/products', async (req, res) => {
    try {
        const [result] = await db.query(`
            SELECT p.*, c.category, d.width, d.height, d.length 
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            LEFT JOIN dimensions d ON p.id = d.product_id
        `);
        res.json(result);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Błąd serwera' });
    }
});


app.post('/products', upload.single('image'), async (req, res) => {
    const connection = await db.getConnection();

    try {
        await connection.beginTransaction();

        const { id, name, brand, materials, fit, color, price, category_id, width, height, length } = req.body;
        const imagePath = req.file ? req.file.path : null;

        const [productResult] = await connection.query(`
            INSERT INTO products (id, category_id, name, brand, materials, fit, color, image, price) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        `, [id, category_id, name, brand, materials, fit, color, imagePath, price]);

        if (width || height || length) {
            await connection.query(`
                INSERT INTO dimensions (product_id, width, height, length) 
                VALUES (?, ?, ?, ?)
            `, [id, width || 0, height || 0, length || 0]);
        }

        await connection.commit();

        const [newProduct] = await connection.query(`
            SELECT p.*, c.category, d.width, d.height, d.length 
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            LEFT JOIN dimensions d ON p.id = d.product_id
            WHERE p.id = ?
        `, [id]);

        res.status(201).json(newProduct[0]);

    } catch (error) {
        await connection.rollback();
        console.error(error);
        if (req.file && fs.existsSync(req.file.path)) {
            fs.unlinkSync(req.file.path);
        }
        if (error.code === 'ER_DUP_ENTRY') {
            return res.status(409).json({
                error: `Produkt o ID ${req.body.id} już istnieje`
            });
        }
        res.status(500).json({ error: 'Błąd dodawania produktu' });
    } finally {
        connection.release();
    }
});


app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});

app.listen(3000, () => console.log('Server running on port 3000'));

/*
// 'image' to pole z formularza (klucz pliku)
app.post('/product', upload.single('image'), (req, res) => {
    // Dane tekstowe z formularza
    const {
        id,
        category_id,
        name,
        brand,
        materials,
        fit,
        color,
        price,
        dimensions  // np. '{"width": 10, "height":20, "length":30}'
    } = req.body;

    if (id === undefined) {
        return res.status(400).json({ error: "'id' is required and must be unique" });
    }

    // Pobierz nazwę pliku (ścieżka względna do zapisu w bazie)
    const image = req.file ? req.file.filename : null;

    const sqlProduct = `INSERT INTO products (id, category_id, name, brand, materials, fit, color, image, price)
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`;

    db.query(sqlProduct, [id, category_id, name, brand, materials, fit, color, image, price], (err, result) => {
        if (err) {
            if (err.code === 'ER_DUP_ENTRY') {
                return res.status(409).json({ error: 'ID already exists' });
            }
            return res.status(500).json(err);
        }

        // Jeśli są wymiary, wstawiamy je do tabeli dimensions
        let dimsObj = null;
        try { dimsObj = dimensions ? JSON.parse(dimensions) : null; } catch { dimsObj = null; }

        if (!dimsObj) {
            return res.status(201).json({ id, category_id, name, brand, materials, fit, color, image, price });
        }
        const { width, height, length } = dimsObj;

        const sqlDimensions = `
            INSERT INTO dimensions (product_id, width, height, length)
            VALUES (?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE width = VALUES(width), height = VALUES(height), length = VALUES(length)
        `;
        db.query(sqlDimensions, [id, width, height, length], (err2, result2) => {
            if (err2) return res.status(500).json(err2);

            res.status(201).json({
                id,
                category_id,
                name,
                brand,
                materials,
                fit,
                color,
                image,
                price,
                dimensions: { width, height, length }
            });
        });
    });
});




app.get('/category', (req, res) => {
    const { id } = req.query;
    if (!id)
        return res.status(400).json({ error: "Parameter 'id' is required" });
    db.query('SELECT * FROM products WHERE category_id = ?', [id], (err, rows) => {
        if (err) return res.status(500).json(err);
        res.json(rows);
    });
});

app.get('/search', (req, res) => {
    const q = req.query.q;
    if (!q) return res.json([]);
    const sql = `
    SELECT p.*, c.name AS category_name
    FROM products p
    LEFT JOIN categories c ON p.category_id = c.id
    WHERE
      p.name      LIKE ? OR
      p.brand     LIKE ? OR
      p.color     LIKE ? OR
      p.material  LIKE ? OR
      c.name      LIKE ?`;
    const value = `%${q}%`;
    db.query(sql, [value, value, value, value, value], (err, rows) => {
        if (err) return res.status(500).json(err);
        res.json(rows);
    });

});

app.get('/filter', (req, res) => {
    const categories = req.query.categories ? req.query.categories.split(',') : [];
    const colors = req.query.colors ? req.query.colors.split(',') : [];
    const materials = req.query.materials ? req.query.materials.split(',') : [];
    const fits = req.query.fits ? req.query.fits.split(',') : [];

    if (
        categories.length === 0 &&
        colors.length === 0 &&
        materials.length === 0 &&
        fits.length === 0
    ) {
        return res.json([]);
    }

    let sql = `
        SELECT p.*, c.category AS category_name
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        WHERE
    `;
    let params = [];
    const conditions = [];

    if (categories.length > 0) {
        conditions.push(`c.category IN (${categories.map(() => '?').join(',')})`);
        params.push(...categories);
    }
    if (colors.length > 0) {
        conditions.push(`p.color IN (${colors.map(() => '?').join(',')})`);
        params.push(...colors);
    }
    if (materials.length > 0) {
        conditions.push(`p.materials IN (${materials.map(() => '?').join(',')})`);
        params.push(...materials);
    }
    if (fits.length > 0) {
        conditions.push(`p.fit IN (${fits.map(() => '?').join(',')})`);
        params.push(...fits);
    }

    sql += conditions.join(' OR ');

    db.query(sql, params, (err, rows) => {
        if (err) return res.status(500).json(err);

        const productsWithPhotoUrl = rows.map(row => ({
            ...row,
            image: row.image
                ? `${req.protocol}://${req.get('host')}/uploads/${row.image}`
                : null
        }));

        res.json(productsWithPhotoUrl);
    });
});
*/


