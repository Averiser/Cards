//
//  BoardGameController.swift
//  Cards
//
//  Created by MyMacBook on 25.07.2022.
//

import UIKit

class BoardGameController: UIViewController {
  
  lazy var boardGameView = getBoardGameView()
  
  private func getBoardGameView() -> UIView {
    // отступ игрового поля от ближайших элементов
    let margin: CGFloat = 10
    
    let boardView = UIView()
    
    boardView.frame.origin.x = margin
    let window = UIApplication.shared.windows[0]
    let topPadding = window.safeAreaInsets.top
    boardView.frame.origin.y = topPadding + startButtonView.frame.height + margin
    
    // рассчитываем ширину
    boardView.frame.size.width = UIScreen.main.bounds.width - margin*2
    // рассчитываем высоту // c учетом нижнего отступа
    let bottomPadding = window.safeAreaInsets.bottom
    boardView.frame.size.height = UIScreen.main.bounds.height - boardView.frame.origin.y - margin - bottomPadding
    
    // изменяем стиль игрового поля
    boardView.layer.cornerRadius = 5
    boardView.backgroundColor = UIColor(red: 0.1, green: 0.9, blue: 0.1, alpha: 0.3)
    
    return boardView
  }
  
  // кнопка для запуска/перезапуска игры
  lazy var startButtonView = getStartButtonView()
  
    private func getStartButtonView() -> UIButton {
      // 1
      // Создаем кнопку
      let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
      // 2
      // Изменяем положение кнопки
      button.center.x = view.center.x
      // получаем доступ к текущему окну
      let window = UIApplication.shared.windows[0]
      // определяем отступ сверху от границ окна до Safe Area
      let topPadding = window.safeAreaInsets.top
      // устанавливаем координату Y кнопки в соответствии с отступом
      button.frame.origin.y = topPadding
      
      // 3
      // Настраиваем внешний вид кнопки
      // устанавливаем текст
      button.setTitle("Begin the game", for: .normal)
      // устанавливаем цвет текста для обычного (не нажатого) состояния
      button.setTitleColor(.black, for: .normal)
      // устанавливаем цвет текста для нажатого состояния
      button.setTitleColor(.gray, for: .highlighted)
      // устанавливаем фоновый цвет
      button.backgroundColor = .systemGray4
      button.layer.cornerRadius = 10
      
      button.addTarget(nil, action: #selector(startGame(_:)), for: .touchUpInside)
      
      return button
    }
  
  // количество пар уникальных карточек
  var cardsPairsCount = 8
  // сущность "Игра"
  lazy var game: Game = getNewGame()
  
  private func getNewGame() -> Game {
    let game = Game()
    game.cardsCount = cardsPairsCount
    game.generateCards()
    return game
  }
  
  override func loadView() {
    super.loadView()
    view.addSubview(startButtonView)
    view.addSubview(boardGameView)
  }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  @objc func startGame(_ sender: UIButton) {
    print("button was pressed")
  }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
