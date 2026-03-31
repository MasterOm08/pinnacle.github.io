// db.js: Native IndexedDB wrapper for Padhoplay offline data
const DB_NAME = 'PadhoplayDB';
const DB_VERSION = 1;

let db;

function initDB() {
  return new Promise((resolve, reject) => {
    console.log("Initializing IndexedDB...");
    const request = indexedDB.open(DB_NAME, DB_VERSION);

    request.onerror = event => {
      console.error("Database error: " + event.target.errorCode);
      reject(event.target.errorCode);
    };

    request.onsuccess = event => {
      db = event.target.result;
      console.log("Database initialized successfully.");
      resolve(db);
    };

    request.onupgradeneeded = event => {
      const upgradeDb = event.target.result;
      
      // Store 1: Users (Teachers/Students)
      if (!upgradeDb.objectStoreNames.contains('users')) {
        const userStore = upgradeDb.createObjectStore('users', { keyPath: 'id', autoIncrement: true });
        userStore.createIndex('role', 'role', { unique: false });
      }

      // Store 2: Progress
      if (!upgradeDb.objectStoreNames.contains('progress')) {
        const progressStore = upgradeDb.createObjectStore('progress', { keyPath: 'id', autoIncrement: true });
        progressStore.createIndex('userId', 'userId', { unique: false });
      }

      // Store 3: Cached Lessons
      if (!upgradeDb.objectStoreNames.contains('lessons')) {
        const lessonStore = upgradeDb.createObjectStore('lessons', { keyPath: 'id', autoIncrement: true });
        lessonStore.createIndex('subject', 'subject', { unique: false });
      }
    };
  });
}

