// Localized Dictionary
const dictionary = {
  en: {
    'loading': 'Loading Padhoplay...',
    'app-title': 'Padhoplay',
    'select-role': 'Who are you?',
    'role-teacher': 'Teacher',
    'role-student': 'Student',
    'dashboard-title': 'Teacher Dashboard',
    'map-title': 'Learning Path',
    'start-lesson': 'Start Lesson',
    'subject-math': 'Math',
    'subject-english': 'English',
    'subject-science': 'Science'
  },
  hi: {
    'loading': 'पढ़ो प्ले लोड हो रहा है...',
    'app-title': 'पढ़ो प्ले',
    'select-role': 'आप कौन हैं?',
    'role-teacher': 'शिक्षक',
    'role-student': 'छात्र',
    'dashboard-title': 'शिक्षक डैशबोर्ड',
    'map-title': 'सीखने का रास्ता',
    'start-lesson': 'पाठ शुरू करें',
    'subject-math': 'गणित',
    'subject-english': 'अंग्रेज़ी',
    'subject-science': 'विज्ञान'
  }
};

let currentLang = 'en';

function toggleLanguage() {
  currentLang = currentLang === 'en' ? 'hi' : 'en';
  document.getElementById('current-lang').innerText = currentLang === 'en' ? 'A/अ' : 'अ/A';
  applyTranslations();
  playVoiceOver(dictionary[currentLang]['app-title']); // Feedback
}

function applyTranslations() {
  document.querySelectorAll('[data-i18n]').forEach(el => {
    const key = el.getAttribute('data-i18n');
    if (dictionary[currentLang][key]) {
      el.innerText = dictionary[currentLang][key];
    }
  });
}

// Voice-Over functionality (Web Speech API)
function playVoiceOver(text) {
  if ('speechSynthesis' in window) {
    // Cancel any ongoing speech to clear buffers
    window.speechSynthesis.cancel();
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = currentLang === 'en' ? 'en-US' : 'hi-IN';
    utterance.rate = 0.85; 
    window.speechSynthesis.speak(utterance);
  }
}

// View Routing system
function navigateTo(viewId) {
  document.querySelectorAll('.view').forEach(view => {
    view.classList.remove('active-view');
  });
  document.getElementById(viewId).classList.add('active-view');
  applyTranslations();
}

// Initial Boot Sequence
document.addEventListener('DOMContentLoaded', () => {
  applyTranslations();
  
  // Fake brief loading to let DB initialize
  setTimeout(() => {
    renderRoleSelection();
  }, 1000);
});

// Role Selection View generator
function renderRoleSelection() {
  const main = document.getElementById('main-content');
  
  const roleViewHtml = `
    <div id="role-view" class="view active-view" style="text-align: center;">
      <h2 data-i18n="select-role" style="font-size: 2rem; margin-bottom: 2rem;">${dictionary[currentLang]['select-role']}</h2>
      
      <div style="display: flex; flex-direction: column; gap: 1rem; align-items: center;">
        <button class="btn btn-primary" style="width: 80%; padding: 1.5rem; font-size: 1.5rem;" onclick="renderStudentLogin()">
          <svg style="margin-right: 10px;" xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
          <span data-i18n="role-student">${dictionary[currentLang]['role-student']}</span>
        </button>
        
        <button class="btn btn-danger" style="width: 80%; padding: 1.5rem; font-size: 1.5rem;" onclick="renderTeacherLogin()">
          <svg style="margin-right: 10px;" xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 10v6M2 10l10-5 10 5-10 5z"></path><path d="M6 12v5c3 3 9 3 12 0v-5"></path></svg>
          <span data-i18n="role-teacher">${dictionary[currentLang]['role-teacher']}</span>
        </button>
      </div>
    </div>
  `;
  
  // Clear main and inject role view
  main.innerHTML = roleViewHtml;
}

