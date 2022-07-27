//
//  Card.swift
//  Cards
//
//  Created by MyMacBook on 25.07.2022.
//

import UIKit

// типы фигуры карт
enum CardType: CaseIterable {
  case circle
  case cross
  case square
  case fill
}

// card colours
enum CardColor: CaseIterable {
  case red
  case green
  case black
  case gray
  case brown
  case yellow
  case purple
  case orange
}

// игральная карточка

typealias Card = (type: CardType, color: CardColor)
