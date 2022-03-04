import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private static int NUM_ROWS = 16;
private static int NUM_COLS = 16;
private int next_row = NUM_ROWS;
private int next_col = NUM_COLS;
private boolean lost = false;
boolean rowinc = true;
boolean colinc = true;
boolean mineinc = true;
boolean resetwait = false;
int nummines = 30;
public final static String LOSSMESSAGE = "Lose...";
public final static String WINMESSAGE = "Win!!";
int flaggedout = 0;
//int startTime = (int)(System.currentTimeMillis());
//int currTime = (int)(System.currentTimeMillis());

//custom modes
//m/n increment mines
//up/down increment rows
//left/right increment cols

//space to restart
//lose/win messages
//mine counter - decrement when marked
//timer

//easy, medium, hard preset modes
//place mines AFTER first click?

void setup ()
{
    size(400, 500);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
    
    setMines();
}
public void setMines()
{
    //your code
    int counter = 0;
    while (counter < nummines){
      int row = (int)(Math.random()*NUM_ROWS);
      int col = (int)(Math.random()*NUM_COLS);
      if (mines.contains(buttons[row][col]) == false){
         mines.add(buttons[row][col]);
         counter++;
      }
    }
}

public void draw ()
{
    //currTime = (int)(System.currentTimeMillis());
    background( 130 );
    flaggedout = 0;
    for (int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_COLS; c++){
        if (buttons[r][c].isFlagged()) { flaggedout++; }
      }
    }
    text("Dimensions: " + NUM_ROWS + "x" + NUM_COLS, 150, 50);
    text("Mines: " + (mines.size()-flaggedout), 50, 50);
    //text("Time: " + (float)(currTime-startTime)/1000 + " seconds", 300, 50);
    if(isWon() == true && !resetwait) {
        displayWinningMessage();   
    } else if (lost){
      displayLosingMessage();
    }
}
public boolean isWon()
{
    //your code here
    for (int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_COLS; c++){
        if (!buttons[r][c].clicked && !mines.contains(buttons[r][c]))
          return false;
      }
    }
    return true;
}
public void displayLosingMessage()
{
    //your code here
    for (int mine = 0; mine < mines.size(); mine++){
      mines.get(mine).clicked = true;
    }
    resetwait = true;
    
    int centerR = NUM_ROWS/2;
    int centerC = NUM_COLS/2-3;
    
    for (int c = 0; c < LOSSMESSAGE.length(); c++){
      buttons[centerR][centerC+c].setLabel(LOSSMESSAGE.substring(c, c+1));
    }
}
public void displayWinningMessage()
{
    //your code here
    int centerR = NUM_ROWS/2;
    int centerC = NUM_COLS/2-2;
    
    for (int c = 0; c < + WINMESSAGE.length(); c++){
      buttons[centerR][centerC+c].setLabel(WINMESSAGE.substring(c, c+1));
    }
    
    resetwait = true;
}
public boolean isValid(int r, int c)
{
    //your code here
    return (r >= 0 && c >= 0 && r < NUM_ROWS && c < NUM_COLS);
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for (int r = row-1; r <= row+1; r++){
      for (int c = col-1; c <= col+1; c++){
        if (isValid(r, c) && mines.contains(buttons[r][c]))
          numMines++;
      }
    }
    if(mines.contains(buttons[row][col]))
      numMines--;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height+100;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        //your code here
        if (!resetwait){
          clicked = true;
          if (mouseButton == RIGHT){
            if (flagged)
              clicked = false;
            flagged = !flagged;
          } else if (!flagged) {
            if (mines.contains( this )){
              displayLosingMessage();
              lost = true;
            } else if (countMines(myRow, myCol) != 0){
              setLabel(Integer.toString(countMines(myRow, myCol)));
            } else {
              for (int r = myRow-1; r <= myRow+1; r++){
                for (int c = myCol-1; c <= myCol+1; c++){
                  if (isValid(r, c) && !buttons[r][c].clicked)// && !buttons[r][c].flagged)
                    buttons[r][c].mousePressed();
                }
              }
            }
          }
        }
    }
    public void draw () 
    {    
        if (flagged) {
            fill( 200, 200, 0 );
        } else if(clicked) {
            fill( 190, 50, 50 );
        } else {
            fill( 0, 200, 0 );
        }
        
        rect(x, y, width, height);
        if (!flagged && clicked && mines.contains(this)){
          fill(0);
          rect(x, y, width, height);
          fill(255,0,0);
          ellipse(x+width/2, y+height/2, 2*width/3, 2*height/3);
        }
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}

void keyPressed(){
  if (keyCode == 39 && rowinc){
    next_row++;
    rowinc = false;
  } else if (keyCode == 37 && rowinc) {
    next_row--;
    rowinc = false;
  } if (keyCode == 38 && colinc) {
    next_col++;
    colinc = false;
  } else if (keyCode == 40) {
    next_col--;
    colinc = false;
  }
  
  if (key == 'm' && mineinc){
    nummines++;
    mineinc = false;
  } else if (key == 'n' && mineinc){
    nummines--;
    mineinc = false;
  }
  
  if (keyCode == 32 && resetwait){
    if (next_row < 5)
      next_row = 5;
    if (next_col < 5)
      next_col = 5;
    NUM_ROWS = next_row;
    NUM_COLS = next_col;
    if (nummines >= (NUM_ROWS*NUM_COLS))
      nummines = NUM_ROWS*NUM_COLS-1;
    else if (nummines < 1)
      nummines = 1;
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++){
      for (int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
    
    mines = new ArrayList<MSButton>();
    setMines();
    resetwait = false;
    lost = false;
    //startTime = (int)(System.currentTimeMillis());
  }
}
void keyReleased(){
  if (keyCode == 37 || keyCode == 39)
    rowinc = true;
  if (keyCode == 38 || keyCode == 40)
    colinc = true;
  if (key == 'm' || key == 'n')
    mineinc = true;
}