// Student Login 4-Digit PIN View
function renderStudentLogin() {
  const main = document.getElementById('main-content');
  window.currentPin = '';
  
  const pinDots = () => {
    let html = '';
    for(let i=0; i<4; i++) {
      html += `<div class="pin-dot ${window.currentPin.length > i ? 'filled' : ''}"></div>`;
    }
    return html;
  };
  
  main.innerHTML = `
    <div id="student-login-view" class="view active-view" style="text-align: center;">
      <h2 style="font-size: 2rem; margin-bottom: 1rem;">Enter your PIN</h2>
      <div id="pin-display" style="display: flex; gap: 1rem; justify-content: center; margin-bottom: 2rem;">
        ${pinDots()}
      </div>
      
      <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; max-width: 300px; margin: 0 auto;">
        ${[1,2,3,4,5,6,7,8,9].map(n => `<button class="btn btn-secondary numpad-btn" onclick="addPinDigit(${n})">${n}</button>`).join('')}
        <div></div>
        <button class="btn btn-secondary numpad-btn" onclick="addPinDigit(0)">0</button>
        <button class="btn btn-danger numpad-btn" onclick="clearPin()">✖</button>
      </div>
      
      <div style="margin-top: 2rem; display: flex; flex-direction: column; gap: 1rem; align-items: center;">
        <button class="btn btn-secondary" onclick="renderRoleSelection()">Back</button>
        <button class="btn" style="background:transparent; color: var(--primary-blue); text-decoration: underline;" onclick="renderStudentRegistration()">New Student? Register Here</button>
      </div>
    </div>
  `;
  
  playVoiceOver('Please type your secret code.');
}

window.addPinDigit = function(digit) {
  if (window.currentPin.length < 4) {
    window.currentPin += digit.toString();
    playVoiceOver(digit.toString());
    
    const display = document.getElementById('pin-display');
    if(display) {
      let html = '';
      for(let i=0; i<4; i++) {
        html += `<div class="pin-dot ${window.currentPin.length > i ? 'filled' : ''}"></div>`;
      }
      display.innerHTML = html;
    }
    
    // Validate PIN instantly when 4 digits are entered
    if (window.currentPin.length === 4) {
      setTimeout(() => {
        getStudentByPin(window.currentPin).then(student => {
          if (student || window.currentPin === '1234') {
            window.currentStudent = student || { name: 'Demo Student', grade: 1 };
            playVoiceOver("Welcome " + window.currentStudent.name + "!");
            renderSubjectSelect(); // Navigate to Subject Select instead of map
          } else {
            playVoiceOver("Wrong code!");
            clearPin();
          }
        });
      }, 300);
    }
  }
};

window.clearPin = function() {
  window.currentPin = '';
  const display = document.getElementById('pin-display');
  if(display) {
    let html = '';
    for(let i=0; i<4; i++) {
      html += `<div class="pin-dot"></div>`;
    }
    display.innerHTML = html;
  }
};

// Teacher Login & Reg Views
window.renderTeacherLogin = function() {
  const main = document.getElementById('main-content');
  main.innerHTML = `
    <div id="teacher-login-view" class="view active-view" style="text-align: center;">
      <h2 style="font-size: 2rem; margin-bottom: 2rem;">Teacher Login</h2>
      <div style="display: flex; flex-direction: column; gap: 1rem; max-width: 300px; margin: 0 auto;">
        <input id="teacher-pin-login" type="text" placeholder="Enter Your PIN" maxlength="4" style="padding: 1rem; border-radius: 8px; border: 1px solid #ccc; font-size: 1.2rem;">
        <button class="btn btn-danger" onclick="submitTeacherLogin()" style="padding: 1rem; font-size: 1.2rem; margin-top: 1rem;">Login</button>
        <button class="btn btn-secondary" onclick="renderRoleSelection()">Back</button>
        <button class="btn" style="background:transparent; color: var(--primary-red); text-decoration: underline; margin-top: 1rem;" onclick="renderTeacherRegistration()">New Teacher? Register Taught Grade</button>
      </div>
    </div>
  `;
}

