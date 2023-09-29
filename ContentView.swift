//
//  ContentView.swift
//  phase3
//
//  Created by Ndenko Benanzea-Fontem on 3/9/23.
//

import SwiftUI
//  the Views width and height
let screenRect = UIScreen.main.bounds
let screenWidth = screenRect.size.width
let screenHeight = screenRect.size.height
//View Model
//this class holds the score struct array within it so that
//we can use the observable object property to share its data
class ScoreList: ObservableObject
{
    @Published var scores: [Score]
    init(scores: [Score])
    {
        self.scores = scores
    }
}


struct ContentView: View
{
    
//    in the parent view create an instance of scorelist in the parent
//    that will be passed down to the children
   
    @StateObject var scoreList = ScoreList(scores: [Score(score:400, time: Date()), Score(score:300, time: Date())])

    var body: some View
    {
        
        
        TabView {
//            pass the parents instance to the children tab views
            Board(scoreList: scoreList).tabItem {
                Label("Board", systemImage: "gamecontroller")
            }
            Scores(scoreList: scoreList).tabItem {
                Label("Scores", systemImage: "list.dash")
            }
            About().tabItem {
                Label("About", systemImage: "info.circle")
            }
        }

    }
}
struct Board: View
{
    //   portrait if == .regular
        @Environment(\.verticalSizeClass) var portrait
    //    landscape if  == .regular
        @Environment(\.horizontalSizeClass) var landscape
    private func shouldOffset() -> Bool
    {
        return portrait == .regular
    }
    private func shouldScaleEffect() -> Bool
    {
        return portrait == .regular
    }
    //connect our view to our viewmodel
    @StateObject var game = Triples()
    //    Detlete "Determ and set to random when done testing
    //    @State var selection: String = "Random"
    @State var selection: String = "Random"
    let pickerOptions: [String] = ["Random", "Determ"]
    @State var gameOver = false
    @State var lastscore = 0
    @State var fontSize: CGFloat = 40
    //    detects whether a drag is currently occuring
    @State var dragAvailable: Bool = true
//    shared data that holds our scores
    @ObservedObject var scoreList: ScoreList
    
    
    //    @StateObject scores =
    var body: some View
    {
        ZStack
        {
//            end of game popup
            Rectangle().fill(Color.white).frame(width: 200, height: 200).zIndex(gameOver ? 1 : 0).cornerRadius(10).shadow(color: Color.black.opacity(0.3), radius: 10, x:0 ,y: 5)
            
            Text("Score: " + String(lastscore)).font(.system(size: 30)).zIndex(gameOver ? 1 : 0)
            Rectangle().fill(Color.red).frame(width: 60, height: 30).zIndex(gameOver ? 1 : 0).cornerRadius(10).offset(x: 50, y:70)
            Button("Close")
            {
                gameOver.toggle()
            }.foregroundColor(Color.white).offset(x: 50, y: 70).zIndex(gameOver ? 1 : 0)
            
//            this hides the popup underneath until we need it at the top
            Rectangle().fill(Color.white).frame(width: 900, height: 900)
            
            ZStack
            {
//                game
                Color.gray.frame(width: 360, height: 360).offset(x: shouldOffset() ? 0 : -220, y: shouldOffset() ? -151 : 7).scaleEffect(shouldScaleEffect() ? 1: 0.85)
                
    //            up
                Color.gray.frame(width: 120, height: 50).offset(x: shouldOffset() ? 0 : 180, y: shouldOffset() ? 75 : -80)
                Color.white.frame(width: 100, height: 35).offset(x: shouldOffset() ? 0 : 180, y: shouldOffset() ? 75 : -80)
    //            left
                Color.gray.frame(width: 120, height: 50).offset(x: shouldOffset() ? 80 : 250, y: shouldOffset() ? 150 : -20)
                Color.white.frame(width: 100, height: 35).offset(x: shouldOffset() ? 80 : 250, y: shouldOffset() ? 150 : -20)
    //            right
                Color.gray.frame(width: 120, height: 50).offset(x: shouldOffset() ? -80 : 110, y: shouldOffset() ? 150 : -20)
                Color.white.frame(width: 100, height: 35).offset(x: shouldOffset() ? -80 : 110, y: shouldOffset() ? 150 : -20)
    //            down
                Color.gray.frame(width: 120, height: 50).offset(x: shouldOffset() ? 0: 180, y: shouldOffset() ? 230 : 40)
                Color.white.frame(width: 100, height: 35).offset(x: shouldOffset() ? 0: 180, y: shouldOffset() ? 230 : 40)
    //            new game
    //            Color.gray.frame(width: 120, height: 50).offset(x: 0, y: 230)
    //            Color.gray.frame(width: 120, height: 50).offset(x: 0, y: 230)
                VStack
                {
                    VStack
                    {
                        Text("Score: " + String(game.score)).font(.system(size: 30))
                    }.offset(x: shouldOffset() ? 0 : 180, y: shouldOffset() ? -45 : 170)
//                    (x: shouldOffset() ? 0 : 0, y: shouldOffset() ? 0 : 0)
                    VStack
                    {
                        
                        HStack
                        {
                            
                            VStack
                            {
                                
                                if let unwrapped = game.board[0][0]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                            }
                            
                            VStack
                            {
                                if let unwrapped = game.board[0][1]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                                
                            }
                            
                            VStack
                            {
                                if let unwrapped = game.board[0][2]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                                
                            }
                            
                            VStack
                            {
                                
                                if let unwrapped = game.board[0][3]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                            }
                            
                            
                        }.offset(x: shouldOffset() ? 0 : -220, y: shouldOffset() ? -55 : 145).scaleEffect(shouldScaleEffect() ? 1 : 0.85).animation(.default)
                        
                        HStack
                        {
                            VStack
                            {
                                if let unwrapped = game.board[1][0]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                                
                            }
                            
                            VStack
                            {
                                if let unwrapped = game.board[1][1]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                                
                            }
                            
                            VStack
                            {
                                if let unwrapped = game.board[1][2]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                            }
                            VStack
                            {
                                if let unwrapped = game.board[1][3]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                            }
                            
                        }.offset(x: shouldOffset() ? 0 : -220, y: shouldOffset() ? -75 : 105).scaleEffect(shouldScaleEffect() ? 1 : 0.85).animation(.default)
                        HStack
                        {
                            VStack
                            {
                                if let unwrapped = game.board[2][0]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                                
                            }
                            
                            VStack
                            {
                                if let unwrapped = game.board[2][1]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                            }
                            
                            VStack
                            {
                                if let unwrapped = game.board[2][2]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                            }
                            VStack
                            {
                                if let unwrapped = game.board[2][3]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                            }
                            
                        }.offset(x: shouldOffset() ? 0 : -220, y: shouldOffset() ? -95 : 65).scaleEffect(shouldScaleEffect() ? 1 : 0.85).animation(.default)
                    
                        HStack
                        {
                            VStack
                            {
                                if let unwrapped = game.board[3][0]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                            }
                            
                            VStack
                            {
                                if let unwrapped = game.board[3][1]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                            }
                            VStack
                            {
                                if let unwrapped = game.board[3][2]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                            }
                            VStack
                            {
                                if let unwrapped = game.board[3][3]
                                {
                                    if unwrapped.val == 1
                                    {
                                        
                                        ZStack
                                        {
                                            Color.blue.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else if unwrapped.val == 2
                                    {
                                        ZStack
                                        {
                                            Color.red.frame(width: 80, height: 80)
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                    else
                                    {
                                        ZStack
                                        {
                                            Color.yellow.frame(width: 80, height: 80)
                                            
                                            Text(String(unwrapped.val)).font(.system(size: fontSize)).foregroundColor(Color.white)
                                        }
                                    }
                                }
                                else
                                {
                                    ZStack
                                    {
                                        Color.yellow.frame(width: 80, height: 80)
                                        
                                        Text(" ").font(.system(size: fontSize)).foregroundColor(Color.white)
                                    }
                                }
                            }
                            
                        }.offset(x: shouldOffset() ? 0 : -220, y: shouldOffset() ? -115 : 25).scaleEffect(shouldScaleEffect() ? 1 : 0.85).animation(.default)
                        VStack
                        {
                            Button("Up")
                            {
                                if (game.collapse(dir: Triples.Direction.up)) == true
                                {
                                    game.spawn()
                                }
                                if (game.isGameDone() == true)
                                {
                                    lastscore = game.score
                                    gameOver.toggle()
                                }
                            }.font(.system(size: 30)).offset(x: shouldOffset() ? 0 : 180, y: shouldOffset() ? -90 : -245)

                            
                            HStack
                            {
                                Button("Left")
                                {
                                    if (game.collapse(dir: Triples.Direction.left)) == true
                                    {
                                        game.spawn()
                                    }
                                    if (game.isGameDone() == true)
                                    {
                                        lastscore = game.score
                                        gameOver.toggle()
                                    }
                                }.font(.system(size: 30)).offset(x: shouldOffset() ? -40 : 150, y: shouldOffset() ? -50 : -220)

                                
                                Button("Right")
                                {
                                    if (game.collapse(dir: Triples.Direction.right)) == true
                                    {
                                        game.spawn()
                                    }
                                    if (game.isGameDone() == true)
                                    {
                                        lastscore = game.score
                                        gameOver.toggle()
                                    }
                                }.font(.system(size: 30)).offset(x: shouldOffset() ? 50 : 220, y: shouldOffset() ? -50 : -220)

                            }
                            
                            Button("Down")
                            {
                                if (game.collapse(dir: Triples.Direction.down)) == true
                                {
                                    game.spawn()
                                }
                                if (game.isGameDone() == true)
                                {
                                    lastscore = game.score
                                    gameOver.toggle()
                                }
                            }.font(.system(size: 30)).offset(x: shouldOffset() ? 0 : 180, y: shouldOffset() ? -10 : -195)

                            
                            Button("New Game")
                            {
//                                trigger the game over screen
                                lastscore = game.score
                                gameOver.toggle()
//                                log the score to highscores
                                var myscore = Score(score: game.score,time: Date())
                                scoreList.scores.append(myscore)
//                                sort in descending order
                                scoreList.scores.sort { $1.score < $0.score }
//                                set up the new game correctly
                                if selection == "Random"
                                {
                                    game.newgame(rand: true)
                                }
                                else
                                {
                                    game.newgame(rand: false)
                                }
                                
                            }.offset(x: shouldOffset() ? 0 : 180, y: shouldOffset() ? 20 : -160)

                        }
                        Picker(
                            selection: $selection,
                            label: HStack
                            {
                                Text("Filter")
                                Text(selection)
                            }
                            ,content:
                                {
                                    ForEach(pickerOptions, id: \.self)
                                    {
                                        option in Text(option)
                                            .tag(option)
                                    }
                                }).offset(x: shouldOffset() ? 0 : 180, y: shouldOffset() ? 20 : -170)                    }.gesture(DragGesture()
                    .onChanged
                    {
                        //                        sense for any drag
                        gesture in
                        //                        once we've noticed any drag, sense for right, ignoring right swipes with small changes in the up and down direction
                        if gesture.translation.width > 0 && abs(gesture.translation.width) > abs(gesture.translation.height) && self.dragAvailable == true
                        {
                            if (game.collapse(dir: Triples.Direction.right)) == true
                            {
                                game.spawn()
                            }
                            if (game.isGameDone() == true)
                            {
                                lastscore = game.score
                                gameOver.toggle()
                            }
                            self.dragAvailable = false
                            
                        }
//                        left
                        if gesture.translation.width < 0 && abs(gesture.translation.width) > abs(gesture.translation.height) && self.dragAvailable == true
                        {
                            if (game.collapse(dir: Triples.Direction.left)) == true
                            {
                                game.spawn()
                            }
                            if (game.isGameDone() == true)
                            {
                                lastscore = game.score
                                gameOver.toggle()
                            }
                            self.dragAvailable = false
                        }
//                        up
                        if gesture.translation.height < 0 && abs(gesture.translation.width) < abs(gesture.translation.height) && self.dragAvailable == true
                        {
                            if (game.collapse(dir: Triples.Direction.up)) == true
                            {
                                game.spawn()
                            }
                            if (game.isGameDone() == true)
                            {
                                lastscore = game.score
                                gameOver.toggle()
                            }
                            self.dragAvailable = false
                        }
//                        down
                        if gesture.translation.height > 0 && abs(gesture.translation.width) < abs(gesture.translation.height) && self.dragAvailable == true
                        {
                            if (game.collapse(dir: Triples.Direction.down)) == true
                            {
                                game.spawn()
                            }
                            if (game.isGameDone() == true)
                            {
                                lastscore = game.score
                                gameOver.toggle()
                            }
                            self.dragAvailable = false
                        }
                    }
                    .onEnded
                    {
                        _ in self.dragAvailable = true
                    })
                    
                     
                    
                    
                }
            }
        }
        
    }
}
struct Scores: View
{
    @ObservedObject var scoreList: ScoreList
    var body: some View
    {
        
        List
        {
            Text("Highscores")
            ForEach(0..<scoreList.scores.count, id: \.self)
            {
                index in VStack(alignment: .leading)
                {
                    VStack(alignment: .leading)
                    {
                        Text("\(index + 1):  Score: \(scoreList.scores[index].score) Time: \(scoreList.scores[index].time.description)")
                        
                    }
                }
            }
        }
    }
}
struct About: View
{
    @State var rectangleColor = Color.white
    @State var isStatic = false
    
    private func generateRandomColor() -> Color
    {
        let randomRed = Double.random(in: 0...1)
        let randomGreen = Double.random(in: 0...1)
        let randomBlue = Double.random(in: 0...1)
        return Color(red: randomRed, green: randomGreen, blue: randomBlue)
    }
    private func startTimer()
    {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true)
        { _ in
            rectangleColor = generateRandomColor()
        }
    }
    
    var body: some View
    {
        ZStack
        {
            Text("Thanks for Playing!\nTap for details..").zIndex(isStatic ? 0: 1)
            Rectangle()
                .fill(.white)
                .frame(width: 1000, height: 1000)
                .zIndex(isStatic ? 1: 0)
                .onTapGesture {
                    isStatic.toggle()
                }
            Text("This application was made \nby Ndenko Benanzea-Fontem \nusing Swift in the CMSC436 class.\nIt demonstrates basic usage of Views,\nanimation, gestures,  timers and other tools").foregroundColor(.black)
                .zIndex(isStatic ? 1: 0)
            
            Rectangle()
                .fill(rectangleColor)
                .frame(width: 1000, height: 1000)
                .onAppear {
                    startTimer()
                }.onTapGesture {
                    isStatic.toggle()
                }
            
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//    
//        ContentView()
//            .previewInterfaceOrientation(.landscapeLeft)
//        ContentView()
//    }
//}
