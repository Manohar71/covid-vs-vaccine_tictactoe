import 'package:flutter/material.dart';
import 'game_logic.dart';
import 'package:device_preview/device_preview.dart';


void main() => runApp(
  DevicePreview(
    enabled: true,
    builder: (context) => MyApp(), // Wrap your app
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  //adding the necessary variables
  String lastValue = "covid";
  bool gameOver = false;
  int turn = 0; // to check the draw
  String result = "";
  int cscore =0;
  int vscore=0;
  List<int> scoreboard = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; //the score are for the different combination of the game [Row1,2,3, Col1,2,3, Diagonal1,2];
  //let's declare a new Game components

  Game game = Game();

  //let's initi the GameBoard
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
              'COVID vs VACCINE'
          ),
        ),
        backgroundColor: Color(0xFF00061a),
      ),
      backgroundColor: Color(0xFF001456),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("covid",style: TextStyle(color: Colors.white
                          , fontSize: 25 , fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text(cscore.toString(),style: TextStyle(fontSize: 20 , color: Colors.white),)
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("vaccine",style:  TextStyle(color: Colors.white
                          , fontSize: 25 , fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text(vscore.toString(),style: TextStyle(fontSize: 20, color: Colors.white),)
                    ],
                  ),
                )
              ],
            ),
          ),
          Text(
            "It's ${lastValue} turn".toUpperCase(),
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold
            ),
          ),

          SizedBox(
            height: 20.0,
          ),
          //now we will make the game board
          //but first we will create a Game class that will contains all the data and method that we will need
          Container(
            height: 345,
            width: 500,
            child: GridView.count(
              crossAxisCount: Game.boardlenth ~/
                  3, // the ~/ operator allows you to evide to integer and return an Int as a result
              padding: EdgeInsets.all(16.0),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: List.generate(Game.boardlenth, (index) {
                return InkWell(
                    onTap: gameOver
                        ? null
                        : () {
                      //when we click we need to add the new value to the board and refrech the screen
                      //we need also to toggle the player
                      //now we need to apply the click only if the field is empty
                      //now let's create a button to repeat the game

                      if (game.board![index] == "") {
                        setState(() {
                          game.board![index] = lastValue;
                          turn++;
                          gameOver = game.winnerCheck(
                              lastValue, index, scoreboard, 3);

                          if (gameOver) {
                            result = "$lastValue is the Winner";
                            if (lastValue == "covid"){
                              cscore +=1;
                            }
                            else{
                              vscore +=1;
                            }
                          } else if (!gameOver && turn == 9) {
                            result = "It's a Draw!";
                            gameOver = true;
                          }
                          if (lastValue == "covid")
                            lastValue = "vaccine";
                          else
                            lastValue = "covid";
                        });
                      }
                    },
                    child: Container(
                      width: Game.blocSize,
                      height: Game.blocSize,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Center(

                        child: Icon(

                          game.board![index] == "covid" ? (Icons.coronavirus) : (game.board![index]== "vaccine" ?( Icons.vaccines) : null),
                          color: game.board![index] == "covid" ? Colors.red:Colors.green,
                          size: 50,


                        ),
                      ),
                    )
                );
              }),
            ),
          ),
          SizedBox(
            height: 30.0,),
          Container(
            child: Text(
              result,
              style: TextStyle(color: Colors.white, fontSize: 30.0 , fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 30,),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                //erase the board
                game.board = Game.initGameBoard();
                lastValue = "covid";
                gameOver = false;
                turn = 0;
                result = "";
                scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
              }
              );
            },

            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
            ),
            icon: Icon(Icons.replay),
            label: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Repeat the Game"),
            ),
          ),
        ],
      ),
    );

    //the first step is organise our project folder structure
  }
}
