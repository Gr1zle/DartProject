import 'dart:io';
import 'dart:math';

void main() {
  bool playAgain = true;
  
  while (playAgain) {
    print("Добро пожаловать в игру Крестики-Нолики!");
    print("Выберите режим игры:");
    print("1. Игра против другого игрока");
    print("2. Игра против компьютера");
    int? mode = int.tryParse(stdin.readLineSync() ?? '');
    
    while (mode != 1 && mode != 2) {
      print("Неверный выбор, введите 1 или 2:");
      mode = int.tryParse(stdin.readLineSync() ?? '');
    }
    
    int size = getBoardSize();
    List<List<String>> board = createBoard(size);
    bool currentPlayer = Random().nextBool();
    bool vsComputer = mode == 2;
    bool gameOver = false;
    String winner = "";
    
    printBoard(board);
    
    while (!gameOver) {
      if (currentPlayer) {
        print("Ход игрока X:");
      } else {
        if (vsComputer) {
          print("Ход компьютера (O):");
        } else {
          print("Ход игрока O:");
        }
      }
      
      int row, col;
      
      if (currentPlayer || !vsComputer) {
        // Ход человека
        List<int> move = getPlayerMove(board);
        row = move[0];
        col = move[1];
      } else {
        // Ход компьютера
        List<int> computerMove = getComputerMove(board);
        row = computerMove[0];
        col = computerMove[1];
        print("$row $col");
      }
      
      board[row][col] = currentPlayer ? "X" : "O";
      printBoard(board);
      
      // Проверка победы
      if (checkWin(board, row, col)) {
        winner = currentPlayer ? "X" : "O";
        gameOver = true;
        print("$winner победил!");
      } else if (isBoardFull(board)) {
        gameOver = true;
        print("Ничья!");
      }
      
      currentPlayer = !currentPlayer;
    }
    
    // Предложение сыграть еще раз
    print("Хотите сыграть еще раз? (y/n)");
    String? answer = stdin.readLineSync();
    playAgain = answer?.toLowerCase() == 'y';
  }
  
  print("Спасибо за игру!");
}

int getBoardSize() {
  print("Введите размер поля (3-9):");
  int? size = int.tryParse(stdin.readLineSync() ?? '');
  
  while (size == null || size < 3 || size > 9) {
    print("Неверный размер, введите число от 3 до 9:");
    size = int.tryParse(stdin.readLineSync() ?? '');
  }
  
  return size;
}

List<List<String>> createBoard(int size) {
  return List.generate(size, (_) => List.filled(size, '.'));
}

void printBoard(List<List<String>> board) {
  int size = board.length;
  
  // Печать заголовка столбцов
  stdout.write("  ");
  for (int i = 0; i < size; i++) {
    stdout.write("${i + 1} ");
  }
  print("");
  
  // Печать строк
  for (int i = 0; i < size; i++) {
    stdout.write("${i + 1} ");
    for (int j = 0; j < size; j++) {
      stdout.write("${board[i][j]} ");
    }
    print("");
  }
}

List<int> getPlayerMove(List<List<String>> board) {
  int size = board.length;
  int? row, col;
  
  while (true) {
    print("Введите строку и столбец (например, 1 2):");
    List<String>? input = stdin.readLineSync()?.split(' ');
    
    if (input?.length != 2) {
      print("Неверный ввод. Введите два числа через пробел.");
      continue;
    }
    
    row = int.tryParse(input![0]);
    col = int.tryParse(input[1]);
    
    if (row == null || col == null || row < 1 || row > size || col < 1 || col > size) {
      print("Неверные координаты. Введите числа от 1 до $size.");
      continue;
    }
    
    if (board[row - 1][col - 1] != '.') {
      print("Эта клетка уже занята. Выберите другую.");
      continue;
    }
    
    break;
  }
  
  return [row! - 1, col! - 1];
}

List<int> getComputerMove(List<List<String>> board) {
  int size = board.length;
  List<List<int>> emptyCells = [];
  
  // Собираем все пустые клетки
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      if (board[i][j] == '.') {
        emptyCells.add([i, j]);
      }
    }
  }
  
  // Выбираем случайную пустую клетку
  Random random = Random();
  return emptyCells[random.nextInt(emptyCells.length)];
}

bool checkWin(List<List<String>> board, int row, int col) {
  String symbol = board[row][col];
  int size = board.length;
  
  // Проверка строки
  bool win = true;
  for (int j = 0; j < size; j++) {
    if (board[row][j] != symbol) {
      win = false;
      break;
    }
  }
  if (win) return true;
  
  // Проверка столбца
  win = true;
  for (int i = 0; i < size; i++) {
    if (board[i][col] != symbol) {
      win = false;
      break;
    }
  }
  if (win) return true;
  
  // Проверка главной диагонали
  if (row == col) {
    win = true;
    for (int i = 0; i < size; i++) {
      if (board[i][i] != symbol) {
        win = false;
        break;
      }
    }
    if (win) return true;
  }
  
  // Проверка побочной диагонали
  if (row + col == size - 1) {
    win = true;
    for (int i = 0; i < size; i++) {
      if (board[i][size - 1 - i] != symbol) {
        win = false;
        break;
      }
    }
    if (win) return true;
  }
  
  return false;
}

bool isBoardFull(List<List<String>> board) {
  for (var row in board) {
    for (var cell in row) {
      if (cell == '.') {
        return false;
      }
    }
  }
  return true;
}