//
//  BoardGameController.swift
//  Cards
//
//  Created by MyMacBook on 25.07.2022.
//

import UIKit

class BoardGameController: UIViewController {
  
  
  private var flippedCards = [UIView]()
  
  // игральные карточки
  var cardViews = [UIView]()
  
  private func placeCardsOnBoard(_ cards: [UIView]) {
    // удаляем все имеющиеся на игровом поле карточки
    for card in cardViews {
      card.removeFromSuperview()
    }
    cardViews = cards
    // перебираем карточки
    for card in cardViews {
      // для каждой карточки генерируем случайные координаты
      let randomXCoordinate = Int.random(in: 0...cardMaxXCoordinate)
      let randomYCoordinate = Int.random(in: 0...cardMaxYCoordinate)
      card.frame.origin = CGPoint(x: randomXCoordinate, y: randomYCoordinate)
      // размещаем карточку на игровом поле
      boardGameView.addSubview(card)
    }
  }
  
  // генерация массива карточек на основе данных Модели
  private func getCardsBy(modelData: [Card]) -> [UIView] {
    // хранилище для представлений карточек
    var cardViews = [UIView]()
    // фабрика карточек
    let cardViewFactory = CardViewFactory()
    // перебираем массив карточек в Модели
    for (index, modelCard) in modelData.enumerated() {
      // добавляем первый экземпляр карты
      let cardOne = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
      cardOne.tag = index
      cardViews.append(cardOne)
      
      // добавляем второй экземпляр карты
      let cardTwo = cardViewFactory.get(modelCard.type, withSize: cardSize, andColor: modelCard.color)
      cardTwo.tag = index
      cardViews.append(cardTwo)
    }
    // добавляем всем картам обработчик переворота
    for card in cardViews {
      (card as! FlippableView).flipCompletionHandler = { [self] flippedCard in
        // переносим карточку вверх иерархии
        flippedCard.superview?.bringSubviewToFront(flippedCard)
        
        // добавляем или удаляем карточку
        if flippedCard.isFlipped {
          self.flippedCards.append(flippedCard)
        } else {
          if let cardIndex = self.flippedCards.firstIndex(of: flippedCard) {
            self.flippedCards.remove(at: cardIndex)
          }
        }
        
        // если перевернуто 2 карточки
        if flippedCards.count == 2 {
          // получаем карточки из данных модели
          let firstCard = game.cards[self.flippedCards.first!.tag]
          let secondCard = game.cards[self.flippedCards.last!.tag]
          
          // если карточки одинаковые
          if game.checkCards(firstCard, secondCard) {
            // сперва анимировано скрываем их
            UIView.animate(withDuration: 0.3) {
              self.flippedCards.first!.layer.opacity = 0
              flippedCards.last!.layer.opacity = 0
              // после чего удаляем из иерархии
            } completion: { _ in
              self.flippedCards.first!.removeFromSuperview()
              self.flippedCards.last!.removeFromSuperview()
              self.flippedCards = []
            }

          } else {
            // переворачиваем карточки рубашкой вверх
            for card in self.flippedCards {
              (card as! FlippableView).flip()
            }
          }
        }
      }
    }
    return cardViews
  }
  
  // размеры карточек
  private var cardSize: CGSize {
    CGSize(width: 80, height: 120)
  }
  
  // предельные координаты размещения карточки
  private var cardMaxXCoordinate: Int {
    Int(boardGameView.frame.width - cardSize.width)
  }
  
  private var cardMaxYCoordinate: Int {
    Int(boardGameView.frame.height - cardSize.height)
  }
  
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
    game = getNewGame()
    let cards = getCardsBy(modelData: game.cards)
    placeCardsOnBoard(cards)
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
