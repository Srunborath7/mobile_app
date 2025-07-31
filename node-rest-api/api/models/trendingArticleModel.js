// models/trendingArticleModel.js
const db = require('../database/db');

// === Create trending_articles table ===
const createTrendingArticlesTable = () => {
  const query = `
    CREATE TABLE IF NOT EXISTS trending_articles (
      id INT AUTO_INCREMENT PRIMARY KEY,
      title VARCHAR(255) NOT NULL,
      summary TEXT,
      image_url VARCHAR(255),
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
  `;
  db.query(query, (err) => {
    if (err) {
      console.error('❌ Failed to create trending_articles:', err);
    } else {
      console.log('✅ trending_articles table ready');
      insertDefaultTrendingArticles(); // Insert seed data if table is empty
    }
  });
};

// === Create trending_article_details table ===
const createTrendingArticleDetailsTable = () => {
  const query = `
    CREATE TABLE IF NOT EXISTS trending_article_details (
      id INT AUTO_INCREMENT PRIMARY KEY,
      trending_article_id INT NOT NULL,
      full_image_url VARCHAR(255),
      content TEXT,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (trending_article_id) REFERENCES trending_articles(id) ON DELETE CASCADE
    )
  `;
  db.query(query, (err) => {
    if (err) {
      console.error('❌ Failed to create trending_article_details:', err);
    } else {
      console.log('✅ trending_article_details table ready');
      insertDefaultTrendingArticleDetails(); // Insert seed data if table is empty
    }
  });
};

// === Insert default data for trending_articles ===
const insertDefaultTrendingArticles = () => {
  db.query('SELECT COUNT(*) AS count FROM trending_articles', (err, result) => {
    if (err) return console.error(err);
    if (result[0].count === 0) {
      const insertQuery = `
        INSERT INTO trending_articles (title, summary, image_url)
        VALUES 
        ('Thailand Started the war against cambodia ',
        'hai soldiers initiated the conflict when they violated a prior agreement by advancing on a Khmer-Hindu temple near the border',
        'https://i.ytimg.com/vi/_wMqV3Yi-ZM/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLBduPBfYvoyeTyT-FgmNCRmKNRWfQ'),

        ('Thailand and Cambodia’s Ceasefire', 
        'While Thailand and Cambodia have reached a temporary ceasefire in their border conflict, it is unlikely to hold as the conflict’s escalation is driven by Thai and Cambodian elites’ efforts to consolidate military and political power.',
        'https://i.ytimg.com/vi/tawpc3tBT2Q/maxresdefault.jpg'),

        ('Calls for free 20 Cambodian', 
        'Calls for Thailand to free 20 Cambodian soldiers held after border clashes',
        'https://www.aljazeera.com/wp-content/uploads/2025/07/2025-07-30T073828Z_2107982834_RC2VWFAZJSGK_RTRMADP_3_THAILAND-CAMBODIA-1753936062.jpg?resize=770%2C513&quality=80')
      `;
      db.query(insertQuery, (err) => {
        if (err) console.error('❌ Failed to insert trending_articles:', err);
        else console.log('✅ Default trending_articles inserted');
      });
    }
  });
};

