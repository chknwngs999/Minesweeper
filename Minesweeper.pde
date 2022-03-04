import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
public static int NUM_ROWS = 10;
public static int NUM_COLS = 10;
public int nummines = 5;

void setup ()
{
    size(400, 400);
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
    
    mines = new ArrayList <MSButton>();
    setMines();
}
public void setMines()
{
    //your code
    int placed = 0;
    while (placed < nummines){
      int row = (int)(Math.random()*NUM_ROWS);
      int col = (int)(Math.random()*NUM_COLS);
      if (!mines.contains(buttons[row][col])){
        mines.add(buttons[row][col]);
        placed++;
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
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
    public static String LOSSMESSAGE = "Lose...";
    for (int mine = 0; mine < mines.size(); mine++){
      mines.get(mine).clicked = true;
    }
    
    int centerR = NUM_ROWS/2;
    int centerC = NUM_COLS/2;
    
    centerC = centerC-(LOSSMESSAGE.length()/2);
    for (int c = 0; c < LOSSMESSAGE.length(); c++){
      buttons[centerR][centerC+c].setLabel(LOSSMESSAGE.substring(c, c+1));
    }
    
    //resetwait = true;
}
public void displayWinningMessage()
{
    //your code here
    public static String WINMESSAGE = "Win!!";
    int centerR = NUM_ROWS/2;
    int centerC = NUM_COLS/2;
    
    centerC = centerC-(WINMESSAGE.length()/2);
    
    for (int c = 0; c < + WINMESSAGE.length(); c++){
      buttons[centerR][centerC+c].setLabel(WINMESSAGE.substring(c, c+1));
    }
    
    //resetwait = true;
}
public boolean isValid(int r, int c)
{
    //your code here
    return (r >=0 && c >= 0) && (r < NUM_ROWS && c < NUM_COLS);
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
    if (mines.contains(buttons[row][col]))
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
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        //your code here
        if (mouseButton == RIGHT){
          flagged = !flagged;
          if (flagged == false){
            clicked = false;
          }
        } else if (mines.contains(this)) {
          displayLosingMessage();
        } else if (countMines(myRow, myCol) != 0) {
          setLabel(countMines(myRow, myCol));
        } else {
          for (int r = myRow-1; r <= myRow+1; r++){
            for (int c = myCol-1; c <= myCol+1; c++){
              if (isValid(r, c) && !buttons[r][c].isClicked()){ //maybe?
                buttons[r][c].mousePressed();
              }
            }
          }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
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
    public boolean isClicked()
    {
        return clicked;
    }
}