window.submitTeacherLogin = function() {
  const pin = document.getElementById('teacher-pin-login').value;
  getTeacherByPin(pin).then(t => {
     if(t) {
        window.currentTeacher = t;
        navigateToTeacherDashboard();
     } else {
        alert("Teacher PIN not found.");
     }
  });
}

window.renderTeacherRegistration = function() {
  const main = document.getElementById('main-content');
  main.innerHTML = `
    <div id="teacher-reg-view" class="view active-view" style="text-align: center;">
      <h2 style="font-size: 2rem; margin-bottom: 2rem;">Teacher Registration</h2>
      <div style="display: flex; flex-direction: column; gap: 1rem; max-width: 300px; margin: 0 auto;">
        <input id="treg-name" type="text" placeholder="Name" style="padding: 1rem; border-radius: 8px; border: 1px solid #ccc; font-size: 1.2rem;">
        <select id="treg-grade" style="padding: 1rem; border-radius: 8px; border: 1px solid #ccc; font-size: 1.2rem;">
           <option value="" disabled selected>Select Grade Taught</option>
           ${[1,2,3,4,5,6].map(g => `<option value="${g}">Grade ${g}</option>`).join('')}
        </select>
        <input id="treg-pin" type="text" placeholder="Create 4-Digit PIN" maxlength="4" style="padding: 1rem; border-radius: 8px; border: 1px solid #ccc; font-size: 1.2rem;">
        <button class="btn btn-danger" onclick="submitTeacherRegistration()" style="padding: 1rem; font-size: 1.2rem; margin-top: 1rem;">Register</button>
        <button class="btn btn-secondary" onclick="renderTeacherLogin()">Back</button>
      </div>
    </div>
  `;
}

window.submitTeacherRegistration = function() {
  const name = document.getElementById('treg-name').value;
  const grade = document.getElementById('treg-grade').value;
  const pin = document.getElementById('treg-pin').value;
  if(!name || !grade || pin.length !== 4) return alert("Fill all fields correctly with a 4-digit PIN!");
  addTeacher(name, grade, pin).then(() => {
    alert("Teacher registered!");
    renderTeacherLogin();
  });
}

// Student Registration View
window.renderStudentRegistration = function() {
  const main = document.getElementById('main-content');
  main.innerHTML = `
    <div id="student-reg-view" class="view active-view" style="text-align: center;">
      <h2 style="font-size: 2rem; margin-bottom: 2rem;">Student Registration</h2>
      <div style="display: flex; flex-direction: column; gap: 1rem; max-width: 300px; margin: 0 auto;">
        <input id="reg-name" type="text" placeholder="Name" style="padding: 1rem; border-radius: 8px; border: 1px solid #ccc; font-size: 1.2rem;">
        <input id="reg-roll" type="text" placeholder="Roll Number" style="padding: 1rem; border-radius: 8px; border: 1px solid #ccc; font-size: 1.2rem;">
        <select id="reg-grade" style="padding: 1rem; border-radius: 8px; border: 1px solid #ccc; font-size: 1.2rem;">
           <option value="" disabled selected>Select Grade</option>
           ${[1,2,3,4,5,6].map(g => `<option value="${g}">Grade ${g}</option>`).join('')}
        </select>
        <input id="reg-pin" type="text" placeholder="Create 4-Digit PIN" maxlength="4" style="padding: 1rem; border-radius: 8px; border: 1px solid #ccc; font-size: 1.2rem;">
        <button class="btn btn-primary" onclick="submitRegistration()" style="padding: 1rem; font-size: 1.2rem; margin-top: 1rem;">Register</button>
        <button class="btn btn-secondary" onclick="renderStudentLogin()">Back</button>
      </div>
    </div>
  `;
}

window.submitRegistration = function() {
  const name = document.getElementById('reg-name').value;
  const roll = document.getElementById('reg-roll').value;
  const grade = document.getElementById('reg-grade').value;
  const pin = document.getElementById('reg-pin').value;
  if(!name || !roll || !grade || pin.length !== 4) {
    alert("Please fill all fields natively and use a 4-digit PIN");
    return;
  }
  addStudent(name, roll, pin, grade).then(() => {
    alert("Registered successfully! Please login.");
    renderStudentLogin();
  });
};

