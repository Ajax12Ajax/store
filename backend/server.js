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

const uploadDir = 'images';
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now();
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
      cb(new Error('Invalid file type. Allowed: JPEG, PNG.'));
    }
  }
});


const mapProduct = (rows) => {
  return rows.map(row => ({
    id: row.id,
    category: row.category,
    name: row.name,
    brand: row.brand,
    dimensions: {
      width: row.width,
      height: row.height,
      length: row.length
    },
    materials: row.materials ? row.materials.split(',') : [],
    fit: row.fit,
    color: row.color,
    price: row.price
  }));
}


app.get('/categories', async (req, res) => {
  try {
    const [result] = await db.query(`
            SELECT * FROM categories;  
        `);
    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.get('/products', async (req, res) => {
  try {
    const [result] = await db.query(`
            SELECT p.id, c.category, p.name, p.brand, d.width, d.height, d.length, p.materials, p.fit, p.color, p.price 
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            LEFT JOIN dimensions d ON p.id = d.product_id
        `);
    res.json(result);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.get('/product/:id', async (req, res) => {
  const id = req.params.id ? req.params.id.split(',') : [];
  if (!id.length) {
    return res.status(400).json({ error: "Parameter 'id' is required" });
  }
  try {
    const placeholders = id.map(() => '?').join(',');
    const [result] = await db.query(`
            SELECT p.id, c.category, p.name, p.brand, d.width, d.height, d.length, p.materials, p.fit, p.color, p.price
            FROM products p  
            LEFT JOIN categories c ON p.category_id = c.id
            LEFT JOIN dimensions d ON p.id = d.product_id
            WHERE p.id IN (${placeholders})
        `, id);
    res.json(mapProduct(result));
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.get('/product/:id/image', async (req, res) => {
  try {
    const id = req.params.id;
    const [fileName] = await db.query(`
            SELECT image FROM products WHERE id = ?
        `, [id]);
    const filePath = path.join('images', fileName[0]['image']);

    if (!fs.existsSync(filePath)) {
      return res.status(404).json({ error: 'Image not found' });
    }

    res.set({
      'Cache-Control': 'no-cache, no-store, must-revalidate, private, max-age=0',
      'Pragma': 'no-cache',
      'Expires': '0',
      'Last-Modified': new Date().toUTCString()
    });

    res.sendFile(path.resolve(filePath));
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.get('/category/:id', async (req, res) => {
  const category_id = req.params.id;
  if (!category_id) {
    return res.status(400).json({ error: "Parameter 'id' is required" });
  }
  const [categoryExists] = await db.query('SELECT id FROM categories WHERE id = ?', [category_id]);
  if (categoryExists.length === 0) {
    return res.status(404).json({ error: "Category not found" });
  }
  try {
    const [result] = await db.query(`
            SELECT p.id, c.category, p.name, p.brand, d.width, d.height, d.length, p.materials, p.fit, p.color, p.price 
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            LEFT JOIN dimensions d ON p.id = d.product_id
            WHERE p.category_id = ?
        `, [category_id]);

    res.json(mapProduct(result));
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });

  }
});

app.get('/search', async (req, res) => {
  const q = req.query.q;
  console.log('Search query:', q);
  if (!q) return res.json([]);
  try {
    const value = `%${q}%`;
    const [result] = await db.query(`
            SELECT p.id, c.category, p.name, p.brand, d.width, d.height, d.length, p.materials, p.fit, p.color, p.price
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.id
            LEFT JOIN dimensions d ON p.id = d.product_id
            WHERE
              p.name      LIKE ? OR
              p.brand     LIKE ? OR
              p.color     LIKE ? OR
              p.materials LIKE ? OR
              p.fit       LIKE ? OR
              c.category  LIKE ?
        `, [value, value, value, value, value, value]);
    res.json(mapProduct(result));
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Server error' });

  }
});

app.get('/product/:id/similar', async (req, res) => {
  const productId = req.params.id;

  if (!productId) {
    return res.status(400).json({ error: "Parameter 'id' is required" });
  }

  try {
    const [currentProduct] = await db.query(`
      SELECT p.id, p.category_id, p.name, p.brand, p.materials, p.fit, p.color, p.price,
             c.category, d.width, d.height, d.length
      FROM products p
      LEFT JOIN categories c ON p.category_id = c.id
      LEFT JOIN dimensions d ON p.id = d.product_id
      WHERE p.id = ?
    `, [productId]);

    if (currentProduct.length === 0) {
      return res.status(404).json({ error: 'Product not found' });
    }

    const product = currentProduct[0];

    const [similarProducts] = await db.query(`
      SELECT p.id, c.category, p.name, p.brand, d.width, d.height, d.length, 
             p.materials, p.fit, p.color, p.price,
             (
               CASE WHEN p.category_id = ? THEN 4 ELSE 0 END +
               CASE WHEN p.brand = ? THEN 3 ELSE 0 END +
               CASE WHEN p.color = ? THEN 3 ELSE 0 END +
               CASE WHEN p.fit = ? THEN 1 ELSE 0 END +
               CASE WHEN p.materials LIKE ? OR ? LIKE CONCAT('%', p.materials, '%') THEN 2 ELSE 0 END
             ) as similarity_score
      FROM products p
      LEFT JOIN categories c ON p.category_id = c.id
      LEFT JOIN dimensions d ON p.id = d.product_id
      WHERE p.id != ?
      HAVING similarity_score > 0
      ORDER BY similarity_score DESC, p.id ASC
      LIMIT 2
    `, [
      product.category_id,
      product.brand,
      product.color,
      product.fit,
      `%${product.materials}%`,
      `%${product.materials}%`,
      productId
    ]);
    
    //console.log(mapProduct(result.slice(0, 3)));
    setTimeout(() => {
      res.json(mapProduct(similarProducts));
    }, 5000);
    //res.json(mapProduct(similarProducts););

  } catch (error) {
    console.error('Error finding similar products:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

app.post('/recommendations/preview', async (req, res) => {
  try {
    const {
      categoryVisits = {},
      colorPreferences = {},
      materialPreferences = {},
      fitPreferences = {},
      itemClicks = {}
    } = req.body;



    console.log('Preview recommendations request:', {
      categoryVisits,
      colorPreferences,
      materialPreferences,
      fitPreferences,
      itemClicks
    });

    // Przygotuj warunki SQL na podstawie preferencji
    const buildPreferenceConditions = () => {
      const conditions = [];
      const params = [];

      const categories = Object.keys(categoryVisits);
      if (categories.length > 0) {
        const placeholders = categories.map(() => '?').join(',');
        conditions.push(`c.category IN (${placeholders})`);
        params.push(...categories);
      }

      const colors = Object.keys(colorPreferences);
      if (colors.length > 0) {
        const placeholders = colors.map(() => '?').join(',');
        conditions.push(`p.color IN (${placeholders})`);
        params.push(...colors);
      }

      const fits = Object.keys(fitPreferences);
      if (fits.length > 0) {
        const placeholders = fits.map(() => '?').join(',');
        conditions.push(`p.fit IN (${placeholders})`);
        params.push(...fits);
      }

      const materials = Object.keys(materialPreferences);
      if (materials.length > 0) {
        const materialConditions = materials.map(() => 'p.materials LIKE ?').join(' OR ');
        conditions.push(`(${materialConditions})`);
        params.push(...materials.map(m => `%${m}%`));
      }

      const clickedItems = Object.keys(itemClicks).map(Number);
      if (clickedItems.length > 0) {
        const placeholders = clickedItems.map(() => '?').join(',');
        conditions.push(`p.id IN (${placeholders})`);
        params.push(...clickedItems);
      }

      return { conditions, params };
    };

    const { conditions, params } = buildPreferenceConditions();

    let query;
    let queryParams;

    if (conditions.length > 0) {
      // Pobierz tylko produkty spełniające preferencje
      query = `
        SELECT p.id, p.category_id, c.category, p.name, p.brand, p.materials, 
               p.fit, p.color, p.price, d.width, d.height, d.length,
               (
                 ${categoryVisits && Object.keys(categoryVisits).length > 0 ?
          `CASE WHEN c.category IN (${Object.keys(categoryVisits).map(() => '?').join(',')}) 
                    THEN ${Math.max(...Object.values(categoryVisits))} * 5 ELSE 0 END +` : '0 +'
        }
                 ${colorPreferences && Object.keys(colorPreferences).length > 0 ?
          `CASE WHEN p.color IN (${Object.keys(colorPreferences).map(() => '?').join(',')}) 
                    THEN ${Math.max(...Object.values(colorPreferences))} * 3 ELSE 0 END +` : '0 +'
        }
                 ${fitPreferences && Object.keys(fitPreferences).length > 0 ?
          `CASE WHEN p.fit IN (${Object.keys(fitPreferences).map(() => '?').join(',')}) 
                    THEN ${Math.max(...Object.values(fitPreferences))} * 2 ELSE 0 END +` : '0 +'
        }
                 ${itemClicks && Object.keys(itemClicks).length > 0 ?
          `CASE WHEN p.id IN (${Object.keys(itemClicks).map(() => '?').join(',')}) 
                    THEN ${Math.max(...Object.values(itemClicks))} * 4 ELSE 0 END +` : '0 +'
        }
                 0
               ) as score
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        LEFT JOIN dimensions d ON p.id = d.product_id
        WHERE (${conditions.join(' OR ')})
        ORDER BY score DESC, CHAR_LENGTH(p.name) ASC
        LIMIT 50
      `;

      queryParams = [
        ...Object.keys(categoryVisits),
        ...Object.keys(colorPreferences),
        ...Object.keys(fitPreferences),
        ...Object.keys(itemClicks),
        ...params
      ];
    } else {
      // Jeśli brak preferencji, pobierz losowe produkty z krótkimi nazwami
      query = `
        SELECT p.id, p.category_id, c.category, p.name, p.brand, p.materials, 
               p.fit, p.color, p.price, d.width, d.height, d.length
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        LEFT JOIN dimensions d ON p.id = d.product_id
        WHERE CHAR_LENGTH(p.name) <= 19
        ORDER BY RAND()
        LIMIT 10
      `;
      queryParams = [];
    }

    const [products] = await db.query(query, queryParams);

    // Znajdź 3 produkty spełniające warunki długości nazw
    const result = [];
    const maxLengths = [19, 18, 18]; // Maksymalne długości dla pozycji 0, 1, 2

    for (let i = 0; i < 3; i++) {
      const maxLength = maxLengths[i];
      const availableProducts = products.filter(p =>
        p.name.length <= maxLength &&
        !result.some(r => r.id === p.id)
      );

      if (availableProducts.length > 0) {
        result.push(availableProducts[0]);
      }
    }

    // Jeśli nie ma wystarczająco produktów, pobierz dodatkowe z krótkimi nazwami
    if (result.length < 3) {
      const usedIds = result.map(p => p.id);
      const [additionalProducts] = await db.query(`
        SELECT p.id, p.category_id, c.category, p.name, p.brand, p.materials, 
               p.fit, p.color, p.price, d.width, d.height, d.length
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        LEFT JOIN dimensions d ON p.id = d.product_id
        WHERE CHAR_LENGTH(p.name) <= 18 
        AND p.id NOT IN (${usedIds.length > 0 ? usedIds.map(() => '?').join(',') : '0'})
        ORDER BY RAND()
        LIMIT ?
      `, [...usedIds, 3 - result.length]);

      result.push(...additionalProducts);
    }

    res.json(mapProduct(result.slice(0, 3)));
  } catch (error) {
    console.error('Error generating preview recommendations:', error);
    res.status(500).json({ error: 'Server error' });
  }
});

// Endpoint dla pełnych rekomendacji - minimum 11 produktów
app.post('/recommendations/full', async (req, res) => {
  try {
    const {
      categoryVisits = {},
      colorPreferences = {},
      materialPreferences = {},
      fitPreferences = {},
      itemClicks = {},
      limit = 20
    } = req.body;

    // Funkcja budowania warunków preferencji
    const buildPreferenceQuery = () => {
      const conditions = [];
      const scoreConditions = [];
      const params = [];

      // Kategorie
      const categories = Object.keys(categoryVisits);
      if (categories.length > 0) {
        const placeholders = categories.map(() => '?').join(',');
        conditions.push(`c.category IN (${placeholders})`);

        const categoryScores = categories.map(cat =>
          `CASE WHEN c.category = ? THEN ${categoryVisits[cat]} * 5 ELSE 0 END`
        ).join(' + ');
        scoreConditions.push(`(${categoryScores})`);

        params.push(...categories, ...categories);
      }

      // Kolory
      const colors = Object.keys(colorPreferences);
      if (colors.length > 0) {
        const placeholders = colors.map(() => '?').join(',');
        conditions.push(`p.color IN (${placeholders})`);

        const colorScores = colors.map(color =>
          `CASE WHEN p.color = ? THEN ${colorPreferences[color]} * 3 ELSE 0 END`
        ).join(' + ');
        scoreConditions.push(`(${colorScores})`);

        params.push(...colors, ...colors);
      }

      // Dopasowanie
      const fits = Object.keys(fitPreferences);
      if (fits.length > 0) {
        const placeholders = fits.map(() => '?').join(',');
        conditions.push(`p.fit IN (${placeholders})`);

        const fitScores = fits.map(fit =>
          `CASE WHEN p.fit = ? THEN ${fitPreferences[fit]} * 2 ELSE 0 END`
        ).join(' + ');
        scoreConditions.push(`(${fitScores})`);

        params.push(...fits, ...fits);
      }

      // Materiały
      const materials = Object.keys(materialPreferences);
      if (materials.length > 0) {
        const materialConditions = materials.map(() => 'p.materials LIKE ?').join(' OR ');
        conditions.push(`(${materialConditions})`);

        const materialScores = materials.map(material =>
          `CASE WHEN p.materials LIKE ? THEN ${materialPreferences[material]} * 2 ELSE 0 END`
        ).join(' + ');
        scoreConditions.push(`(${materialScores})`);

        params.push(...materials.map(m => `%${m}%`), ...materials.map(m => `%${m}%`));
      }

      // Kliknięte produkty
      const clickedItems = Object.keys(itemClicks);
      if (clickedItems.length > 0) {
        const placeholders = clickedItems.map(() => '?').join(',');
        conditions.push(`p.id IN (${placeholders})`);

        const clickScores = clickedItems.map(id =>
          `CASE WHEN p.id = ? THEN ${itemClicks[id]} * 4 ELSE 0 END`
        ).join(' + ');
        scoreConditions.push(`(${clickScores})`);

        params.push(...clickedItems, ...clickedItems);
      }

      return {
        conditions: conditions.length > 0 ? conditions.join(' OR ') : '1=1',
        scoreQuery: scoreConditions.length > 0 ? scoreConditions.join(' + ') : '0',
        params
      };
    };

    const hasPreferences = Object.keys(categoryVisits).length > 0 ||
      Object.keys(colorPreferences).length > 0 ||
      Object.keys(materialPreferences).length > 0 ||
      Object.keys(fitPreferences).length > 0 ||
      Object.keys(itemClicks).length > 0;

    let recommendedProducts = [];

    if (hasPreferences) {
      const { conditions, scoreQuery, params } = buildPreferenceQuery();

      // Pobierz produkty spełniające preferencje z obliczonym wynikiem
      const [products] = await db.query(`
        SELECT p.id, p.category_id, c.category, p.name, p.brand, p.materials, 
               p.fit, p.color, p.price, d.width, d.height, d.length,
               (${scoreQuery}) as score
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        LEFT JOIN dimensions d ON p.id = d.product_id
        WHERE ${conditions}
        HAVING score > 0
        ORDER BY score DESC
        LIMIT ?
      `, [...params, limit]);

      recommendedProducts = products;
    }

    // Jeśli mniej niż 11 produktów, dodaj losowe
    if (recommendedProducts.length < 11) {
      const usedIds = recommendedProducts.map(p => p.id);
      const remaining = 11 - recommendedProducts.length;

      const [randomProducts] = await db.query(`
        SELECT p.id, p.category_id, c.category, p.name, p.brand, p.materials, 
               p.fit, p.color, p.price, d.width, d.height, d.length
        FROM products p
        LEFT JOIN categories c ON p.category_id = c.id
        LEFT JOIN dimensions d ON p.id = d.product_id
        WHERE ${usedIds.length > 0 ? `p.id NOT IN (${usedIds.map(() => '?').join(',')})` : '1=1'}
        ORDER BY RAND()
        LIMIT ?
      `, [...usedIds, remaining]);

      recommendedProducts.push(...randomProducts);
    }

    // Usuń pole score z odpowiedzi
    const finalProducts = recommendedProducts.map(product => {
      const { score, ...productWithoutScore } = product;
      return productWithoutScore;
    });

    res.json(mapProduct(finalProducts.slice(0, limit)));

  } catch (error) {
    console.error('Error generating full recommendations:', error);
    res.status(500).json({ error: 'Server error' });
  }
});



app.post('/products', upload.single('image'), async (req, res) => {
  const connection = await db.getConnection();
  try {
    await connection.beginTransaction();

    const { id, name, brand, materials, fit, color, price, category_id, width, height, length } = req.body;
    const imagePath = req.file ? req.file.filename : null;

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
        error: `Product with ID ${req.body.id} already exists`
      });
    }
    res.status(500).json({ error: 'Error adding product' });
  } finally {
    connection.release();
  }
});

app.post('/categories', async (req, res) => {
  const connection = await db.getConnection();
  try {
    await connection.beginTransaction();
    const category = req.body;
    console.log('Adding category:', category);
    await connection.query(`
            INSERT INTO categories (category) 
            VALUES (?)
        `, category.category);
    await connection.commit();
    const [newCategory] = await connection.query(`
            SELECT * FROM categories;
        `);
    res.status(201).json(newCategory);
  } catch (error) {
    await connection.rollback();
    console.error(error);
    res.status(500).json({ error: 'Error adding category' });
  } finally {
    connection.release();
  }
});


app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});

app.listen(3000, () => console.log('Server running on port 3000'));