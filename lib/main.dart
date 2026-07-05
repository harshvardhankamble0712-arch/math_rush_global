<!DOCTYPE html>
<html lang="mr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Math Elite</title>
    <style>
        /* CSS: बेस डिझाईन */
        body {
            margin: 0; padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            color: white; display: flex;
            justify-content: center; align-items: center;
            height: 100vh; text-align: center; overflow: hidden;
        }
        .screen {
            display: none; width: 90%; max-width: 400px;
            background: rgba(255, 255, 255, 0.1); padding: 30px;
            border-radius: 15px; box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(10px); position: relative;
        }
        .active { display: block; }
        
        .game-logo { width: 180px; height: auto; margin-bottom: 20px; border-radius: 15px; filter: drop-shadow(0px 4px 8px rgba(0,0,0,0.4)); }
        h1 { display: none; }
        .hk-production { font-size: 0.8em; color: #ccc; margin-top: 30px; }
        
        /* बटन्स */
        button {
            background-color: #ff9800; color: white; border: none;
            padding: 15px; margin: 10px 0; width: 100%;
            font-size: 1.2em; border-radius: 8px; cursor: pointer;
            transition: 0.3s; font-weight: bold;
        }
        button:hover { background-color: #e68a00; }
        .back-btn { background-color: #555; width: auto; padding: 10px 15px; margin-bottom: 20px; float: left; }
        .settings-btn { float: right; background: none; font-size: 1.8em; cursor: pointer; padding: 0; width: auto; margin:0;}
        
        /* गेमप्ले */
        .info-bar { display: flex; justify-content: space-between; font-size: 1.2em; margin-bottom: 20px; clear: both;}
        .question { font-size: 3em; margin: 20px 0; font-weight: bold; background: rgba(0,0,0,0.2); padding: 20px; border-radius: 10px;}
        .options-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; }
        .option-btn { background-color: #4CAF50; font-size: 1.5em; padding: 20px; }
        
        /* सेटिंग्स आणि कस्टम मोड */
        .modal {
            display: none; position: absolute; top: 50%; left: 50%;
            transform: translate(-50%, -50%); width: 85%; max-width: 350px;
            background: #222; padding: 20px; border-radius: 15px;
            z-index: 100; box-shadow: 0 0 20px rgba(0,0,0,0.8); border: 2px solid #ff9800;
        }
        select, input {
            width: 90%; padding: 10px; margin: 10px 0;
            font-size: 1.2em; border-radius: 5px; border: none; text-align: center;
        }
        #result-msg { font-size: 1.5em; margin-top: 20px; height: 30px; font-weight: bold;}
    </style>
</head>
<body>

    <div id="settings-modal" class="modal">
        <h2>⚙️ Settings</h2>
        <p>भाषा निवडा (Language):</p>
        <select id="language-select">
            <option value="mr">मराठी</option>
            <option value="en">English</option>
            <option value="hi">हिंदी</option>
        </select>
        <button onclick="closeSettings()" style="background-color: #4CAF50;">Save & Close</button>
    </div>

    <div id="home-screen" class="screen active">
        <button class="settings-btn" onclick="openSettings()">⚙️</button>
        <div style="clear:both;"></div>
        <img src="IMG-20260704-WA2822.jpg" alt="Math Elite Logo" class="game-logo">
        <h1>Math Elite</h1>
        <button onclick="showScreen('category-screen')">Start Game</button>
        <div class="hk-production">Background by HK Production</div>
    </div>

    <div id="category-screen" class="screen">
        <button class="back-btn" onclick="showScreen('home-screen')">🔙 Back</button>
        <button class="settings-btn" onclick="openSettings()">⚙️</button>
        <h2 style="clear:both;">पर्याय निवडा</h2>
        <button onclick="selectCategory('+')">बेरीज (Addition)</button>
        <button onclick="selectCategory('-')">वजाबाकी (Subtraction)</button>
        <button onclick="selectCategory('*')">गुणाकार (Multiplication)</button>
        <button onclick="selectCategory('/')">भागाकार (Division)</button>
        <button onclick="showScreen('custom-screen')" style="background-color: #9c27b0;">पालक देतील ते (Custom)</button>
    </div>

    <div id="custom-screen" class="screen">
        <button class="back-btn" onclick="showScreen('category-screen')">🔙 Back</button>
        <h2 style="clear:both;">पालकांचे गणित</h2>
        <input type="number" id="custom-num1" placeholder="पहिली संख्या (उदा. 15)">
        <select id="custom-op">
            <option value="+">बेरीज (+)</option>
            <option value="-">वजाबाकी (-)</option>
            <option value="*">गुणाकार (x)</option>
            <option value="/">भागाकार (/)</option>
        </select>
        <input type="number" id="custom-num2" placeholder="दुसरी संख्या (उदा. 7)">
        <button onclick="startCustomGame()" style="background-color: #e91e63;">Start Custom Game</button>
    </div>

    <div id="level-screen" class="screen">
        <button class="back-btn" onclick="showScreen('category-screen')">🔙 Back</button>
        <h2 style="clear:both;">लेव्हल निवडा</h2>
        <button onclick="startGame('simple')">Basic / Simple Level</button>
        <button onclick="startGame('pro')">Pro Level</button>
    </div>

    <div id="game-screen" class="screen">
        <button class="back-btn" onclick="clearInterval(timerInterval); showScreen('category-screen')">🔙 Quit</button>
        <div class="info-bar">
            <span>Score: <span id="score">0</span></span>
            <span>Time: <span id="time">0</span>s</span>
        </div>
        <div class="question" id="question-text">?</div>
        <div class="options-grid" id="options-container"></div>
        <div id="result-msg"></div>
        <button id="next-btn" style="display:none;" onclick="handleNext()">Next ➡️</button>
    </div>

    <script>
        let currentCategory = '';
        let currentLevel = '';
        let score = 0;
        let timeLeft = 0;
        let timerInterval;
        let correctAnswer = 0;
        let isCustomMode = false; // कस्टम मोड चालू आहे का ते तपासण्यासाठी

        // सेटिंग्स उघडणे आणि बंद करणे
        function openSettings() { document.getElementById('settings-modal').style.display = 'block'; }
        function closeSettings() { document.getElementById('settings-modal').style.display = 'none'; }

        function showScreen(screenId) {
            document.querySelectorAll('.screen').forEach(screen => screen.classList.remove('active'));
            document.getElementById(screenId).classList.add('active');
        }

        function selectCategory(category) {
            currentCategory = category;
            isCustomMode = false;
            showScreen('level-screen');
        }

        // पालकांचा कस्टम गेम सुरु करणे
        function startCustomGame() {
            let num1 = parseInt(document.getElementById('custom-num1').value);
            let num2 = parseInt(document.getElementById('custom-num2').value);
            let op = document.getElementById('custom-op').value;

            if(isNaN(num1) || isNaN(num2)) {
                alert("कृपया दोन्ही संख्या टाका! (Please enter numbers)");
                return;
            }

            currentCategory = op;
            isCustomMode = true;
            score = 0;
            document.getElementById('score').innerText = score;
            showScreen('game-screen');
            
            // कस्टम गेमसाठी टाईम लिमिट थोडी जास्त (३० सेकंद) ठेवूया
            startTimer(30);
            createProblem(num1, num2, op);
        }

        // नॉर्मल गेम सुरु करणे
        function startGame(level) {
            currentLevel = level;
            score = 0;
            document.getElementById('score').innerText = score;
            showScreen('game-screen');
            generateRandomProblem();
        }

        // टायमर लॉजिक
        function startTimer(seconds) {
            timeLeft = seconds;
            document.getElementById('time').innerText = timeLeft;
            clearInterval(timerInterval);
            timerInterval = setInterval(() => {
                timeLeft--;
                document.getElementById('time').innerText = timeLeft;
                if(timeLeft <= 0) {
                    clearInterval(timerInterval);
                    document.getElementById('result-msg').innerText = "❌ Time Out!";
                    document.getElementById('result-msg').style.color = "red";
                    document.getElementById('next-btn').style.display = "block";
                    disableOptions();
                }
            }, 1000);
        }

        function generateRandomProblem() {
            startTimer((currentLevel === 'simple') ? 10 : 20);
            let maxNum = (currentLevel === 'simple') ? 10 : 100;
            let num1 = Math.floor(Math.random() * maxNum) + 1;
            let num2 = Math.floor(Math.random() * maxNum) + 1;

            if(currentCategory === '-' && num1 < num2) {
                let temp = num1; num1 = num2; num2 = temp; // वजाबाकीसाठी मोठी संख्या आधी
            }
            createProblem(num1, num2, currentCategory);
        }

        // स्क्रीनवर गणित तयार करणे
        function createProblem(num1, num2, operator) {
            document.getElementById('result-msg').innerText = '';
            document.getElementById('next-btn').style.display = 'none';

            let displayOp = operator === '*' ? 'x' : operator === '/' ? '÷' : operator;
            document.getElementById('question-text').innerText = `${num1} ${displayOp} ${num2}`;
            
            if(operator === '+') correctAnswer = num1 + num2;
            else if(operator === '-') correctAnswer = num1 - num2;
            else if(operator === '*') correctAnswer = num1 * num2;
            else if(operator === '/') correctAnswer = parseFloat((num1 / num2).toFixed(1)); 

            let options = [correctAnswer];
            while(options.length < 4) {
                let variance = Math.floor(Math.random() * 10) - 5;
                if(variance === 0) variance = 2; // शून्य टाळण्यासाठी
                let wrongAnswer = correctAnswer + variance;
                if(!options.includes(wrongAnswer)) {
                    options.push(wrongAnswer);
                }
            }
            options.sort(() => Math.random() - 0.5);

            let optionsHtml = '';
            options.forEach(opt => {
                optionsHtml += `<button class="option-btn" onclick="checkAnswer(${opt})">${opt}</button>`;
            });
            document.getElementById('options-container').innerHTML = optionsHtml;
        }

        function checkAnswer(selected) {
            clearInterval(timerInterval); 
            disableOptions();
            let msgElement = document.getElementById('result-msg');
            
            if(selected === correctAnswer) {
                msgElement.innerText = "✅ बरोबर (Correct)!";
                msgElement.style.color = "lightgreen";
                score += 10;
                document.getElementById('score').innerText = score;
            } else {
                msgElement.innerText = `❌ चुकीचे! बरोबर उत्तर: ${correctAnswer}`;
                msgElement.style.color = "red";
            }
            document.getElementById('next-btn').style.display = "block";
        }

        function disableOptions() {
            document.querySelectorAll('.option-btn').forEach(btn => btn.disabled = true);
        }

        // Next बटनाचे लॉजिक
        function handleNext() {
            if(isCustomMode) {
                // कस्टम मोडमध्ये एका गणितानंतर पुन्हा कस्टम स्क्रीनवर पाठवणे योग्य राहील
                showScreen('custom-screen');
                document.getElementById('custom-num1').value = '';
                document.getElementById('custom-num2').value = '';
            } else {
                generateRandomProblem();
            }
        }
    </script>
</body>
</html>
      