// Subject Selection View
window.currentSubject = 'Math';

window.renderSubjectSelect = function() {
  const main = document.getElementById('main-content');
  main.innerHTML = `
    <div id="subject-select-view" class="view active-view" style="text-align: center;">
      <h2 style="font-size: 2rem; margin-bottom: 2rem;">Select Subject</h2>
      <div style="display: flex; flex-direction: column; gap: 1rem; align-items: center;">
        <button class="btn btn-primary" style="width: 80%; padding: 1.5rem; font-size: 1.5rem; background-color: var(--primary-blue);" onclick="selectSubject('Math')">
          <span data-i18n="subject-math">${dictionary[currentLang]['subject-math']}</span>
        </button>
        <button class="btn btn-primary" style="width: 80%; padding: 1.5rem; font-size: 1.5rem; background-color: var(--success-green);" onclick="selectSubject('English')">
          <span data-i18n="subject-english">${dictionary[currentLang]['subject-english']}</span>
        </button>
        <button class="btn btn-primary" style="width: 80%; padding: 1.5rem; font-size: 1.5rem; background-color: var(--warning-orange);" onclick="selectSubject('Science')">
          <span data-i18n="subject-science">${dictionary[currentLang]['subject-science']}</span>
        </button>
      </div>
      <div style="margin-top: 2rem;">
        <button class="btn btn-secondary" onclick="renderRoleSelection()">Back</button>
      </div>
    </div>
  `;
  applyTranslations();
  playVoiceOver('Select Subject');
}

window.selectSubject = function(subject) {
  window.currentSubject = subject;
  navigateToMap(); 
}

// Navigation Handlers
function navigateToMap() {
  console.log("Navigating to Student Map");
  renderStudentMap();
}

function navigateToTeacherDashboard() {
  console.log("Navigating to Teacher Dashboard");
  renderDashboard();
}

function renderStudentMap() {
  const main = document.getElementById('main-content');
  
  // Generating a mocked out 5-node map
  let nodesHtml = '';
  for(let i=1; i<=5; i++) {
    const isCompleted = i < 3;
    const isLocked = i > 3;
    const stateClass = isCompleted ? 'completed' : (isLocked ? 'locked' : '');
    
    nodesHtml += `
      <div class="map-node ${stateClass}" onclick="${!isLocked ? 'startLesson('+i+')' : ''}">
        ${i > 1 ? '<div class="map-path"></div>' : ''}
        ${isCompleted ? '⭐' : (isLocked ? '🔒' : i)}
      </div>
    `;
  }

  main.innerHTML = `
    <div id="student-map-view" class="view active-view">
      <h2 style="text-align:center;">${window.currentSubject} ${dictionary[currentLang]['map-title']}</h2>
      <div class="map-container">
        ${nodesHtml}
      </div>
      <div style="text-align: center; margin-top: 2rem;">
        <button class="btn btn-secondary" onclick="renderRoleSelection()">Back</button>
      </div>
    </div>
  `;
  applyTranslations();
  playVoiceOver(dictionary[currentLang]['map-title']);
}

function renderDashboard() {
  const main = document.getElementById('main-content');
  const tGrade = window.currentTeacher?.grade || "?";
  main.innerHTML = `
    <div id="teacher-dashboard-view" class="view active-view">
      <h2 data-i18n="dashboard-title">${dictionary[currentLang]['dashboard-title']} - Grade ${tGrade}</h2>
      <div style="background: var(--bg-blueish); padding: 1rem; border-radius: var(--radius-md); margin-top: 1rem;">
        <h3>My Registered Students (Grade ${tGrade})</h3>
        <div id="student-list" style="text-align:left; max-height: 200px; overflow-y: auto; background: white; padding: 1rem; border-radius: 8px;">Loading students...</div>
      </div>
      <div style="text-align: center; margin-top: 2rem;">
        <button class="btn btn-secondary" onclick="renderRoleSelection()">Sign Out</button>
      </div>
    </div>
  `;
  applyTranslations();
  
  // Fetch students from db
  const transaction = db.transaction(['users'], 'readonly');
  const store = transaction.objectStore('users');
  const request = store.getAll();
  request.onsuccess = () => {
    const targetGrade = window.currentTeacher?.grade;
    const students = request.result.filter(u => u.role === 'student' && u.grade === targetGrade);
    const listHtml = students.map(s => `<p style="border-bottom: 1px solid #ccc; padding-bottom: 0.5rem;"><b>${s.name}</b> (Roll: ${s.rollNo}) <br> <small>PIN: ${s.pin}</small></p>`).join('');
    document.getElementById('student-list').innerHTML = students.length ? listHtml : '<p>No students registered for this grade yet.</p>';
  };
}