// === Insert default data for trending_article_details ===
const insertDefaultTrendingArticleDetails = () => {
  db.query('SELECT COUNT(*) AS count FROM trending_article_details', (err, result) => {
    if (err) return console.error(err);
    if (result[0].count === 0) {
      const insertQuery = `
        INSERT INTO trending_article_details (trending_article_id, full_image_url, content)
        VALUES 
        (1, 'https://ichef.bbci.co.uk/news/1024/cpsprodpb/dfaa/live/53d6fa40-6877-11f0-af20-030418be2ca5.jpg.webp',
         'On Thursday, simmering tensions between Thailand and Cambodia exploded into a deadly battle at the border.
         
         This is not a recent dispute. In fact, the argument between Thailand and Cambodia dates back more than a century, when the borders of the two nations were drawn after the French occupation of Cambodia.

         Things officially became hostile in 2008, when Cambodia tried to register an 11th Century temple located in the disputed area as a Unesco World Heritage Site - a move that was met with heated protest from Thailand.
         
         Over the years there have been sporadic clashes that have seen soldiers and civilians killed on both sides.
         
         The latest tensions ramped up in May after a Cambodian soldier was killed in a clash. This plunged bilateral ties to their lowest point in more than a decade.
         
         In the past two months, both countries have imposed border restrictions on one another. Cambodia banned imports from Thailand such as fruits and vegetables, and stopped importing power and internet services.
         
         Both countries have also strengthened troop presence along the border in recent weeks.
         '),

        (2, 'https://cdn.cfr.org/sites/default/files/styles/slide_3_2/public/image/2025/07/Cambodia%20Thailand%20war.webp', 
        'In recent weeks, the border conflict between Thailand and Cambodia had ramped up dramatically, until the two sides agreed to a ceasefire that started at midnight Monday their time; noon today, U.S. eastern time.
        
        The ceasefire was brokered by Malaysian and U.S. officials, and President Donald Trump used as leverage the threat of not making trade deals with Thailand and Cambodia unless the fighting ceased.
        
        Although the number of casualties was small when the conflict started in earnest on May 28, by now, some thirty Cambodians and Thais have died. Some 200,000 people reportedly have been displaced from the areas near the conflict, martial law has been declared in Thai provinces near the border, and nationalist rhetoric escalated on both sides.
        
        In addition, in recent days before the ceasefire, Cambodia reportedly appeared to try to broaden the conflict by initiating attacks on Thailand’s southern coast, which the Thai military says were effectively rebuffed.
        
        Both sides also had begun using heavy artillery against each other. And Thailand reportedly had begun launching airstrikes into Cambodia.
        
        Former Cambodian prime minister Hun Sen, still an enormously powerful actor in Cambodia and Southeast Asia more broadly, has charged one of the most prominent pro-military Thai politicians of “long-standing greed and ambition,” and told Cambodians to unite in the face of a dangerous Thai threat.
        
        Meanwhile, last Friday acting Thai Prime Minister Phumtham Wechayachai, who is serving because the top Thai court removed prime minister Paetongtarn Shinawatra, said that the conflict could turn into “full-fledged war.”

        (In reality, there is almost no way that Cambodia, with a military a third as big as Thailand’s and lacking Thailand’s advanced weaponry, could win a full-fledged war, but neither side really seems to want all-out war.)
        '),

        (3, 'https://i.ytimg.com/vi/n1dX8FTeS6g/maxresdefault.jpg',
         'Cambodia has called on Thailand to return 20 of its soldiers who were taken captive by Thai forces hours after a ceasefire that halted days of deadly cross-border clashes over disputed territory between the Southeast Asian neighbours.
         
         Cambodian Ministry of National Defence spokesperson Maly Socheata said on Thursday that talks were under way for the release of 20 soldiers, though reports from Thailand indicate that the Royal Thai Army wants the detainees to face the “legal process” before repatriation.
         
         “We will do our best to continue negotiations with the Thai side in order to bring all our soldiers back home safely and as soon as possible,” the spokesperson told a news briefing.
         
         “We call on the Thai side to send all 20 military personnel back to Cambodia as soon as possible,” she said.
         
         According to reports, the group of Cambodian troops were captured at about 7:50am local time on Tuesday (00:50 GMT) after crossing into Thai-held territory – nearly eight hours after a ceasefire came into effect between the two countries.
         
         Speaking to the media at the headquarters of the Royal Thai Army on Thursday, army spokesperson Major-General Winthai Suvaree said the commander of Thailand’s Second Army Region had assured that the Cambodian detainees – which numbered 18 – would be dealt with under international legal conditions.
         
         “The soldiers would be swiftly returned once the legal procedures are completed,” Thailand’s The Nation newspaper reported the army spokesperson as saying.
         ')

      `;
      db.query(insertQuery, (err) => {
        if (err) console.error('❌ Failed to insert trending_article_details:', err);
        else console.log('✅ Default trending_article_details inserted');
      });
    }
  });
};

// === Export functions ===
module.exports = {
  createTrendingArticlesTable,
  createTrendingArticleDetailsTable,
};