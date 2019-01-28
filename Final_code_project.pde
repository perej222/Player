int screenSelector;
import ddf.minim.*;
Minim minim;
AudioPlayer sfx;
AudioPlayer sfx2;
AudioPlayer sfx3;
AudioPlayer sfx4;
AudioPlayer bgm;
PVector center;

ArrayList<Bullet> bullets = new ArrayList<Bullet>();

int yellowLemon = 0;
int greenLemon = 0;

int YouWin= 3;

float angle = 0;
float x = 0;


//int player1[] = new int [HandSpawnX];
//wint player2[] = new int [HandSpawnY];


float speed = 0.75;
Player lemon;
Player lemon2;

boolean hitNow = false;

int bulletIndex = 0;


void setup()
{
  size(900,900);
  screenSelector = 0;
  
  minim = new Minim(this);
  bgm = minim.loadFile("Bgm.mp3");
  bgm.play();
  bgm.loop();
  sfx = minim.loadFile("scissors.mp3");
  sfx2 = minim.loadFile("paper.mp3");
  sfx3 = minim.loadFile("rock.mp3");
  
  //PLAYER ONE
  lemon = new Player("lemon.png");
  lemon.x = 400;
  lemon.y = 780;
  lemon.s = 0.35;
 
  
  //PLAYER TWO
  lemon2 = new Player("lemon2.png");
  lemon2.x = 400;
  lemon2.y = 50;
  lemon2.s = 0.35;
    }


void draw()
{
     if (screenSelector == 0) {
 
  background(-100);
  fill(0);
  textSize(30);
  text("ROCK PAPER SHOOTER!", width/2.5 -90, 90);
  text("A game of Rock, Paper, Scissors!",  width/2.5 - 140, 170);
  text("Green LemonHead uses the ASD keys to shoot!",  width/2.5 - 220, 230);
   text("Yellow LemonHead uses the JKL keys to shoot!",  width/2.5 - 220, 280);
    text("Press B to start!",  width/2.5 - 100, 350);
   
   
 } else if (screenSelector == 1) {
   screen1();
 
}
}
    void screen1(){
   
      if (screenSelector == 1) {
  background(-300);
  fill(0);
  textSize(30);
  text(yellowLemon, width-100, 50);
  textSize(30);
  text(greenLemon, width-100, 550);
 
  
 //PLAYERS APPEAR
  lemon.update();
  lemon.render();
  
  lemon2.update();
  lemon2.render();

  
  //SPAWNS BULLETS INTO SCENE
  for (int i = 0; i < bullets.size(); i += 1)
  {
    bullets.get(i).render();
    bullets.get(i).update();
  }
   }
    
    
    
}

void update()
{
  
  if (screenSelector == 1) {
    
    
  
  if (yellowLemon == 3){
  screen2();
  }
  
    } else if (screenSelector == 2) {
   screen2();
    }
  
}
  
void screen2()
{
  background(-300);
  fill(0);
  textSize(30);
 

  
  
}
void keyPressed()
{
  //BULLET KEYS
        
  if (key == 'a'|| key == 'A' )
  {
    sfx.play();
    sfx.rewind();
    bullets.add(new Bullet("rock", 1));
    
  }
  if (key == 's'|| key == 'S')
  {
    sfx2.play();
    sfx2.rewind();
    bullets.add(new Bullet("paper", 1));
  
    }
  if (key == 'd'|| key == 'D')
  {
    sfx3.play();
    sfx3.rewind();
    bullets.add(new Bullet("scissors", 1));
  
    }
    
     if (key == 'j'|| key == 'J')
     {
       sfx.play();
       sfx.rewind();
       bullets.add(new Bullet("rock", 2));
     }
   
    
      if (key == 'k'|| key == 'K')
      {
        sfx2.play();
        sfx2.rewind();
        bullets.add(new Bullet("paper", 2));
      }
      if (key == 'l'|| key == 'L')
      {
        sfx3.play();
        sfx3.rewind();
        bullets.add(new Bullet("scissors", 2));
      }
         if (key == 'b' || key == 'B') {
        //if you press the letter A, the screenSelector variable will be 1
        screenSelector = 1;
 
      }
  }




class Bullet extends SpriteObject
{
  String type;
  int player;
  //BULLET ANIMATION
  Bullet(String type, int player)
  {
    super(type + ".png");
    this.type = type;
    this.player = player;
    this.speed = 10;
    if (this.player == 1) {
      this.directionY = -1;
      this.x = lemon.x;
      this.y = lemon.y;
    } else if (this.player == 2) {
      this.directionY = 1;
      this.x = lemon2.x;
      this.y = lemon2.y;
    }
  }
  
  boolean Yellowins(Bullet other) {
    switch (this.type) {
      case "rock": {
        if (other.type == "paper") {
          yellowLemon = yellowLemon +1;
          
         return false;
          
        } else if (other.type == "scissors") {
        
          return true;
        }
      }
      case "paper": {
        if (other.type == "scissors") {
        yellowLemon = yellowLemon +1;
          return false;
          
        } else if (other.type == "rock") {

          return true;
        }
      }
      case "scissors": {
        if (other.type == "rock") {
           yellowLemon = yellowLemon +1;
          return false;
        } else if (other.type == "paper") {
         
  
          return true;
        }
      }
    }
    
    return false;
  }


  
  void update()
  {
    this.y += this.directionY * this.speed;
    this.x += this.directionX * this.speed;
    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet other = bullets.get(i);
      if (this != other) {
        if (this.player != other.player) {
          if (this.collides(other)) {
            
            if (this.type == other.type) {
              bullets.remove(i);
              int index = 0;
              for (int j = bullets.size() - 1; i >= 0; i--) {
                if (bullets.get(j) == this) {
                  index = j;
                  break;
                }
              }
              bullets.remove(index);
              break;
            }
            
            if (this.Yellowins(other)) {
              bullets.remove(i);
              break;
            }
           
        }
        }
      }
    }
  }
}


class Player extends SpriteObject
{
  //LAUNCHES FROM PLAYER
  Player(String filename)
  {
    super(filename);
  }
  
  void update()
  {

    this.x += this.directionX * this.speed;
  }
}


class SpriteObject
//PROJECTILE PHYSICS
{
  float x = 0.0;
  float y = 0.0;
  float w = -1.0;
  float h = -1.0;
  float rotation = 0.0;
  float speed = 1;
  float directionX;
  float directionY;
  float s = 1.0;
  
  PImage img;
  boolean loaded = false;
     
  SpriteObject(String filename)
  //FINDS SPRITE
  {
    this.img = requestImage(filename);
  }
    
  void update()
  {
    if (this.x > width - (this.w * this.s * 0.5) && this.directionX > 0)
   
    this.y += directionY * speed;
    this.x += directionX * speed;
  }
  
  boolean collides(SpriteObject other) {
    if(this.x < other.x + other.img.width && 
      this.x + this.img.width > other.x &&
      this.y < other.y + other.img.height && 
      this.y + this.img.height > other.y) {
      
      return true;
    
       
    }
    
    return false;
  
  }
 
   
  void render()
  {
    if (this.img.width > 0 && loaded == false)
    {
      loaded = true;
      if (this.w == -1.0)
      {
        this.w = this.img.width;
      }
      if (this.h == -1.0)
      {
        this.h = this.img.height;
        
      }
    }
       
    if (loaded)
    {
      imageMode(CENTER);
      pushMatrix();
      translate(this.x, this.y);
      rotate(radians(this.rotation));
      scale(this.s);
      image(this.img, 3, 3, this.w, this.h);
      popMatrix();
    }
  }
}