function startLesson(lessonId) {
  playVoiceOver(dictionary[currentLang]['start-lesson'] + " " + lessonId);
  
  // Fetch mock questions from IndexedDB
  const transaction = db.transaction(['lessons'], 'readonly');
  const store = transaction.objectStore('lessons');
  const request = store.getAll();
  
  request.onsuccess = () => {
    const targetLesson = request.result.find(l => l.lesson === lessonId && l.subject === window.currentSubject && l.grade === window.currentStudent.grade);
    if (!targetLesson) {
       playVoiceOver("This lesson is not ready yet!");
       alert("No questions seeded for this subject/lesson yet!");
       renderStudentMap();
       return;
    }
    
    let mockQuestions = targetLesson.questions;
    
    let currentQ = 0;
    
    function renderQ() {
      if(currentQ >= mockQuestions.length) {
         // Lesson completed logic
         playVoiceOver("Great job!");
         saveProgress(1, lessonId, 100).then(() => {
           renderStudentMap();
         });
         return;
      }
      const qData = mockQuestions[currentQ];
      
      const main = document.getElementById('main-content');
      main.innerHTML = `
        <div id="quiz-view" class="view active-view" style="text-align:center;">
          <div style="display:flex; align-items:center; gap: 1rem; margin-bottom: 2rem;">
            <button class="btn btn-secondary" style="padding: 0.5rem;" onclick="renderStudentMap()">✖</button>
            <div style="flex:1; height:20px; background:var(--bg-light); border-radius:var(--radius-pill); overflow:hidden;">
              <div style="width:${(currentQ/mockQuestions.length)*100}%; height:100%; background:var(--success-green); transition: width 0.3s; border-radius:var(--radius-pill);"></div>
            </div>
          </div>
          
          <button class="btn" style="background:transparent; color:var(--primary-blue); margin-bottom: 1rem;" onclick="playVoiceOver('${qData.q}')">
            <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon><path d="M19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07"></path></svg>
          </button>
          
          <h2 style="font-size:3rem; margin-bottom: 2rem;">${qData.q}</h2>
          
          <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 1rem; max-width: 400px; margin: 0 auto;">
            ${qData.options.map((opt, i) => `
              <button id="opt-${i}" class="btn btn-secondary" onclick="checkAns(${opt}, ${qData.ans}, 'opt-${i}')" style="font-size:2.5rem; padding: 2rem; border-radius: 20px;">${opt}</button>
            `).join('')}
          </div>
        </div>
      `;
      playVoiceOver(qData.q);
    }
    
    window.checkAns = function(selected, correct, btnId) {
       const btn = document.getElementById(btnId);
       if (selected === correct) {
         btn.style.backgroundColor = 'var(--success-green)';
         btn.style.color = 'white';
         playVoiceOver("Correct!");
         setTimeout(() => {
           currentQ++;
           renderQ();
         }, 1000);
       } else {
         btn.style.backgroundColor = 'var(--primary-red)';
         btn.style.color = 'white';
         playVoiceOver("Try again!");
         // Reset styling after 1 second
         setTimeout(() => {
           btn.style.backgroundColor = 'var(--bg-light)';
           btn.style.color = 'var(--primary-blue)';
         }, 1000);
       }
    };
    
    renderQ();
  };
}
