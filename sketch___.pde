class Monkey {
  float x, y, vy;
  float baseHeight;
  boolean isJumping = false;
  boolean isSliding = false; 
  float slideTimer = 0;
  
  Monkey(float x, float y) {
    this.x = x;
    this.y = y;
    this.baseHeight = y;
    this.vy = 0;
  }
  
  void update() {
    if (isJumping) {
      y += vy;
      vy += 0.8;
      if (y >= baseHeight) {
        y = baseHeight;
        isJumping = false;
        vy = 0;
      }
    }
    
    if (isSliding) {
      slideTimer -= 1;
      if (slideTimer <= 0) {
        isSliding = false;
      }
    }
  }
  
  void jump() {
    if (!isJumping) {
      vy = -14;
      isJumping = true;
      isSliding = false; 
    }
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    
    if (isSliding) {
      rotate(QUARTER_PI);
      
      fill(139, 69, 19);
      rect(-20, -12, 40, 24, 8);
      fill(160, 82, 45);
      ellipse(25, 0, 30, 30);
      fill(255, 222, 173);
      ellipse(28, 0, 18, 18);
      
      stroke(0);
      strokeWeight(2);
      line(23, -4, 27, 0); 
      line(27, -4, 23, 0);
      noStroke();
      
      popMatrix();
      fill(255, 0, 0);
      textSize(14);
      text("Slip!", x - 15, y - 35);
    } else {
      noFill();
      stroke(110, 55, 10);
      strokeWeight(4);
      beginShape();
      vertex(-12, 10);
      bezierVertex(-35, 10, -40, -15, -30, -25);
      endShape();
      noStroke();
      
      fill(110, 55, 10);
      ellipse(-5, 22, 12, 16);
      
      fill(139, 69, 19);
      ellipse(0, 5, 34, 40);
      
      fill(255, 222, 173);
      ellipse(4, 7, 20, 28);
      
      fill(110, 55, 10);
      ellipse(10, 24, 12, 16);
      
      fill(160, 82, 45);
      ellipse(12, -22, 32, 30);
      
      ellipse(-2, -25, 12, 12);
      fill(255, 222, 173);
      ellipse(-2, -25, 7, 7);
      
      fill(255, 222, 173);
      ellipse(16, -20, 20, 18);
      
      fill(0);
      ellipse(20, -22, 4, 6);
      
      noFill();
      stroke(0);
      strokeWeight(1.5);
      arc(18, -16, 8, 6, 0, PI);
      noStroke();
    }
    
    popMatrix();
  }
}

class Obstacle {
  float x, y, w, h;
  int type; 
  
  Obstacle(float x, float y, int type) {
    this.x = x;
    this.y = y;
    this.type = type;
    if (type == 0) {
      this.w = 30;
      this.h = 28;
    } else {
      this.w = 32;
      this.h = 24;
    }
  }
  
  void update(float speed) {
    x -= speed;
  }
  
  void display() {
    if (type == 0) {
      fill(110);
      rect(x, y, w, h, 6);
      fill(140);
      rect(x + 4, y + 4, w - 8, h - 12, 4);
    } else {
      pushMatrix();
      translate(x, y + 10);
      
      fill(255, 215, 0);
      arc(-6, 0, 20, 16, QUARTER_PI, PI + HALF_PI);
      arc(6, 0, 20, 16, -HALF_PI, PI - QUARTER_PI);
      fill(218, 165, 32);
      ellipse(0, -2, 8, 8);
      
      popMatrix();
    }
  }
}

Monkey monkey;
ArrayList<Obstacle> obstacles;
float gameSpeed = 5;
int score = 0;
boolean gameOver = false;

float startMouseY = 0;
boolean dragging = false;

void setup() {
  size(800, 400);
  monkey = new Monkey(100, 280);
  obstacles = new ArrayList<Obstacle>();
}

void draw() {
  background(135, 206, 235);
  
  fill(100, 180, 100);
  rect(0, 260, width, 60);
  
  fill(85, 140, 60);
  rect(0, 310, width, 90);
  fill(120, 200, 80);
  rect(0, 310, width, 10);
  
  if (!gameOver) {
    score++;
    gameSpeed = 5 + (score / 300);
    
    if (frameCount % 85 == 0) {
      int t = (random(1) > 0.4) ? 0 : 1;
      obstacles.add(new Obstacle(width, 285, t));
    }
    
    monkey.update();
    monkey.display();
    
    for (int i = obstacles.size() - 1; i >= 0; i--) {
      Obstacle obs = obstacles.get(i);
      obs.update(gameSpeed);
      obs.display();
      
      if (abs(monkey.x - obs.x) < 22 && abs(monkey.y - obs.y) < 25) {
        if (obs.type == 1) { 
          monkey.isSliding = true;
          monkey.slideTimer = 50; 
          obstacles.remove(i);
        } else {
          gameOver = true;
        }
      }
      
      if (obs.x < -50) {
        obstacles.remove(i);
      }
    }
    
    fill(255);
    textSize(22);
    text("Score: " + score, 25, 45);
    
    fill(50);
    textSize(13);
    text("Controls: Drag mouse up or press SPACE to jump!", 25, 75);
    
  } else {
    fill(0, 0, 0, 180);
    rect(0, 0, width, height);
    
    fill(255, 100, 100);
    textSize(42);
    textAlign(CENTER, CENTER);
    text("GAME OVER", width/2, height/2 - 35);
    
    fill(255);
    textSize(22);
    text("Final Score: " + score, width/2, height/2 + 15);
    
    textSize(15);
    fill(200);
    text("Click to Restart", width/2, height/2 + 60);
    textAlign(LEFT, BASELINE);
  }
}

void mousePressed() {
  if (gameOver) {
    score = 0;
    gameSpeed = 5;
    obstacles.clear();
    monkey.y = monkey.baseHeight;
    monkey.isJumping = false;
    monkey.isSliding = false;
    gameOver = false;
  } else {
    startMouseY = mouseY;
    dragging = true;
  }
}

void mouseReleased() {
  if (dragging && !gameOver) {
    float diffY = startMouseY - mouseY; 
    if (diffY > 25 || monkey.isSliding) { 
      monkey.jump();
    }
    dragging = false;
  }
}

void keyPressed() {
  if (key == ' ' && !gameOver) {
    monkey.jump();
  }
}
