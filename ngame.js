let canvas = document.getElementById("gameCanvas");
let ctx = canvas.getContext("2d");
let username;
let snake, direction, food, score, gameLoop;
let gameRunning = false;

function startGame() {
    username = document.getElementById("username").value.trim();
    if (!username) {
        alert("Please enter a username!");
        return;
    }

    snake = [{ x: 10, y: 10 }];
    direction = "RIGHT";
    food = { x: Math.floor(Math.random() * 20), y: Math.floor(Math.random() * 20) };
    score = 0;
    gameRunning = true;

    document.addEventListener("keydown", changeDirection);

    if (gameLoop) clearInterval(gameLoop);
    gameLoop = setInterval(updateGame, 100);

    loadScores();
}

function changeDirection(event) {
    if (!gameRunning) return;

    if (event.key === "ArrowUp" && direction !== "DOWN") direction = "UP";
    if (event.key === "ArrowDown" && direction !== "UP") direction = "DOWN";
    if (event.key === "ArrowLeft" && direction !== "RIGHT") direction = "LEFT";
    if (event.key === "ArrowRight" && direction !== "LEFT") direction = "RIGHT";
}

function updateGame() {
    if (!gameRunning) return;

    let head = { ...snake[0] };
    if (direction === "UP") head.y--;
    if (direction === "DOWN") head.y++;
    if (direction === "LEFT") head.x--;
    if (direction === "RIGHT") head.x++;

    if (head.x === food.x && head.y === food.y) {
        score++;
        food = { x: Math.floor(Math.random() * 20), y: Math.floor(Math.random() * 20) };
    } else {
        snake.pop();
    }

    if (head.x < 0 || head.x >= 20 || head.y < 0 || head.y >= 20 || snake.some(seg => seg.x === head.x && seg.y === head.y)) {
        gameRunning = false;
        clearInterval(gameLoop);
        saveScore();
        alert(`${username} Game Over! Score: ${score}`);
        return;
    }

    snake.unshift(head);
    drawGame();
}

function drawGame() {
    ctx.fillStyle = "black";
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    drawStar(food.x * 20 + 10, food.y * 20 + 10, 5, 10, 5);

    ctx.fillStyle = "green";
    snake.forEach(part => {
        ctx.beginPath();
        ctx.arc(part.x * 20 + 10, part.y * 20 + 10, 10, 0, Math.PI * 2);
        ctx.fill();
    });
}

function drawStar(cx, cy, spikes, outerRadius, innerRadius) {
    let rot = Math.PI / 2 * 3;
    let step = Math.PI / spikes;
    let x, y;

    ctx.beginPath();
    ctx.moveTo(cx, cy - outerRadius);

    for (let i = 0; i < spikes; i++) {
        x = cx + Math.cos(rot) * outerRadius;
        y = cy + Math.sin(rot) * outerRadius;
        ctx.lineTo(x, y);
        rot += step;

        x = cx + Math.cos(rot) * innerRadius;
        y = cy + Math.sin(rot) * innerRadius;
        ctx.lineTo(x, y);
        rot += step;
    }

    ctx.lineTo(cx, cy - outerRadius);
    ctx.fillStyle = "yellow";
    ctx.fill();
}

function saveScore() {
    fetch("/submit_score.php", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `username=${encodeURIComponent(username)}&score=${encodeURIComponent(score)}`
    }).then(loadScores)
      .catch(err => console.error("Error submitting score:", err));
}

function loadScores() {
    fetch("/get_scores.php")
        .then(response => response.json())
        .then(data => {
            let scoreboard = document.getElementById("scores");
            scoreboard.innerHTML = "";
            data.forEach(row => {
                scoreboard.innerHTML += `<tr><td>${row.username}</td><td>${row.score}</td></tr>`;
            });
        })
        .catch(err => console.error("Error loading scores:", err));
}
