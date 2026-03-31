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

async function addStudent(name, rollNo, pin) {
  return new Promise((resolve, reject) => {
    const transaction = db.transaction(['users'], 'readwrite');
    const store = transaction.objectStore('users');
    const request = store.add({ name, rollNo, pin, role: 'student', date: new Date().getTime() });

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

async function seedData() {
  // Wait for db init
  if(!db) await initDB();
  
  const transaction = db.transaction(['lessons'], 'readwrite');
  const store = transaction.objectStore('lessons');
  
  // Checking if we already have data
  const countRequest = store.count();
  countRequest.onsuccess = () => {
    if(countRequest.result === 0) {
      console.log("Seeding authentic lessons for Grade 1 Math Unit 1...");
      
      const grade1Unit1Lessons = [
        {
          grade: 1, subject: 'Math', unit: 1, lesson: 1, title: 'Addition to 5',
          questions: [
            { q: "1 + 1 = ?", options: [1, 2, 3, 4], ans: 2 },
            { q: "2 + 1 = ?", options: [2, 3, 4, 5], ans: 3 },
            { q: "3 + 2 = ?", options: [3, 4, 5, 6], ans: 5 },
            { q: "1 + 3 = ?", options: [2, 3, 4, 5], ans: 4 },
            { q: "0 + 5 = ?", options: [1, 3, 5, 0], ans: 5 }
          ]
        },
        {
          grade: 1, subject: 'Math', unit: 1, lesson: 2, title: 'Addition to 10',
          questions: [
            { q: "4 + 4 = ?", options: [6, 7, 8, 9], ans: 8 },
            { q: "5 + 2 = ?", options: [5, 6, 7, 8], ans: 7 },
            { q: "6 + 4 = ?", options: [8, 9, 10, 11], ans: 10 },
            { q: "3 + 6 = ?", options: [7, 8, 9, 10], ans: 9 },
            { q: "7 + 2 = ?", options: [7, 8, 9, 10], ans: 9 }
          ]
        },
        {
          grade: 1, subject: 'Math', unit: 1, lesson: 3, title: 'Simple Subtraction',
          questions: [
            { q: "2 - 1 = ?", options: [0, 1, 2, 3], ans: 1 },
            { q: "5 - 2 = ?", options: [1, 2, 3, 4], ans: 3 },
            { q: "4 - 4 = ?", options: [0, 1, 2, 4], ans: 0 },
            { q: "6 - 3 = ?", options: [1, 2, 3, 4], ans: 3 },
            { q: "8 - 1 = ?", options: [5, 6, 7, 8], ans: 7 }
          ]
        }
      ];
      
      grade1Unit1Lessons.forEach(lesson => store.add(lesson));
      console.log("Seeding complete.");
    }
  };
}

// Auto-init on load
document.addEventListener('DOMContentLoaded', () => {
  initDB().then(() => {
    seedData();
  });
});