// Utility functions
async function saveProgress(userId, lessonId, score) {
  return new Promise((resolve, reject) => {
    const transaction = db.transaction(['progress'], 'readwrite');
    const store = transaction.objectStore('progress');
    const request = store.add({ userId, lessonId, score, date: new Date().getTime() });

    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
}

async function getProgress(userId) {
  return new Promise((resolve, reject) => {
    const transaction = db.transaction(['progress'], 'readonly');
    const store = transaction.objectStore('progress');
    const index = store.index('userId');
    const request = index.getAll(userId);

    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
}

async function addStudent(name, rollNo, pin, grade) {
  return new Promise((resolve, reject) => {
    const transaction = db.transaction(['users'], 'readwrite');
    const store = transaction.objectStore('users');
    const request = store.add({ name, rollNo, pin, grade: parseInt(grade, 10), role: 'student', date: new Date().getTime() });

    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
}

async function getStudentByPin(pin) {
  return new Promise((resolve, reject) => {
    const transaction = db.transaction(['users'], 'readonly');
    const store = transaction.objectStore('users');
    const request = store.getAll(); 
    
    request.onsuccess = () => {
      const student = request.result.find(u => u.pin === pin && u.role === 'student');
      resolve(student);
    };
    request.onerror = () => reject(request.error);
  });
}

async function addTeacher(name, grade, pin) {
  return new Promise((resolve, reject) => {
    const transaction = db.transaction(['users'], 'readwrite');
    const store = transaction.objectStore('users');
    const request = store.add({ name, grade: parseInt(grade, 10), pin, role: 'teacher', date: new Date().getTime() });
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
  });
}

async function getTeacherByPin(pin) {
  return new Promise((resolve, reject) => {
    const transaction = db.transaction(['users'], 'readonly');
    const store = transaction.objectStore('users');
    const request = store.getAll(); 
    request.onsuccess = () => {
      const teacher = request.result.find(u => u.pin === pin && u.role === 'teacher');
      resolve(teacher);
    };
    request.onerror = () => reject(request.error);
  });
}

function buildQuestionObject(subject, qText) {
  let ans = "";
  let options = [];
  
  if(subject === "Math") {
     let match = qText.match(/(\d+)\s*([\+\-\*\/])\s*(\d+)/);
     if(match) {
        let a = parseInt(match[1]), op = match[2], b = parseInt(match[3]);
        if(op === '+') ans = (a + b).toString();
        if(op === '-') ans = (a - b).toString();
        if(op === '*') ans = (a * b).toString();
        if(op === '/') ans = (a / b).toString();
        options = [ans, (parseInt(ans)+1).toString(), (parseInt(ans)-1).toString(), (parseInt(ans)+2).toString()];
     } else return null;
  } else if (subject === "Science") {
     if(/color.*Grapes/i.test(qText)) { ans = "Green"; options = ["Green", "Red", "Yellow", "Blue"]; }
     else if(/color.*Apple/i.test(qText)) { ans = "Red"; options = ["Red", "Blue", "Green", "Purple"]; }
     else if(/color.*Banana/i.test(qText)) { ans = "Yellow"; options = ["Yellow", "Red", "Green", "White"]; }
     else if(/living.*Car/i.test(qText)) { ans = "Non-living"; options = ["Living", "Non-living", "Plant", "Animal"]; }
     else if(/living.*Cat/i.test(qText)) { ans = "Living"; options = ["Living", "Non-living", "Machine", "Toy"]; }
     else if(/living.*Tree/i.test(qText)) { ans = "Living"; options = ["Living", "Non-living", "Plastic", "Metal"]; }
     else if(/living.*Stone/i.test(qText)) { ans = "Non-living"; options = ["Living", "Non-living", "Magic", "Animal"]; }
     else if(/smell/i.test(qText)) { ans = "Nose"; options = ["Nose", "Eyes", "Ears", "Hands"]; }
     else if(/see/i.test(qText)) { ans = "Eyes"; options = ["Eyes", "Nose", "Mouth", "Legs"]; }
     else if(/hear/i.test(qText)) { ans = "Ears"; options = ["Ears", "Eyes", "Nose", "Teeth"]; }
     else if(/touch/i.test(qText)) { ans = "Skin"; options = ["Skin", "Eyes", "Nose", "Heart"]; }
     else if(/underground/i.test(qText)) { ans = "Roots"; options = ["Roots", "Leaves", "Stem", "Flowers"]; }
     else if(/colorful/i.test(qText)) { ans = "Flowers"; options = ["Flowers", "Roots", "Stem", "Branch"]; }
     else if(/green/i.test(qText)) { ans = "Leaves"; options = ["Leaves", "Roots", "Bark", "Fruit"]; }
     else if(/Lion/i.test(qText)) { ans = "Jungle"; options = ["Jungle", "House", "Water", "Sky"]; }
     else if(/Rabbit/i.test(qText)) { ans = "Burrow"; options = ["Burrow", "Tree", "Sky", "Water"]; }
     else if(/Fish/i.test(qText)) { ans = "Water"; options = ["Water", "Land", "Tree", "Jungle"]; }
     else if(/safety.*road/i.test(qText)) { ans = "Look both ways"; options = ["Look both ways", "Run fast", "Close eyes", "Play ball"]; }
     else if(/safety.*home/i.test(qText)) { ans = "Don't play with fire"; options = ["Don't play with fire", "Jump on bed", "Run with scissors", "Eat dirt"]; }
     else if(/safety.*kitchen/i.test(qText)) { ans = "Don't touch hot stove"; options = ["Don't touch hot stove", "Play with knives", "Spill water", "Eat raw meat"]; }
     else { ans = "Yes"; options = ["Yes", "No", "Maybe", "I don't know"]; }
  } else if (subject === "English") {
     if(/action word:(.*)or(.*)/i.test(qText)) {
        let m = qText.match(/action word:\s*(\w+)\s*or\s*(\w+)/i);
        if(m) {
           let w1 = m[1], w2 = m[2];
           const verbs = ['Run', 'Jump', 'Eat', 'Cry', 'Sing'];
           ans = verbs.includes(w1) ? w1 : w2;
           options = [w1, w2, "Car", "Apple"];
        }
     } else if(/noun:(.*)or(.*)/i.test(qText)) {
        let m = qText.match(/noun:\s*(\w+)\s*or\s*(\w+)/i);
        if(m) {
           let w1 = m[1], w2 = m[2];
           const nouns = ['Apple', 'Book', 'Dog', 'Table', 'Sun'];
           ans = nouns.includes(w1) ? w1 : w2;
           options = [w1, w2, "Run", "Jump"];
        }
     } else if(/opposite of '(\w+)'/i.test(qText)) {
        let m = qText.match(/opposite of '(\w+)'/i);
        if(m) {
           let w = m[1];
           let dict = { 'Up': 'Down', 'Sit': 'Stand', 'Day': 'Night', 'Small': 'Big', 'Hot': 'Cold' };
           ans = dict[w] || 'Unknown';
           options = [ans, "Apple", "Car", w];
        }
     } else if(/synonym of '(\w+)'/i.test(qText)) {
        let m = qText.match(/synonym of '(\w+)'/i);
        if(m) {
           let w = m[1];
           let dict = { 'Run': 'Sprint', 'Fast': 'Quick', 'Happy': 'Glad', 'City': 'Town', 'Leaf': 'Petal', 'Box': 'Carton', 'Boy': 'Lad', 'Chair': 'Seat', 'Cold': 'Chilly' };
           ans = dict[w] || 'Same';
           options = [ans, "Slow", "Big", "Red"];
        }
     } else if(/Make '(\w+)' plural/i.test(qText)) {
        let m = qText.match(/Make '(\w+)' plural/i);
        if(m) {
           let w = m[1];
           ans = w + (w.endsWith('y') ? 'ies' : 's');
           if(w==='City') ans = 'Cities';
           if(w==='Leaf') ans = 'Leaves';
           if(w==='Box') ans = 'Boxes';
           options = [ans, w, w+'es', w+'en'];
        }
     } else if(/is '(\w+)' a noun or a verb/i.test(qText)) {
        let m = qText.match(/is '(\w+)' a noun or a verb/i);
        if(m) {
           let w = m[1];
           const nouns = ['City', 'Leaf', 'Box', 'Boy', 'Chair'];
           ans = nouns.includes(w) ? 'Noun' : 'Verb';
           options = ['Noun', 'Verb', 'Adjective', 'Adverb'];
        }
     } else { ans = "Grammar"; options = ["Grammar", "Vocab", "Spelling", "Math"]; }
  }

  if(options && options.length > 0) {
     if(!options.includes(ans)) options[0] = ans;
     options = Array.from(new Set(options)); 
     while(options.length < 4) options.push("Option " + options.length);
     options.sort(() => Math.random() - 0.5);
     let cleanedQ = qText.replace(/\s*\(Example.*?\)/i, '').replace(/\s*\(Q-\d+\)/i, '').trim();
     return { q: cleanedQ, options: options.slice(0,4), ans };
  }
  return null;
}

async function seedData() {
  if(!db) await initDB();
  
  const transaction = db.transaction(['lessons'], 'readwrite');
  const store = transaction.objectStore('lessons');
  const countRequest = store.count();
  
  countRequest.onsuccess = async () => {
    if(countRequest.result === 0) {
      console.log("Deep Seeding dataset from CSV via Heuristics...");
      try {
        const response = await fetch('./rural_questions_dataset_unique%20(1).csv');
        const text = await response.text();
        const rows = text.split('\n');
        
        const lessonsMap = {};
        
        for(let i=1; i<rows.length; i++) {
           if(!rows[i].trim()) continue;
           const parts = rows[i].match(/(?:^|,)((?:[^,"]+|"[^"]*")*)/g).map(s => s.replace(/^,/, '').replace(/(^"|"$)/g, ''));
           if(parts.length < 7) continue;
           
           const [id, grade, subject, unit, lesson, qNum, ...qRest] = parts;
           const questionText = qRest.join(',').trim();
           const key = `${grade}|${subject}|${unit}|${lesson}`;
           
           if(!lessonsMap[key]) {
               lessonsMap[key] = { 
                   grade: parseInt(grade, 10), 
                   subject, 
                   unit: parseInt(unit, 10), 
                   lesson: parseInt(lesson, 10), 
                   title: `${subject} G${grade} U${unit} L${lesson}`, 
                   questions: [] 
               };
           }
           
           let qObj = buildQuestionObject(subject, questionText);
           if(qObj) lessonsMap[key].questions.push(qObj);
        }
        
        const insertTransaction = db.transaction(['lessons'], 'readwrite');
        const insertStore = insertTransaction.objectStore('lessons');
        for (const key in lessonsMap) {
            if(lessonsMap[key].questions.length > 0) {
                insertStore.add(lessonsMap[key]);
            }
        }
        console.log("CSV Heuristic Scale-Up Seeding complete.");
      } catch (err) {
        console.error("Failed to parse CSV dataset: ", err);
      }
    }
  };
}

// Auto-init on load
document.addEventListener('DOMContentLoaded', () => {
  initDB().then(() => {
    seedData();
  });
});
