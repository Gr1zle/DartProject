import 'dart:io';
import 'dart:math';
// Глобальная константа
const int BOARD_SIZE = 10;
// Структура для представления корабля
class Ship {
  int length;
  String name;

  Ship(this.length, this.name);
}
// Функция для печати игрового поля (с возможностью скрытия кораблей)
void printBoard(List<List<String>> board, {bool hideShips = false}) {
  print('  |' + List.generate(BOARD_SIZE, (i) => '${i + 1}').join('|') + '|');
  print('--' + '---' * BOARD_SIZE);
  for (int i = 0; i < BOARD_SIZE; i++) {
    stdout.write('${i + 1}'.padLeft(2) + '|');
    for (int j = 0; j < BOARD_SIZE; j++) {
      if (hideShips && board[i][j] == 'O') {
        stdout.write('~|'); // Скрываем корабли, заменяя их на воду
      } else {
        stdout.write('${board[i][j]}|');
      }
    }
    print('');
  }
}
// Функция для инициализации игрового поля
List<List<String>> createBoard() {
  return List.generate(BOARD_SIZE, (i) => List.filled(BOARD_SIZE, '~'));
}
// Функция для проверки, является ли клетка допустимой для размещения корабля
bool isValidPlacement(
    List<List<String>> board, int x, int y, int length, String orientation) {
  if (orientation == 'h') {
    if (x + length > BOARD_SIZE) return false; // Проверка выхода за границы
    for (int i = x; i < x + length; i++) {
      if (board[y][i] != '~') return false; // Проверка на пересечения
    }
  } else if (orientation == 'v') {
    if (y + length > BOARD_SIZE) return false; // Проверка выхода за границы
    for (int i = y; i < y + length; i++) {
      if (board[i][x] != '~') return false; // Проверка на пересечения
    }
  }
  return true;
}
// Функция для размещения корабля на поле
void placeShip(List<List<String>> board, int x, int y, int length,
    String orientation) {
  if (orientation == 'h') {
    for (int i = x; i < x + length; i++) {
      board[y][i] = 'O';
    }
  } else if (orientation == 'v') {
    for (int i = y; i < y + length; i++) {
      board[i][x] = 'O';
    }
  }
}
// Функция для расстановки кораблей (ручной ввод с проверками)
void placeShips(List<List<String>> board, List<Ship> ships) {
  printBoard(board);
  print('Расставляем корабли...');

  for (Ship ship in ships) {
    while (true) {
      try {
        print(
            'Введите координаты для корабля "${ship.name}" (длина: ${ship.length}) (x, y, орентация[h/v] h-горизонталь v-вертикаль): ');
        stdout.write('X: ');
        int x = int.parse(stdin.readLineSync()!) - 1;
        stdout.write('Y: ');
        int y = int.parse(stdin.readLineSync()!) - 1;
        stdout.write('Ориентация (h/v): ');
        String orientation = stdin.readLineSync()!;

        if (x >= 0 &&
            x < BOARD_SIZE &&
            y >= 0 &&
            y < BOARD_SIZE &&
            (orientation == 'h' || orientation == 'v')) {
          if (isValidPlacement(board, x, y, ship.length, orientation)) {
            placeShip(board, x, y, ship.length, orientation);
            printBoard(board);
            break; 
          } else {
            print('Нельзя разместить корабль здесь. Пересечение или выход за границы.');
          }
        } else {
          print('Неверные координаты или ориентация.');
        }
      } catch (e) {
        print('Ошибка ввода. Пожалуйста, введите числовые значения для координат и "h" или "v" для ориентации.');
      }
    }
  }
  print('Корабли расставлены!');
}
// Функция для хода игрока
bool makeMove(List<List<String>> board) {
  while (true) {
    try {
      print('Введите координаты для удара (x, y):');
      stdout.write('X: ');
      int x = int.parse(stdin.readLineSync()!) - 1;
      stdout.write('Y: ');
      int y = int.parse(stdin.readLineSync()!) - 1;

      if (x >= 0 && x < BOARD_SIZE && y >= 0 && y < BOARD_SIZE) {
        if (board[y][x] == 'O') {
          print('Попал!');
          board[y][x] = 'X'; // Помечаем попадание
          return true; // Возвращаем true, если попали
        } else if (board[y][x] == '~') {
          print('Мимо!');
          board[y][x] = '*'; // Помечаем промах
          return false; // Возвращаем false, если промахнулись
        } else {
          print('Сюда уже стреляли!');
          return false; // Возвращаем false, если уже стреляли в эту клетку
        }
      } else {
        print('Неверные координаты!');
      }
    } catch (e) {
      print('Ошибка ввода. Пожалуйста, введите числовые значения для координат.');
    }
  }
}
// Функция для проверки, остались ли корабли
bool hasShips(List<List<String>> board) {
  for (int i = 0; i < BOARD_SIZE; i++) {
    for (int j = 0; j < BOARD_SIZE; j++) {
      if (board[i][j] == 'O') {
        return true; // Если нашли хотя бы одну клетку корабля, возвращаем true
      }
    }
  }
  return false; // Если не нашли ни одной клетки корабля, возвращаем false
}

void main() {
  // Список кораблей для каждого игрока
  List<Ship> ships = [
    Ship(4, 'Линкор'),
    Ship(3, 'Крейсер 1'),
    Ship(3, 'Крейсер 2'),
    Ship(2, 'Эсминец 1'),
    Ship(2, 'Эсминец 2'),
    Ship(2, 'Эсминец 3'),
    Ship(1, 'Торпедный катер 1'),
    Ship(1, 'Торпедный катер 2'),
    Ship(1, 'Торпедный катер 3'),
    Ship(1, 'Торпедный катер 4'),
  ];
  // Инициализация игровых полей
  List<List<String>> player1Board = createBoard();
  List<List<String>> player2Board = createBoard();
  // Расстановка кораблей для обоих игроков
  print('Игрок 1, расставьте свои корабли:');
  placeShips(player1Board, ships);

  print('Игрок 2, расставьте свои корабли:');
  placeShips(player2Board, ships);

  // Основной игровой цикл
  bool player1Turn = true;
  int player1Score = 0;
  int player2Score = 0;

  while (hasShips(player1Board) && hasShips(player2Board)) {
    print('Ход игрока ${player1Turn ? 1 : 2}:');
    print('Счет: Игрок 1 - $player1Score, Игрок 2 - $player2Score');

    if (player1Turn) {
      print('Ваше поле:');
      printBoard(player1Board);
      print('Поле противника:');
      printBoard(player2Board, hideShips: true); // Скрываем корабли противника

      bool hit = makeMove(player2Board);
      if (hit) {
        player1Score++;
        if (!hasShips(player2Board)) {
          print('Игрок 1 потопил все корабли игрока 2!');
        }
      }
    } else {
      print('Ваше поле:');
      printBoard(player2Board);
      print('Поле противника:');
      printBoard(player1Board, hideShips: true); 

      bool hit = makeMove(player1Board);
      if (hit) {
        player2Score++;
        if (!hasShips(player1Board)) {
          print('Игрок 2 потопил все корабли игрока 1!');
        }
      }
    }

    player1Turn = !player1Turn; // Переключение хода
    sleep(Duration(seconds: 2)); // Пауза перед следующим ходом
  }
  // Определение победителя
  if (!hasShips(player1Board)) {
    print('Игрок 2 победил!');
  } else {
    print('Игрок 1 победил!');
  }
  print('Финальный счет: Игрок 1 - $player1Score, Игрок 2 - $player2Score');
}